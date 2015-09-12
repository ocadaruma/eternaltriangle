//
//  Sequencer.m
//  EternalTriangle
//
//  Created by hokada on 9/12/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

#import "Sequencer.h"
#import <EternalTriangle/EternalTriangle-Swift.h>
#import <AudioToolbox/AudioToolbox.h>

#pragma C function prototype decls
static void checkError(OSStatus);
static OSStatus audioUnitCallback(void *,
                                  AudioUnitRenderActionFlags*,
                                  const AudioTimeStamp *,
                                  UInt32,
                                  UInt32,
                                  AudioBufferList *);

#pragma Class body

@interface Sequencer ()

@property (nonatomic) AUGraph processingGraph;
@property (nonatomic) AudioUnit samplerUnit;
@property (nonatomic) MusicPlayer musicPlayer;
@property (nonatomic) MusicSequence musicSequence;

@end

@implementation Sequencer

- (instancetype)init {
  self = [super init];

  if (self) {
    [self prepareAUGraph];
    [self startAUGraph];
    [self loadSF2Preset:0];

    self.musicSequence = [self createMusicSequence];
    self.musicPlayer = [self createPlayer:_musicSequence];
  }

  return self;
}

- (void)dealloc {

}

- (void)play {
  Boolean playing = 0;
  checkError(MusicPlayerIsPlaying(_musicPlayer, &playing));
  if (playing) {
    checkError(MusicPlayerStop(_musicPlayer));
  }

  checkError(MusicPlayerSetTime(_musicPlayer, 0));
  checkError(MusicPlayerStart(_musicPlayer));
}

- (void)stop {
  checkError(MusicPlayerStop(_musicPlayer));
}

#pragma private functions

- (void)prepareAUGraph {
  // create AUGraph
  checkError(NewAUGraph(&_processingGraph));

  // create sampler
  AUNode samplerNode;
  AudioComponentDescription desc;
  desc.componentType = kAudioUnitType_MusicDevice;
  desc.componentSubType = kAudioUnitSubType_Sampler;
  desc.componentManufacturer = kAudioUnitManufacturer_Apple;
  desc.componentFlags = 0;
  desc.componentFlagsMask = 0;
  checkError(AUGraphAddNode(_processingGraph, &desc, &samplerNode));

  // create IONode
  AUNode ioNode;
  AudioComponentDescription ioUnitDesc;
  ioUnitDesc.componentType = kAudioUnitType_Output;
  ioUnitDesc.componentSubType = kAudioUnitSubType_RemoteIO;
  ioUnitDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
  ioUnitDesc.componentFlags = 0;
  ioUnitDesc.componentFlagsMask = 0;
  checkError(AUGraphAddNode(_processingGraph, &ioUnitDesc, &ioNode));

  // open AUGraph and connect nodes
  checkError(AUGraphOpen(_processingGraph));
  checkError(AUGraphNodeInfo(_processingGraph, samplerNode, nil, &_samplerUnit));

  // set callback
  checkError(AudioUnitAddRenderNotify(_samplerUnit, audioUnitCallback, NULL));

  AudioUnitElement ioUnitOutputElement = 0;
  AudioUnitElement samplerOutputElement = 0;
  checkError(AUGraphConnectNodeInput(_processingGraph, samplerNode, samplerOutputElement, ioNode, ioUnitOutputElement));
}

- (void)startAUGraph {
  Boolean isInitialized = 0;
  checkError(AUGraphIsInitialized(_processingGraph, &isInitialized));
  if (isInitialized) {
    checkError(AUGraphInitialize(_processingGraph));
  }

  Boolean isRunning = 0;
  checkError(AUGraphIsRunning(_processingGraph, &isRunning));
  if (isRunning) {
    checkError(AUGraphStart(_processingGraph));
  }
}

- (void)loadSF2Preset:(UInt8)preset {
  NSURL* bankURL = [[NSBundle bundleForClass:self.class] URLForResource:@"vibraphone" withExtension:@"sf2"];
  AUSamplerInstrumentData instData;
  instData.fileURL = (__bridge CFURLRef)bankURL;
  instData.instrumentType = kInstrumentType_DLSPreset;
  instData.bankMSB = kAUSampler_DefaultMelodicBankMSB;
  instData.bankLSB = kAUSampler_DefaultBankLSB;
  instData.presetID = preset;

  checkError(AudioUnitSetProperty(_samplerUnit,
                                  kAUSamplerProperty_LoadInstrument,
                                  kAudioUnitScope_Global,
                                  0,
                                  &instData,
                                  sizeof(AUSamplerInstrumentData)));
}

- (MusicSequence)createMusicSequence {
  // create the sequence
  MusicSequence musicSequence;
  checkError(NewMusicSequence(&musicSequence));

  // add track
  MusicTrack track;
  checkError(MusicSequenceNewTrack(musicSequence, &track));

  MusicTimeStamp beat = 1.0;
  for (UInt8 i = 60; i <= 72; i++) {
    MIDINoteMessage message;
    message.channel = 0;
    message.note = i;
    message.velocity = 64;
    message.releaseVelocity = 0;
    message.duration = 0.2;

    checkError(MusicTrackNewMIDINoteEvent(track, beat, &message));
    beat += 0.5;
  }

  checkError(MusicSequenceSetAUGraph(musicSequence, _processingGraph));

  return musicSequence;
}

- (MusicPlayer)createPlayer:(MusicSequence)sequence {
  MusicPlayer player;
  checkError(NewMusicPlayer(&player));
  checkError(MusicPlayerSetSequence(player, sequence));
  checkError(MusicPlayerPreroll(player));

  return player;
}

@end

#pragma C function decls
static void checkError(OSStatus err) {
  if (err) {
    NSLog(@"error occurred. code : %@", @(err));
  }
}

static OSStatus audioUnitCallback(void *inRefCon,
                                  AudioUnitRenderActionFlags*	ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData) {
  NSLog(@"called");
  return noErr;
}
