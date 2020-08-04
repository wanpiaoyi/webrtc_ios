//
//  AudioSpeedChange.h
//  IPRecordCameraSDK
//
//  Created by yang on 2018/7/2.
//  Copyright © 2018年 ReNew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@interface AudioSpeedChange : NSObject

-(void)changeSpeed:(float)speed;
-(void)clearAll;
-(CMSampleBufferRef)checkAudio:(CMSampleBufferRef)sampleBuffer;
-(CMSampleBufferRef)getAudioBuffer;
-(CMSampleBufferRef)flushVideo;

@end
