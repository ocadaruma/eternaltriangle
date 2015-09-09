//
//  ParserTests.swift
//  EternalTriangle
//
//  Created by hokada on 9/1/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation
import XCTest
import EternalTriangle

class ParserTests: XCTestCase {
  func testParseEntireSong() {
    let path = NSBundle(forClass: ParserTests.self).pathForResource("song", ofType: "txt")!
    let string = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
    let parser = ABCParser(string: string)
    let tune = parser.parse()

    //tune header
    let header = tune.tuneHeader
    XCTAssertEqual(header.reference!.number, 1)
    XCTAssertEqual(header.tuneTitle!.title, "Zocharti Loch")
    XCTAssertEqual(header.composer!.name, "Louis Lewandowski (1821-1894)")
    XCTAssertEqual(header.meter.numerator, 4)
    XCTAssertEqual(header.meter.denominator, 4)
    XCTAssertEqual(header.tempo.bpm, 76)
    XCTAssertEqual(header.tempo.inLength.numerator, 1)
    XCTAssertEqual(header.tempo.inLength.denominator, 4)

    let v1 = header.voiceHeaders[0]
    let v2 = header.voiceHeaders[1]

    XCTAssertEqual(v1.id, "T1")
    XCTAssertEqual(v1.clef.clefName, .Treble)

    XCTAssertEqual(v2.id, "B1")
    XCTAssertEqual(v2.clef.clefName, .Bass)

    XCTAssertEqual(header.key.keySignature, .Flat2)
    XCTAssertEqual(header.unitNoteLength.denominator, .Quarter)

    //tune body
    let voice1 = tune.tuneBody.voices[0]
    XCTAssertEqual(voice1.id, "T1")
    XCTAssertEqual(voice1.elements.count, 31)
    XCTAssertEqual(voice1.elements[0] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[1] as! Simple, .SlurStart)
    XCTAssertEqual(voice1.elements[2] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 0)))
    XCTAssertEqual(voice1.elements[3] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .C, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[4] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[5] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[6] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .G, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[7] as! Simple, .SlurEnd)
    XCTAssertEqual(voice1.elements[8] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[9] as! Simple, .BarLine)
    XCTAssertEqual(voice1.elements[10] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[11] as! Note,
      Note(
        length: NoteLength(numerator: 6, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[12] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .E, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[13] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[14] as! Simple, .BarLine)
    XCTAssertEqual(voice1.elements[15] as! Simple, .LineBreak)
    XCTAssertEqual(voice1.elements[16] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[17] as! Simple, .SlurStart)
    XCTAssertEqual(voice1.elements[18] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 0)))
    XCTAssertEqual(voice1.elements[19] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .C, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[20] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[21] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[22] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .G, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[23] as! Simple, .SlurEnd)
    XCTAssertEqual(voice1.elements[24] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[25] as! Simple, .BarLine)
    XCTAssertEqual(voice1.elements[26] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[27] as! Note,
      Note(
        length: NoteLength(numerator: 8, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[28] as! Simple, .Space)
    XCTAssertEqual(voice1.elements[29] as! Simple, .BarLine)
    XCTAssertEqual(voice1.elements[30] as! Simple, .LineBreak)

    //voice 2
    let voice2 = tune.tuneBody.voices[1]
    XCTAssertEqual(voice2.id, "B1")
    XCTAssertEqual(voice2.elements.count, 28)
    XCTAssertEqual(voice2.elements[0] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[1] as! Rest, Rest(length: NoteLength(numerator: 8, denominator: 1)))
    XCTAssertEqual(voice2.elements[2] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[3] as! Simple, .BarLine)
    XCTAssertEqual(voice2.elements[4] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[5] as! Rest, Rest(length: NoteLength(numerator: 2, denominator: 1)))
    XCTAssertEqual(voice2.elements[6] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[7] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[8] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .G, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[9] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .A, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[10] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[11] as! Simple, .BarLine)
    XCTAssertEqual(voice2.elements[12] as! Simple, .LineBreak)
    XCTAssertEqual(voice2.elements[13] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[14] as! Simple, .SlurStart)
    XCTAssertEqual(voice2.elements[15] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[16] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[17] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[18] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[19] as! Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .E, accidental: nil, offset: 2)))
    XCTAssertEqual(voice2.elements[20] as! Simple, .SlurEnd)
    XCTAssertEqual(voice2.elements[21] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[22] as! Simple, .BarLine)
    XCTAssertEqual(voice2.elements[23] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[24] as! Note,
      Note(
        length: NoteLength(numerator: 8, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 2)))
    XCTAssertEqual(voice2.elements[25] as! Simple, .Space)
    XCTAssertEqual(voice2.elements[26] as! Simple, .BarLine)
    XCTAssertEqual(voice2.elements[27] as! Simple, .LineBreak)
  }
}