//
//  SampleHandler.m
//  QKRecordScreen
//
//  Created by yangpeng on 2020/4/27.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//


#import "SampleHandler.h"
#import <QKWebRtc/QKWebRtc.h>
#import "HeaderInfo.h"
#import "QKWebRtcAudio.h"


@interface SampleHandler()

@property(nonatomic) UIInterfaceOrientation frameRotation;
@property BOOL pushStarted;
@property BOOL cameraClosed;
@property(strong,nonatomic) QKWebRtcAudio *qkRtcAudio;

@end

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.


    WS(weakSelf);
    self.qkRtcAudio = [[QKWebRtcAudio alloc] init];
    [self.qkRtcAudio useSpeaker];
    self.frameRotation = UIInterfaceOrientationPortrait;
    
 

    [QKRTCCloud initReplykit:qkGroupName finishShare:^(NSString *msg) {
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        [userInfo setObject:msg forKey:NSUnderlyingErrorKey];
        [userInfo setObject:msg forKey:NSLocalizedDescriptionKey];
        [userInfo setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:msg  code:-1 userInfo:userInfo];
        [self finishBroadcastWithError:error];

    }];

    [QKRTCCloud openReplykitShareScreen];
   

}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.

}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.

}

- (void)broadcastFinished {
    NSLog(@"broadcastFinished");
    // User has requested to finish the broadcast.
    [QKRTCCloud replykitCloseShareScreen];

}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
        {
            [QKRTCCloud setReplykitVideo:sampleBuffer];
        }

            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;
            
        default:
            break;
    }
}

@end
