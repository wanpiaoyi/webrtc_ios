//
//  QKMeetingManager.m
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/7/23.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "QKMeetingManager.h"
#import "QKRTCUser.h"
#import "QKWebrtcPubs.h"
#import "CloudMemberView.h"
#import "QKWebRtcAudio.h"
#import <QKWebRtc/QKWebRtc.h>
#import "HeaderInfo.h"
#import "PGToastView.h"
#import "AlertSignChooseView.h"

@interface QKMeetingManager()<QKMeetingCloudDelegate>
@property(strong,nonatomic) UIView *view;
@property(strong,nonatomic) UIView *v_memberView;
@property(strong,nonatomic) UIView *bigView;

@property(strong,atomic) NSMutableArray<QKRTCUser*> *array_members;

@property(strong,nonatomic) UIImageView *img_imgback;
@property(strong,nonatomic) UIImageView *img_head;
@property(strong,nonatomic) CloudMemberView *cloudMemberView;
@property(strong,nonatomic) QKWebRtcAudio *qkRtcAudio;



@end

@implementation QKMeetingManager
+(instancetype)shareInstance{
    
    static QKMeetingManager * instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QKMeetingManager alloc] init];
    });
    return instance;
}
-(id)init{
    self = [super init];
    if(self){
        self.qkRtcAudio = [[QKWebRtcAudio alloc] init];

        self.array_members = [NSMutableArray new];
        self.img_imgback = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
        self.img_imgback.image = [UIImage imageNamed:@"qkrtc_webrtc_back"];
        self.img_imgback.contentMode = UIViewContentModeScaleToFill;
        self.img_head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 132, 132)];
        self.img_head.image = [UIImage imageNamed:userDefaultHeader];
        self.img_head.autoresizingMask = UIViewAutoresizingNone;
        self.img_head.clipsToBounds = YES;

        self.cloudMemberView = [[CloudMemberView alloc] init];
        WS(weakSelf);
        [self.cloudMemberView setClickItem:^(QKRTCUser *part,NSInteger path) {
            if([part.objId isEqualToString:weakSelf.memberId]){
                [weakSelf.array_members exchangeObjectAtIndex:0 withObjectAtIndex:path];
                [weakSelf layoutViews];
            }else{
                [weakSelf ownerAction:part path:path];
            }
        }];
    }
    return self;
}

-(void)initManager{
    [self.qkRtcAudio useSpeaker];

    [QKMeetingCloud setRtcDelegate:self];
}
-(void)setMainView:(UIView*)view{
    self.view = view;
}

