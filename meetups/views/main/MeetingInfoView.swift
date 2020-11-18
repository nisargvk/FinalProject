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

    var body: some View {
        VStack{
            Form{
                Section{
                    TextField("Purpose Of meeting", text: $purpose)
                    DatePicker(selection: $meetingDate, in: ...Date()){
                        Text("Meeting Date")
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
