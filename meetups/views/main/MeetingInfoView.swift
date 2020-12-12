//
//  MeetingInfoView.swift
//  meetups
//
//  Created by Nisarg on 2020-11-17.
//

import SwiftUI

struct MeetingInfoView: View {
    @ObservedObject var locationManager = LocationManager()
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject() var userViewModel: UserViewModel
    @State private var purpose: String = ""
    @State private var meetingDate = Date()
    @State private var meetingLocation: String = ""
    @State private var duration = 0
    @State var durationType = ["Private","Public"]
    
    @State private var meetingLat: Double = 0.0
    @State private var meetingLng: Double = 0.0
   

    var body: some View {
        VStack{
            Form{
                Section{
                    TextField("Purpose Of meeting", text: $purpose)
                    DatePicker(selection: $meetingDate, in: ...Date()){
                        Text("Meeting Date")
                    }
                    
                    Section(){
                        Picker(selection: $duration,label: Text("Meeting Type")){
                                ForEach(0 ..< durationType.count) {
                                               Text(self.durationType[$0])
                                }
                        }
                    }
                }
                
                Section{
                    HStack{
                        TextField("Meeting Location", text:$meetingLocation)
                        Button(action: {
                            self.getLocation()
                        }){
                            Image(systemName: "location")
                        }
                    }
                }
            }
            Button(action:{
                self.addMeeting()
            }){
                Text("Add Parking")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(
                        Color(UIColor(Color.orange)
                    ))
                    .cornerRadius(5.0)
            }
            
        }
    }
    
    private func validateForm() -> String? {
        if purpose.isEmpty{
            return "Provide your purpose"
        }
        
        if durationType.isEmpty {
            return "Please specify the meeting type"
        }
        
        return nil
    }
    
    private func getLocation(){
        print(#function, "Getting Location")
        
        self.locationManager.start()
        
        print(#function, "Address : \(self.locationManager.address)")
        print(#function, "Lat : \(self.locationManager.lat)")
        print(#function, "Lng : \(self.locationManager.lng)")
        
        self.meetingLocation = self.locationManager.address
        self.meetingLat = self.locationManager.lat
        self.meetingLng = self.locationManager.lng
    }
    
    private func addMeeting(){
        var newMeeting = Meeting()
        let error = validateForm()
        newMeeting.email = self.userSettings.userEmail
        newMeeting.purpose = self.purpose
        newMeeting.meetingDate = self.meetingDate
       // newMeeting.durationType = self.durationType
        newMeeting.meetingLocation = self.meetingLocation
        
        print(#function, "New Meeting : \(newMeeting)")
        
        meetingViewModel.addMeeting(newMeeting: newMeeting)
        
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct MeetingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingInfoView()
    }
}