-(void)ownerAction:(QKRTCUser *)part path:(NSInteger) path{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    {
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = @(1);
        bean.name = @"切成大画面";
        [array addObject:bean];

    }
    {
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = @(2);
        bean.name = @"关闭麦克风";
        [array addObject:bean];

    }
    
    {
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = @(3);
        bean.name = @"关闭摄像头";
        [array addObject:bean];
    }
    
    {
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = @(4);
        bean.name = @"挂断";
        [array addObject:bean];
    }
    __weak QKRTCUser *weakUser = part;
    WS(weakSelf);
    AlertSignChooseView *alert = [[AlertSignChooseView alloc] init:array frame:webpubs.window.bounds callBack:^(AlertSignChooseBean *bean) {
        NSNumber *state = bean.data;
        switch ([state intValue]) {
            case 1:
            {
              [weakSelf.array_members exchangeObjectAtIndex:0 withObjectAtIndex:path];
                [weakSelf layoutViews];
            }
                
                break;
            case 2:
            {
                [QKMeetingCloud muteById:weakUser.objId];
            }
                break;
            case 3:
            {
                [QKMeetingCloud closeVideoById:weakUser.objId];
            }
                break;
            case 4:
            {
                [QKMeetingCloud hagnUpById:weakUser.objId callback:^(NSInteger code, id value) {
                    if(code != 0){
                        NSLog(@"出错了：%@",value);
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }];
    [webpubs.window addSubview:alert];
}

/*
设置参会者界面
*/
-(void)setMemberView:(UIView*)view{
    self.v_memberView = view;
}


-(void)clearAll{
    self.view = nil;
    [self.array_members removeAllObjects];
}

//刷新页面
-(void)layoutViews{
    //先移除掉没有视频的占位大头像
    [self.img_imgback removeFromSuperview];
    [self.img_head removeFromSuperview];
    NSMutableArray *members = [NSMutableArray arrayWithArray:self.array_members];
    if(members.count == 0){
        return;
    }
    QKRTCUser *bigScreen = nil;
    if(members.count > 0){
        bigScreen = [members objectAtIndex:0];
        [members removeObjectAtIndex:0];
    }
    [self addBigView:bigScreen];
    self.cloudMemberView.array_members = members;
    [self.cloudMemberView changeFrame];
    [self.cloudMemberView reloadData];
    [self.v_memberView addSubview:self.cloudMemberView];
}



-(QKRTCUser *)checkBigScreen:(NSArray*)members{
    for(QKRTCMemberInfo *member in members){
        if(member.pushList != nil){
            for(EnterResPush *push in member.pushList){
                if([push.type isEqualToString:mainType] || [push.type isEqualToString:screenType]){
                    QKRTCUser *user = [QKRTCUser new];
                    user.objId = member.objId;
                    user.name = member.objId;
                    user.type = push.type;
                    return user;
                }
            }
        }
    }
    return nil;
}

//显示大画面
-(void)addBigView:(QKRTCUser*)bigScreen{
    if(bigScreen == nil){
        return;
    }
    if(self.bigView != nil){
        [self.bigView removeFromSuperview];
    }
    QKRTCRenderView *render = [QKMeetingCloud getRenderView:bigScreen.objId type:bigScreen.type];
    render.frame = self.view.bounds;
    render.layer.cornerRadius = 0.0;
    [self.view insertSubview:render atIndex:0];
    self.bigView = render;
    NSLog(@"addBigView render:%@ id:%@ type;%@",render,bigScreen.objId,bigScreen.type);
    if(self.memberId != nil && [render.memberId isEqualToString:self.memberId]&&![bigScreen.type isEqualToString:screenType]){
        render.videoMode = QKRenderModeFill;
    }else{
        render.videoMode = QKRenderModeFit;
    }
    if(!bigScreen.video){
        [render addSubview:self.img_imgback];

        [render addSubview:self.img_head];
        self.img_imgback.frame = render.bounds;
        self.img_head.contentMode = UIViewContentModeScaleAspectFill;

        UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(nowOrientation == UIInterfaceOrientationPortrait || nowOrientation == UIInterfaceOrientationPortraitUpsideDown){
            self.img_head.frame = CGRectMake((render.frame.size.width - self.img_head.frame.size.width)/2, (render.frame.size.height - self.img_head.frame.size.height)/2 - 60, self.img_head.frame.size.width, self.img_head.frame.size.height);
        }else{
            self.img_head.frame = CGRectMake((render.frame.size.width - self.img_head.frame.size.width)/2, (render.frame.size.height - self.img_head.frame.size.height)/2, self.img_head.frame.size.width, self.img_head.frame.size.height);
        }
    }else{
        [self.img_imgback removeFromSuperview];
        [self.img_head removeFromSuperview];
    }

}


#pragma mark -sdk delegate的监听事件
/*
 * 获取到新的音视频流
 */
-(void)onMemberStartPush:(QKRTCMemberInfo *)info type:(NSString*)type{
    NSLog(@"onMemberStartPush:%@  type:%@",info.objId,type);
    [self addMember:info type:type];
    /*
     拉去远端的音视频数据
     */
    [QKMeetingCloud startRemoteView:info.objId type:type];
    [self layoutViews];
}
/**
* 移出音视频流,有用户离开房间
*/
-(void)onMemberStopPush:(NSString *)memberId type:(NSString*)type{
    NSLog(@"onMemberStopPush:%@  type:%@",memberId,type);

    [self closeView:memberId type:type];
}



-(void)closeView:(NSString*)memberId type:(NSString*)type{
    [self removeMember:memberId type:type];

    [QKMeetingCloud stopRemoteView:memberId type:type];
    [self layoutViews];
}
/**
* 用户信息更新
*/
-(void)onMemberInfoUpdate:(QKRTCMemberInfo*)info{
    [self updateMember:info];
    [self layoutViews];
}

/**
* 被禁言
*/
-(void)onMute{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(MeetingStateMuteOne) forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MeetingNotification object:dic];
}

/**
* 被关闭摄像头
*/
-(void)onCameraClose{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(MeetingStateCameraClose) forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MeetingNotification object:dic];
}

/**
* 账号被踢下线
*/
-(void)onKickOut{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(MeetingStateCtlKickout) forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MeetingNotification object:dic];
}

/**
* 账号被挤下线
*/
-(void)onOffLine{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(MeetingStateDeviceConflict) forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MeetingNotification object:dic];
}

/**
* 用户角色信息变更。
*/
-(void)onRoleUpdate:(NSString*)role oldRole:(NSString*)oldRole memberId:(NSString*)memberId{

   
    NSLog(@"error onRoleUpdate:%@ memberId:%@",role,memberId);
    
    if([role isEqualToString:watcherType]&&([oldRole isEqualToString:ownerType] || [oldRole isEqualToString:participatorType])){
        [pgToast setText:@"角色改变停止推流"];
    }else if(([role isEqualToString:ownerType] || [role isEqualToString:participatorType]) && [oldRole isEqualToString:watcherType]){
        [pgToast setText:@"角色改变开始推流"];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@(MeetingStateToPar) forKey:@"state"];
        [[NSNotificationCenter defaultCenter] postNotificationName:MeetingNotification object:dic];
    }
    
}
-(void)onRoomClose{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(MeetingStateRoomClose) forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MeetingNotification object:dic];
}


