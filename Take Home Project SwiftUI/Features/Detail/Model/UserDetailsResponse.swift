//
//  UserDetailsResponse.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import Foundation

// MARK: - UserDetailsResponse
struct UserDetailsResponse: Codable {
    let data: User
    let support: Support
}
