//
//  Chapter1_OverviewOfCoreAudio.m
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/29/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#import "Chapter1_OverviewOfCoreAudio.h"
#import <AudioToolbox/AudioToolbox.h>



void assertOkay(OSStatus status) {
    assert(status == noErr);
}


/**
 Chapter 1, Page 17
 Read from and print the property dictionary for a single audio file

 @param filename Full string file path including extension
 */
void Chapter1_PrintPropertiesForAudioFilename(NSString *filename)
{
    NSString *audioFilePath = [filename stringByExpandingTildeInPath];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
    AudioFileID audioFile;
    OSStatus error = noErr;
    
    // Open file
    CFURLRef audioURLRef = CFBridgingRetain(audioURL);
    error = AudioFileOpenURL(audioURLRef, kAudioFileReadPermission, 0, &audioFile);
    assertOkay(error);
    
    // Get size of the property info dictionary
    UInt32 dictionarySize = 0;
    error = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0);
    assertOkay(error);
    
    // Get actual property info dictionary
    CFDictionaryRef dictionary;
    error = AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary);
    assertOkay(error);
    
    // Print out the dictionary
    NSLog(@"Dictionary: %@", dictionary);
    CFRelease(dictionary);
    CFRelease(audioURLRef);
    
    AudioFileClose(audioFile);
    assertOkay(error);
}
