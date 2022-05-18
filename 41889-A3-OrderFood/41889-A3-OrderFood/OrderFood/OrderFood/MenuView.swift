//
//  MenuView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var allDishes: [SingleDishInMenu] = []
    @Binding var showManageView: Bool
    @State var showAlert: Bool = false
    @State var tips: String = ""
    var body: some View {
        VStack{
            HStack{
                Text("Menu")
                    .font(.largeTitle)
                
                Spacer()
            }
            .padding(10)
            
            ScrollView(showsIndicators: true){
                ForEach($allDishes, id: \.self) {dish in
                    SingleDishInMenuView(dish: dish)
                }
            }
            .padding(10)
            
            HStack{
                Spacer()
                
                Button {
                    Order()
                } label: {
                    Text("Order")
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
        .onChange(of: showManageView) { newValue in
            if (!showManageView){
                updateDishes()
            }
        }
        .alert(Text(tips), isPresented: $showAlert) {
            
        }

    }
    
    func updateDishes() {
        allDishes = userSetting.sqlOperation.searchMenu()
    }
    
    func Order() {
        if(userSetting.userInfo.userType == UserType.None) {
            tips = "Please log in first"
            showAlert = true
            return
        }
        var count: Int = 0
        for dish in allDishes {
            if (dish.isSelected) {
                userSetting.sqlOperation.addOrdered(
                    menuId: dish.dishId,
                    date: Date(),
                    accountId: userSetting.userInfo.userId
                )
                dish.isSelected = false
                count += 1
                
            }
        }
        if( count > 0 ){
            tips = "Order success"
            showAlert = true
        }
        
    }
}

private struct SingleDishInMenuView: View{
    @Binding var dish: SingleDishInMenu
    
    var body: some View{
        VStack{
            
            HStack{
                Text(dish.name)
                Spacer()
                if (dish.recommend) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            Toggle("$"+String(dish.price), isOn: $dish.isSelected)
            
            Spacer()
        }
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showManageView: .constant(false)).environmentObject(UserSetting.shared)
    }
}
