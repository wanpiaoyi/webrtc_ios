//
//  QKGLRenderView.h
//  QKRTCCloud
//
//  Created by 袁儿宝贝 on 2019/10/10.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QKWebRtc/QKRTCRenderView.h>

@class RTCVideoTrack;
@interface QKGLRenderView : QKRTCRenderView

@property(strong,nonatomic) RTCVideoTrack *videoTrack;
@property(copy,nonatomic)  void (^touch)(UIView *touchView);


-(void)bindTrack;

-(void)unBindTrack;

@end

