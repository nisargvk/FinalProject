//
//  PasswordRecoveryView.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 08.11.2020.
//

import SwiftUI

struct PasswordRecoveryView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject() var authViewModel: AuthViewModel
    
    @State private var email:String = ""
    @State private var errorMessage: String = ""
    
    private func validateForm() -> String? {
        if email.isEmpty {
            return "Provide your email"
        }
        
        if !isEmailValid(email: email) {
            return "Provide a valid email"
        }
        
        return nil
    }
    
    private func onRecover() {
        let error = validateForm()
        
        if error != nil {
            self.errorMessage = error!
        } else {
            self.errorMessage = ""
            
            // TODO: Use VM to send Code (Using SendGrid and customization)
            //  + Checking existence of the user
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Spacer()
            Section {
                Text("Enter the email to send a recovery link to")
                    .font(.system(size: 18, weight: .bold))
                    
                
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Email", text: self.$email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.bottom, 15)
                        .autocapitalization(.none)
                    Text(errorMessage)
                        .italic()
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }.padding(.bottom, 24)
                
                Button(action: onRecover){
                    Text("Send recovery link")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.orange)
                        .cornerRadius(25.0)
                }
            }
            Spacer()
        }.padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView()
    }
}
