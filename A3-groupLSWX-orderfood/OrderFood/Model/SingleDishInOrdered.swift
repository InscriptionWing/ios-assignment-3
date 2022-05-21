//
//  SingleDish.swift
//  OrderFood
//
//  Created by Snow on 2022/5/16.
//

import Foundation

class SingleDishInOrdered: ObservableObject {
    var orderId: Int
    var name: String
    var price: Double
    var count: Int
    var imageName: String
    var recommend: Bool
    var orderTime: Date
    @Published var isSelected: Bool
    
    init() {
        orderId = 0
        name = ""
        price = 0
        count = 0
        imageName = ""
        recommend = false
        orderTime = Date()
        isSelected = false
    }
    
    init(orderId: Int, name: String, price: Double, count: Int, imageName: String = "", recommend: Bool = false, orderTime: Date = Date()){
        self.orderId = orderId
        self.name = name
        self.price = price
        self.count = count
        self.imageName = imageName
        self.recommend = recommend
        self.orderTime = orderTime
        self.isSelected = false
    }
    
    func time() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: orderTime)
    }
    
}
