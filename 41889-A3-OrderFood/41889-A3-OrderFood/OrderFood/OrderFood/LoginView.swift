//
//  LoginView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var username: String = ""
    @State var password: String = ""
    @State var showCreateAccountView: Bool = false
    @State var isActive: Bool = false
    @State var showAlert: Bool = false
    
    @Binding var showLoginView: Bool
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image(systemName: "person.crop.circle")
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        
                }
                
                HStack{
                    Image(systemName: "key")
                    SecureField("Password",text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                }
                
                HStack{
                    Spacer()
                    
                    NavigationLink(isActive: $isActive) {
                        CreateAccountView(rootIsActive: $isActive)
                    } label: {
                        Text("Create Account")
                            .foregroundColor(.blue)
                            .font(.footnote)
                    }
                    
                }
                
                Spacer()
                
                Button {
                    SignIn()
                } label: {
                    Text("Sign In")
                        .foregroundColor(.blue)
                        .font(.title)
                }

                Spacer();
            }
            .padding(10)
        }
        .alert(Text("Login failed"), isPresented: $showAlert) {
        }
    }
    
    func SignIn() {
        let userInfo = userSetting.sqlOperation.signIn(
            signInInfo: SignInInfo(
                username: username.trimmingCharacters(in: .whitespaces),
                password: password.trimmingCharacters(in: .whitespaces)
            )
        )
        if (userInfo.userType == .None){
            showAlert = true
        } else{
            userSetting.userInfo = userInfo
            showLoginView = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLoginView: .constant(true))
            .environmentObject(UserSetting.shared)
    }
}
