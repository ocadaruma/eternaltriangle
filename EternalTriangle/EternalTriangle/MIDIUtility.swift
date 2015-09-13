//
//  MIDIUtility.swift
//  EternalTriangle
//
//  Created by hokada on 9/13/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

func pitchToMIDINote(pitch: Pitch) -> UInt8 {
  var note: UInt8 = 0

  switch pitch.name {
  case .C: note += 0
  case .D: note += 2
  case .E: note += 4
  case .F: note += 5
  case .G: note += 7
  case .A: note += 9
  case .B: note += 11
  }

  if let accidental = pitch.accidental {
    switch accidental {
    case .DoubleFlat: note -= 2
    case .DoubleSharp: note += 2
    case .Flat: note -= 1
    case .Sharp: note += 1
    case .Natural: ()
    }
  }

  note += UInt8((pitch.offset + 4) * 12)

  return note
}