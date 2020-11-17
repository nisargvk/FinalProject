//
//  HomeView.swift
//  meetups
//
//  Created by Mac on 28.10.2020.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject() var userViewModel: UserViewModel
    @State private var selection: Int? = nil
    @State private var meetingDate = Date()
    var body: some View {
        NavigationView {
            NavigationLink(destination: ProfileView(), tag:1, selection: $selection){}
            VStack {
                if userViewModel.profileIsLoaded {
                    Button(action:{
                        print("Add a meeting")
                        self.selection = 2
                    }){
                        Image(systemName:"plus")
                            
                    }
                } else {
                    VStack {
                        ProgressView()
                        Text("Entering...")
                    }
                }
            }.navigationBarTitle("My meetups", displayMode: .inline)
            .navigationBarBackButtonHidden(false)
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        //Button("Delete Account", action: self.deleteAccount)
                        Button("Edit Profile", action: self.editProfile)
                        Button("SignOut", action: self.signOut)
                    }label:{
                        Image(systemName: "gear")
                    }
                    
                }
            }
//            .navigationBarItems(trailing:
//                NavigationLink(destination: ProfileView()) {
//                    Text(userViewModel.userProfile.username)
//                        .foregroundColor(.blue)
//                }
//            )
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            userViewModel.listenToUser()
        }.onDisappear {
            userViewModel.stopListeningToUser()
        }
    }
    private func editProfile(){
        self.selection = 1
       
    }
    
    private func signOut(){
        self.selection = 1
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        MainView()
            .environmentObject(
                AuthViewModel(functions: appDelegate.functions, auth: appDelegate.auth)
            )
            .environmentObject(
                UserViewModel(
                    firestore: appDelegate.firestore,
                    functions: appDelegate.functions,
                    auth: appDelegate.auth,
                    storage: appDelegate.storage
                )
            )
    }
}
