//
//  Chapter7_FileBasedPlayer.mm
//  CoreAudioBookExamples
//
//  Created by Kiran Kumar on 4/15/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#include "Chapter7_FileBasedPlayer.h"

#include <AudioToolbox/AudioToolbox.h>

#define kInputFileLocation CFSTR("/Users/kirankumar/IThoughtSheKnew_FullDraft1.mp3")

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - User Data Struct
    //Listing 7.2
    typedef struct MYAUGraphPlayer {
        AudioStreamBasicDescription inputFormat;
        AudioFileID                 inputFile;
        
        AUGraph     graph;
        AudioUnit   fileAU;
    } KKAUGraphPlayer;
    
#pragma mark - Utility functions
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
    
    // Listing 7.7 - 7.13
    // Listing 7.14 - 7.17
    
#pragma mark - Entry point
    void Chapter7_PlayFromFile(void)
    {
        KKAUGraphPlayer graphPlayer = {0};
        
        // Open the input audio file
        // Get the audio data format from the file
        // Listing 7.3
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, kInputFileLocation, kCFURLPOSIXPathStyle, false);
        CheckError(AudioFileOpenURL(fileURL, kAudioFileReadPermission, 0, &graphPlayer.inputFile), "Failed to open audio file");
        CFRelease(fileURL);
        
        UInt32 propertySize = sizeof(graphPlayer.inputFormat);
        CheckError(AudioFileGetProperty(graphPlayer.inputFile, kAudioFilePropertyDataFormat, &propertySize, &graphPlayer.inputFormat), "Failed to get ASBD for audio file");
        
        // Build a basic fileplayer -> speakers graph
        // Configure the file player
        // Listing 7.4
        
        // Start playing
        // Sleep until the file is finished
        // Listing 7.5
        
        // Cleanup
        // Listing 7.6
        
        
    }

#ifdef __cplusplus
}
#endif
