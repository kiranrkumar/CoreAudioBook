//
//  WaveformGenerator.h
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/30/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#ifndef Chapter2_WaveformGenerator_h
#define Chapter2_WaveformGenerator_h

#import "Chapter2_WaveformDefines.h"

class WaveformGenerator {
public:
    static WaveformGenerator * NewWaveformGenerator(double fs, double durInSeconds, double freq, KKWaveformType waveType);
    
    WaveformGenerator(double fs, double durInSeconds, double freq);
    virtual ~WaveformGenerator();
    virtual SInt16 nextSample() = 0;
    virtual NSString * GetFilename();
    
protected:
    long mCurrentSample;
    double mFs;
    double mDurInSeconds;
    double mFreq;
    double mWavelength;
    
    NSString *mFilename;
};

class SawtoothWaveform : public WaveformGenerator {
public:
    SawtoothWaveform(double fs, double durInSeconds, double freq);
    SInt16 nextSample();
};

class SineWaveform : public WaveformGenerator {
public:
    SineWaveform(double fs, double durInSeconds, double freq);
    SInt16 nextSample();
};

class SquareWaveform : public WaveformGenerator {
public:
    SquareWaveform(double fs, double durInSeconds, double freq);
    SInt16 nextSample();
};

#endif /* Chapter2_WaveformGenerator_h */
