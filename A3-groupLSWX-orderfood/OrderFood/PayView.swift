//
//  PayView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/20.
//

import SwiftUI

struct PayView: View {
    var allDishes: [SingleDishInOrdered]
    var body: some View {
        VStack{
            ScrollView{
                ForEach(allDishes, id: \.orderId) { dish in
                    UnitView(dish: dish)
                }
            }
            
            Text(total())
                .font(.title2)
            
            Button{
                
            }label: {
                Text("Pay")
                    .font(.title)
            }
        }
        .navigationTitle("List")
        .navigationBarTitleDisplayMode(.inline)
        .padding(10)
    }
    
    func total() -> String {
        var money: Double = 0
        for dish in allDishes {
            money += dish.price * Double(dish.count)
        }
        return String(format: "Total: $ %.2f", money)
    }
}

private struct UnitView: View {
    var dish: SingleDishInOrdered
    var body: some View {
        VStack {
            HStack {
                Text("Food: \(dish.name)")
                Spacer()
            }
            
            HStack{
                Text("Order Time: \(dish.time())")
                Spacer()
            }
            
            HStack{
                Text(PriceAndCount())
                Spacer()
            }
            Divider()
        }
    }
    
    func PriceAndCount() -> String {
        return String(format: "Price and Count: $ %.2f x %d", dish.price, dish.count)
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        return PayView(allDishes: [
            .init(orderId: 1, name: "AA", price: 10.2, count: 3, imageName: "", recommend: false, orderTime: Date()),
            .init(orderId: 2, name: "BB", price: 3.2, count: 1, imageName: "", recommend: false, orderTime: Date()),
            .init(orderId: 3, name: "CC", price: 26.2, count: 6, imageName: "", recommend: false, orderTime: Date()),
            .init(orderId: 4, name: "DD", price: 11.2, count: 2, imageName: "", recommend: false, orderTime: Date()),
            .init(orderId: 5, name: "EE", price: 12.25, count: 3, imageName: "", recommend: false, orderTime: Date()),
        ])
    }
}
