//
//  MockURLSessionProtocol.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-03-04.
//

import Foundation
import XCTest

class MockURLSesstionProtocol: URLProtocol {
    
    static var loadingHandler: (() -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        guard let handler = MockURLSesstionProtocol.loadingHandler else {
            XCTFail()
            return
        }
        
        let (response, data) = handler()
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
