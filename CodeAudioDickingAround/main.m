//
//  main.m
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/29/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Chapter2_TheStoryOfSound.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Chapter2_WriteAudioFile(44100, 3, 440.0, KKWaveformType_Sine);
    }
    return 0;
}
