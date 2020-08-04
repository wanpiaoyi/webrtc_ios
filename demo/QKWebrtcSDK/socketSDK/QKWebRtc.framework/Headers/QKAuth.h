//
//  QKAuth.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/4/27.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QKWebRtc/QKCloudBaseObj.h>
typedef NS_ENUM(NSInteger,QKRTCRoomType) {
    QKRTCRoomTypeLine = 0,//连线房间
    QKRTCRoomTypeAnonymous = 1,//匿名房间
};
NS_ASSUME_NONNULL_BEGIN

@interface QKAuth : QKCloudBaseObj

@property(copy,nonatomic) NSString *appKey;//":"xxx",
@property(copy,nonatomic) NSString *objId;//":"xxx",

@property(copy,nonatomic) NSString *session;//":"xxx",

@property(copy,nonatomic) NSString *roomId;//":xxx,

@property(copy,nonatomic) NSString *sig;//": "",
@property(copy,nonatomic) NSString *role;//": "",
@property(nonatomic) NSInteger roomType;//": "",



@end

NS_ASSUME_NONNULL_END
