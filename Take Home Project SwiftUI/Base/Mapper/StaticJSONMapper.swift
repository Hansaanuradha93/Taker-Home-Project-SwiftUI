//
//  StaticJSONMapper.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import Foundation

struct StaticJSONMapper {
    
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
        
        guard let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToNavigateTOJSONFile
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let result = try decoder.decode(type, from: data)
            return result
        } catch (let error) {
            print("‼️ static JSON decoding error: \(error)")
            throw MappingError.decodingError
        }
    }
}

extension StaticJSONMapper {
    
    enum MappingError: Error {
        case failedToNavigateTOJSONFile
        case decodingError
    }
}
