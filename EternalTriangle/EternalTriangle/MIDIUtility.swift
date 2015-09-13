//
//  MIDIUtility.swift
//  EternalTriangle
//
//  Created by hokada on 9/13/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

let keySignatureMapFlat: [KeySignature : [PitchName]] = [
  .Flat1 : [.B],
  .Flat2 : [.B, .E],
  .Flat3 : [.B, .E, .A],
  .Flat4 : [.B, .E, .A, .D],
  .Flat5 : [.B, .E, .A, .D, .G],
  .Flat6 : [.B, .E, .A, .D, .G, .C],
  .Flat7 : [.B, .E, .A, .D, .G, .C, .F]
]

let keySignatureMapSharp: [KeySignature : [PitchName]] = [
  .Sharp1 : [.F],
  .Sharp2 : [.F, .C],
  .Sharp3 : [.F, .C, .G],
  .Sharp4 : [.F, .C, .G, .D],
  .Sharp5 : [.F, .C, .G, .D, .A],
  .Sharp6 : [.F, .C, .G, .D, .A, .E],
  .Sharp7 : [.F, .C, .G, .D, .A, .E, .B]
]

func pitchToMIDINote(key: Key, pitch: Pitch) -> UInt8 {
  var note: Int

  switch pitch.name {
  case .C: note = 0
  case .D: note = 2
  case .E: note = 4
  case .F: note = 5
  case .G: note = 7
  case .A: note = 9
  case .B: note = 11
  }

  var accidental = 0
  if let pitches = keySignatureMapFlat[key.keySignature] {
    if contains(pitches, pitch.name) {
      accidental = -1
    }
  }
  if let pitches = keySignatureMapSharp[key.keySignature] {
    if contains(pitches, pitch.name) {
      accidental = 1
    }
  }

  if let a = pitch.accidental {
    switch a {
    case .DoubleFlat: accidental = -2
    case .DoubleSharp: accidental = 2
    case .Flat: accidental = -1
    case .Sharp: accidental = 1
    case .Natural: accidental = 0
    }
  }

  return UInt8((pitch.offset) * 12 + 60 + note + accidental)
}

func calculateUnitDuration(tempo: Tempo) -> Float32 {
  let bps = Float32(tempo.bpm) / 60

  return Float32(tempo.inLength.denominator) / Float32(tempo.inLength.numerator) / bps
}

func calculateDuration(element: HasLength, unitDuration: Float32) -> Float32 {
  return unitDuration * Float32(element.length.numerator) / Float32(element.length.denominator)
}

func calculateDuration(meter: Meter, rest: MultiMeasureRest, unitDuration: Float32) -> Float32 {
  return unitDuration * Float32(meter.numerator) / Float32(meter.denominator) * Float32(rest.num)
}

func defaultMIDINoteMessage(note: UInt8, duration: Float32) -> MIDINoteMessage {
  return MIDINoteMessage(channel: 0, note: note, velocity: 64, releaseVelocity: 0, duration: duration)
}