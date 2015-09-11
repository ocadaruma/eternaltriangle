//
//  Sequencer.swift
//  EternalTriangle
//
//  Created by hokada on 9/9/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation
import AudioToolbox

//public let tones = [
//  "",
//  "",
//  ""
//]

public class Sequencer {
  private var processingGraph: AUGraph = nil
  private var samplerUnit: AudioUnit = nil
  private var musicPlayer: MusicPlayer = nil
  private var musicSequence: MusicSequence = nil

  public init() {
    prepareAUGraph()
    startAUGraph()
    loadSF2Preset(0)

    musicSequence = createMusicSequence()
    musicPlayer = createPlayer(musicSequence)
  }

//  public func loadTune(tune: Tune) {
//
//  }

  public func play() {
    var playing = Boolean(0)
    checkError(MusicPlayerIsPlaying(musicPlayer, &playing))
    if playing != 0 {
      checkError(MusicPlayerStop(musicPlayer))
    }

    checkError(MusicPlayerSetTime(musicPlayer, 0))
    checkError(MusicPlayerStart(musicPlayer))
  }

  public func pause() {

  }

  public func stop() {
    checkError(MusicPlayerStop(musicPlayer))
  }

  private func prepareAUGraph() {
    // create AUGraph
    processingGraph = AUGraph()
    checkError(NewAUGraph(&processingGraph))

    // create sampler
    var samplerNode = AUNode()
    var desc = AudioComponentDescription(
      componentType: OSType(kAudioUnitType_MusicDevice),
      componentSubType: OSType(kAudioUnitSubType_Sampler),
      componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
      componentFlags: 0,
      componentFlagsMask: 0)
    checkError(AUGraphAddNode(processingGraph, &desc, &samplerNode))

    // create IONode
    var ioNode = AUNode()
    var ioUnitDesc = AudioComponentDescription(
      componentType: OSType(kAudioUnitType_Output),
      componentSubType: OSType(kAudioUnitSubType_RemoteIO),
      componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
      componentFlags: 0,
      componentFlagsMask: 0)
    checkError(AUGraphAddNode(processingGraph, &ioUnitDesc, &ioNode))

    // open AUGraph and connect nodes
    checkError(AUGraphOpen(processingGraph))
    samplerUnit = AudioUnit()
    checkError(AUGraphNodeInfo(processingGraph, samplerNode, nil, &samplerUnit))

    var ioUnitOutputElement = AudioUnitElement(0)
    var samplerOutputElement = AudioUnitElement(0)
    checkError(AUGraphConnectNodeInput(
      processingGraph,
      samplerNode,
      samplerOutputElement,
      ioNode,
      ioUnitOutputElement))
  }

  private func startAUGraph() {
    var isInitialized = Boolean(0)
    checkError(AUGraphIsInitialized(processingGraph, &isInitialized))
    if isInitialized == 0 {
      checkError(AUGraphInitialize(processingGraph))
    }

    var isRunning = Boolean(0)
    checkError(AUGraphIsRunning(processingGraph, &isRunning))
    if isRunning == 0 {
      checkError(AUGraphStart(processingGraph))
    }
  }

  private func loadSF2Preset(preset: UInt8) {
    if let bankURL = NSBundle.mainBundle().URLForResource("vibraphone", withExtension: "sf2") {
      var instData = AUSamplerInstrumentData(
        fileURL: Unmanaged.passUnretained(bankURL),
        instrumentType: UInt8(kInstrumentType_DLSPreset),
        bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
        bankLSB: UInt8(kAUSampler_DefaultBankLSB),
        presetID: preset)

      checkError(AudioUnitSetProperty(
        samplerUnit,
        AudioUnitPropertyID(kAUSamplerProperty_LoadInstrument),
        AudioUnitScope(kAudioUnitScope_Global),
        0,
        &instData,
        UInt32(sizeof(AUSamplerInstrumentData))))
    }
  }

  private func createMusicSequence() -> MusicSequence {
    // create the sequence
    var musicSequence = MusicSequence()
    checkError(NewMusicSequence(&musicSequence))

    // add track
    var track = MusicTrack()
    checkError(MusicSequenceNewTrack(musicSequence, &track))

    // make some notes and put them on the track
    var beat = MusicTimeStamp(1.0)
    for i: UInt8 in 60...72 {
      var message = MIDINoteMessage(
        channel: 0,
        note: i,
        velocity: 64,
        releaseVelocity: 0,
        duration: 1.0)

      checkError(MusicTrackNewMIDINoteEvent(track, beat, &message))
      beat += 0.5
    }

    // associate the AUGraph with the sequence.
    MusicSequenceSetAUGraph(musicSequence, processingGraph)

    return musicSequence
  }

  private func createPlayer(musicSequence: MusicSequence) -> MusicPlayer {
    var player = MusicPlayer()
    checkError(NewMusicPlayer(&player))
    checkError(MusicPlayerSetSequence(player, musicSequence))
    checkError(MusicPlayerPreroll(player))

    return player
  }
}