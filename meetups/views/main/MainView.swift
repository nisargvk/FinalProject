//
//  HomeView.swift
//  meetups
//
//  Created by  Nisarg Khandhar on 28.10.2020.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject() var userViewModel: UserViewModel
    @EnvironmentObject() var authViewModel: AuthViewModel
    @EnvironmentObject var meetingViewModel: MeetingViewModel

    @State private var selection: Int? = nil
    @State private var meetingDate = Date()
    var body: some View {
        
        NavigationView {
           
          //  NavigationLink(destination: ProfileView(), tag:1, selection: $selection){}
            VStack {
                NavigationLink(destination: ProfileView(), tag:1, selection: $selection){}
                NavigationLink(destination: MeetingInfoView(), tag:3, selection: $selection){}
                NavigationLink(destination: SignInView(), tag:2, selection: $selection){}
                
                List{
                    ForEach(self.meetingViewModel.meetingList, id: \.self){ (meeting) in
                        
                        NavigationLink(destination: MeetingDetailView(meeting: meeting)){

                           HStack{
//                                Text("\(Formatter().simplifiedDateDormatter(date: parking.parkingDate))")
                               Text("@ \(meeting.meetingLocation)")
                            }
                          .font(.headline)
                           .foregroundColor(.blue)
                       }
                        
                    }
                    .onDelete{(indexSet) in
                        for index in indexSet{
                            self.meetingViewModel.deleteMeeting(index: index)
                        }
                        
                    }
                    
                }
                if userViewModel.profileIsLoaded {
                  
                    //Button("Add Meeting", action: self.meetingView)

                    Button(action:{
                       // print("Add a meeting")
                        self.meetingView()

                    }){
                        Image(systemName:"plus")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(
                                Color(UIColor(Color.orange)
                            ))
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
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            userViewModel.listenToUser()
            //meetingViewModel.meetingList()
            self.meetingViewModel.meetingList.removeAll()
            self.meetingViewModel.getAllMeetings()

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
