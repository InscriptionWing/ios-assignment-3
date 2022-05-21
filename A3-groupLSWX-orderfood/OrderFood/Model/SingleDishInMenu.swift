//
//  DishesInMenu.swift
//  OrderFood
//
//  Created by Snow on 2022/5/20.
//

import Foundation

class SingleDishInMenu: ObservableObject  {
    var dishId: Int
    var name: String
    var price: Double
    @Published var count: Int
    var imageName: String
    var recommend: Bool
    
    init(){
        dishId = -1
        name = ""
        price = 0
        count = 0
        imageName = ""
        recommend = false
    }
    
    init(dishId: Int, name: String, price: Double, count: Int, imageName: String = "", recommend: Bool = false){
        self.dishId = dishId
        self.name = name
        self.price = price
        self.count = count
        self.imageName = imageName
        self.recommend = recommend
    }
    
}
