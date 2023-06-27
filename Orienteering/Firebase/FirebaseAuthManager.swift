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
    
    // Register a new user account with email and password and add user data to Firestore
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
                loginUserWithEmailAndPassword(email: email, password: password) { message, status in
                  // pass
                }
                completion("Your account has been successfully created.", true)
            }
        }
    }
    
    // Add user data to Firestore
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
    
    // Log in a user with email and password
    func loginUserWithEmailAndPassword(email: String, password: String, completion: @escaping (String, Bool) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    // Handle sign-in error
                    print(error)
                    completion("fail", false)
                } else {
                    // Sign-in successful
                    completion("success", true)
                }
            }
    }
    
    // Check if a user is logged in
    func isUserLogin() -> Bool{
        if(Auth.auth().currentUser != nil){
            return true
        } else {
            return false
        }
    }
    
    // Log out the current user and terminate the app
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully")
            // Suspend the app to ensure that all background tasks are completed
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            // Delay app termination by 500 milliseconds to ensure that all tasks are completed
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                exit(0)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // Authenticate a user with Google Sign-In and sign them in with Firebase Authentication
    func loginWithGoogle() async -> Bool {
        // Get the client ID from Firebase configuration
        guard let clientID = FirebaseApp.app()?.options.clientID else {
              fatalError("No client ID found in Firebase configuration")
            }
        // Configure Google Sign-In with the client ID
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Get the root view controller of the app
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
          print("There is no root view controller!")
         return false
        }

        do {
            // Show the Google Sign-In UI and get the user's authentication
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            // Get the user's ID token and access token
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken

            // Authenticate the user with Firebase Authentication using the ID token and access token
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user

            // Log the user in with Firebase Authentication and return true
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        } catch {
            // Handle authentication error and return false
            print(error.localizedDescription)
            return false
        }
    }
    
    // Error case for missing ID tokens
    enum AuthenticationError: Error {
      case tokenError(message: String)
    }
}
