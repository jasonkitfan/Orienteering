//
//  SocialMediaLogin.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 14/6/2023.
//

import SwiftUI

struct SocialMediaLogin: View {
    @State var isSuccess: Bool = false
    let auth = FirebaseAuthManager()
    
    var body: some View {
        
        let home = NavigationLink(destination: MainView(), isActive: $isSuccess) {
            EmptyView()
        }
        
        HStack(spacing: 30) {
            MediaLoginButton(media: "google") {
                print("handle google login")
                Task {
                        isSuccess = await auth.loginWithGoogle()
                        print(isSuccess)
                    }
            }
            MediaLoginButton(media: "apple") {
                print("handle apple login")
            }
            MediaLoginButton(media: "windows") {
                print("handle microsoft login")
            }
        }
        .padding()
        .background(home)
    }
}

struct MediaLoginButton: View {
    let media: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Image("logo_\(media)")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            Text(media)
        }
    }
}


struct SocialMediaLogin_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaLogin()
    }
}