/**
* 连接数量达到上限，最多支持30人同时推流
*/
-(void)webRTCErrorConnect{
    NSLog(@"error webRTCErrorConnect");
}

#pragma mark -本地数据维护

/*
 是否存在member
 */
-(BOOL)hasMemberId:(NSString*)memberId{
    for(QKRTCMemberInfo *bean in self.array_members){
        if([bean.objId isEqualToString:memberId]){
            return YES;;
        }
    }
    return NO;
}


/*
 是否存在用户
 */
-(QKRTCUser*)hasMember:(NSString*)memberId type:(NSString*)type{
    for(QKRTCUser *bean in self.array_members){
        if([bean.objId isEqualToString:memberId] && [bean.type isEqualToString:type]){
            return bean;
        }
    }
    return nil;
}

-(void)addMember:(NSString *)memberId type:(NSString*)type audio:(BOOL)audio camera:(BOOL)camera
{
    QKRTCUser *oldMember = [self hasMember:memberId type:type];
    if(oldMember == nil){
        QKRTCUser *user = [QKRTCUser new];
        user.objId = memberId;
        user.name = memberId;
        user.type = type;
        user.audio = audio;
        user.video = camera;
        [self.array_members insertObject:user atIndex:0];
    }

}
-(void)addMember:(QKRTCMemberInfo *)info type:(NSString*)type{
    if(info == nil || type == nil){
        return;
    }
    QKRTCUser *oldMember = [self hasMember:info.objId type:type];
    if(oldMember == nil){
        QKRTCUser *user = [QKRTCUser new];
        user.objId = info.objId;
        if(info.name != nil && info.name.length > 0){
            user.name = info.name;
        }else{
            user.name = info.objId;
        }
        user.type = type;
        for(EnterResPush *push in info.pushList){
            if([push.type isEqualToString:type]){
                user.audio = push.audio;
                user.video = push.video;
                break;
            }
        }

        [self.array_members addObject:user];
    }
}

-(void)updateMember:(QKRTCMemberInfo *)member{
    for(EnterResPush *push in member.pushList){
        if([push.type isEqualToString:mainType] || [push.type isEqualToString:screenType]){
            QKRTCUser *user = [self hasMember:member.objId type:push.type];
            user.audio = push.audio;
            user.video = push.video;
        }
    }
}


/*
 移除Member
 */
-(BOOL)removeMember:(NSString*)memberId type:(NSString*)type{
    for(QKRTCUser *bean in self.array_members){
        if([bean.objId isEqualToString:memberId]&&[bean.type isEqualToString:type]){
            [self.array_members removeObject:bean];
            return YES;
        }
    }
    return false;
}
@end
