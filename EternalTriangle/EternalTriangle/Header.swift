//
//  Information.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public protocol Header { }

public struct Reference : Header {
  public let number: Int
}

public struct TuneTitle : Header {
  public let title: String
}

public struct Composer : Header {
  public let name: String
}

public struct Meter : Header {
  public let numerator: Int
  public let denominator: Int
}

public struct UnitNoteLength : Header {
  public let denominator: UnitDenominator
}

public struct Tempo : Header {
  public let bpm: Int
  public let inLength: NoteLength
}

public enum KeySignature {
  case Sharp1, Sharp2, Sharp3, Sharp4, Sharp5, Sharp6, Sharp7
  case Zero
  case Flat1, Flat2, Flat3, Flat4, Flat5, Flat6, Flat7
}

public struct Key : Header {
  public let keySignature: KeySignature
}

public struct VoiceHeader : Header {
  public let id: String
  public let clef: Clef
}