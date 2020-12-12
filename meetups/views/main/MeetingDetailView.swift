//
//  MeetingDetailView.swift
//  meetups
//
//  Created by Nisarg on 2020-12-08.
//

import SwiftUI

struct MeetingDetailView: View {
    var meeting: Meeting
    @State private var selection: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            NavigationLink(destination: DirectionsView(location: self.meeting.meetingLocation,
                                                       lat: self.meeting.meetingLat,
                                                       lng: self.meeting.meetingLng),
                           tag: 1, selection: $selection){}
            

            Text("Meeting Purpose : \(meeting.purpose)")
            Text("Email: \(meeting.email)")
            Text("Meeting Date: \(meeting.meetingDate)")
            //Text("Meeting Type: \(meeting.durationType)")
            
            VStack{
                Text("Location: \(meeting.meetingLocation)")
                .bold()
                
                Button(action: {
                    self.selection = 1
                }){
                    Image(systemName: "arrow.up.right.diamond.fill")
                        .foregroundColor(Color.blue)
                }
            }
            
            Spacer()
        }
        .padding(5)
        .navigationBarTitle(Text("Meeting Details"))
    }
    
    
}


struct MeetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(meeting: Meeting())
    }
}
