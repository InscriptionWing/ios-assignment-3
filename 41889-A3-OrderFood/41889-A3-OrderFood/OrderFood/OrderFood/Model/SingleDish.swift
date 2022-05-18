//
//  SingleDish.swift
//  OrderFood
//
//  Created by Lin on 2022/5/16.
//

import Foundation


class SingleDish{
    var dishId: Int
    var name: String
    var price: Double
    var recommend: Bool
    
    init(){
        dishId = -1
        name = ""
        price = 0
        recommend = false
    }
    
    init(dishId: Int, name: String, price: Double, recommend: Bool = false){
        self.dishId = dishId
        self.name = name
        self.price = price
        self.recommend = recommend
    }
    
}

class SingleDishInMenu: SingleDish, Hashable  {
    var isSelected: Bool
    
    override init(){
        self.isSelected = false
        super.init()
    }
    
    override init(dishId: Int, name: String, price: Double, recommend: Bool = false){
        self.isSelected = false
        super.init()
        super.dishId = dishId
        super.name = name
        super.price = price
        super.recommend = recommend
    }
    
    static func == (lhs: SingleDishInMenu, rhs: SingleDishInMenu) -> Bool {
        return lhs.dishId == rhs.dishId && lhs.isSelected == rhs.isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dishId)
        hasher.combine(isSelected)
    }
}

class SingleDishInOrdered: SingleDishInMenu {
    var orderId: Int
    var orderTime: Date
    
    override init() {
        self.orderId = 0
        self.orderTime = Date()
        super.init()
    }
    
    init(orderId: Int, name: String, price: Double, recommend: Bool = false, dishId: Int, orderTime: Date = Date()){
        self.orderId = orderId
        self.orderTime = orderTime
        super.init()
        super.dishId = dishId
        super.name = name
        super.price = price
        super.recommend = recommend
    }
    
    func time() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        return dateFormatter.string(from: orderTime)
    }
    
    static func == (lhs: SingleDishInOrdered, rhs: SingleDishInOrdered) -> Bool {
        return lhs.orderId == rhs.orderId && lhs.isSelected == rhs.isSelected
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
        hasher.combine(isSelected)
    }
}
