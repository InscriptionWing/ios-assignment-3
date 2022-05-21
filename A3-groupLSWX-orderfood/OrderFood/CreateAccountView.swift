//
//  RegisterView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var userSetting: UserSetting
    @State var username: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    
    @State var tips: String = ""
    @State var showAlert: Bool = false
    
    @Binding var rootIsActive: Bool
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "person.crop.circle")
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    
            }
            
            HStack{
                Image(systemName: "key")
                SecureField("Password",text: $password1)
                    .textFieldStyle(.roundedBorder)
                
            }
            
            HStack{
                Image(systemName: "key")
                SecureField("Confirm password",text: $password2)
                    .textFieldStyle(.roundedBorder)
                
            }
            
            Spacer()
            
            Button {
                create()
            } label: {
                Text("Create")
                    .foregroundColor(.blue)
                    .font(.title)
            }

            Spacer();
            
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(tips), message: nil, dismissButton: Alert.Button.default(Text("Ok"), action: {
                if ( tips == "success" ){
                    //go back to preview view
                    rootIsActive = false
                }
            }))
        })
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)

    }
    
    func create() {
        if (username.trimmingCharacters(in: .whitespaces).isEmpty) {
            showAlert = true
            tips = "Username can not be empty"
            return
        }
        
        if (password1.trimmingCharacters(in: .whitespaces).isEmpty) {
            showAlert = true
            tips = "Password can not be empty"
            return
        }
        
        if (password1.trimmingCharacters(in: .whitespaces) != password2.trimmingCharacters(in: .whitespaces)){
            showAlert = true
            tips = "The two passwords are not equal"
            return
        }
        
        if (!userSetting.sqlOperation.createAccount(
                createAccountInfo:
                    CreateAccountInfo(
                        username: username.trimmingCharacters(in: .whitespaces),
                        password: password1.trimmingCharacters(in: .whitespaces)
                    )
            )){
            showAlert = true
            tips = "Username is already in use"
        } else{
            showAlert = true
            tips = "success"
        }

    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(rootIsActive: .constant(false)).environmentObject(UserSetting.shared)
    }
}
