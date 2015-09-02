//
//  ABCParser.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

//func parseTuneTitle(string: String) -> (TuneTitle?, String) {
//  if let s = StringScanner(string: string).scan("^T:\\s\\w+$") {
//    return (nil, string)
//  } else {
//    return (nil, string)
//  }
//}

//func parseComposer(string: String) -> (Composer?, String) {
//
//}
//
//func parseMeter(string: String) -> (Meter?, String) {
//
//}
//
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
