//
//  Chapter2_TheStoryOfSound.m
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/29/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#import "Chapter2_TheStoryOfSound.h"
#import "Chapter2_WaveformGenerator.h"

#import <AudioToolbox/AudioToolbox.h>

#ifdef __cplusplus
extern "C" {
#endif
void Chapter2_WriteAudioFile(double fs, double durInSeconds, double freq, KKWaveformType waveType)
{
    assert(freq > 0);
    
    WaveformGenerator *waveGenerator = WaveformGenerator::NewWaveformGenerator(fs, durInSeconds, freq, waveType);
    
    NSString *filename = waveGenerator->GetFilename();
    NSURL *desktopDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *fileURL = [desktopDirectory URLByAppendingPathComponent:filename];
    
    // Prepare the format
    AudioStreamBasicDescription asbd;
    memset(&asbd, 0, sizeof(asbd));
    asbd.mSampleRate = fs;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    asbd.mBitsPerChannel = 16;
    asbd.mChannelsPerFrame = 1;
    asbd.mFramesPerPacket = 1;
    asbd.mBytesPerFrame = 2;
    asbd.mBytesPerPacket = 2;
    
    // Set up the file
    AudioFileID audioFile;
    OSStatus audioErr = noErr;
    CFURLRef cfFileUrl = (CFURLRef)CFBridgingRetain(fileURL);
    
    audioErr = AudioFileCreateWithURL(cfFileUrl, kAudioFileAIFFType, &asbd, kAudioFileFlags_EraseFile, &audioFile);
    assert(audioErr == noErr);
    
    //Start writing samples
    long maxSampleCount = (long)(fs * durInSeconds);
    long sampleCount = 0;
    UInt32 bytesToWrite = 2;
    
    while (sampleCount < maxSampleCount) {
        SInt16 sample = waveGenerator->nextSample();
        audioErr = AudioFileWriteBytes(audioFile, false, sampleCount*2, &bytesToWrite, &sample);
        assert(audioErr == noErr);
        sampleCount++;
    }
    
    audioErr = AudioFileClose(audioFile);
    assert(audioErr == noErr);
    NSLog(@"Wrote %ld samples", sampleCount);
    
    delete waveGenerator;
    
    CFBridgingRelease(cfFileUrl);
}
#ifdef __cplusplus
}
#endif
