//
//  UserSetting.swift
//  OrderFood
//
//  Created by 1 on 2022/5/16.
//

import Foundation

private var defaultDishName: [String] = [
    "LAN ZHOU BEEF NOODLE",
    "PORK AND CHIVES DUMPLINGS(10pc)",
    "SALT AND PEPPER PORK CHOP",
    "SHAN DONG CRISPY CHICKEN",
    "SPICY BEEF NOODLE SOUP",
    "STEAMED PORK BUNS(8pc)"
]

final class UserSetting: ObservableObject{
    @Published var userInfo: UserInfo
    @Published var sqlOperation: SqlOperation
    
    static let shared = UserSetting()
    
    init(){
        self.userInfo = UserInfo();
        self.sqlOperation = SqlOperation();
        
        addDefaultInformation()
    }
    
    private func addDefaultInformation() {
        if(!sqlOperation.isTheAccountNameExist(username: "Admin")){
            createAdminAccount()
            addDefaultMenu()
        }
    }
    
    private func createAdminAccount() {
        let _ = sqlOperation.createAccount(createAccountInfo: CreateAccountInfo(username: "Admin", password: "123456"), type: 1)
    }
    
    private func addDefaultMenu() {
        for name in defaultDishName {
            sqlOperation.addDish(dish: SingleDishInMenu(dishId: -1, name: name, price: 10, count: 0, imageName: name, recommend: false))
        }
    }
}
