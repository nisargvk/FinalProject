//
//  GoogleSignInController.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 10.11.2020.
//

import Foundation
import Firebase
import GoogleSignIn

// Making it ObservableObject in order to pass as an EnvironmentObject
class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    private let firebaseAuth: Auth
    
    init (firebaseAuth: Auth){
        self.firebaseAuth = firebaseAuth
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let auth = user.authentication else { return }

        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print("Firebase-Google Sign In Eror")
                print(error.localizedDescription)
            }
        }
    }
}
