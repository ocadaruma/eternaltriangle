//
//  Element.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public protocol MusicalElement {}
public protocol HasLength : MusicalElement {
  var length: NoteLength { get }
}

public enum Simple : MusicalElement {
  case BarLine
  case DoubleBarLine
  case SlurStart
  case SlurEnd
  case Tie
  case Space
  case LineBreak
}

public struct Note : HasLength {
  public let length: NoteLength
  public let pitch: Pitch
}

public struct Rest: HasLength {
  public let length: NoteLength
}

public struct MultiMeasureRest : MusicalElement {
  public let num: Int
}

public struct Chord : HasLength {
  public let length: NoteLength
  public let pitches: [Pitch]
}

public struct VoiceId : MusicalElement {
  public let id: String
}

public struct Tuplet : MusicalElement {
  public let notes: Int
  public let inTimeOf: Int? = nil
  static let defaultTime: Int = 3

  public let elements: [HasLength]

  public var time: Int {
    get {
      if let t = inTimeOf {
        return t
      } else {
        switch notes {
        case 2, 4, 8: return 3
        case 3, 6: return 2
        default: return Tuplet.defaultTime
        }
      }
    }
  }
}
