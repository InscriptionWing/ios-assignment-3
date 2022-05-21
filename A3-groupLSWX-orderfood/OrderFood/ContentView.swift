//
//  ContentView.swift
//  OrderFood
//
//  Created by 1 on 2022/5/15.
//

import SwiftUI

//Home View
struct ContentView: View {
    @EnvironmentObject var userSetting: UserSetting
    
    @State var showLoginView: Bool = false
    @State var showUserInfoView: Bool = false
    @State var showManageView: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                
                TabView{
                    MenuView()
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
                .navigationTitle(Text("Welcome"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if(userSetting.userInfo.userType == UserType.Manager){
                            Button{
                                showManageView = true
                            }label:{
                                Text("Manage")
                            }
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
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
                }

                NavigationLink(isActive: $showLoginView) {
                    LoginView(showLoginView: $showLoginView)
                } label: {

                }
                
                NavigationLink(isActive: $showUserInfoView) {
                    UserInformationView(showUserInfo: $showUserInfoView)
                } label: {
                    
                }
                
                NavigationLink(isActive: $showManageView) {
                    ManageView()
                } label: {

                }
                
            }
        }
        .navigationViewStyle(.stack)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserSetting.shared)
    }
}
