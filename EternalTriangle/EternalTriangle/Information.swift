//
//  Information.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public protocol Information {
  static var prefix: String { get }
}

public struct TuneTitle : Information {
  public static let prefix = "T"
  public let title: String
}

public struct Composer : Information {
  public static let prefix = "C"
  public let name: String
}

public struct Meter : Information {
  public static let prefix = "M"
  public let numerator: Int
  public let denominator: Int
}

public struct UnitNoteLength : Information {
  public static let prefix = "L"
  public let length: NoteLength
}

public struct Tempo : Information {
  public static let prefix = "Q"
  public let bpm: Int
  public let inLength: NoteLength
}

public enum KeySignature {
  case Sharp1, Sharp2, Sharp3, Sharp4, Sharp5, Sharp6, Sharp7
  case Zero
  case Flat1, Flat2, Flat3, Flat4, Flat5, Flat6, Flat7
}

public struct Key : Information {
  public static let prefix = "K"
  public let keySignature: KeySignature
}

public struct VoiceHeader : Information {
  public static let prefix = "V"
  public let id: String
  public let clef: Clef
}