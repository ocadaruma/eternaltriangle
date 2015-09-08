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

func eatPattern(pattern: String) -> String -> (Bool, String) {
  return { (string: String) -> (Bool, String) in
    let scanner = StringScanner(string: string)
    if scanner.scan(pattern).isEmpty {
      return (false, string)
    } else {
      return (true, scanner.result)
    }
  }
}

// compose parsers.
// if first parser returns nil, run second.
func || <T, U> (f: T -> (U?, T), g: T -> (U?, T)) -> T -> (U?, T) {
  return { a -> (U?, T) in
    let (fR, rest) = f(a)

    switch fR {
    case .Some(let r): return (r, rest)
    case .None: return g(rest)
    }
  }
}

func && <T, U, V> (f: T -> (U?, T), g: T -> (V?, T)) -> T -> (U?, V?, T) {
  return { a -> (U?, V?, T) in
    let (fR, rest) = f(a)

    switch fR {
    case .Some(let r):
      let (gR, gRest) = g(rest)
      return (r, gR, gRest)
    case .None: return (nil, nil, rest)
    }
  }
}

func && <T, U, V> (f: T -> (U?, T), g: T -> ([V], T)) -> T -> (U?, [V], T) {
  return { a -> (U?, [V], T) in
    let (fR, rest) = f(a)

    switch fR {
    case .Some(let r):
      let (gR, gRest) = g(rest)
      return (r, gR, gRest)
    case .None: return (nil, [], rest)
    }
  }
}

infix operator &> { associativity left }
infix operator &< { associativity left }

func &> <T, U, V> (f: T -> (U?, T), g: T -> (V?, T)) -> T -> (V?, T) {
  return { a -> (V?, T) in
    let (fR, rest) = f(a)

    switch fR {
    case .Some(let r):
      let (gR, gRest) = g(rest)
      return (gR, gRest)
    case .None: return (nil, rest)
    }
  }
}

func &> <T, U> (f: T -> (Bool, T), g: T -> (U?, T)) -> T -> (U?, T) {
  return { a -> (U?, T) in
    let (fR, rest) = f(a)
    if fR {
      let (gR, gRest) = g(rest)
      return (gR, gRest)
    } else {
      return (nil, rest)
    }
  }
}

func &> <T, U> (f: T -> (Bool, T), g: T -> ([U], T)) -> T -> ([U], T) {
  return { a -> ([U], T) in
    let (fR, rest) = f(a)
    if fR {
      let (gR, gRest) = g(rest)
      return (gR, gRest)
    } else {
      return ([], rest)
    }
  }
}

func &< <T, U> (f: T -> (U?, T), g: T -> (Bool, T)) -> T -> (U?, T) {
  return { a -> (U?, T) in
    let (fR, rest) = f(a)

    switch fR {
    case .Some(let r):
      let (gR, gRest) = g(rest)
      return (gR ? r : nil, gRest)
    case .None: return (nil, rest)
    }
  }
}

func &< <T, U> (f: T -> ([U], T), g: T -> (Bool, T)) -> T -> ([U], T) {
  return { a -> ([U], T) in
    let (fR, rest) = f(a)

    if fR.isEmpty {
      return ([], rest)
    } else {
      let (gR, gRest) = g(rest)
      return (gR ? fR : [], gRest)
    }
  }
}

public func repeat<T, U>(f: T -> (U?, T)) -> T -> ([U], T) {
  return { a -> ([U], T) in
    var fR: U?
    var rest: T = a
    var result: [U] = []
    do {
      (fR, rest) = f(rest)
      if let r = fR {
        result.append(r)
      }
    } while (fR != nil)
    return (result, rest)
  }
}

