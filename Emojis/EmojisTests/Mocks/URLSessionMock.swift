//
//  URLSessionMock.swift
//  EmojisTests
//
//  Created by Tobias Lewinzon on 23/05/2024.
//

import Foundation
@testable import Emojis

enum SomeError: Error {
    case runtimeError(String)
}

class URLSessionSuccessMock: URLSessionProxy {
    let forSuccess: Bool
    
    init(forSuccess: Bool) {
        self.forSuccess = forSuccess
    }
    
    func getData(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard forSuccess else {
            throw SomeError.runtimeError("Faking an error response")
        }
        
        guard let fakeData = getResponseData() else {
            throw SomeError.runtimeError("Decoding error")
        }
        
        return (fakeData, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: [:])!)
    }
    
    
    private func getResponseData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "emojisMockResponse", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
}


