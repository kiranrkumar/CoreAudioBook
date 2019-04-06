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

const int kNumRecordBuffers = 3;
    
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
    
static int MyComputeRecordBufferSize(const AudioStreamBasicDescription *format, AudioQueueRef queue, float seconds) { return 0; }
static void MyCopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID audioFile) {
    OSStatus error;
    UInt32 propertySize;
    
    error = AudioQueueGetPropertySize(queue, kAudioConverterCompressionMagicCookie, &propertySize);
    
    if (error == noErr && propertySize > 0) {
        // Create buffer of bytes in which to hold the magic cookie
        Byte *magicCookie = (Byte *)malloc(propertySize);
        CheckError(AudioQueueGetProperty(queue, kAudioConverterCompressionMagicCookie, magicCookie, &propertySize), "Error getting the audio queue's magic cookie");
        CheckError(AudioFileSetProperty(audioFile, kAudioFilePropertyMagicCookieData, propertySize, magicCookie), "Error setting the magic cookie data to the audio file");
        free(magicCookie);
    }
}

OSStatus MyGetDefaultInputDeviceSampleRate(Float64 *outSampleRate) {
    OSStatus error;
    AudioDeviceID deviceID = 0;
    
    AudioObjectPropertyAddress propertyAddress;
    UInt32 propertySize;
    propertyAddress.mSelector = kAudioHardwarePropertyDefaultInputDevice;
    propertyAddress.mScope = kAudioObjectPropertyScopeGlobal;
    propertyAddress.mElement = 0;
    propertySize = sizeof(AudioDeviceID);
    error = AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize, &deviceID);
    return error;
}
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
    CheckError(MyGetDefaultInputDeviceSampleRate(&recordFormat.mSampleRate), "Error getting device sample rate");
    
    UInt32 propertySize = sizeof(recordFormat);
    CheckError(AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &propertySize, &recordFormat), "AudioFormatGetProperty failed");
    
    // Set up queue
    // Create the audio queue
    AudioQueueRef queue = {0};
    CheckError(AudioQueueNewInput(&recordFormat, MyAQInputCallback, &recorder, NULL, NULL, 0, &queue), "AudioQueueNewInput failed");
    // Retrieve the filled-out ASBD from audio queue
    UInt32 size = sizeof(recordFormat);
    CheckError(AudioQueueGetProperty(queue, kAudioConverterCurrentOutputStreamDescription, &recordFormat, &size), "AudioQueueGetProperty failed to retrieve information for kAudioConverterCurrentOutputStreamDescription");
    
    // Set up file
    // Create audio file for output
    CFURLRef myFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR("chapter4Output.caf"), kCFURLPOSIXPathStyle, false);
    CheckError(AudioFileCreateWithURL(myFileURL, kAudioFileCAFType, &recordFormat, kAudioFileFlags_EraseFile, &recorder.recordFile), "AudioFileCreateWithURL failed");
    CFRelease(myFileURL);
    
    // Handle cookie (if it exists)
    MyCopyEncoderCookieToFile(queue, recorder.recordFile);
    
    // Other setup as needed
    // Determine size of each buffer, and use that information to allocate and enqueue the buffers
    int bufferByteSize = MyComputeRecordBufferSize(&recordFormat, queue, 0.5);
    for (int bufferIx = 0; bufferIx < kNumRecordBuffers; ++bufferIx) {
        AudioQueueBufferRef buffer;
        CheckError(AudioQueueAllocateBuffer(queue, bufferByteSize, &buffer), "AudioQueueAllocateBuffer failed");
        CheckError(AudioQueueEnqueueBuffer(queue, buffer, 0, NULL), "AudioQueueEnqueueBuffer failed");
    }
    
    // Start recording, and stop when the user presses <return>
    recorder.running = TRUE;
    CheckError(AudioQueueStart(queue, NULL), "AudioQueueStart failed");
    printf("Recording started...press <return> to stop:\n");
    getchar();
    
    // Stop queue
    printf("Recording finished.\n");
    recorder.running = FALSE;
    CheckError(AudioQueueStop(queue, TRUE), "AudioQueueStop failed");
    // Grab the updated magic cookie from the queue
    MyCopyEncoderCookieToFile(queue, recorder.recordFile);
    // Clean up audio queue and file
    AudioQueueDispose(queue, TRUE);
    AudioFileClose(recorder.recordFile);
}
    
#ifdef __cplusplus
}
#endif
