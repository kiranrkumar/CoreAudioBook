//
//  WaveformDefines.h
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/31/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#ifndef Chapter2_WaveformDefines_h
#define Chapter2_WaveformDefines_h

#import <Foundation/Foundation.h>

// For some reason, if I put this enum in WaveformGenerator.h, and then import WaveGenerator.h into Chapter2_TheStoryOfSound.h, I get a bunch
//  of errors in WaveformGenerator.h saying things like "public" and "class" are invalid. To remedy this, I've implemented this workaround of
//  having a separate file just for the enum and having both WaveGenerator.h and Chapter2_TheStoryOfSound.h import that. I don't know why this works,
//  and I really want to figure that out at some point

typedef NS_ENUM(NSInteger, KKWaveformType) {
    KKWaveformType_Square,
    KKWaveformType_Sine,
    KKWaveformType_Sawtooth
};

#endif /* Chapter2_WaveformDefines_h */
