//
//  StringScanner.swift
//  EternalTriangle
//
//  Created by hokada on 8/15/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public class StringScanner {
  private let string: NSMutableString

  public init(string: String) {
    self.string = NSMutableString(string: string)
  }

  public var result: String { get { return String(string) } }

  public var eos: Bool { get { return string.length <= 0 } }

  public func scan(pattern: String) -> String? {
    let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil)
    let range = regex.map {
      $0.rangeOfFirstMatchInString(String(string),
        options: NSMatchingOptions.Anchored,
        range: NSMakeRange(0, string.length))
    }

    return range.flatMap {
      if ($0.length > 0) {
        let subStr = string.substringWithRange($0)
        string.deleteCharactersInRange($0)
        return subStr
      } else {
        return nil
      }
    }
  }
}