//
//  Meeting.swift
//  meetups
//
//  Created by Baljinder Singh on 2020-11-18.
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
    
    init(){}
    
    init(email: String, purpose: String, meetingDate: Date, meetingLocation: String){
        self.email = email
        self.purpose = purpose
        self.meetingDate = meetingDate
        self.meetingLocation = meetingLocation
    }
}
