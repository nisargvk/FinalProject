//
//  SignInView.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 28.10.2020.
//

import SwiftUI
import GoogleSignIn

struct SignInView: View {
    @EnvironmentObject() var authViewModel: AuthViewModel
    @EnvironmentObject var userSettings: UserSettings
    @State private var email:String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    @State private var showPasswordRecovery: Bool = false
    
    @State private var submitting: Bool = false
    
    private func resetForm() {
        self.email = ""
        self.password = ""
        self.errorMessage = ""
    }
    
    private func validateForm() -> String? {
        if email.isEmpty || password.isEmpty {
            return "Provide your email and password"
        }
        
        if !isEmailValid(email: email) {
            return "Provide a valid email"
        }
        
        return nil
    }
    
    private func onSignIn() {
        let error = validateForm()
        
        if error != nil {
            self.errorMessage = error!
        } else {
            self.submitting = true
            self.errorMessage = ""
            
            self.authViewModel.signInWithEmail(email: self.email, password: self.password) { error in
                self.submitting = false
                
                if error != nil {
                    self.errorMessage = "Invalid email or password"
                }
            }
        }
        self.userSettings.userEmail = self.email
    }
    
    private func onSignInWithGoogle() {
        self.errorMessage = ""

        self.authViewModel.signInWithGoogle()
        self.userSettings.userEmail = self.email
    }
    
    var body: some View {
        // SUPER-IMPORTANT: Cannot put NavigationView into a View that will be navigated to (NavigationViews get duplicatedwith separate hierarchies)
        //      -> Only specify for the top-level
        NavigationView {
            VStack(alignment: .center, spacing: 2) {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.bottom, 15)
                            .autocapitalization(.none)
                        SecureField("Password", text: self.$password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.bottom, 5)
                        Text(errorMessage)
                            .italic()
                            .foregroundColor(.red)
                            .font(.system(size: 10))
                    }.padding(.bottom, 24)
                    
                    Button(action: onSignIn){
                        Text(submitting ? "Wait..." : "Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(
                                Color(UIColor(Color.orange)
                                        .darker(by: submitting ? 10 : 0)!)
                            )
                            .cornerRadius(25.0)
                    }.padding(.bottom, 15)
                    
                    Button("Forgot your password?", action: {
                        showPasswordRecovery = true
                    })
                }
                
                HStack {
                    VStack {
                        Divider().background(Color.black)
                    }.padding(.trailing, 2.5)
                    Text("OR").foregroundColor(.black)
                    VStack {
                        Divider().background(Color.black)
                    }.padding(.leading, 2.5)
                }.padding(.vertical, 20)
                
                Section {
                    Button(action: onSignInWithGoogle){
                        HStack{
                            Spacer()
                            Image("google-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.trailing, 10)
                            Text("Sign In with Google")
                            Spacer()
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 380, height: 60)
                        .background(Color.white)
                        .cornerRadius(25.0)
                    }
                }

                Spacer()

                HStack{
                    NavigationLink(destination: SignUpView()) {
                        Text("Create a new account?")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: self.$showPasswordRecovery) {
                PasswordRecoveryView()
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 35)
            .background(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
            .navigationBarTitle("Sign In", displayMode: .large)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            // Resetting form when navigating back
            // - NOT NavigationView (Never goes away)
            .onAppear(perform: resetForm)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        SignInView()
            .environmentObject(
                AuthViewModel(functions: appDelegate.functions, auth: appDelegate.auth)
            )
    }
}
