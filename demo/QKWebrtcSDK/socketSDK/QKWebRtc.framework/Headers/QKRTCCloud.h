//
//  QKRTCCloud.h
//  QKWebRtc
//
//  Created by 袁儿宝贝 on 2019/10/12.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QKWebRtc/QKCloudBaseObj.h>
#import <QKWebRtc/QKGLRenderView.h>
#import <QKWebRtc/QKResolution.h>
#import <QKWebRtc/QKOptions.h>
#import <QKWebRtc/QKRTCRenderView.h>
#import <QKWebRtc/QKEnterLogin.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^RctCallback)(NSInteger code,id value);
@class QKRTCMemberInfo,QKAuth;

@protocol QKWebRTCHelperDelegate <NSObject>
@optional
/*
 * 获取到新的音视频流
 */
-(void)onMemberStartPush:(QKRTCMemberInfo *)info type:(NSString*)type;
/**
* 移出音视频流
*/
-(void)onMemberStopPush:(NSString *)memberId type:(NSString*)type;
/**
* 用户信息更新
*/
-(void)onMemberInfoUpdate:(QKRTCMemberInfo*)info;
/**
* 连接数量达到上限，最多支持30人同时推流
*/
-(void)webRTCErrorConnect;

/**
* 账号被挤下线
*/
-(void)onOffLine;


@end

typedef NS_ENUM(NSInteger, LogLevel) {
    LevelDebug, // 显示所有日志
    LevelError,//只显示错误日志
};



@interface QKRTCCloud : NSObject


+(void)lineRtc:(QKOptions*)option;
+(void)initLog:(LogLevel)log;

/*
 初始化SDK
 */
+(void)initSdk;

/*
 设置回调的监听
 */
+(void)setRtcDelegate:(id<QKWebRTCHelperDelegate>)delegate;

/*
 查看版本号
 */
+(NSString*)version;


/*
 加入房间
*/
+(void)enterRoom:(QKEnterLogin*)loginBean  callback:(void (^)(int code,NSArray *res,NSString *msg))callback;
/*
 离开房间并释放资源
*/
+(void)quitRoom:(RctCallback)callback;

/*
开始推流推流
*/
+(BOOL)startPush:(BOOL)audioOpen cameraOpen:(BOOL)cameraOpen useFront:(BOOL)useFront;
/*
 停止推流
 */
+(void)stopPush:(RctCallback)callback;

/*打开摄像头，开始推流*/
+(void)openCamera:(BOOL)useFront;
/*关闭摄像头*/
+(void)closeCamera;
/*开启音频*/
+(void)openMic;
/*关闭音频*/
+(void)closeMic;

/*切换摄像头*/
+(void)switchCamera:(BOOL)isFront;


/*
 更新用户角色，ownerType 和participatorType角色的用户，可以推流。watcherType的用户只能观看。
 */
+(void)roleUpdate:(NSString*)role callback:(RctCallback)callback;

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


/*
 开启美颜
 */
+(void)enableBeauty:(BOOL)beauty;




+(NSString*)getSendStr;

/*
 初始化屏幕共享
 */
+(void)initShareScreen:(QKAuth*)auth groupName:(NSString*)groupName;


/*停止屏幕分享*/
+(void)closeShareScreen:(NSString*)msg;


/*
 Replykit初始化
 */
+(void)initReplykit:(NSString*)groupName finishShare:(void (^)(NSString *msg))finishShare;

/*
 Replykit开启屏幕共享
 */
+(void)openReplykitShareScreen;


/*
 Replykit设置分享数据
 */
+(void)setReplykitVideo:(CMSampleBufferRef)sampleBuffer;



/*
 Replykit停止屏幕共享
 */
+(void)replykitCloseShareScreen;
@end

