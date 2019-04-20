//
//  Chapter7_SpeechSynthesizer.mm
//  CoreAudioBookExamples
//
//  Created by Kiran Kumar on 4/19/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#include "Chapter7_SpeechSynthesizer.h"

#include <AudioToolbox/AudioToolbox.h>
#include <ApplicationServices/ApplicationServices.h>

// #define PART_II

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark - User Data Struct
    // Listing 7.19
    typedef struct KKAUGraphPlayer {
        AUGraph graph;
        AudioUnit speechAU;
    } KKAUGraphPlayer;
    
#pragma mark - Utility Functions
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
    
    void CreateMyAUGraph(KKAUGraphPlayer *player) {
        // Listing 7.21
        // Create a new AUGraph
        CheckError(NewAUGraph(&player->graph), "NewAUGraph() failed");
        
        // Generate an audio component description that matches our output device (speakers)
        AudioComponentDescription outputDescription = {0};
        outputDescription.componentType = kAudioUnitType_Output;
        outputDescription.componentSubType = kAudioUnitSubType_DefaultOutput;
        outputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        // Add a node with above output description to the graph
        AUNode outputNode;
        CheckError(AUGraphAddNode(player->graph, &outputDescription, &outputNode), "AUGraphAddNode() failed to add output node to graph");
        
        // Generate an audio component description that matches a speech synthesis generator AU
        AudioComponentDescription speechDescription = {0};
        speechDescription.componentType = kAudioUnitType_Generator;
        speechDescription.componentSubType = kAudioUnitSubType_SpeechSynthesis;
        speechDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        // Add a node with the above speech synthesizer description to the graph
        AUNode speechNode;
        CheckError(AUGraphAddNode(player->graph, &speechDescription, &speechNode), "AUGraphAddNode() failed to add speech synthesis node to graph");
        
        // Open the graph to open (but not allocate resources for) all the contained audio units
        CheckError(AUGraphOpen(player->graph), "AUGraphOpen() failed");
        
        // Get the reference to the audio unit for the speech synthesis graph node
        CheckError(AUGraphNodeInfo(player->graph, speechNode, &speechDescription, &player->speechAU), "AUGraphNodeInfo failed to get info for speech synthesis node");
#ifdef PART_II
        // Listings 7.24 - 7.26
#else
        // Listing 7.22
#endif
    }
    
    // Listing 7.23
    void PrepareSpeechAU(MyAUGraphPlayer *player) {
        
    }
    
#pragma mark - Entry Point
    // Listing 7.20
    void Chapter7_SynthesizeSpeech() {
        KKAUGraphPlayer graphPlayer = {0};
        
        // Build a basic speech->speakers graph
        CreateMyAUGraph(&graphPlayer);
        
        // Configure the speech synthesizer
        PrepareSpeechAU(&graphPlayer);
        
        // Start playing
        CheckError(AUGraphStart(graphPlayer.graph), "AUGraphStart failed");
        
        // Sleep a while so the speech can play out
        usleep((int)(10 * 1000. * 1000.));
        
        // Cleanup
        AUGraphStop(graphPlayer.graph);
        AUGraphUninitialize(graphPlayer.graph);
        AUGraphClose(graphPlayer.graph);
        DisposeAUGraph(graphPlayer.graph);
    }
    
#ifdef __cplusplus
}
#endif
