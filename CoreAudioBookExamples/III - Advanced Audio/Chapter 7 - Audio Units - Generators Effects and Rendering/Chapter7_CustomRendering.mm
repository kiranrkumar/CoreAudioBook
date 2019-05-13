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
    AudioOutputUnitStop(player.outputUnit);
    AudioUnitUninitialize(player.outputUnit);
    AudioComponentInstanceDispose(player.outputUnit);
}
