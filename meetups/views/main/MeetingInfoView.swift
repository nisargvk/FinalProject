//
//  MeetingInfoView.swift
//  meetups
//
//  Created by Nisarg on 2020-11-17.
//

import SwiftUI

struct MeetingInfoView: View {
    
    @State private var purpose: String = ""
    @State private var meetingDate = Date()
    @State private var meetingLocation: String = ""
    @State private var duration: String = ""
    let durationHours = ["Private","Public"]

    var body: some View {
        VStack{
            Form{
                Section{
                    TextField("Purpose Of meeting", text: $purpose)
                    DatePicker(selection: $meetingDate, in: ...Date()){
                        Text("Meeting Date")
                    }
                    
                    Section(header: Text("Meeting Type")){
                        Picker(selection: $duration,label: Text("Duration"), content: /*@START_MENU_TOKEN@*/{
                        })
                        }
                    Section{
                        TextField("Meeting Location", text: $meetingLocation)
                    }
                }
            }
            
        }
    }
}

struct MeetingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingInfoView()
    }
}
