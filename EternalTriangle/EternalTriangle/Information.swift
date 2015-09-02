//
//  Information.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public protocol Information { }

public struct TuneTitle : Information {
  public let title: String
}

public struct Composer : Information {
  public let name: String
}

public struct Meter : Information {
  public let numerator: Int
  public let denominator: Int
}

public struct UnitNoteLength : Information {
  public let length: NoteLength
}

public struct Tempo : Information {
  public let bpm: Int
  public let inLength: NoteLength
}

public enum KeySignature {
  case Sharp1, Sharp2, Sharp3, Sharp4, Sharp5, Sharp6, Sharp7
  case Zero
  case Flat1, Flat2, Flat3, Flat4, Flat5, Flat6, Flat7
}

public struct Key : Information {
  public let keySignature: KeySignature
}

public struct VoiceHeader : Information {
  public let id: String
  public let clef: Clef
}