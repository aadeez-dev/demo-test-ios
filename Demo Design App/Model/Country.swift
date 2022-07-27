//
//  Country.swift
//  Demo Design App
//
//  Created by Aadeez Shaikh on 27/07/22.
//

import Foundation

struct Country: Codable {
    let code, emoji, unicode, name: String
    let title, dialCode: String?
}
