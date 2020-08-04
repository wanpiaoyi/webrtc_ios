//
//  QKOptions.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/7/17.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, QKOptionStreamType) {
    QKOptionStreamTypeMain = 0,      //拉大流
    QKOptionStreamTypeAll,     //拉大小流
};

NS_ASSUME_NONNULL_BEGIN

@interface QKOptions : NSObject
@property(copy,nonatomic) NSString *socketUrl;
@property(strong,nonatomic) NSNumber *socketPort;
@property(nonatomic) QKOptionStreamType streamType;
@end

NS_ASSUME_NONNULL_END
