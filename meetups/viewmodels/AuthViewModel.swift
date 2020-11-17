//
//  UserViewModel.swift
//  meetups
//
//  Created by Mac on 28.10.2020.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthViewModel: ObservableObject {
    private let functions: Functions
    private let auth: Auth
    
    init(functions: Functions, auth: Auth) {
        self.functions = functions
        self.auth = auth
    }
    
    @Published public var isLoaded: Bool = false
    @Published public var isAuthed: Bool = false
    
    public func listenToAuth() {
        _ = self.auth.addStateDidChangeListener { (auth, user) in
            self.isLoaded = true
            self.isAuthed = user != nil
        }
    }
    
    public func signInWithEmail(email: String, password: String, completion: @escaping (Error?)->()) {
        self.auth.signIn(withEmail: email, password: password) { (_, error) in
            completion(error)
        }
    }
    
    public func signInWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func signOut() {
        try! self.auth.signOut()
    }
}
