//
//  QKResolution.h
//  QKRTCCloud
//
//  Created by 袁儿宝贝 on 2019/10/11.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, QKVideoSizeFrame) {
    QKVideoSize960x540,     //表清
    QKVideoSize1280x720,     //高清
    QKVideoSize1920x1080,      //超清
};


@interface QKResolution : NSObject
/*
 //默认 1280x720
 */
@property (nonatomic) QKVideoSizeFrame videoSize;
/*
 //默认 1000kbps ,最大8000kbps，最小300kbps
 */
@property (nonatomic) int bitrate;
/*
 //默认20fps 10～25
 */
@property (nonatomic) int fps;

/*
 获取默认配置参数
 */
+(QKResolution*)defaultVideoSettings;
+(QKResolution*)defaultPreviewSettings;
-(void)setWidth:(NSInteger)width;
-(void)setHeight:(NSInteger)Height;


-(int)width;
-(int)height;
-(NSString*)type;
@end

