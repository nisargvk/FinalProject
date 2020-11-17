//
//  Network.swift
//  meetups
//
//  Created by Mac on 10.11.2020.
//

import Foundation
import SwiftUI

func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}
