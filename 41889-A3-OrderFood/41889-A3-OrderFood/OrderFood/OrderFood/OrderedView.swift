//
//  OrderedView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct OrderedView: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var allDishes: [SingleDishInOrdered] = []
    
    var body: some View {
        VStack{
            HStack{
                Text("Ordered")
                    .font(.largeTitle)
                
                Spacer()
            }
            .padding(10)
            
            ScrollView(showsIndicators: true){
                ForEach($allDishes, id: \.self) { dish in
                    SingleDishInOrderedView(dish: dish)
                }
            }
            .padding(10)
            
            HStack{
                Spacer()
                
                Button {
                    cancel()
                } label: {
                    Text("Cancel")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Spacer()
                
            }
            .padding(10)
            
            Spacer()
        }
        .onAppear{
            updateDishes()
        }

    }
    
    func updateDishes() {
        if( userSetting.userInfo.userType == UserType.None ) {
            allDishes = []
            return
        }
        allDishes = userSetting.sqlOperation.searchOrdered(accountId: userSetting.userInfo.userId)
    }
    
    func cancel() {
        if(userSetting.userInfo.userType == UserType.None) {
            return
        }

        userSetting.sqlOperation.deleteOrdered(
            accountId: userSetting.userInfo.userId,
            ids: allDishes.filter{ $0.isSelected }.map{ $0.orderId }
        )
        
        updateDishes()

    }
}

private struct SingleDishInOrderedView: View{
    @Binding var dish: SingleDishInOrdered
    var body: some View{
        VStack{
            HStack{
                if (dish.recommend) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                
                Text(dish.name)
                Spacer()
            }
            
            Toggle(formatString(), isOn: $dish.isSelected)
            
            Spacer()
        }
        
    }
    
    func formatString() -> String{
        return String(format: "%@         $ %.2f",
                      dish.time(),
                      dish.price
        )
    }
}

struct OrderedView_Previews: PreviewProvider {
    static var previews: some View {
        OrderedView(allDishes: []).environmentObject(UserSetting.shared)
    }
}
