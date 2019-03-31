//
//  Chapter3_AudioDataFormats.mm
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/31/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#ifdef __cplusplus
extern "C" {
#endif
    
void Chapter3_WriteMultipleASBDs()
{
    AudioFileTypeAndFormatID fileTypeAndFormat;
    fileTypeAndFormat.mFileType = kAudioFileAIFFType;
    fileTypeAndFormat.mFormatID = kAudioFormatLinearPCM;
    
    OSStatus audioErr = noErr;
    UInt32 infoSize = 0;
    
    audioErr = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, sizeof(fileTypeAndFormat), &fileTypeAndFormat, &infoSize);
    assert(audioErr == noErr);
    
    AudioStreamBasicDescription *asbds = (AudioStreamBasicDescription *)malloc(infoSize);
    audioErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, sizeof(fileTypeAndFormat), &fileTypeAndFormat, &infoSize, asbds);
    assert(audioErr == noErr);
    
    int asbdCount = infoSize / sizeof(AudioStreamBasicDescription);
    
    for (int i = 0; i < asbdCount; ++i) {
        UInt32 format4cc = CFSwapInt32HostToBig(asbds[i].mFormatID);
        NSLog(@"%d: mFormatId: %4.4s, mFormatFlags: %d, mBitsPerChannel: %d",
              i, (char *)&format4cc, asbds[i].mFormatFlags, asbds[i].mBitsPerChannel);
    }
    
    free(asbds);
}
    
#ifdef __cplusplus
}
#endif
