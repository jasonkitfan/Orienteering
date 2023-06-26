//
//  DrawerView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 26/6/2023.
//

import SwiftUI

struct DrawerView: View {
    @Binding var isOpen: Bool
    let authManager = FirebaseAuthManager()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Button(action: {
                    // handle profile button action
                }, label: {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                        Text("Profile")
                    }
                })
                
                Button(action: {
                    // handle record button action
                }, label: {
                    HStack {
                        Image(systemName: "doc.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                        Text("Record")
                    }
                })
                
                Button(action: {
                    // handle settings button action
                }, label: {
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.orange)
                            .font(.title)
                        Text("Settings")
                    }
                })
                
                Button(action: {
                    // handle languages button action
                }, label: {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.purple)
                            .font(.title)
                        Text("Languages")
                    }
                })
                Button(action: {
                    // handle sign out button action
                    authManager.logoutUser()
                }, label: {
                    HStack {
                        Image(systemName: "power")
                            .foregroundColor(.red)
                            .font(.title)
                        Text("Sign Out")
                    }
                })
                
                Spacer()
            }
            .padding(16)
            .frame(width: UIScreen.main.bounds.width / 2)
            .background(Color.white)
            .offset(x: isOpen ? 0 : -UIScreen.main.bounds.width / 2)
            .animation(.easeInOut, value: isOpen)
            Spacer()
        }
    }
}

//struct DrawerView_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawerView()
//    }
//}
