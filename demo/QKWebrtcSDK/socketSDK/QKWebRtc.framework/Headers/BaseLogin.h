//
//  BaseLogin.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/7/24.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "QKCloudBaseObj.h"


@interface BaseLogin : QKCloudBaseObj
@property(copy,nonatomic) NSString *appKey;//": "xxx",
@property(copy,nonatomic) NSString *session;//":"xxx",

@property(copy,nonatomic) NSString *objId;//":"xxx",
@property(copy,nonatomic) NSString *roomId;//":xxx,
@property(copy,nonatomic) NSString *role;//": "xxx",

@property(copy,nonatomic) NSString *sig;//": "",

@end

