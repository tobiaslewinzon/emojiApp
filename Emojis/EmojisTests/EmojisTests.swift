//
//  EmojisTests.swift
//  EmojisTests
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import XCTest
@testable import Emojis

final class EmojisTests: XCTestCase {

    func testSuccessfullCall() async {
        // Clear tables.
        Category.deleteAll()
        // Setup URLSessionSuccessMock for success.
        let mockSession = URLSessionSuccessMock(forSuccess: true)
        let success = await EmojiService.getEmojis(urlSession: mockSession)
        // Assert data was decoded and saved.
        XCTAssertTrue(success)
        // Check data count.
        XCTAssertEqual(Emoji.getAll().count, 10)
    }
    
    func testFailedCall() async {
        // Clear tables.
        Category.deleteAll()
        // Setup URLSessionSuccessMock for failure.
        let mockSession = URLSessionSuccessMock(forSuccess: false)
        let success = await EmojiService.getEmojis(urlSession: mockSession)
        // Assert data was not decoded and saved.
        XCTAssertFalse(success)
        // Check data count.
        XCTAssertEqual(Emoji.getAll().count, 0)
    }
    
    func testFailedCallWithCache() async {
        var mockSession: URLSessionSuccessMock
        var success: Bool
        
        // Clear tables.
        Category.deleteAll()
        
        // Setup URLSessionSuccessMock for success.
        mockSession = URLSessionSuccessMock(forSuccess: true)
        success = await EmojiService.getEmojis(urlSession: mockSession)
        // Assert data was decoded and saved.
        XCTAssertTrue(success)
        
        // Setup URLSessionSuccessMock for failure.
        mockSession = URLSessionSuccessMock(forSuccess: false)
        success = await EmojiService.getEmojis(urlSession: mockSession)
        // Assert data was retrieved anyways.
        XCTAssertTrue(success)
    }
}
