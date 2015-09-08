//
//  ParserTests.swift
//  EternalTriangle
//
//  Created by hokada on 9/1/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation
import XCTest
import EternalTriangle

class ParserTests: XCTestCase {
  func testParse() {
    let path = NSBundle(forClass: ParserTests.self).pathForResource("song", ofType: "txt")!
    let string = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
//    let parser = ABCParser(string: string)
//    let tune = parser.parse()!

    parseTuplet("(2ab")
  }
}