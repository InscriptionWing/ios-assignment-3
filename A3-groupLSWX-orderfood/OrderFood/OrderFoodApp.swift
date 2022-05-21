//
//  OrderFoodApp.swift
//  OrderFood
//
//  Created by 1 on 2022/5/15.
//

import SwiftUI

@main
struct OrderFoodApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserSetting.shared)
        }
    }
}
