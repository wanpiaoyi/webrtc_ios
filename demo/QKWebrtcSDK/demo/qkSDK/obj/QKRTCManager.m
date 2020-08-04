//
//  QKRTCManager.m
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/7/23.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "QKRTCManager.h"
#import "QKRTCUser.h"
#import "QKWebrtcPubs.h"
#import "CloudMemberView.h"
#import "QKWebRtcAudio.h"
#import <QKWebRtc/QKWebRtc.h>

#import "HeaderInfo.h"

@interface QKRTCManager()<QKWebRTCHelperDelegate>
@property(strong,nonatomic) UIView *view;
@property(strong,nonatomic) UIView *v_memberView;

@property(strong,atomic) NSMutableArray<QKRTCUser*> *array_members;

@property(strong,nonatomic) UIImageView *img_imgback;
@property(strong,nonatomic) UIImageView *img_head;
@property(strong,nonatomic) CloudMemberView *cloudMemberView;
@property(strong,nonatomic) QKWebRtcAudio *qkRtcAudio;

@end

@implementation QKRTCManager
+(instancetype)shareInstance{
    
    static QKRTCManager * instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QKRTCManager alloc] init];
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
            [weakSelf.array_members exchangeObjectAtIndex:0 withObjectAtIndex:path];
            [weakSelf layoutViews];
        }];
        

    }
    return self;
}

-(void)initManager{
    [self.qkRtcAudio useSpeaker];

    [QKRTCCloud setRtcDelegate:self];
}
-(void)setMainView:(UIView*)view{
    self.view = view;
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
    [self stopShareScreen];
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
    QKRTCRenderView *render = [QKRTCCloud getRenderView:bigScreen.objId type:bigScreen.type];
//    render.frame = CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height);
    render.frame = self.view.bounds;
    render.layer.cornerRadius = 0.0;
    [self.view insertSubview:render atIndex:0];
    
    if(self.memberId != nil && [render.memberId isEqualToString:self.memberId]&&![bigScreen.type isEqualToString:screenType]){
        render.videoMode = QKRenderModeFill;
    }else{
        render.videoMode = QKRenderModeFit;
    }
    if(!bigScreen.video){
        [render addSubview:self.self.img_imgback];

        [render addSubview:self.img_head];
        self.img_imgback.frame = render.bounds;
        self.img_head.contentMode = UIViewContentModeScaleAspectFill;

        UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(nowOrientation == UIInterfaceOrientationPortrait || nowOrientation == UIInterfaceOrientationPortraitUpsideDown){
            self.img_head.frame = CGRectMake((render.frame.size.width - self.img_head.frame.size.width)/2, (render.frame.size.height - self.img_head.frame.size.height)/2 - 60, self.img_head.frame.size.width, self.img_head.frame.size.height);
        }else{
            self.img_head.frame = CGRectMake((render.frame.size.width - self.img_head.frame.size.width)/2, (render.frame.size.height - self.img_head.frame.size.height)/2, self.img_head.frame.size.width, self.img_head.frame.size.height);
        }
    }

}


-(void)closeView:(NSString*)memberId type:(NSString*)type{
    [self removeMember:memberId type:type];

    [QKRTCCloud stopRemoteView:memberId type:type];
    [self layoutViews];
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
    [QKRTCCloud startRemoteView:info.objId type:type];
    [self layoutViews];
}
/**
* 移出音视频流,有用户离开房间
*/
-(void)onMemberStopPush:(NSString *)memberId type:(NSString*)type{
    [self closeView:memberId type:type];
}



/**
* 用户信息更新
*/
-(void)onMemberInfoUpdate:(QKRTCMemberInfo*)info{
    [self updateMember:info];
    [self layoutViews];
}




/**
* 账号被挤下线
*/
-(void)onOffLine{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(RTCStateDeviceConflict) forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:RTCNotification object:dic];
}

/**
* 连接数量达到上限，最多支持30人同时推流
*/
-(void)webRTCErrorConnect{
    NSLog(@"error webRTCErrorConnect");
}

#pragma mark - 屏幕共享相关
-(void)stopShareScreen{
    [QKRTCCloud closeShareScreen:@"屏幕分享关闭"];
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
        user.name = info.objId;
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
