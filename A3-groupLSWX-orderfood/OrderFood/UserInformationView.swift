//
//  UserInformationView.swift
//  OrderFood
//
//  Created by Lin on 2022/5/15.
//

import SwiftUI

struct UserInformationView: View {
    @EnvironmentObject var userSetting: UserSetting
    
    @Binding var showUserInfo: Bool
    var body: some View {
        VStack{
            Text("User Information")
                .font(.title)
            
            HStack{
                Text("User Name:")
                    .font(.title3)
                    .foregroundColor(.blue)
                Text(userSetting.userInfo.userName)
                Spacer()
            }
            .padding(10)
            
            HStack{
                Spacer()
                Button {
                    showUserInfo = false
                    userSetting.userInfo = UserInfo()
                } label: {
                    Text("Sign Out")
                        .font(.title2)
                }
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct UserInformationView_Previews: PreviewProvider {
    @EnvironmentObject var userSetting: UserSetting
    static var previews: some View {
        UserInformationView(showUserInfo: .constant(true))
            .environmentObject(UserSetting.shared)
    }
}
