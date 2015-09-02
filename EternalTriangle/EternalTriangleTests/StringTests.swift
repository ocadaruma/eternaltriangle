//
//  StringTests.swift
//  EternalTriangle
//
//  Created by hokada on 9/3/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//


import Foundation
import XCTest
import EternalTriangle

class StringTests: XCTestCase {
  func testWholeMatch() {
    let matches = "abcDEFghi".matchesWithPattern("abc[DXY]")
    XCTAssertEqual(matches.count, 1)
    XCTAssertEqual(matches[0].match, "abcD")
    XCTAssertEqual(matches[0].range.startIndex, "abcD".startIndex)
    XCTAssertEqual(matches[0].range.endIndex, "abcD".endIndex)
  }

  func testCapture() {
    let matches = "abcDEFghi".matchesWithPattern("abc([DXY][EXY]Fg)(.*)")
    XCTAssertEqual(matches.count, 3)
    XCTAssertEqual(matches[0].match, "abcDEFghi")
    XCTAssertEqual(matches[1].match, "DEFg")
    XCTAssertEqual(matches[2].match, "hi")
  }

  func testEmpty() {
    let matches = "abcDEFghi".matchesWithPattern("ghi")
    XCTAssertEqual(matches.count, 0)
  }
}
