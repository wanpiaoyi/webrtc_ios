//
//  QKMeetingSDK.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/7/21.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QKWebRtc/QKCloudBaseObj.h>
#import <QKWebRtc/QKGLRenderView.h>
#import <QKWebRtc/QKResolution.h>
#import <QKWebRtc/QKOptions.h>
#import <QKWebRtc/QKRTCRenderView.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^RctCallback)(NSInteger code,id value);
@class QKRTCMemberInfo,QKMeetingLogin,QKAuth;

@protocol QKMeetingCloudDelegate <NSObject>
@optional
/**
 * 获取到新的音视频流
 */
-(void)onMemberStartPush:(QKRTCMemberInfo *)info type:(NSString*)type;
/**
* 移出音视频流,有用户离开房间
*/
-(void)onMemberStopPush:(NSString *)memberId type:(NSString*)type;

/**
* 连接数量达到上限，最多支持30人同时推流
*/
-(void)webRTCErrorConnect;


/**
* 用户信息更新
*/
-(void)onMemberInfoUpdate:(QKRTCMemberInfo*)info;

/**
* 被禁言
*/
-(void)onMute;

/**
* 被关闭摄像头
*/
-(void)onCameraClose;

/**
* 账号被踢下线
*/
-(void)onKickOut;

/**
* 账号被挤下线
*/
-(void)onOffLine;

/**
* 用户角色信息变更。
*/
-(void)onRoleUpdate:(NSString*)role oldRole:(NSString*)role memberId:(NSString*)memberId;

/**
* 会议房间被关闭
*/
-(void)onRoomClose;


@end



@interface QKMeetingCloud : NSObject


+(void)lineRtc:(QKOptions*)option;
/*
 初始化SDK
 */
+(void)initSdk;

/*
 设置回调的监听
 */
+(void)setRtcDelegate:(id<QKMeetingCloudDelegate>)delegate;

/*
 查看版本号
 */
+(NSString*)version;


/*
 加入房间
*/
+(void)enterRoom:(QKMeetingLogin*)loginBean  callback:(void (^)(int code,NSArray *res,NSString *msg))callback;
/*
 离开房间并断开所有会议
*/
+(void)quitRoom:(RctCallback)callback;

/*
 初始化推流通道,同时会开启摄像头和麦克风进行推拉流
 */
+(BOOL)initStreamInfo:(BOOL) audioOpen cameraOpen:(BOOL)cameraOpen useFront:(BOOL)useFront;
/*打开摄像头，开始推流*/
+(void)openCamera:(BOOL)useFront;
/*关闭摄像头*/
+(void)closeCamera;
/*开启音频，开启摄像头后默认开启音频*/
+(void)openMic;
/*关闭音频*/
+(void)closeMic;

/*切换摄像头*/
+(void)switchCamera:(BOOL)isFront;


/*
 开始显示远端视频画面。
 */
+(void)startRemoteView:(NSString *)memberId type:(NSString*)type;

/*
停止显示远端视频画面,关闭pc对象
*/
+(void)stopRemoteView:(NSString *)memberId type:(NSString*)type;

/*
获取画面
*/
+(QKRTCRenderView*)getRenderView:(NSString *)memberId type:(NSString*)type;
/*
 设置本地编码参数
 */
+(void)setVideoResolution:(QKResolution*)videoSetting;

//主持人挂断某人
+(void)hagnUpById:(NSString *)memberId callback:(RctCallback)callback;

//主持人关闭某人摄像头
+(void)closeVideoById:(NSString *)memberId;

// 主持人关闭某人麦克风
+(void)muteById:(NSString *)memberId;

//获取当前房间内推流成员。
+(NSMutableArray*)getAllMember;

//全员关闭麦克风
+(void)muteAll;


+(void)enableBeauty:(BOOL)beauty;
+(NSString*)getSendStr;



@end

