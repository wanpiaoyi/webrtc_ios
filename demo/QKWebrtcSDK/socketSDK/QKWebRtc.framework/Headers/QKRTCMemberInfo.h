//
//  QKRTCMemberInfo.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/7/22.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <QKWebRtc/QKWebRtc.h>

@interface EnterResPush: QKCloudBaseObj

@property(strong,nonatomic) NSString *type;//: main screen preview
@property(nonatomic) BOOL video;//是否开摄像头
@property(nonatomic) BOOL audio;//是否开音频

@end


@interface QKRTCMemberInfo: QKCloudBaseObj

@property(strong,nonatomic) NSString *objId;//:"xxx",
@property(strong,nonatomic) NSString *name;//

@property(strong,nonatomic) NSString *role;//角色
@property(strong,nonatomic) NSString *roomId;
@property(strong,nonatomic) NSString *session;

@property(strong,nonatomic) NSMutableArray<EnterResPush*> *pushList;

-(BOOL)hasMic;
-(BOOL)hasVideo;


-(BOOL)hasScreenMic;
-(BOOL)hasScreenVideo;
-(BOOL)checkPushType:(NSString*)type;
-(UIView*)getPreview;

-(UIView*)getScreenView;
/*
 是否是参与者
 */
-(BOOL)isParticipator;
/*
 是否围观者
 */
-(BOOL)isWatcher;

/*
 添加推流信息
 */
-(void)addPush:(EnterResPush*)push;

/*
 修改push的音频和视频
 */
-(void)changePush:(EnterResPush*)push;
/*
删除push
 */
-(void)removePush:(NSString*)type;

-(void)copyPar:(QKRTCMemberInfo*)par;

@end
