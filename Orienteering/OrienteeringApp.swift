//
//  OrienteeringApp.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 14/6/2023.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct OrienteeringApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let auth = FirebaseAuthManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                if(auth.isUserLogin()){
                    MainView()
                }
                else {
                    LoginView()
                }
            }
        }
    }
}
