//
//  QKRTCCameraPreviewView.h
//  QKRTCCloud
//
//  Created by 袁儿宝贝 on 2019/10/10.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import <WebRTC/WebRTC.h>
#import <QKWebRtc/QKRTCRenderView.h>

@class GPUImageView;
@interface QKRTCCameraPreviewView : QKRTCRenderView
@property(copy,nonatomic)  void (^touch)(UIView *touchView);
@property(nonatomic, strong) GPUImageView *gpuView;

//-(void)setCaptureSession:(AVCaptureSession *)captureSession;
-(void)setVideoSize:(CGSize)videoSize;
@end

