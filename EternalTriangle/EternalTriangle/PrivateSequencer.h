//
//  Sequencer.h
//  EternalTriangle
//
//  Created by hokada on 9/12/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MIDINote : NSObject

@property (nonatomic) MIDINoteMessage message;
@property (nonatomic) MusicTimeStamp timestamp;

- (instancetype)initWithMessage:(MIDINoteMessage)message timestamp:(MusicTimeStamp)timestamp;

@end

@interface MIDIVoice : NSObject

@property (nonatomic) NSArray* notes;

- (instancetype)initWithNotes:(NSArray *)notes;

@end

@interface PrivateSequencer : NSObject

- (void)play;
- (void)stop;
- (void)loadVoices:(NSArray *)voices;

@end
