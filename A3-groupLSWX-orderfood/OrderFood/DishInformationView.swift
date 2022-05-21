//
//  DishInformationView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/16.
//

import SwiftUI

struct DishInformationView: View {
    @EnvironmentObject var userSetting: UserSetting
    var singleDish: SingleDishInMenu
    
    @State var name: String
    @State var price: Double
    @State var recommend: Bool
    @Binding var showDishInformationView: Bool
    
    init(singleDish: SingleDishInMenu, showDishInformationView: Binding<Bool>) {
        self.singleDish = singleDish
        self.name = singleDish.name
        self.price = singleDish.price
        self.recommend = singleDish.recommend
        self._showDishInformationView = showDishInformationView
    }
    
    var body: some View {
        VStack{
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Price", value: $price, formatter: Self.formatter)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            
            Toggle(isOn: $recommend) {
                Text("Recommend")
            }
            
            Spacer()
            
            Button{
                updateDish()
                showDishInformationView = false
            }label: {
                Text("Confirm")
                    .font(.title2)
            }
            
            Spacer()
        }
        .navigationTitle(singleDish.dishId >= 0 ? "Edit" : "Add")
        .navigationBarTitleDisplayMode(.inline)

    }
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private func updateDish() {
        if (name.trimmingCharacters(in: .whitespaces).isEmpty){
            return
        }
        singleDish.name = name.trimmingCharacters(in: .whitespaces)
        singleDish.price = price
        singleDish.recommend = recommend
        if (singleDish.dishId >= 0){
            userSetting.sqlOperation.updateDish(dish: singleDish)
        } else{
            userSetting.sqlOperation.addDish(dish: singleDish)
        }
        
    }
}

struct DishInformationView_Previews: PreviewProvider {
    static var previews: some View {
        DishInformationView(singleDish: SingleDishInMenu(dishId: -1, name:  "Apple", price: 2.3, count: 0), showDishInformationView: .constant(false))
    }
}
