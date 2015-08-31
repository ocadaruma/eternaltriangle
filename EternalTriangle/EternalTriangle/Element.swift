//
//  Element.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public protocol Element { }
public protocol HasLength : Element {
  var length: NoteLength { get }
}

public struct DefaultElement : Element { }

// singleton objects
public let BarLine = DefaultElement()
public let DoubleBarLine = DefaultElement()
public let SlurStart = DefaultElement()
public let SlurEnd = DefaultElement()
public let Tie = DefaultElement()

// elements has length
public struct Note : HasLength {
  public let length: NoteLength
}
public struct Rest : HasLength {
  public let length: NoteLength
}
public struct Chord : HasLength {
  public let length: NoteLength
  public let pitches: [Pitch]
}

public struct Tuplet : Element {
  public let notes: Int
  public let inTimeOf: Int? = nil
  public let defaultTime: Int = 3

  public let elements: [HasLength]

  public func time() -> Int {
    if let t = inTimeOf {
      return t
    } else {
      switch notes {
      case 2, 4, 8: return 3
      case 3, 6: return 2
      default: return defaultTime
      }
    }
  }
}
