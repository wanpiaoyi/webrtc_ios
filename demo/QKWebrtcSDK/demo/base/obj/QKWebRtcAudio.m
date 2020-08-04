//
//  QKWebRtcAudio.m
//  QKWebrtcSDK
//
//  Created by 袁儿宝贝 on 2019/10/15.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import "QKWebRtcAudio.h"
#import <WebRTC/WebRTC.h>
@interface QKWebRtcAudio()<RTCAudioSessionDelegate>

@end

@implementation QKWebRtcAudio

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)useSpeaker{
    NSError* error = nil;

//    AVAudioSession* sysSession = [AVAudioSession sharedInstance];
//    [sysSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
//                                    error:&error];

    RTCAudioSessionConfiguration* configuration =
        [RTCAudioSessionConfiguration webRTCConfiguration];
    configuration.mode = AVAudioSessionModeVideoChat;
    configuration.categoryOptions = AVAudioSessionCategoryOptionMixWithOthers;
    // change config

    RTCAudioSession* session = [RTCAudioSession sharedInstance];
    [session lockForConfiguration];
    BOOL hasSucceeded =
        [session setConfiguration:configuration active:YES error:&error];
    if (!hasSucceeded) {
        // error
    }
    [session unlockForConfiguration];

}


- (void)configureAudioSession {
  RTCAudioSessionConfiguration *configuration =
      [[RTCAudioSessionConfiguration alloc] init];
  configuration.category = AVAudioSessionCategoryPlayback;
  configuration.categoryOptions = AVAudioSessionCategoryOptionAllowBluetooth;
  configuration.mode = AVAudioSessionModeDefault;

  RTCAudioSession *session = [RTCAudioSession sharedInstance];
  [session lockForConfiguration];
  BOOL hasSucceeded = NO;
  NSError *error = nil;
  if (session.isActive) {
    hasSucceeded = [session setConfiguration:configuration error:&error];
  } else {
    hasSucceeded = [session setConfiguration:configuration
                                      active:YES
                                       error:&error];
  }
  if (!hasSucceeded) {
    RTCLogError(@"Error setting configuration: %@", error.localizedDescription);
  }
  [session unlockForConfiguration];
}

#pragma mark - RTCAudioSessionDelegate

- (void)audioSessionDidStartPlayOrRecord:(RTCAudioSession *)session {
  // Stop playback on main queue and then configure WebRTC.
  [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeMain
                               block:^{
    RTCLog(@"Setting isAudioEnabled to YES.");
    session.isAudioEnabled = YES;
  }];
}

- (void)audioSessionDidStopPlayOrRecord:(RTCAudioSession *)session {
  // WebRTC is done with the audio session. Restart playback.
  [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeMain
                               block:^{
    RTCLog(@"audioSessionDidStopPlayOrRecord");
    [self restartAudioPlayerIfNeeded];
  }];
}
- (void)restartAudioPlayerIfNeeded {
  [self configureAudioSession];
}


@end
