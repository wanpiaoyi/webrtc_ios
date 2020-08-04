//
//  BroadcastSetupViewController.m
//  QKRTCShareScreenSetupUI
//
//  Created by yangpeng on 2020/7/27.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "BroadcastSetupViewController.h"

@implementation BroadcastSetupViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    for(UIView *v in self.view.subviews){
        if([v isKindOfClass:[UILabel class]]){
            UILabel *lbl = (UILabel*)v;
            if([lbl.text isEqualToString:@"直播屏幕"]){
                lbl.text = @"屏幕录制";
            }
        }
    }
}

// Call this method when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup {
    
    // URL of the resource where broadcast can be viewed that will be returned to the application
    NSURL *broadcastURL = [NSURL URLWithString:@"http://apple.com/broadcast/streamID"];
    
    // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
    NSDictionary *setupInfo = @{ @"broadcastName" : @"屏幕录制" };
    
    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    [self.extensionContext completeRequestWithBroadcastURL:broadcastURL setupInfo:setupInfo];
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was cancelled by the user
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"屏幕录制" code:-1 userInfo:nil]];
}
@end
