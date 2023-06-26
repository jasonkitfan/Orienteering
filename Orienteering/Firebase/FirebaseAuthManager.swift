//
//  FirebaseAuthManager.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import FirebaseAuth
import FirebaseFirestore
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import UIKit

struct FirebaseAuthManager {
    // email and password login
    func register(email: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, completion: @escaping (String, Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle registration error and return error message
                let errorMessage = error.localizedDescription
                completion(errorMessage, false)
            } else {
                // Registration successful
                let uid = authResult?.user.uid ?? ""
                addUserDataToFirestore(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, uid: uid)
                loginUserWithEmailAndPassword(email: email, password: password) { messsage, status in
                  // pass
                }
                completion("Your account has been successfully created.", true)
            }
        }
    }
    
    // create user data in firestore
    func addUserDataToFirestore(firstName: String, lastName: String, dateOfBirth: Date, uid: String) {
        let db = Firestore.firestore()
        let userData = [
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth,
            "uid": uid
        ] as [String : Any]
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                // Handle the error
                print("Error adding document: \(error)")
            } else {
                // Document added successfully
                print("Document added with ID: \(uid)")
            }
        }
    }
    
    // login with email and password
    func loginUserWithEmailAndPassword(email: String, password: String, completion: @escaping (String, Bool) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    // Handle sign-in error
                    completion(error.localizedDescription, false)
                } else {
                    // Sign-in successful
                    completion("", true)
                }
            }
        }
    func isUserLogin() -> Bool{
        if(Auth.auth().currentUser != nil){
            return true
        } else {
            return false
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully")
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                exit(0)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func loginWithGoogle() async -> Bool{
        guard let clientID = FirebaseApp.app()?.options.clientID else {
              fatalError("No client ID found in Firebase configuration")
            }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = await windowScene.windows.first,
                  let rootViewController = await window.rootViewController else {
              print("There is no root view controller!")
              return false
            }

              do {
                let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

                let user = userAuthentication.user
                guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
                let accessToken = user.accessToken

                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                               accessToken: accessToken.tokenString)

                let result = try await Auth.auth().signIn(with: credential)
                let firebaseUser = result.user
                print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
                return true
              }
              catch {
                print(error.localizedDescription)
                return false
              }
    }
    
    enum AuthenticationError: Error {
      case tokenError(message: String)
    }
    
}
