//
//  QKMeetingController.m
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/4/15.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "QKMeetingController.h"
#import <QKWebRtc/QKWebRtc.h>
#import <ReplayKit/ReplayKit.h>

#import "AlertSignChooseView.h"
#import "QKWebRtcAudio.h"
#import "QKMeetingManager.h"
#import "QKWebrtcPubs.h"
#import "PGToastView.h"
#import "QukanAlert.h"
#import "HeaderInfo.h"

@interface QKMeetingController ()



@property(strong,nonatomic) IBOutlet UIView *v_memberView;


@property(strong,nonatomic) IBOutlet UIImageView *img_head;
@property(strong,nonatomic) IBOutlet UIImageView *img_bottom;
@property(strong,nonatomic) IBOutlet UIView *v_shareScreen;
@property(strong,nonatomic) IBOutlet UIButton *btn_switchCamera;
@property(strong,nonatomic) IBOutlet UIButton *btn_mic;
@property(strong,nonatomic) IBOutlet UIButton *btn_hangup;
@property(strong,nonatomic) IBOutlet UIButton *btn_camera;
@property(strong,nonatomic) IBOutlet UILabel *lbl_time;
@property(strong,nonatomic) IBOutlet UILabel *lbl_audio;
@property(strong,nonatomic) IBOutlet UILabel *lbl_camera;
@property(strong,nonatomic) IBOutlet UIView *v_audio;
@property(strong,nonatomic) IBOutlet UIView *v_camera;
@property(strong,nonatomic) IBOutlet UIView *v_hangup;
@property(strong,nonatomic) IBOutlet UIView *v_video;
@property(strong,nonatomic) IBOutlet UIView *v_quality;
@property(strong,nonatomic) IBOutlet UIView *v_quality1;
@property(strong,nonatomic) IBOutlet UILabel *lbl_quality;
@property(strong,nonatomic) IBOutlet UIButton *btn_shareType;



//当前ui方向
@property(nonatomic) UIInterfaceOrientation nowOrientation;

@property(nonatomic) BOOL uiInited;

//连线时间的计时器
@property(strong,nonatomic) NSTimer *timer;
@property(strong,nonatomic) QKResolution *resolution;

@property NSInteger time;
@property BOOL useFrontCamera;
@property BOOL cameraOpen;
@property BOOL micOpen;



- (void)cloudListen:(NSNotification *)notification;
-(void)initLandscape;
-(void)initPortrait;

@property(strong,nonatomic) RPSystemBroadcastPickerView *picker;

@end

@implementation QKMeetingController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [[UIApplication sharedApplication]
    setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
    [[UIApplication sharedApplication]
    setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

    self.time = 0;
    self.micOpen = true;
    self.cameraOpen = true;
    /*
     使用前置摄像头
     */
    self.useFrontCamera = true;

    [self initRtcInfo];

    [self addNotification];
    [self addShareScreen];

    [super viewDidLoad];

}
-(void)initRtcInfo{
    [QKMeetingCloud enableBeauty:webpubs.beauty];
    self.resolution = [QKResolution defaultVideoSettings];
    [QKMeetingCloud setVideoResolution:self.resolution];
    [meetingManager setMainView:self.v_video];
    [meetingManager setMemberView:self.v_memberView];
    [meetingManager layoutViews];
    meetingManager.memberId = self.memberId;
    [QKMeetingCloud enableBeauty:true];
    if(self.micOpen){
        [self.btn_mic setImage:[UIImage imageNamed:@"qkrtc_watch_micOpen"] forState:UIControlStateNormal];
        self.lbl_audio.text = @"麦克风已开启";
    }else{
        [self.btn_mic setImage:[UIImage imageNamed:@"qkrtc_watch_micClose"] forState:UIControlStateNormal];
        self.lbl_audio.text = @"麦克风已关闭";
    }

    if(self.cameraOpen){
        [self.btn_camera setImage:[UIImage imageNamed:@"qkrtc_watch_cameraOpen"] forState:UIControlStateNormal];
        self.lbl_camera.text = @"摄像头已开启";
    }else{
        [self.btn_camera setImage:[UIImage imageNamed:@"qkrtc_watch_cameraClose"] forState:UIControlStateNormal];
        self.lbl_camera.text = @"摄像头已关闭";
    }
    [meetingManager addMember:self.memberId type:mainType audio:self.micOpen camera:self.cameraOpen];
    //初始化推流信息
    [QKMeetingCloud initStreamInfo:self.micOpen cameraOpen:self.cameraOpen useFront:self.useFrontCamera];
}

//添加屏幕分享
-(void)addShareScreen{
    if (@available(iOS 12.0, *)) {
         RPSystemBroadcastPickerView *picker = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0,-100, 39, 39)];
         picker.showsMicrophoneButton = false;
         //你的app对用upload extension的 bundle id， 必须要填写对
         picker.preferredExtension = shareExtension;
         [self.view insertSubview:picker atIndex:0];
         self.picker = picker;
     }
}


