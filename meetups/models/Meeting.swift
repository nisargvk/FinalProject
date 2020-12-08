//
//  Meeting.swift
//  meetups
//
//  Created by Nisarg on 2020-12-07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct Meeting: Codable, Hashable {
    @DocumentID var id = UUID().uuidString
    var email: String = ""
    var purpose: String = ""
    var meetingDate = Date()
    var meetingLocation: String = ""
    var meetingLat: Double = 0.0
    var meetingLng: Double = 0.0
    
    init(){}
    
    init(email: String, purpose: String, meetingDate: Date, meetingLocation: String){
        self.email = email
        self.purpose = purpose
        self.meetingDate = meetingDate
        self.meetingLocation = meetingLocation
    }
}
