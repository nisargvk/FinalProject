//
//  HomeView.swift
//  meetups
//
//  Created by Mac on 28.10.2020.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject() var userViewModel: UserViewModel
    @EnvironmentObject() var authViewModel: AuthViewModel

    @State private var selection: Int? = nil
    @State private var meetingDate = Date()
    var body: some View {
        
        NavigationView {
           
          //  NavigationLink(destination: ProfileView(), tag:1, selection: $selection){}
            VStack {
                NavigationLink(destination: ProfileView(), tag:1, selection: $selection){
                   // Text(userViewModel.userProfile.username).foregroundColor(.blue)
                }
                NavigationLink(destination: MeetingInfoView(), tag:3, selection: $selection){}
                NavigationLink(destination: SignInView(), tag:2, selection: $selection){}
                if userViewModel.profileIsLoaded {
                  
                    
                    Button(action:{
                       // print("Add a meeting")
                        self.meetingView()
                        
                    }){
                        Image(systemName:"plus")
                            .resizable()
                            .frame(width: 40, height:40)
                            .shadow(radius: 1,x: 1,y:1)
                            .offset(y:350)
                       
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
//                        foregroundColor(.blue)
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
        //print(#function)
        //self.userViewModel.userProfile
        self.selection = 1
       
    }
    
    private func meetingView(){
        self.selection = 3
    }
    
    private func signOut(){
        self.authViewModel.signOut()
        
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
