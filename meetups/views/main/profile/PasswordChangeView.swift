//
//  PasswordChangeView.swift
//  meetups
//
//  Created by Mac on 10.11.2020.
//

import SwiftUI

struct PasswordChangeView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject() var userViewModel: UserViewModel
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var passwordErrorMessage: String = ""
    @State private var confirmationErrorMessage: String = ""
    
    @State private var submitting: Bool = false
    
    private func validateForm() -> Bool {
        let passwordError = validatePassword(password: self.password)
        let confirmationError = validateConfirmPassword(confirmPassword: self.confirmPassword, password: self.password)
        
        passwordErrorMessage = passwordError ?? ""
        confirmationErrorMessage = confirmationError ?? ""
        
        return (passwordError == nil && confirmationError == nil)
    }
    
    private func onChange() {
        let isValid = validateForm()
        
        if isValid {
            self.submitting = true
            
            self.userViewModel.changePassword(newPassword: password) { error in
                self.submitting = false
                
                if let caughtError = error {
                    self.passwordErrorMessage = caughtError.localizedDescription
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Spacer()
            Section {
                Text("Enter and confirm a new password")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 30)
                    
                
                VStack(alignment: .leading, spacing:1) {
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    Text(passwordErrorMessage)
                        .italic()
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }.padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 1) {
                    SecureField("Confirm Password", text: self.$confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    Text(confirmationErrorMessage)
                        .italic()
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }.padding(.bottom, 24)
                
                Button(action: onChange){
                    Text(submitting ? "Resetting..." : "Reset Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color(UIColor(Color.orange)
                                            .darker(by: submitting ? 10 : 0)!))
                        .cornerRadius(25.0)
                }
            }
            Spacer()
        }.padding(.horizontal, 20)
        .padding(.vertical, 35)
        .background(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
    }
}

struct PasswordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeView()
    }
}
