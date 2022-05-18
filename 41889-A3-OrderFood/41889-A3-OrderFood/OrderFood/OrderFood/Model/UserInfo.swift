//
//  UserInfo.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import Foundation

enum UserType{
    case Customer
    case Manager
    case None
}

//User information
struct UserInfo{
    var userId: Int
    var userName: String
    var userType: UserType
    
    init(){
        userId = -1
        userName = ""
        userType = UserType.None
    }
}