-(void)initUI{

    UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if(self.uiInited && nowOrientation == self.nowOrientation){
        return;
    }

    self.v_quality1.layer.cornerRadius = 3.0;
    self.v_quality1.layer.borderWidth = 1.0;
    self.v_quality1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lbl_quality.text = self.resolution.type;


    self.uiInited = YES;
    self.nowOrientation = nowOrientation;
    if(nowOrientation == UIInterfaceOrientationPortrait || nowOrientation == UIInterfaceOrientationPortraitUpsideDown){
        [self initPortrait];
    }else{
        [self initLandscape];
    }
    [meetingManager layoutViews];
}

-(IBAction)getSendData:(id)sender{
    NSString *str = [QKMeetingCloud getSendStr];
    [pgToast setText:str];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudListen:) name:MeetingNotification object:nil];
}


- (void)cloudListen:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];

    NSNumber *state = infoDic[@"state"];
    NSDictionary * data = infoDic[@"data"];

    switch ([state intValue]) {


        case MeetingStateMuteOne:  //开启关闭某人禁言
        {
            if(self.micOpen){
                [self closeMic];
            }
        }
            break;
        case MeetingStateCameraClose:  //开启关闭某人摄像头
        {
             if(self.cameraOpen){
                 [self closeCamera];
             }
        }
            break;

        case MeetingStateRoleUpdate:  //用户角色更新
        {
            NSLog(@"用户角色发生变更");
        }
            break;
            

        case MeetingStateCtlKickout:  //某人被踢出房间
        {
            WS(weakSelf);
            NSString *roomId = data[@"roomId"];
               dispatch_async(dispatch_get_main_queue(), ^{

                   [weakSelf back:nil];
                   [pgToast setText:@"被踢出房间。"];

                });

        }
            break;
            
        case MeetingStateDeviceConflict:  //被其它登录端踢出房间
          {
              WS(weakSelf);
              dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf back:nil];
                  [pgToast setText:@"当前账号已在其他房间登录。"];
              });

          }
              break;
            case MeetingStateToPar:
            {
                [QKMeetingCloud initStreamInfo:self.micOpen cameraOpen:self.cameraOpen useFront:self.useFrontCamera];
            }
                break;
            //会议结束
            case MeetingStateRoomClose:
            {
                WS(weakSelf);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf back:nil];
                    [pgToast setText:@"会议关闭。"];
                });
            }
                break;

        default:
            break;
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initUI];

}


-(IBAction)back:(id)sender{
    self.btn_hangup.enabled = false;
    //重置视频的方向，用于控制屏幕旋转
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = 0;

        val = AVCaptureVideoOrientationPortrait;

        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }

    [meetingManager clearAll];
    NSLog(@"main layoutViews1 back2");

    WS(weakSelf);
    __block BOOL leaveFinish = false;
    [QKMeetingCloud quitRoom:^(NSInteger code, id value) {
        NSLog(@"main layoutViews1 back4");

        if(leaveFinish == true){
            return;
        }
        leaveFinish = true;
        NSLog(@"main layoutViews1 back5");

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
    NSLog(@"main layoutViews1 back3");
    double time = 8.0;
    if(sender == nil){
        time = 0.5;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time* NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        if(leaveFinish == false){
            leaveFinish = true;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    });

}


-(void)startTimer{
    if(self.timer == nil || ![self.timer isValid]){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dealTime) userInfo:Nil repeats:YES];
    }
}

