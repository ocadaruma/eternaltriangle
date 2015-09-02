//
//  ABCParser.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

func createParser<T>(pattern: String, op: [MatchResult] -> T) -> String -> (T?, String) {
  return { (string: String) -> (T?, String) in
    let scanner = StringScanner(string: string)
    let matches = scanner.scan(pattern)
    if matches.isEmpty {
      return (nil, string)
    } else {
      return (op(matches), scanner.result)
    }
  }
}

public let parseTuneTitle = createParser("^T:\\s*(.+)\n?", { TuneTitle(title: $0[1].match) })
public let parseComposer = createParser("^C:\\s*(.+)\n?", { Composer(name: $0[1].match) })
public let parseMeter = createParser("^M:\\s*((?:\\d\\/\\d)|C\\||C)\n?", { (matches: [MatchResult]) -> Meter in
  var (num, den) = (4, 4)
  let body = matches[1].match
  switch body {
  case "C|":
    (num, den) = (2, 2)
  case "C":
    (num, den) = (4, 4)
  default:
    let m = body.matchesWithPattern("(\\d)\\/(\\d)")
    num = m[1].match.toInt()!
    den = m[2].match.toInt()!
  }
  return Meter(numerator: num, denominator: den)
})

//func parseUnitNoteLength(string: String) -> (UnitNoteLength?, String) {
//
//}
//
//func parseTempo(string: String) -> (Tempo?, String) {
//
//}
//
//func parseKey(string: String) -> (Key?, String) {
//
//}
//
//func parseVoiceHeader(string: String) -> (VoiceHeader?, String) {
//
//}

protocol Parser {
  typealias ResultType

  func parse(string: String) -> (ResultType?, String)
}

//struct Parser<Result> {
//  typealias RegexParser = String -> (Result?, String)
//}

// parse string in subset of ABC notation to tune
public class ABCParser {
//  public func parse(string: String) -> Tune? {
//    let scanner = StringScanner(string: string)
//    var headers: [Information] = []
//
//    while !scanner.eos {
//      if let header = scanner.scan("^[TCMLQKV]:\\s*") {
//
//      }
//
//
//    }
//
//    return nil
//  }
}
