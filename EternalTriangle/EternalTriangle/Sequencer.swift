//
//  Sequencer2.swift
//  EternalTriangle
//
//  Created by hokada on 10/30/15.
//  Copyright © 2015 Haruki Okada. All rights reserved.
//

import Foundation
import AudioToolbox

public class Sequencer {
  var processingGraph: AUGraph = nil
  var mixerUnit: AudioUnit = nil
  var mixerNode: AUNode = 0
  var ioNode: AUNode = 0
  var musicPlayer: MusicPlayer = nil
  var musicSequence: MusicSequence = nil
  var tune: Tune! = nil

  public init() {
    prepareGraph()
    checkError(NewMusicSequence(&musicSequence))
    checkError(MusicSequenceSetAUGraph(musicSequence, processingGraph))
    checkError(NewMusicPlayer(&musicPlayer))
    checkError(MusicPlayerSetSequence(musicPlayer, musicSequence))

    // MusicPlayer seems to play 1 musicstamp in 0.5 sec.
    checkError(MusicPlayerSetPlayRateScalar(musicPlayer, 0.5));
  }

  public func loadTune(tune: Tune) {
    self.tune = tune

    for (i, voice) in tune.tuneBody.voices.enumerate() {
      var samplerNode: AUNode = 0
      var desc = AudioComponentDescription(
        componentType: kAudioUnitType_MusicDevice,
        componentSubType: kAudioUnitSubType_Sampler,
        componentManufacturer: kAudioUnitManufacturer_Apple,
        componentFlags: 0,
        componentFlagsMask: 0)
      checkError(AUGraphAddNode(processingGraph, &desc, &samplerNode))
      checkError(AUGraphConnectNodeInput(processingGraph, samplerNode, 0, mixerNode, UInt32(i)))

      var unit: AudioUnit = nil
      checkError(AUGraphNodeInfo(processingGraph, samplerNode, nil, &unit))
      loadSF2Preset(0, unit: unit)
      loadVoice(voice, node: samplerNode)
    }

    var isInitialized: DarwinBoolean = false
    checkError(AUGraphIsInitialized(processingGraph, &isInitialized))
    if (!isInitialized) {
      checkError(AUGraphInitialize(processingGraph))
    }
    checkError(MusicPlayerPreroll(musicPlayer))
  }

  public func play() {
    var playing: DarwinBoolean = false
    checkError(MusicPlayerIsPlaying(musicPlayer, &playing))
    if (!playing) {
      checkError(MusicPlayerStart(musicPlayer))
    }
  }

  public func stop() {
    var playing: DarwinBoolean = false
    checkError(MusicPlayerIsPlaying(musicPlayer, &playing))
    if (playing) {
      checkError(MusicPlayerStop(musicPlayer))
    }
  }

  private func prepareGraph() {
    checkError(NewAUGraph(&processingGraph))
    checkError(AUGraphOpen(processingGraph))

    var mixerDesc = AudioComponentDescription(
      componentType: kAudioUnitType_Mixer,
      componentSubType: kAudioUnitSubType_MultiChannelMixer,
      componentManufacturer: kAudioUnitManufacturer_Apple,
      componentFlags: 0,
      componentFlagsMask: 0)
    checkError(AUGraphAddNode(processingGraph, &mixerDesc, &mixerNode))
    checkError(AUGraphNodeInfo(processingGraph, mixerNode, nil, &mixerUnit))
    checkError(AUGraphAddRenderNotify(processingGraph, renderCallback, nil))

    var ioDesc = AudioComponentDescription(
      componentType: kAudioUnitType_Output,
      componentSubType: kAudioUnitSubType_RemoteIO,
      componentManufacturer: kAudioUnitManufacturer_Apple,
      componentFlags: 0,
      componentFlagsMask: 0)
    checkError(AUGraphAddNode(processingGraph, &ioDesc, &ioNode))

    checkError(AUGraphConnectNodeInput(processingGraph, mixerNode, 0, ioNode, 0))
  }

  private func loadVoice(voice: Voice, node: AUNode) {
    var track: MusicTrack = nil
    checkError(MusicSequenceNewTrack(musicSequence, &track))
    let unitDuration = calculateUnitDuration(tune.tuneHeader.tempo)

    var timestamp: MusicTimeStamp = 0
    for elem in voice.elements {
      switch elem {
      case let n as Note:
        let note = pitchToMIDINote(tune.tuneHeader.key, pitch: n.pitch)
        let duration = calculateDuration(n, unitDuration: unitDuration)
        var message = defaultMIDINoteMessage(note, duration: duration)

        checkError(MusicTrackNewMIDINoteEvent(track, timestamp, &message))
        timestamp += MusicTimeStamp(duration)
      case let c as Chord:
        let duration = calculateDuration(c, unitDuration: unitDuration)
        for p in c.pitches {
          let note = pitchToMIDINote(tune.tuneHeader.key, pitch: p)
          var message = defaultMIDINoteMessage(note, duration: duration)

          checkError(MusicTrackNewMIDINoteEvent(track, timestamp, &message))
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
            var message = defaultMIDINoteMessage(note, duration: duration)

            checkError(MusicTrackNewMIDINoteEvent(track, timestamp, &message))
          case let c as Chord:
            for p in c.pitches {
              let note = pitchToMIDINote(tune.tuneHeader.key, pitch: p)
              var message = defaultMIDINoteMessage(note, duration: duration)

              checkError(MusicTrackNewMIDINoteEvent(track, timestamp, &message))
            }
          default: ()
          }
          timestamp += MusicTimeStamp(duration)
        }
      default: ()
      }
    }

    checkError(MusicTrackSetDestNode(track, node))
  }
}

let renderCallback: AURenderCallback = { (inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) -> OSStatus in

  print(inTimeStamp.memory.mSampleTime)
  return noErr
}

func loadSF2Preset(preset: UInt8, unit: AudioUnit) {
  if let bankURL = NSBundle(forClass: Sequencer.self).URLForResource("vibraphone", withExtension: "sf2") {
    var instdata = AUSamplerInstrumentData(
      fileURL: Unmanaged.passUnretained(bankURL),
      instrumentType: UInt8(kInstrumentType_DLSPreset),
      bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
      bankLSB: UInt8(kAUSampler_DefaultBankLSB),
      presetID: preset)

    checkError(AudioUnitSetProperty(unit,
      kAUSamplerProperty_LoadInstrument,
      kAudioUnitScope_Global,
      0,
      &instdata,
      UInt32(sizeof(AUSamplerInstrumentData))))
  }
}

func checkError(status: OSStatus) -> Void {
  assert(status == noErr, "error code : \(status)")
}