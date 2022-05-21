//
//  OrderedView.swift
//  OrderFood
//
//  Created by 1 on 2022/5/15.
//

import SwiftUI

struct OrderedView: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var allDishes: [SingleDishInOrdered] = []
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators: true){
                ForEach(allDishes, id: \.orderId) { dish in
                    SingleDishInOrderedView(dish: dish)
                }
            }
            .padding(10)
            
            Spacer()
            
            HStack{
                Text(total())
                
                Spacer()
                
                NavigationLink {
                    PayView(allDishes: allDishes)
                } label: {
                    Text("Checkout")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                
                Button {
                    cancel()
                } label: {
                    Text("Cancel")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding(10)
            
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
    
    func total() -> String {
        var money: Double = 0
        for dish in allDishes {
            money += dish.price * Double(dish.count)
        }
        return String(format: "Total: $ %.2f", money)
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
    @ObservedObject var dish: SingleDishInOrdered
    var body: some View{
        VStack{
            HStack{
                if (dish.recommend) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                
                if (!dish.imageName.isEmpty) {
                    Image(dish.imageName)
                        .resizable()
                        .frame(width: 70, height: 70)
                }
                
                VStack(alignment: .leading){
                    
                    Text(dish.name)
                    Toggle(formatString(), isOn: $dish.isSelected)
                }
                
            }
            
            Divider()
        }
        .frame(height: 70)
        
    }
    
    func formatString() -> String{
        return String(format: "%@  $ %.2f x %d",
                      dish.time(), dish.price, dish.count
        )
    }
}

struct OrderedView_Previews: PreviewProvider {
    static var previews: some View {
        OrderedView(allDishes: []).environmentObject(UserSetting.shared)
    }
}