public func repeat<T, U>(f: T -> (U?, T), n: Int) -> T -> ([U], T) {
  return { a -> ([U], T) in
    var fR: U?
    var rest: T = a
    var result: [U] = []

    for i in 0..<n {
      (fR, rest) = f(rest)
      if let r = fR {
        result.append(r)
      }
      if fR == nil {
        break
      }
    }

    if count(result) == n {
      return (result, rest)
    } else {
      return ([], a)
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
  var sig: KeySignature

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

public func parseComment<T>(string: String) -> (T?, String) {
  let scanner = StringScanner(string: string)
  let matches = scanner.scan("^%.*$\n?")
  return (nil, scanner.result)
}

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

let parseTie = createParser("-", { m -> MusicalElement in
  Simple.Tie
})

let parseLineBreak = createParser("\n", { m -> MusicalElement in
  Simple.LineBreak
})

let parseVoiceId = createParser("^\\[V:\\s*(\\w+)\\]", { m -> MusicalElement in
  VoiceId(id: m[1].match)
})

public let parsePitch = createParser("(\\^{0,2}|_{0,2}|=?)([a-g]|[A-G])([',]*)", { m -> Pitch in
  var accidental: Accidental?
  var pitchName: PitchName
  var offset: Int = 0

  switch m[1].match {
  case "^^": accidental = .DoubleSharp
  case "^": accidental = .Sharp
  case "=": accidental = .Natural
  case "_": accidental = .Flat
  case "__": accidental = .DoubleFlat
  default: accidental = nil
  }

  switch m[2].match {
  case "C": pitchName = .C
  case "c": pitchName = .C; offset = 1
  case "D": pitchName = .D
  case "d": pitchName = .D; offset = 1
  case "E": pitchName = .E
  case "e": pitchName = .E; offset = 1
  case "F": pitchName = .F
  case "f": pitchName = .F; offset = 1
  case "G": pitchName = .G
  case "g": pitchName = .G; offset = 1
  case "A": pitchName = .A
  case "a": pitchName = .A; offset = 1
  case "B": pitchName = .B
  case "b": pitchName = .B; offset = 1
  default: pitchName = .C
  }

  offset += count(filter(m[3].match, { $0 == "'" }))
  offset -= count(filter(m[3].match, { $0 == "," }))

  return Pitch(
    name: pitchName,
    accidental: accidental,
    offset: offset)
})

public let parseNoteLength = createParser("(\\d*)/(\\d+)", { m -> NoteLength in
  var num: Int
  if m[1].match.isEmpty {
    num = 1
  } else {
    num = m[1].match.toInt()!
  }

  var den: Int
  if m[2].match.isEmpty {
    den = 1
  } else {
    den = m[2].match.toInt()!
  }

  return NoteLength(numerator: num, denominator: den)
}) || createParser("(\\d*)(/*)", { m -> NoteLength in
  var num: Int
  if m[1].match.isEmpty {
    num = 1
  } else {
    num = m[1].match.toInt()!
  }

  var den = 1
  for i in 0..<count(m[2].match) {
    den *= 2
  }

  return NoteLength(numerator: num, denominator: den)
})

public let parseNote = { (s: String) -> (MusicalElement?, String) in
  let (pitchOpt, lengthOpt, rest) = (parsePitch && parseNoteLength)(s)
  var note: Note?
  if let pitch = pitchOpt, length = lengthOpt {
    note = Note(length: length, pitch: pitch)
  } else {
    note = nil
  }

  return (note, rest)
}

let parseNoteAndTie = parseNote && parseTie

public let parseRest = { (s: String) -> (MusicalElement?, String) in
  let (lengthOpt, rest) = (eatPattern("z") &> parseNoteLength)(s)
  var r: Rest?
  if let length = lengthOpt {
    r = Rest(length: length)
  } else {
    r = nil
  }
  return (r, rest)
}

public let parseMultiMeasureRest = createParser("Z(\\d*)", { m -> MusicalElement in
  MultiMeasureRest(num: m[1].match.toInt()!)
})

public let parseChord = { (s: String) -> (MusicalElement?, String) in
  let (pitches, rest) = (eatPattern("\\[") &> repeat(parsePitch) &< eatPattern("\\]"))(s)
  if pitches.isEmpty {
    return (nil, s)
  } else {
    let (length, lRest) = parseNoteLength(rest)
    if let l = length {
      return (Chord(length: l, pitches: pitches), lRest)
    } else {
      return (nil, s)
    }
  }
}

public let parseTuplet = { (s: String) -> (MusicalElement?, String) in
  let (nOpt, rest) = (createParser("\\(([2-9])", { m -> Int in
    m[1].match.toInt()!
  }))(s)

  if let n = nOpt {
    let (elements, eR) = repeat(parseChord || parseNote || parseRest, n)(rest)
    if elements.isEmpty {
      return (nil, s)
    } else {
      return (Tuplet(notes: n, inTimeOf: nil, elements: elements.map { $0 as! HasLength }), eR)
    }
  } else {
    return (nil, s)
  }
}

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
