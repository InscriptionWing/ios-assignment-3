//
//  ContentView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

//Home View
struct ContentView: View {
    @EnvironmentObject var userSetting: UserSetting
    
    @State var showLoginView: Bool = false
    @State var showUserInfoView: Bool = false
    @State var showManageView: Bool = false
    var body: some View {
        VStack{
            HStack{
                if(userSetting.userInfo.userType == UserType.Manager){
                    Button{
                        showManageView = true
                    }label:{
                        Text("Manage")
                    }
                }
                Spacer()
                Button {
                    if (userSetting.userInfo.userType == UserType.None){
                        showLoginView = true
                    } else{
                        showUserInfoView = true
                    }
                } label: {
                    if (userSetting.userInfo.userType != UserType.None){
                        Text(userSetting.userInfo.userName)
                    }else{
                        Text("Login")
                    }
                }
                
            }
            .padding(10)
            TabView{
                MenuView(showManageView: $showManageView)
                    .tabItem {
                        Image(systemName: "menucard")
                        Text("Menu")
                    }
                OrderedView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Ordered")
                    }
            }
        }
        .sheet(isPresented: $showLoginView) {
            LoginView(showLoginView: $showLoginView)
        }
        .sheet(isPresented: $showUserInfoView){
            UserInformationView(showUserInfo: $showUserInfoView)
        }
        .sheet(isPresented: $showManageView) {
            ManageView()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserSetting.shared)
    }
}
