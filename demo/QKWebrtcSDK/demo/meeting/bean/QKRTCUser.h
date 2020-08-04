//
//  User.h
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/7/23.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QKRTCUser : NSObject
@property(strong,nonatomic) NSString *objId;//:"xxx",

@property(strong,nonatomic) NSString *type;//
@property(strong,nonatomic) NSString *name;//

@property(nonatomic) BOOL video;//是否开摄像头
@property(nonatomic) BOOL audio;//是否开音频

@end

NS_ASSUME_NONNULL_END
