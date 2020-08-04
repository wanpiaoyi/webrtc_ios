//
//  QKRTCManager.h
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/7/23.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define rtcManager ((QKRTCManager*)[QKRTCManager shareInstance])
#define RTCNotification @"RTCNotification"
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,RTCState){
    RTCStateRoleUpdate,  //用户角色发生改变
    RTCStateDeviceConflict,  //被其它登录端踢出房间
};


@interface QKRTCManager : NSObject

@property(strong,nonatomic) NSString *memberId;

@property(strong,nonatomic) NSString *roomId;
@property(strong,nonatomic) NSString *role;

+(instancetype)shareInstance;

-(void)setMainView:(UIView*)view;
/*
设置参会者界面
*/
-(void)setMemberView:(UIView*)view;
-(void)initManager;
//刷新页面
-(void)layoutViews;
-(void)clearAll;
-(void)addMember:(NSString *)memberId type:(NSString*)type audio:(BOOL)audio camera:(BOOL)camera;
@end

NS_ASSUME_NONNULL_END
