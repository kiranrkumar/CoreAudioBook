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

/*
 p. 133:
 
 The proper order [of steps to create an audio graph] follows:
 1. Create the AUGraph
 2. Create nodes
 3. Open the graph
 4. (Optional) Get audio units from nodes if you need to access any of the units directly
 5. Connect nodes
 6. Initialize the AUGraph
 7. Star the AUGraph
 */

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
    void CreateMyAUGraph(KKAUGraphPlayer *player) {
        /*/
            Steps to create an AU graph as listed above
         */
        
        // 1. Create a new AUGraph
        CheckError(NewAUGraph(&player->graph), "NewAUGraph failed");
        
        // 2. Create and add the nodes.
        // The nodes essentially act as wrappers around the around units, maintaining the relationships with other nodes (and subsequently, with other audio units) within the graph
        
        // Generate description that matches output device (speakers)
        AudioComponentDescription outputcd = {0};
        outputcd.componentType = kAudioUnitType_Output;
        outputcd.componentSubType = kAudioUnitSubType_DefaultOutput;
        outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        // Add node with the above description to the output graph
        AUNode outputNode;
        CheckError(AUGraphAddNode(player->graph, &outputcd, &outputNode), "AUGraphAddNode failed to add output node");
        
        // Now, generate description that matches a generator AU of type: audio file player
        AudioComponentDescription filePlayerCd = {0};
        filePlayerCd.componentType = kAudioUnitType_Generator;
        filePlayerCd.componentSubType = kAudioUnitSubType_AudioFilePlayer;
        filePlayerCd.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        // Add node with the above description to the output graph.
        AUNode filePlayerNode;
        CheckError(AUGraphAddNode(player->graph, &filePlayerCd, &filePlayerNode), "AUGraphAddNode failed to add file player node");
        
        // 3. Open the graph
        
        // Opening the graph opens all contained audio units but does not allocate any resources yet
        CheckError(AUGraphOpen(player->graph), "AUGraphOpen failed");
        
        // Get the reference to the AudioUnit object for the file player graph node
        CheckError(AUGraphNodeInfo(player->graph, filePlayerNode, NULL, &player->fileAU), "AUGraphNodeInfo failed to retrieve file player AU");
    }
    
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
        CreateMyAUGraph(&graphPlayer);
        
        // Configure the file player
        Float64 fileDuration = PrepareFileAU(&graphPlayer);
        // Listing 7.4
        
        
        // Start playing
        CheckError(AUGraphStart(graphPlayer.graph), "AUGraphStart failed");
        
        // Sleep until the file is finished
        usleep((int)(fileDuration * 1000.0 * 1000.0));
        // Listing 7.5
        
        // Cleanup
        AUGraphStop(graphPlayer.graph);
        AUGraphUninitialize(graphPlayer.graph);
        AUGraphClose(graphPlayer.graph);
        AudioFileClose(graphPlayer.inputFile);
        
        // Listing 7.6
        
        
    }

#ifdef __cplusplus
}
#endif
