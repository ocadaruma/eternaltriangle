//
//  Core.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public enum PitchName: Int {
  case C = 0, D, E, F, G, A, B
}

public enum Accidental {
  case Natural, Flat, Sharp, DoubleFlat, DoubleSharp
}

public struct Pitch {
  public let name: PitchName
  public let accidental: Accidental? = nil
  public let octave: Int
}

public enum UnitDenominator: Double {
  case Whole = 1
  case Half = 2
  case Quarter = 4
  case Eighth = 8
  case Sixteenth = 16
  case ThirtySecond = 32
  case SixtyFourth = 64
}

public struct NoteLength {
  public let unit: UnitDenominator
  public let numerator: Int
  public let denominator: Int
}
