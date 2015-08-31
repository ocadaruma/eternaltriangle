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
    XCTAssertFalse(s.eos)
    XCTAssert(s.scan("\\w+") == "This")
    XCTAssertNil(s.scan("\\w+"))
    XCTAssert(s.scan("\\s+") == " ")
    XCTAssertNil(s.scan("\\s+"))
    XCTAssert(s.scan("\\w+") == "is")
    XCTAssertFalse(s.eos)

    XCTAssert(s.scan("\\s+") == " ")
    XCTAssert(s.scan("\\w+") == "an")
    XCTAssert(s.scan("\\s+") == " ")
    XCTAssert(s.scan("\\w+") == "example")
    XCTAssert(s.scan("\\s+") == " ")
    XCTAssert(s.scan("\\w+") == "string")
    XCTAssert(s.eos)

    XCTAssertNil(s.scan("\\s+"))
    XCTAssertNil(s.scan("\\w+"))
  }
}
