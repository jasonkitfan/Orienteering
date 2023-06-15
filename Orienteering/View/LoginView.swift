//
//  LoginView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 14/6/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var isSuccess: Bool = false
    
    var body: some View {
        let home = NavigationLink(destination: MainView(), isActive: $isSuccess) {
            EmptyView()
        }
        
            VStack {
                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.top, 50)
                Text("Orienteering")
                    .font(.system(size: 30))
                    .padding(.bottom, 50)
                TextField("Email", text: $email)
                    .background(Color.white)
                    .padding(8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    .padding(.horizontal)
                SecureField("Password", text: $password)
                    .background(Color.white)
                    .padding(8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                Button(action: {
                    let auth = FirebaseAuthManager()
                    auth.loginUserWithEmailAndPassword(email: email, password: password) { message, status in
                        if(!status){
                            showingAlert = true
                            alertMessage = message
                        } else {
                            isSuccess = status
                            print(isSuccess)
                        }
                    }
                }) {
                    Text("Login")
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                Spacer()
                VStack {
                    Text("Or login with")
                    SocialMediaLogin()
                    
                }
                Spacer()
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: RegistrationView()) {
                        Text("Sign Up")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .alert(alertMessage, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
            }.background(home)
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
