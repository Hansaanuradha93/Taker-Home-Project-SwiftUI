//
//  Models.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
