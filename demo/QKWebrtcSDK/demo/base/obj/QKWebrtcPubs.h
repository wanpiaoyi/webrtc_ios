//
//  QKWebrtcPubs.h
//  QKRTCCloud
//
//  Created by 袁儿宝贝 on 2019/9/29.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define userDefaultHeader @"qkrtc_defaule_logo"

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

#define webpubs ((QKWebrtcPubs*)[QKWebrtcPubs sharePubThings])

@interface QKWebrtcPubs : NSObject
@property (nonatomic) float safeTop; //iphonex 情况下  44
@property (nonatomic) float safeBottom; //iphonex 情况下  34
@property float allHeight;//真实屏幕高度
@property float allWidth; //真实屏幕宽度
@property BOOL beauty; //是否开启美颜

@property(strong,nonatomic) NSString *memberId;

-(UIWindow*)window;
+(QKWebrtcPubs *)sharePubThings;
-(float)deleteTop;
-(float)deleteBottom;
-(float)screen_height;
-(float)screen_width;
@end

