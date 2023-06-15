//
//  ContentView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 14/6/2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var errorMessage: String = ""
    
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var isSuccess: Bool = false

    let minimumPasswordLength = 8
    
    var isFormValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        let isPasswordValid = password.count >= minimumPasswordLength
        
        return !firstName.isEmpty && !lastName.isEmpty && isEmailValid && isPasswordValid && password == confirmPassword
    }
    
    var body: some View {
        let home = NavigationLink(destination: MainView(), isActive: $isSuccess) {
            EmptyView()
        }
        
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker(
                        selection: $dateOfBirth,
                        displayedComponents: .date,
                        label: { Text("Date of Birth") }
                    )
                }
        
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                if !isFormValid && !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                Button("Register") {
                    if !isFormValid {
                       if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
                           errorMessage = "Please fill in all fields"
                       }
                       else if(password != confirmPassword){
                           errorMessage = "Passwords do not match"
                       }
                       else if(password.count < minimumPasswordLength){
                           errorMessage = "Password length must be at least \(minimumPasswordLength) characters"
                       }
                       else {
                           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                           let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                           let isEmailValid = emailPredicate.evaluate(with: email)
                           
                           if(!isEmailValid){
                               errorMessage = "Invalid email format"
                           }
                       }
                   } else {
                       let auth = FirebaseAuthManager()
                       auth.register(email: email, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth) {message, status in
                           // pop up error
                           if(!status){
                               alertMessage = message
                               showingAlert = true
                           } else {
                            // return to home view
                               isSuccess = status
                           }
                           
                       }
                   }
                }.alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                    }
            }
            .navigationBarTitle("Registration")
            .background(home)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
