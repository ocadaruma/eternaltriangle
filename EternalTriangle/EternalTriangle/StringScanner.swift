//
//  StringScanner.swift
//  EternalTriangle
//
//  Created by hokada on 8/15/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public class StringScanner {
  private var string: String

  public init(string: String) {
    self.string = string
  }

  public var result: String { get { return string } }

  public var eos: Bool { get { return string.characters.count <= 0 } }

  public func scan(pattern: String) -> [MatchResult] {
    let results = string.matchesWithPattern(pattern)
    if let r = results.first {
      string.removeRange(r.range)
    }
    return results
  }
}