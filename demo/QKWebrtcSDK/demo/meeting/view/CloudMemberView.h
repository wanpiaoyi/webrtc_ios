//
//  CloudMemberView.h
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QKWebRtc/QKWebRtc.h>
#import "QKRTCUser.h"
@interface CloudMemberView : UIView

@property(strong,nonatomic) NSMutableArray<QKRTCUser*> *array_members;

@property(copy,nonatomic) void (^clickItem)(QKRTCUser *part,NSInteger path);
@property(copy,nonatomic) void (^touchEnd)();

@property(nonatomic) BOOL titleHidden;
-(void)changeFrame;
-(void)reloadData;

-(void)titleChanged:(BOOL)hidden;

@end

