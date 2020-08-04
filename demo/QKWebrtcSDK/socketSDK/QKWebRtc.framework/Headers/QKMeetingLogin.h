//
//  QKMeetingLogin.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/7/24.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//
#import <QKWebRtc/BaseLogin.h>



@interface QKMeetingLogin : BaseLogin

@property(copy,nonatomic) NSString *clientType;//": "xxx",
@property(nonatomic) int battery;//": 50,


@property(copy,nonatomic) NSString *name;//": "xxx",


@end

