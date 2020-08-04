//
//  MemberEnter.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberEnter : NSObject
@property (copy,nonatomic) NSString *memberId;//":"xxx",

@property (copy,nonatomic) NSString *name;//:"xxx"
@property (copy,nonatomic) NSString *avatar;//": "xxx",

@property (copy,nonatomic) NSString *battery;//: 50//电量

@property (copy,nonatomic) NSString *role;//: ""//角色
@end

NS_ASSUME_NONNULL_END
