//
//  SocialMediaLogin.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 14/6/2023.
//

import SwiftUI

struct SocialMediaLogin: View {
    var body: some View {
        HStack(spacing: 30) {
            MediaLoginButton(media: "google") {
                print("handle google login")
            }
            MediaLoginButton(media: "apple") {
                print("handle apple login")
            }
            MediaLoginButton(media: "windows") {
                print("handle microsoft login")
            }
        }
        .padding()
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
