//
//  QKAudioData.h
//  IPRecordCameraSDK
//
//  Created by yang on 2018/7/2.
//  Copyright © 2018年 ReNew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@interface QKAudioData : NSObject
@property (nonatomic) short* buffer;
@property (nonatomic) int size;
-(void)createAudioData:(int)size;
@end
