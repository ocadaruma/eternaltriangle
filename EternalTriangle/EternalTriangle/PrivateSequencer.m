//
//  Sequencer.m
//  EternalTriangle
//
//  Created by hokada on 9/12/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

#import "PrivateSequencer.h"

#pragma C function prototype decls
static void checkError(OSStatus);
static OSStatus audioUnitCallback(void *,
                                  AudioUnitRenderActionFlags*,
                                  const AudioTimeStamp*,
                                  UInt32,
                                  UInt32,
                                  AudioBufferList*);

static void prepareAUGraph(AUGraph*, AUNode*, AudioUnit*);
static void loadSF2Preset(UInt8, AudioUnit);
static MusicSequence createSequence(AUGraph);
static MusicPlayer createPlayer(MusicSequence);
static void loadVoice(MIDIVoice*, MusicSequence, AUNode);

#pragma Class body

@implementation MIDINote

- (instancetype)initWithMessage:(MIDINoteMessage)message timestamp:(MusicTimeStamp)timestamp {
  self = [self init];

  if (self) {
    self.message = message;
    self.timestamp = timestamp;
  }

  return self;
}

@end

@implementation MIDIVoice

- (instancetype)initWithNotes:(NSArray *)notes {
  self = [self init];

  if (self) {
    self.notes = notes;
  }

  return self;
}

@end

@interface PrivateSequencer ()

@property (nonatomic) AUGraph processingGraph;
@property (nonatomic) AudioUnit mixerUnit;
@property (nonatomic) AUNode mixerNode;
@property (nonatomic) MusicPlayer musicPlayer;
@property (nonatomic) MusicSequence musicSequence;

@end

@implementation PrivateSequencer

- (instancetype)init {
  self = [super init];

  if (self) {
    prepareAUGraph(&_processingGraph, &_mixerNode, &_mixerUnit);
    self.musicSequence = createSequence(_processingGraph);
    self.musicPlayer = createPlayer(_musicSequence);
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

- (void)loadVoices:(NSArray *)voices {
  [voices enumerateObjectsUsingBlock:^(MIDIVoice* voice, NSUInteger idx, BOOL *stop) {
    // create sampler
    AUNode samplerNode;
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_MusicDevice;
    desc.componentSubType = kAudioUnitSubType_Sampler;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    checkError(AUGraphAddNode(_processingGraph, &desc, &samplerNode));

    AudioUnit samplerUnit;
    checkError(AUGraphNodeInfo(_processingGraph, samplerNode, NULL, &samplerUnit));
    checkError(AUGraphConnectNodeInput(_processingGraph, samplerNode, 0, _mixerNode, (UInt32)idx));

    loadSF2Preset(0, samplerUnit);
    loadVoice(voice, _musicSequence, samplerNode);
  }];

  [self startAUGraph];
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

@end

#pragma C function decls
static void checkError(OSStatus err) {
  NSCAssert(err == noErr, @"error code : %@", @(err));
}

static OSStatus audioUnitCallback(void *inRefCon,
                                  AudioUnitRenderActionFlags*	ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData) {
  NSLog(@"called. inTimeStamp : %@", @(inTimeStamp->mSampleTime));
  return noErr;
}

static void prepareAUGraph(AUGraph *outGraph, AUNode *mixerNode, AudioUnit *mixerUnit) {
  // create AUGraph
  checkError(NewAUGraph(outGraph));
  checkError(AUGraphOpen(*outGraph));

  // create ioNode
  AUNode ioNode;
  AudioUnit ioUnit;
  AudioComponentDescription ioUnitDesc;
  ioUnitDesc.componentType = kAudioUnitType_Output;
  ioUnitDesc.componentSubType = kAudioUnitSubType_RemoteIO;
  ioUnitDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
  ioUnitDesc.componentFlags = 0;
  ioUnitDesc.componentFlagsMask = 0;
  checkError(AUGraphAddNode(*outGraph, &ioUnitDesc, &ioNode));
  checkError(AUGraphNodeInfo(*outGraph, ioNode, NULL, &ioUnit));

  // create mixerNode
  AudioComponentDescription mixerDesc;
  mixerDesc.componentType = kAudioUnitType_Mixer;
  mixerDesc.componentSubType = kAudioUnitSubType_MultiChannelMixer;
  mixerDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
  mixerDesc.componentFlags = 0;
  mixerDesc.componentFlagsMask = 0;
  checkError(AUGraphAddNode(*outGraph, &mixerDesc, mixerNode));
  checkError(AUGraphNodeInfo(*outGraph, *mixerNode, NULL, mixerUnit));

  // set callback
  checkError(AudioUnitAddRenderNotify(*mixerUnit, audioUnitCallback, NULL));

  AudioUnitElement ioUnitOutputElement = 0;
  AudioUnitElement mixerOutputElement = 0;
  checkError(AUGraphConnectNodeInput(*outGraph, *mixerNode, mixerOutputElement, ioNode, ioUnitOutputElement));
}

static void loadSF2Preset(UInt8 preset, AudioUnit unit) {
  NSURL* bankURL = [[NSBundle bundleForClass:[PrivateSequencer class]] URLForResource:@"vibraphone" withExtension:@"sf2"];
  AUSamplerInstrumentData instData;
  instData.fileURL = (__bridge CFURLRef)bankURL;
  instData.instrumentType = kInstrumentType_DLSPreset;
  instData.bankMSB = kAUSampler_DefaultMelodicBankMSB;
  instData.bankLSB = kAUSampler_DefaultBankLSB;
  instData.presetID = preset;

  checkError(AudioUnitSetProperty(unit,
                                  kAUSamplerProperty_LoadInstrument,
                                  kAudioUnitScope_Global,
                                  0,
                                  &instData,
                                  sizeof(AUSamplerInstrumentData)));
}

static void loadVoice(MIDIVoice* voice, MusicSequence sequence, AUNode inNode) {
  MusicTrack track;
  checkError(MusicSequenceNewTrack(sequence, &track));

  [voice.notes enumerateObjectsUsingBlock:^(MIDINote* note, NSUInteger idx, BOOL *stop) {
    MIDINoteMessage message = note.message;
    checkError(MusicTrackNewMIDINoteEvent(track, note.timestamp, &message));
  }];

  checkError(MusicTrackSetDestNode(track, inNode));
}

static MusicSequence createSequence(AUGraph inGraph) {
  MusicSequence musicSequence;
  checkError(NewMusicSequence(&musicSequence));
  checkError(MusicSequenceSetAUGraph(musicSequence, inGraph));

  return musicSequence;
}

static MusicPlayer createPlayer(MusicSequence inSequence) {
  MusicPlayer player;
  checkError(NewMusicPlayer(&player));
  checkError(MusicPlayerSetSequence(player, inSequence));
  checkError(MusicPlayerPreroll(player));

  return player;
}
