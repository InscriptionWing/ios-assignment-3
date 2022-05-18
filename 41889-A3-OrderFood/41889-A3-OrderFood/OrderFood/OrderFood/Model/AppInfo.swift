//
//  AppInfo.swift
//  OrderFood
//
//  Created by Snow on 2022/5/17.
//

import Foundation

struct AppInfo {
    #if SIMULATOR
    let homePath = "/Users/Shared"
    #else
    let homePath = NSHomeDirectory()
    #endif
    
    static let shared = AppInfo()
    
    private init(){
        
    }
    
    var documentsPath: String {
        get{
            return homePath + "/Documents"
        }
    }
    
}
