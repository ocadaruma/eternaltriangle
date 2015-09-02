//
//  StringScannerTests.swift
//  EternalTriangle
//
//  Created by hokada on 8/15/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation
import XCTest
import EternalTriangle

class StringScannerTests: XCTestCase {
  func testScan() {
    let s = StringScanner(string: "This is an example string")
    let empty: [MatchResult] = []
    XCTAssertFalse(s.eos)
    XCTAssertEqual(s.scan("\\w+").first!.match, "This")
    XCTAssert(s.scan("\\w+").isEmpty)
    XCTAssertEqual(s.scan("\\s+").first!.match, " ")
    XCTAssert(s.scan("\\s+").isEmpty)
    XCTAssertEqual(s.scan("\\w+").first!.match, "is")
    XCTAssertFalse(s.eos)

    XCTAssertEqual(s.scan("\\s+").first!.match, " ")
    XCTAssertEqual(s.scan("\\w+").first!.match, "an")
    XCTAssertEqual(s.scan("\\s+").first!.match, " ")
    XCTAssertEqual(s.scan("\\w+").first!.match, "example")
    XCTAssertEqual(s.scan("\\s+").first!.match, " ")
    XCTAssertEqual(s.scan("\\w+").first!.match, "string")
    XCTAssert(s.eos)

    XCTAssert(s.scan("\\s+").isEmpty)
    XCTAssert(s.scan("\\w+").isEmpty)
  }
}
