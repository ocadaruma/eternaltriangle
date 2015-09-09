//
//  Element.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public protocol MusicalElement {}
public protocol HasLength : MusicalElement, Equatable {}

public enum Simple : MusicalElement {
  case BarLine
  case DoubleBarLine
  case SlurStart
  case SlurEnd
  case Tie
  case Space
  case LineBreak
}

public struct Note : HasLength, Equatable {
  public let length: NoteLength
  public let pitch: Pitch
  public init(length: NoteLength, pitch: Pitch) {
    self.length = length
    self.pitch = pitch
  }
}

public func ==(lhs: Note, rhs: Note) -> Bool {
  return lhs.length == rhs.length &&
    lhs.pitch == rhs.pitch
}

public struct Rest: HasLength, Equatable {
  public let length: NoteLength
  public init(length: NoteLength) {
    self.length = length
  }
}

public func ==(lhs: Rest, rhs: Rest) -> Bool {
  return lhs.length == rhs.length
}

public struct MultiMeasureRest : MusicalElement, Equatable {
  public let num: Int
}

public func ==(lhs: MultiMeasureRest, rhs: MultiMeasureRest) -> Bool {
  return lhs.num == rhs.num
}

public struct Chord : HasLength, Equatable {
  public let length: NoteLength
  public let pitches: [Pitch]
}

public func ==(lhs: Chord, rhs: Chord) -> Bool {
  return lhs.length == rhs.length &&
    lhs.pitches == rhs.pitches
}

public struct VoiceId : MusicalElement, Equatable {
  public let id: String
}

public func ==(lhs: VoiceId, rhs: VoiceId) -> Bool {
  return lhs.id == rhs.id
}

public struct Tuplet<T : HasLength> : MusicalElement, Equatable {
  public let notes: Int
  public let inTimeOf: Int?
  private let defaultTime: Int = 3

  public let elements: [T]

  public var time: Int {
    get {
      if let t = inTimeOf {
        return t
      } else {
        switch notes {
        case 2, 4, 8: return 3
        case 3, 6: return 2
        default: return self.defaultTime
        }
      }
    }
  }
}

public func == <T : HasLength>(lhs: Tuplet<T>, rhs: Tuplet<T>) -> Bool {
  return lhs.notes == rhs.notes &&
    lhs.inTimeOf == rhs.inTimeOf &&
    lhs.elements == rhs.elements
}
