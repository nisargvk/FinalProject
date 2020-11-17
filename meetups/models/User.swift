//
//  User.swift
//  meetups
//
//  Created by Mac on 28.10.2020.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var profileImage: String

    init(id: String, username: String, email: String, profileImage: String) {
        self.id = id
        self.username = username
        self.email = email
        self.profileImage = profileImage
    }

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case profileImage
    }
}