-(void)stopTimer{
    if(self.timer != nil && [self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark  - UI处理
-(void)dealTime{
    self.time++;
    self.lbl_time.text = [self getTimes:self.time];
}



-(void)initPortrait{
    self.img_head.frame = CGRectMake(0, -webpubs.safeTop, webpubs.allWidth, 59 + webpubs.safeTop);
    self.img_bottom.frame = CGRectMake(0,webpubs.screen_height - 79, webpubs.allWidth, 79 + webpubs.safeBottom);

    self.img_head.image = [UIImage imageNamed:@"qkrtc_watch_yyhenhead"];
    self.img_bottom.image = [UIImage imageNamed:@"qkrtc_watch_yyhenbottom"];
}

-(void)initLandscape{
    self.img_head.frame = CGRectMake(-webpubs.safeTop,0,59 + webpubs.safeTop, webpubs.allWidth);
    int addTop = 0;
    if(webpubs.safeTop == 20){
        addTop = 20;
    }
    self.img_bottom.frame = CGRectMake(webpubs.screen_height - 79 + addTop,0, 79 + webpubs.safeBottom, webpubs.allWidth);

    self.img_head.image = [UIImage imageNamed:@"qkrtc_watch_yyledhead"];
    self.img_bottom.image = [UIImage imageNamed:@"qkrtc_watch_yyledbottom"];

}

#pragma mark - 按钮点击操作
-(IBAction)openOrCloseMic:(id)sender{
    if(self.micOpen){
        [self closeMic];
    }else{
        [self openMic];
    }
}

-(IBAction)shareScreen:(id)sender{
    if (@available(iOS 12.0, *)) {

        for (UIView *view in self.picker.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                [(UIButton*)view sendActionsForControlEvents:UIControlEventAllEvents];
            }
        }

        WS(weakSelf);
        self.btn_shareType.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.btn_shareType.enabled = YES;
            });

        });
    }else{
        [QukanAlert alertMsg:@"仅IOS 12.0以上系统的机器，支持屏幕分享" nav:self.navigationController];
    }
}
-(void)closeMic{
    self.micOpen = false;
    [self.btn_mic setImage:[UIImage imageNamed:@"qkrtc_watch_micClose"] forState:UIControlStateNormal];
    self.lbl_audio.text = @"麦克风已关闭";
    [QKMeetingCloud closeMic];
}

-(void)openMic{
    self.micOpen = true;
    [self.btn_mic setImage:[UIImage imageNamed:@"qkrtc_watch_micOpen"] forState:UIControlStateNormal];
    self.lbl_audio.text = @"麦克风已开启";
    [QKMeetingCloud openMic];

}


-(IBAction)openOrCloseCamera:(id)sender{

    if(self.cameraOpen){
        [self closeCamera];
    }else{
        [self openCamera];
    }
}

-(void)openCamera{
    self.cameraOpen = true;
    [self.btn_camera setImage:[UIImage imageNamed:@"qkrtc_watch_cameraOpen"] forState:UIControlStateNormal];
    self.lbl_camera.text = @"摄像头已开启";
    [QKMeetingCloud openCamera:self.useFrontCamera];
}

-(void)closeCamera{
    self.cameraOpen = false;

    [self.btn_camera setImage:[UIImage imageNamed:@"qkrtc_watch_cameraClose"] forState:UIControlStateNormal];
    self.lbl_camera.text = @"摄像头已关闭";
    [QKMeetingCloud closeCamera];
}
/*
 切换摄像头
 */
-(IBAction)switchCamera:(id)sender{
  
    if(self.cameraOpen){
        self.useFrontCamera = !self.useFrontCamera;
        [QKMeetingCloud switchCamera:self.useFrontCamera];
    }
}
/*
 修改分辨率
 */
-(IBAction)changeQuality:(id)sender{
 
    NSMutableArray *array = [[NSMutableArray alloc] init];

    {
        QKResolution *video = [[QKResolution alloc] init];
        
        video.videoSize = QKVideoSize960x540;
        video.bitrate = 800*1024;
        video.fps = 18;
        
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = video;
        bean.name = [video type];
        [array addObject:bean];

    }
    {
        QKResolution *video = [[QKResolution alloc] init];
        
        video.videoSize = QKVideoSize1280x720;
        video.bitrate = 1500*1024;
        video.fps = 18;
        
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = video;
        bean.name = [video type];
        [array addObject:bean];

    }
    
    {
        QKResolution *video = [[QKResolution alloc] init];
        
        video.videoSize = QKVideoSize1920x1080;
        video.bitrate = 2200*1024;
        video.fps = 20;
        
        AlertSignChooseBean *bean = [AlertSignChooseBean new];
        bean.data = video;
        bean.name = [video type];
        [array addObject:bean];

    }
    
    WS(weakSelf);
    AlertSignChooseView *alert = [[AlertSignChooseView alloc] init:array frame:webpubs.window.bounds callBack:^(AlertSignChooseBean *bean) {
        QKResolution *resultion = bean.data;
        self.resolution = resultion;
        weakSelf.lbl_quality.text = [resultion type];
        [QKMeetingCloud setVideoResolution:resultion];
    }];
    [webpubs.window addSubview:alert];

}


-(NSString*)getTimes:(NSInteger) time{
    NSInteger second = time%60;
    NSInteger min = time/60%60;
    NSInteger hour = time/3600%60;

    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,min,second];
}
@end
