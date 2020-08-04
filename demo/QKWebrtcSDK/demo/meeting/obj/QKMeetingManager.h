//
//  QKMeetingManager.h
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/7/23.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define meetingManager ((QKMeetingManager*)[QKMeetingManager shareInstance])
#define MeetingNotification @"MeetingNotification"
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,MeetingState){
    MeetingStateMuteOne,  //禁言
    MeetingStateCameraClose,  //关闭摄像头
    MeetingStateCtlKickout,  //被踢出房间
    MeetingStateRoleUpdate,  //用户角色发生改变
    MeetingStateDeviceConflict,  //被其它登录端踢出房间
    MeetingStateToPar,//角色变更成为参会人员，参会人员可以推流
    MeetingStateRoomClose
};


@interface QKMeetingManager : NSObject

@property(strong,nonatomic) NSString *memberId;

@property(strong,nonatomic) NSString *roomId;
@property(strong,nonatomic) NSString *role;
+(instancetype)shareInstance;
-(void)setMainView:(UIView*)view;
-(void)initManager;
/*
设置参会者界面
*/
-(void)setMemberView:(UIView*)view;

//刷新页面
-(void)layoutViews;
-(void)clearAll;
-(void)addMember:(NSString *)memberId type:(NSString*)type audio:(BOOL)audio camera:(BOOL)camera;
@end

NS_ASSUME_NONNULL_END
