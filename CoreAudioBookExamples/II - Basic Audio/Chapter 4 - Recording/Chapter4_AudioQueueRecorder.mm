//
//  Chapter4_AudioQueueRecorder.mm
//  CoreAudioBookExamples
//
//  Created by Kiran Kumar on 4/2/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#import "Chapter4_AudioQueueRecorder.h"

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - User Data Struct
typedef struct MyRecorder {
    AudioFileID     recordFile;
    SInt64          recordPacket;
    Boolean         running;
} MyRecorder;
    
#pragma mark - Utility Functions
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
    
static void MyGetDefaultInputDeviceSampleRate(Float64 *sampleRate);
// Listings 4.20 and 4.21
// Listing 4.22
// Listing 4.23
    
#pragma mark - Record Callback Function
// Replace with Listings 4.24 - 4.26
static void MyAQInputCallback(void *inUserData,
                              AudioQueueRef inQueue,
                              AudioQueueBufferRef inBuffer,
                              const AudioTimeStamp *inStartTime,
                              UInt32 inNumPackets,
                              const AudioStreamPacketDescription *inPacketDesc)
{}

#pragma mark - Entry Point
void Chapter4_RecordWithAudioQueue()
{
    // Set up format
    MyRecorder recorder = {0};
    AudioStreamBasicDescription recordFormat;
    memset(&recordFormat, 0, sizeof(recordFormat));
    
    recordFormat.mFormatID = kAudioFormatMPEG4AAC;
    recordFormat.mChannelsPerFrame = 2;
    MyGetDefaultInputDeviceSampleRate(&recordFormat.mSampleRate);
    
    UInt32 propertySize = sizeof(recordFormat);
    CheckError(AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &propertySize, &recordFormat), "AudioFormatGetProperty failed");
    
    // Set up queue
    // Listings 4.8 - 4.9
    
    // Set up file
    // Listings 4.10 - 4.11
    
    // Other setup as needed
    // Listings 4.12 - 4.13
    
    // Start queue
    // Listings 4.14 - 4.15
    
    // Stop queue
    // Listings 4.16 - 4.18
}
    
#ifdef __cplusplus
}
#endif
