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
    
#pragma mark - Utility Functions
    // Listing 4.2

    void CreateMyAUGraph(MYAUGraphPlayer *player) {
        // Listing 7.21
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
        // Build a basic speech->speakers graph
        // Configure the speech synthesizer
        // Start playing
        // Sleep a while so the speech can play out
        // Cleanup
        
    }
    
#ifdef __cplusplus
}
#endif
