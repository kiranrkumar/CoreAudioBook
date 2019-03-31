//
//  Chapter2_TheStoryOfSound.h
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/29/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#ifndef Chapter2_TheStoryOfSound_h
#define Chapter2_TheStoryOfSound_h

#import "Chapter2_WaveformDefines.h"

#ifdef __cplusplus
extern "C" {
#endif

void Chapter2_WriteAudioFile(double fs, double durInSeconds, double freq, KKWaveformType waveType);

#ifdef __cplusplus
}
#endif

#endif /* Chapter2_TheStoryOfSound_h */
