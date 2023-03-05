//
//  NetworkManagerUsersResponseFailureMock.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-03-05.
//

import Foundation
@testable import Take_Home_Project_SwiftUI

class NetworkManagerUsersResponseFailureMock: NetworkManagerImplementation {
    
    func request<T>(session: URLSession, endPoint: Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkManager.NetworkError.invalidURL
    }
    
    func request(session: URLSession, endPoint: Endpoint) async throws { }
}
