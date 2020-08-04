//
//  QKEnterLogin.h
//  QKRTCCloud
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <QKWebRtc/BaseLogin.h>
NS_ASSUME_NONNULL_BEGIN

/*
 | owner        | 会议发起人 |
 | control      | 助理会控   |
 | participator | 参与人     |
 | watcher      | 围观者     |
 | studio       | 导播       |
 */
@interface QKEnterLogin : BaseLogin
@property(nonatomic) BOOL saveRecord;//": "",

@end

NS_ASSUME_NONNULL_END
