//
//  ContentView.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 28.10.2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject() var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            // Waiting until the current authentication state is loaded
            if authViewModel.isLoaded {
                Group {
                    if authViewModel.isAuthed {
                        MainView()
                    } else {
                        SignInView()
                    }
                }
            } else {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
            }
        }
        .onAppear {
            authViewModel.listenToAuth()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    private static func authed(vm: AuthViewModel) -> AuthViewModel {
        vm.isAuthed = true
        
        return vm
    }
    
    private static func loggedIn(vm: UserViewModel) -> UserViewModel {
        vm.userProfile = UserProfile(username: "Greg", email: "Email", profileImage: "")
        
        return vm
    }
    
    static var previews: some View {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let authViewModel = AuthViewModel(functions: appDelegate.functions, auth: appDelegate.auth)
        
        let userViewModel = UserViewModel(
            firestore: appDelegate.firestore,
            functions: appDelegate.functions,
            auth: appDelegate.auth,
            storage: appDelegate.storage
        )
        
        ContentView()
            .environmentObject(
                authed(vm: authViewModel)
            )
            .environmentObject(
                loggedIn(vm: userViewModel)
            )
    }
}
