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
    @EnvironmentObject() var meetingViewModel: MeetingViewModel
    @Environment(\.presentationMode) var presentationMode



    @State private var selection: Int? = nil
    @State private var meetingDate = Date()
    var body: some View {
        NavigationLink(destination: ProfileView(), tag:1, selection: $selection){
           // Text(userViewModel.userProfile.username).foregroundColor(.blue)
        }
        NavigationLink(destination: MeetingInfoView(), tag:3, selection: $selection){}
        NavigationLink(destination: SignInView(), tag:2, selection: $selection){}
        NavigationView {
           
          //  NavigationLink(destination: ProfileView(), tag:1, selection: $selection){}
           // VStack {
               
                    ZStack{
                        if userViewModel.profileIsLoaded {
                        
                        List{
                            ForEach(self.meetingViewModel.meetingList, id: \.self){ (parking) in
                                
                                    
                                    HStack{

                                        Text("@ \(parking.meetingLocation)")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                
                            }
                            .onDelete{(indexSet) in
                                for index in indexSet{
                                    self.meetingViewModel.deleteMeeting(index: index)
                                }
                                
                            }
                    
                            
                        }
                }else {
                    VStack {
                        ProgressView()
                        Text("Entering...")
                    }
                }
                        
                        Button(action:{
                            print("Add a meeting")
                            self.selection = 3
                        }){
                            Image(systemName:"plus")
                                .resizable()
                                .frame(width: 40, height:40)
                                .shadow(radius: 1,x: 1,y:1)
                               // .offset(y:350)
                                
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

        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            userViewModel.listenToUser()
        }.onDisappear {
            userViewModel.stopListeningToUser()
        }
        .onAppear(){
            //self.meetingViewModel.meetingList.removeAll()
            self.meetingViewModel.getAllMeetings()
        }
    }
    
    private func editProfile(){
        //print(#function)
        //self.userViewModel.userProfile
        self.selection = 1
       
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
