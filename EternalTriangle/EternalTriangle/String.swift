//
//  String.swift
//  EternalTriangle
//
//  Created by hokada on 9/2/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public struct MatchResult {
  public let match: String
  public let range: Range<String.Index>
}

public extension String {
  public var range: NSRange {
    get {
      return NSMakeRange(0, count(self))
    }
  }

  public func matchesWithPattern(pattern: String) -> [MatchResult] {
    let regex = NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines, error: nil)

    let match = regex?.firstMatchInString(self,
      options: .Anchored,
      range: self.range)

    if let m = match {
      let n = m.numberOfRanges
      var matches: [MatchResult] = []
      for i in 0..<n {
        let r = m.rangeAtIndex(i)
        if r.location != NSNotFound {
          let start = advance(self.startIndex, r.location)
          let end = advance(start, r.length)
          let range = start..<end

          let result = MatchResult(
            match: self.substringWithRange(range),
            range: range)

          matches.append(result)
        }
      }
      return matches
    } else {
      return []
    }
  }
}