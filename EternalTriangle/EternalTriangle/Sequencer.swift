//
//  Sequencer.swift
//  EternalTriangle
//
//  Created by hokada on 9/13/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public class Sequencer {
  private let sequencer: PrivateSequencer

  public init() {
    sequencer = PrivateSequencer()
  }

  public func play() {
    sequencer.play()
  }

  public func stop() {
    sequencer.stop()
  }

  public func loadTune(tune: Tune) {
    var voices: [MIDIVoice] = []
    let unitDuration = calculateUnitDuration(tune.tuneHeader.tempo)

    for (_, voice) in tune.tuneBody.voices.enumerate() {
//      let header = tune.tuneHeader.voiceHeaders[index]

      var notes: [MIDINote] = []
      var timestamp: MusicTimeStamp = 0
      for elem in voice.elements {
        switch elem {
        case let n as Note:
          let note = pitchToMIDINote(tune.tuneHeader.key, pitch: n.pitch)
          let duration = calculateDuration(n, unitDuration: unitDuration)
          let message = defaultMIDINoteMessage(note, duration: duration)

          notes.append(MIDINote(message: message, timestamp: timestamp))

          timestamp += MusicTimeStamp(duration)
        case let c as Chord:
          let duration = calculateDuration(c, unitDuration: unitDuration)
          for p in c.pitches {
            let note = pitchToMIDINote(tune.tuneHeader.key, pitch: p)
            let message = defaultMIDINoteMessage(note, duration: duration)
            notes.append(MIDINote(message: message, timestamp: timestamp))
          }
          timestamp += MusicTimeStamp(duration)
        case let r as Rest:
          timestamp += MusicTimeStamp(calculateDuration(r, unitDuration: unitDuration))
        case let mr as MultiMeasureRest:
          timestamp += MusicTimeStamp(calculateDuration(tune.tuneHeader.meter, rest: mr, unitDuration: unitDuration))
        case let t as Tuplet:
          let f = Float32(t.notes) / Float32(t.time)
          for e in t.elements {
            let duration = calculateDuration(e, unitDuration: unitDuration) * f
            switch e {
            case let n as Note:
              let note = pitchToMIDINote(tune.tuneHeader.key, pitch: n.pitch)
              let message = defaultMIDINoteMessage(note, duration: duration)
              notes.append(MIDINote(message: message, timestamp: timestamp))
            case let c as Chord:
              for p in c.pitches {
                let note = pitchToMIDINote(tune.tuneHeader.key, pitch: p)
                let message = defaultMIDINoteMessage(note, duration: duration)
                notes.append(MIDINote(message: message, timestamp: timestamp))
              }
            default: ()
            }
            timestamp += MusicTimeStamp(duration)
          }
        default: ()
        }
      }

      voices.append(MIDIVoice(notes: notes as [AnyObject]))
    }

    sequencer.loadVoices(voices as [AnyObject])
  }
}