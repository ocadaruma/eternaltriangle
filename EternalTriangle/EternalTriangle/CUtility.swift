//
//  CUtility.swift
//  EternalTriangle
//
//  Created by hokada on 9/10/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation
import AudioToolbox

let errorMessageMap = [
  kAUGraphErr_NodeNotFound : "kAUGraphErr_NodeNotFound",
  kAUGraphErr_OutputNodeErr : "kAUGraphErr_OutputNodeErr",
  kAUGraphErr_InvalidConnection : "kAUGraphErr_InvalidConnection",
  kAUGraphErr_CannotDoInCurrentContext : "kAUGraphErr_CannotDoInCurrentContext",
  kAUGraphErr_InvalidAudioUnit : "kAUGraphErr_InvalidAudioUnit",
  kAudioToolboxErr_InvalidSequenceType : "kAudioToolboxErr_InvalidSequenceType",
  kAudioToolboxErr_TrackIndexError : "kAudioToolboxErr_TrackIndexError",
  kAudioToolboxErr_TrackNotFound : "kAudioToolboxErr_TrackNotFound",
  kAudioToolboxErr_EndOfTrack : "kAudioToolboxErr_EndOfTrack",
  kAudioToolboxErr_StartOfTrack : "kAudioToolboxErr_StartOfTrack",
  kAudioToolboxErr_IllegalTrackDestination : "kAudioToolboxErr_IllegalTrackDestination",
  kAudioToolboxErr_NoSequence : "kAudioToolboxErr_NoSequence",
  kAudioToolboxErr_InvalidEventType : "kAudioToolboxErr_InvalidEventType",
  kAudioToolboxErr_InvalidPlayerState : "kAudioToolboxErr_InvalidPlayerState",
  kAudioUnitErr_InvalidProperty : "kAudioUnitErr_InvalidProperty",
  kAudioUnitErr_InvalidParameter : "kAudioUnitErr_InvalidParameter",
  kAudioUnitErr_InvalidElement : "kAudioUnitErr_InvalidElement ",
  kAudioUnitErr_NoConnection : "kAudioUnitErr_NoConnection ",
  kAudioUnitErr_FailedInitialization : "kAudioUnitErr_FailedInitialization",
  kAudioUnitErr_TooManyFramesToProcess : "kAudioUnitErr_TooManyFramesToProcess",
  kAudioUnitErr_InvalidFile : "kAudioUnitErr_InvalidFile",
  kAudioUnitErr_FormatNotSupported : "kAudioUnitErr_FormatNotSupported",
  kAudioUnitErr_Uninitialized : "kAudioUnitErr_Uninitialized",
  kAudioUnitErr_InvalidScope : "kAudioUnitErr_InvalidScope",
  kAudioUnitErr_PropertyNotWritable : "kAudioUnitErr_PropertyNotWritable",
  kAudioUnitErr_InvalidPropertyValue : "kAudioUnitErr_InvalidPropertyValue",
  kAudioUnitErr_PropertyNotInUse : "kAudioUnitErr_PropertyNotInUse",
  kAudioUnitErr_Initialized : "kAudioUnitErr_Initialized",
  kAudioUnitErr_InvalidOfflineRender : "kAudioUnitErr_InvalidOfflineRender",
  kAudioUnitErr_Unauthorized : "kAudioUnitErr_Unauthorized"
]

public func checkError(err: OSStatus) {
  if err == noErr {
    return
  }

  let message = errorMessageMap[Int(err)] ?? "UnknownError"
  println("error occurred. code: \(message)")
}
