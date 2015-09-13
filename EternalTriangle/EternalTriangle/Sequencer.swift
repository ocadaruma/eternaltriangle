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

    for (index, voice) in enumerate(tune.tuneBody.voices) {
      let header = tune.tuneHeader.voiceHeaders[index]

      var notes: [MIDINote] = []
      var timestamp: MusicTimeStamp = 0
      for elem in voice.elements {
        switch elem {
        case let n as Note:
          let note = pitchToMIDINote(tune.tuneHeader.key, n.pitch)
          let duration = calculateDuration(n, unitDuration)
          let message = defaultMIDINoteMessage(note, duration)

          notes.append(MIDINote(message: message, timestamp: timestamp))

          timestamp += MusicTimeStamp(duration)
        case let c as Chord:
          let duration = calculateDuration(c, unitDuration)
          for p in c.pitches {
            let note = pitchToMIDINote(tune.tuneHeader.key, p)
            let message = defaultMIDINoteMessage(note, duration)
            notes.append(MIDINote(message: message, timestamp: timestamp))
          }
          timestamp += MusicTimeStamp(duration)
        case let r as Rest:
          timestamp += MusicTimeStamp(calculateDuration(r, unitDuration))
        case let mr as MultiMeasureRest:
          timestamp += MusicTimeStamp(calculateDuration(tune.tuneHeader.meter, mr, unitDuration))
        case let t as Tuplet:
          let f = Float32(t.notes) / Float32(t.time)
          for e in t.elements {
            let duration = calculateDuration(e, unitDuration) * f
            switch e {
            case let n as Note:
              let note = pitchToMIDINote(tune.tuneHeader.key, n.pitch)
              let message = defaultMIDINoteMessage(note, duration)
              notes.append(MIDINote(message: message, timestamp: timestamp))
            case let c as Chord:
              for p in c.pitches {
                let note = pitchToMIDINote(tune.tuneHeader.key, p)
                let message = defaultMIDINoteMessage(note, duration)
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