//
//  DishInformationView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/16.
//

import SwiftUI

struct DishInformationView: View {
    @EnvironmentObject var userSetting: UserSetting
    var singleDish: SingleDish
    
    @State var name: String = ""
    @State var price: Double = 0.00
    @State var recommend: Bool = false
    
    @Binding var isRootActive: Bool
    
    init(singleDish: SingleDish, isRootActive: Binding<Bool>) {
        self.singleDish = singleDish
        self.name = singleDish.name
        self.price = singleDish.price
        self.recommend = singleDish.recommend
        self._isRootActive = isRootActive
    }
    
    var body: some View {
        VStack{
            Text(singleDish.dishId >= 0 ? "Edit" : "Add")
                .font(.title)
            
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
            }label: {
                Text("Confirm")
                    .font(.title2)
            }
            
            Spacer()
        }

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
        
        isRootActive = false
    }
}

struct DishInformationView_Previews: PreviewProvider {
    static var previews: some View {
        DishInformationView(singleDish: SingleDish(dishId: -1, name: "Apple", price: 2.3), isRootActive: .constant(true))
    }
}
