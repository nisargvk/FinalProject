//
//  SignUpView.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 28.10.2020.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject() var userViewModel: UserViewModel
    
    @State private var username:String = ""
    @State private var email:String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var usernameErrorMessage: String = ""
    @State private var emailErrorMessage: String = ""
    @State private var passwordErrorMessage: String = ""
    @State private var confirmationErrorMessage: String = ""
    
    @State private var showImagePicker : Bool = false
    @State private var image : UIImage? = UIImage(named: "profile-placeholder")
    @State private var isImageSelected: Bool = false
    
    @State private var showVerificationMessage: Bool = false
    @State private var showErrorMessage: Bool = false
    
    @State private var submitting: Bool = false
    
    private func goBack() {
        self.mode.wrappedValue.dismiss()
    }
    
    private func validateForm() -> Bool {
        let usernameError = validateUsername(username: self.username)
        let emailError = validateEmail(email: self.email)
        let passwordError = validatePassword(password: self.password)
        let confirmationError = validateConfirmPassword(confirmPassword: self.confirmPassword, password: self.password)
        
        usernameErrorMessage = usernameError ?? ""
        emailErrorMessage = emailError ?? ""
        passwordErrorMessage = passwordError ?? ""
        confirmationErrorMessage = confirmationError ?? ""
        
        return (
            usernameError == nil && emailError == nil &&
                passwordError == nil && confirmationError == nil
        )
    }
    
    private func processError(error: UserCreationError) {
        if error == UserCreationError.emailExists {
            self.emailErrorMessage = "Email is already being used by someone else"
        } else if error == UserCreationError.usernameExists {
            self.usernameErrorMessage = "Username is already being used by someone else"
        } else {
            self.showErrorMessage = true
        }
    }
    
    private func onSignUp() {
        if !validateForm() {
            return
        }
        
        self.submitting = true
        
        self.userViewModel.createUser(
            data: UserData(username: self.username, email: self.email, password: self.password),
            image: self.isImageSelected ? image?.jpegData(compressionQuality: 1) : nil
        ) { (error) in
            self.submitting = false
            
            if let caughtError = error {
                self.processError(error: caughtError)
            } else {
                self.showVerificationMessage = true
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    Spacer()

                    Button(action: {
                        self.showImagePicker = true
                    }){
                        Image(uiImage: image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150, alignment: .center)
                            .clipShape(Circle())
                    }

                    Spacer()
                }.padding(.bottom, 25)
                
                VStack {
                    VStack(alignment: .leading, spacing: 1) {
                        TextField("Username", text: self.$username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .autocapitalization(.none)
                        Text(usernameErrorMessage)
                            .italic()
                            .foregroundColor(.red)
                            .font(.system(size: 10))
                    }.padding(.bottom, 5)

                    VStack(alignment: .leading, spacing: 1) {
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .autocapitalization(.none)
                        Text(emailErrorMessage)
                            .italic()
                            .foregroundColor(.red)
                            .font(.system(size: 10))
                    }.padding(.bottom, 5)
                    .alert(isPresented: $showVerificationMessage) {
                        Alert(
                            title: Text("Confirm your email"),
                            message: Text("A confirmation link was sent to your email. Please click on it before signing into your account."),
                            dismissButton: .default(
                                Text("Got it!"),
                                action: self.goBack
                            )
                        )
                    }

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
                }.frame(width: 380, height: 350)

                Button(action: onSignUp) {
                    Text(submitting ? "Wait..." : "Sign up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color(UIColor(Color.orange)
                                            .darker(by: submitting ? 10 : 0)!))
                        .cornerRadius(25.0)
                }.disabled(submitting).padding(.bottom, 20)
                .alert(isPresented: $showErrorMessage) {
                    Alert(
                        title: Text("Sign up failed"),
                        message: Text("An error occured. Please try again later.")
                    )
                }
            }
            
            Spacer()

            Button(action: self.goBack) {
                Text("Already have an account?")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
        .navigationBarTitle("Sign Up", displayMode: .large)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: self.$showImagePicker) {
            ImagePicker(isShown: $showImagePicker, isSelected: $isImageSelected, image: $image)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
