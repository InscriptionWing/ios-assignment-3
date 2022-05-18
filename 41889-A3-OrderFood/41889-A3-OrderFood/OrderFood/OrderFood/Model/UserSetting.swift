//
//  UserSetting.swift
//  OrderFood
//
//  Created by Lin on 2022/5/16.
//

import Foundation

final class UserSetting: ObservableObject{
    @Published var userInfo: UserInfo
    @Published var sqlOperation: SqlOperation
    
    static let shared = UserSetting()
    
    init(){
        self.userInfo = UserInfo();
        self.sqlOperation = SqlOperation();
    }
}
