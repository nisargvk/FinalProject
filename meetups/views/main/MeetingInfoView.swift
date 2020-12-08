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
    @State private var duration = 0
    var durationType = ["Private","Public"]

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
                    Section{
                        TextField("Meeting Location", text: $meetingLocation)
                    }
                }
            }
            Button(action:{
                //self.addParking()
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
}

struct MeetingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingInfoView()
    }
}
