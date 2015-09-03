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

// compose parsers.
// if first parser returns nil, run second.
func || <T, U> (f: T -> (U?, T), g: T -> (U?, T)) -> T -> (U?, T) {
  return { (a: T) -> (U?, T) in
    let (fR, rest) = f(a)

    switch fR {
    case .Some(let r): return (r, rest)
    case .None: return g(rest)
    }
  }
}

// parsers for header

public let parseReference = createParser("^X:\\s*(\\d+)$\n?", { m -> Header in
  Reference(number: m[1].match.toInt()!)
})

public let parseTuneTitle = createParser("^T:\\s*(.+)$\n?", { m -> Header in
  TuneTitle(title: m[1].match)
})

public let parseComposer = createParser("^C:\\s*(.+)$\n?", { m -> Header in
  Composer(name: m[1].match)
})

public let parseMeter = createParser("^M:\\s*((?:\\d+/\\d+)|C\\||C)$\n?", { matches -> Header in
  var (num, den) = (4, 4)
  let body = matches[1].match
  switch body {
  case "C|":
    (num, den) = (2, 2)
  case "C":
    (num, den) = (4, 4)
  default:
    let m = body.matchesWithPattern("(\\d+)/(\\d+)")
    num = m[1].match.toInt()!
    den = m[2].match.toInt()!
  }
  return Meter(numerator: num, denominator: den)
})

public let parseUnitNoteLength = createParser("^L:\\s*1/(\\d+)$\n?", { m -> Header in
  let den = m[1].match.toInt()!
  return UnitNoteLength(denominator: UnitDenominator(rawValue: den) ?? .Quarter)
})

public let parseTempo = createParser("^Q:\\s*(\\d+)/(\\d+)=(\\d+)$\n?", { m -> Header in
  let num = m[1].match.toInt()!
  let den = m[2].match.toInt()!
  let bpm = m[3].match.toInt()!

  return Tempo(bpm: bpm, inLength: NoteLength(numerator: num, denominator: den))
})

public let parseKey = createParser("^K:\\s*([ABCDEFG][#b]?m?)$\n?", { m -> Header in
  var sig = KeySignature.Zero

  switch m[1].match {
  case "C", "Am": sig = .Zero
  case "G", "Em": sig = .Sharp1
  case "D", "Bm": sig = .Sharp2
  case "A", "F#m": sig = .Sharp3
  case "E", "C#m": sig = .Sharp4
  case "B", "G#m": sig = .Sharp5
  case "F#", "D#m": sig = .Sharp6
  case "C#", "A#m": sig = .Sharp7
  case "F", "Dm": sig = .Flat1
  case "Bb", "Gm": sig = .Flat2
  case "Eb", "Cm": sig = .Flat3
  case "Ab", "Fm": sig = .Flat4
  case "Db", "Bbm": sig = .Flat5
  case "Gb", "Ebm": sig = .Flat6
  case "Cb", "Abm": sig = .Flat7
  default: sig = .Zero
  }

  return Key(keySignature: sig)
})

public let parseVoiceHeader = createParser("^V:\\s*(\\w+)\\s*(?:clef=(\\w+))?$\n?", { m -> Header in
  let id = m[1].match
  if m.count < 3 {
    return VoiceHeader(id: id, clef: Clef(clefName: .Treble))
  } else {
    let clefName = ClefName(rawValue: m[2].match) ?? .Treble
    return VoiceHeader(id: id, clef: Clef(clefName: clefName))
  }
})

//public func parseComment<T>(string: String) -> (T?, String) {
//  let scanner = StringScanner(string: string)
//  let matches = scanner.scan("^%.*$\n?")
//  return (nil, scanner.result)
//}
//
//public func parseLine(string: String) -> (String?, String) {
//  let scanner = StringScanner(string: string)
//  let matches = scanner.scan("(^.*$)(\n)?")
//  return (nil, scanner.result)
//}

let parseHeader =
parseReference ||
parseTuneTitle ||
parseComposer ||
parseMeter ||
parseUnitNoteLength ||
parseTempo ||
parseKey ||
parseVoiceHeader

// parsers for element

let parseDoubleBarLine = createParser("\\|\\|", { m -> MusicalElement in
  Simple.DoubleBarLine
})

let parseBarLine = createParser("\\|", { m -> MusicalElement in
  Simple.BarLine
})

let parseSlurStart = createParser("\\(", { m -> MusicalElement in
  Simple.SlurStart
})

let parseSlurEnd = createParser("\\)", { m -> MusicalElement in
  Simple.SlurEnd
})

let parseSpace = createParser("\\s+", { m -> MusicalElement in
  Simple.Space
})

let parseLineBreak = createParser("\n", { m -> MusicalElement in
  Simple.LineBreak
})

// parse string in subset of ABC notation to tune
public class ABCParser {
  private let string: String

  public init(string: String) {
    self.string = string
  }

  private func buildResult(headers: [Header], elems: [MusicalElement]) -> Tune? {
    return nil
  }

  private func parseIter(str: String, headers: [Header], elems: [MusicalElement]) -> Tune? {
    if (str.isEmpty) {
      return buildResult(headers, elems: elems)
    } else {
      var nextHeaders = headers
      let (hOpt, rest) = parseHeader(str)
      if let h = hOpt {
        nextHeaders.append(h)
      } else {

      }
      return parseIter(rest, headers: nextHeaders, elems: elems)
    }
  }

  public func parse() -> Tune? {
    return parseIter(string, headers: [], elems: [])
  }
}
