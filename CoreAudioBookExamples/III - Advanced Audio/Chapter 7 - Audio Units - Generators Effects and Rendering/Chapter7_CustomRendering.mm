//
//  Chapter7_CustomRendering.mm
//  CoreAudioBookExamples
//
//  Created by Kiran Kumar on 5/12/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#include "Chapter7_CustomRendering.h"

#include <AudioToolbox/AudioToolbox.h>

#define sineFrequency 880.0

#pragma mark user-data struct
// Listing 7.28
typedef struct MySineWavePlayer {
    AudioUnit outputUnit;
    double startingFrameCount;
} MySineWavePlayer;

#pragma mark callback function
// Listing 7.34
// follows the signature of AURenderCallback
OSStatus SineWaveRenderProc(   void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList * __nullable ioData) {
    MySineWavePlayer *player = (MySineWavePlayer *)inRefCon;
    
    double j = player->startingFrameCount;
    double cycleLength = 44100. / sineFrequency;
    for (int frame = 0; frame < inNumberFrames; ++frame) {
        Float32 *data = (Float32 *)ioData->mBuffers[0].mData;
        (data)[frame] = (Float32)sin(2 * M_PI * (j / cycleLength));
        // copy to right channel, too
        data = (Float32 *)ioData->mBuffers[1].mData;
        (data)[frame] = (Float32)sin(2 * M_PI * (j / cycleLength));
        
        j += 1.0;
        if (j > cycleLength) {
            j -= cycleLength;
        }
    }
    
    player->startingFrameCount = j;
    return noErr;
}

#pragma mark Utility function
// Listing 4.2
static void CheckError(OSStatus error, const char *operation) {
    if (error == noErr)
        return;
    
    char errorString[20];
    
    // Check for 4-character code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if ( isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4]) ) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else {
        sprintf(errorString, "%d", (int)error);
    }
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    
    exit(1);
}

// Listings 7.30 - 7.32
void CreateAndConnectOutputUnit (MySineWavePlayer *player) {
    // Generate a description that matches the output device (speakers)
    AudioComponentDescription outputcd = {0};
    outputcd.componentType = kAudioUnitType_Output;
    outputcd.componentSubType = kAudioUnitSubType_DefaultOutput;
    outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // Get the audio unit
    AudioComponent comp = AudioComponentFindNext(NULL, &outputcd);
    if (comp == NULL) {
        printf("Can't find matching audio unit\n");
        exit(-1);
    }
    CheckError(AudioComponentInstanceNew(comp, &player->outputUnit), "Can't open component for outputUnit");
    
    // Now that we have the default output unit, we need to register a custom render callback to the AU
    AURenderCallbackStruct input;
    input.inputProc = SineWaveRenderProc; // actual callback function (process)
    input.inputProcRefCon = player; // context object
    CheckError(AudioUnitSetProperty(player->outputUnit,
                                    kAudioUnitProperty_SetRenderCallback,
                                    kAudioUnitScope_Input,
                                    0,
                                    &input,
                                    sizeof(input)), "Error setting render callback to output AU");
    
    // Initialize the unit
    CheckError(AudioUnitInitialize(player->outputUnit), "Error initialization player's outputUnit");
}

// Listing 7.29
void Chapter7_CustomSineRendering(void) {
    MySineWavePlayer player = {0};
    
    // Set up output unit and callback
    CreateAndConnectOutputUnit(&player);
    
    // Start playing
    CheckError(AudioOutputUnitStart(player.outputUnit), "Couldn't start output unit");
    
    // Play for 5 seconds
    sleep(5);
    
    // Clean up
    AudioOutputUnitStop(player.outputUnit); // Instead of AUGraphStop
    AudioUnitUninitialize(player.outputUnit); // Instead of AUGraphUninitialize
    AudioComponentInstanceDispose(player.outputUnit); // Instead of AUGraphClose
}
