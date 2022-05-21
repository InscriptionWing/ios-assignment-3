//
//  MenuView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var showAlert: Bool = false
    @State var tips: String = ""
    
    @State var dishes: [SingleDishInMenu] = []
    var body: some View {
        VStack{
            ScrollView(showsIndicators: true){
                ForEach(dishes, id: \.dishId) {dish in
                    SingleDishInMenuView(dish: dish)
                }
            }
            .padding(10)
            
            Spacer()
            
            Button {
                Order()
            } label: {
                Text("Order")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(5)
            
        }
        .onAppear{
            updateDishes()
        }
        .alert(Text(tips), isPresented: $showAlert) {
            
        }


    }
    
    func updateDishes() {
        dishes = userSetting.sqlOperation.searchMenu()
    }
    
    func Order() {
        if(userSetting.userInfo.userType == UserType.None) {
            tips = "Please log in first"
            showAlert = true
            return
        }
        var orderedCount: Int = 0
        for dish in dishes {
            if (dish.count > 0) {
                userSetting.sqlOperation.addOrdered(
                    dish: SingleDishInOrdered(
                        orderId: 0,
                        name: dish.name,
                        price: dish.price,
                        count: dish.count,
                        imageName: dish.imageName,
                        recommend: dish.recommend,
                        orderTime: Date()
                    ),
                    accountId: userSetting.userInfo.userId
                )
                dish.count = 0
                orderedCount += 1
            }
        }
        
        if ( orderedCount > 0 ){
            tips = "Order success"
            showAlert = true
        }
        
    }
}

private struct SingleDishInMenuView: View{
    @ObservedObject var dish: SingleDishInMenu
    var body: some View{
        HStack {
            if (!dish.imageName.isEmpty) {
                Image(dish.imageName)
                    .resizable()
                    .frame(width: 70, height: 70)
            }
            VStack{
                HStack{
                    Text(dish.name)
                    Spacer()
                    if (dish.recommend) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                
                Spacer()
                
                HStack{
                    Text(String(format:"$ %.2f", dish.price))
                    
                    Spacer()
                    
                    if( dish.count > 0) {
                        Button {
                                dish.count -= 1
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                    }
                    
                    Text(String(dish.count))
                    
                    Button {
                            dish.count += 1
                    } label: {
                        Image(systemName: "plus.circle")
                    }

                }

            }
        }
        .frame(height: 70)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(UserSetting.shared)
    }
}
