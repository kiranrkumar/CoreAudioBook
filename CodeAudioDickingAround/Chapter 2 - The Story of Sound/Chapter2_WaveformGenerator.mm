//
//  WaveformGenerator.mm
//  CodeAudioDickingAround
//
//  Created by Kiran Kumar on 3/30/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

#import "Chapter2_WaveformGenerator.h"

#pragma mark - Base Class
#pragma mark Factory Method
WaveformGenerator * WaveformGenerator::NewWaveformGenerator(double fs, double durInSeconds, double freq, KKWaveformType waveType)
{
    WaveformGenerator *waveform = NULL;
    switch (waveType) {
        case KKWaveformType_Sine:
            waveform = new SineWaveform(fs, durInSeconds, freq);
            break;
        case KKWaveformType_Sawtooth:
            waveform = new SawtoothWaveform(fs, durInSeconds, freq);
            break;
        case KKWaveformType_Square:
            waveform = new SquareWaveform(fs, durInSeconds, freq);
            break;
        default:
            break;
    }
    
    return waveform;
}

#pragma mark Instance Methods
WaveformGenerator::WaveformGenerator(double fs, double durInSeconds, double freq) : mFs(fs), mDurInSeconds(durInSeconds), mFreq(freq), mWavelength(mFs/mFreq), mCurrentSample(0) {}
WaveformGenerator::~WaveformGenerator() {}

NSString * WaveformGenerator::GetFilename()
{
    return mFilename;
}

#pragma mark - Sine
SineWaveform::SineWaveform(double fs, double durInSeconds, double freq) : WaveformGenerator(fs, durInSeconds, freq)
{
    mFilename = [NSString stringWithFormat:@"%.2f-sine.aif", freq];
}

SInt16 SineWaveform::nextSample()
{
    return CFSwapInt16HostToBig(SHRT_MAX * sin(2 * M_PI * (mCurrentSample++ / mWavelength)));
}

#pragma mark - Square
SquareWaveform::SquareWaveform(double fs, double durInSeconds, double freq) : WaveformGenerator(fs, durInSeconds, freq)
{
    mFilename = [NSString stringWithFormat:@"%.2f-square.aif", freq];
}

SInt16 SquareWaveform::nextSample()
{
    return (mCurrentSample++ % (long)mWavelength) < (mWavelength / 2) ? CFSwapInt16HostToBig(SHRT_MAX) : CFSwapInt16HostToBig(SHRT_MIN);
}

#pragma mark - Sawtooth
SawtoothWaveform::SawtoothWaveform(double fs, double durInSeconds, double freq) : WaveformGenerator(fs, durInSeconds, freq)
{
    mFilename = [NSString stringWithFormat:@"%.2f-saw.aif", freq];
}

SInt16 SawtoothWaveform::nextSample()
{
    return CFSwapInt16HostToBig(mCurrentSample++ / mWavelength * 2 * SHRT_MAX - SHRT_MIN);
}
