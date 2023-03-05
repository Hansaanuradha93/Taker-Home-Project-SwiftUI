//
//  NetworkManagerUsersResponseSuccessMock.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-03-05.
//

import Foundation
@testable import Take_Home_Project_SwiftUI

class NetworkManagerUsersResponseSuccessMock: NetworkManagerImplementation {
    
    func request<T>(session: URLSession, endPoint: Take_Home_Project_SwiftUI.Endpoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self) as! T
    }
    
    func request(session: URLSession, endPoint: Take_Home_Project_SwiftUI.Endpoint) async throws { }
    
}
