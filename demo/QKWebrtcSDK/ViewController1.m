//
//  ViewController1.m
//  QKRTCCloud
//
//  Created by 袁儿宝贝 on 2019/9/29.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import "ViewController1.h"
#import "QKWebrtcPubs.h"
#import "QKMeetingController.h"
#import "QKRTCController.h"
#import "QKRTCManager.h"
#import "QKMeetingManager.h"

#import <QKWebRtc/QKWebRtc.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

#import <ReplayKit/ReplayKit.h>
#import "HeaderInfo.h"

@interface ViewController1 ()

@property(strong,nonatomic) IBOutlet UITextField *fld_memberId;
@property(strong,nonatomic) IBOutlet UITextField *fld_bitrate;
@property(strong,nonatomic) IBOutlet UITextField *fld_roomId;

@property(strong,nonatomic) NSString *memberId;

@end

@implementation ViewController1

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [QKRTCCloud initLog:LevelDebug];
    [QKRTCCloud initSdk];
    
}



-(IBAction)showController:(id)sender{
    WS(weakSelf);
    NSString *roomId = [self checkText:self.fld_roomId.text];
  
      if(roomId == nil){
            return;
      }
      if(roomId.length == 0){
            [self showMsg:@"roomId不能为空"];
            return;
      }
    NSString *appKey = @"6xkksaudj54ldmli";
    NSString *appSecret = @"zhBTugQF7fcTD9uT";
    NSString *session = [self defaultSession];
    NSString *objId = session;
    NSString *role = participatorType;


    NSString *content = [NSString stringWithFormat:@"%@_%@_%@_%@",session,objId,role,roomId];
    NSString *sig = [self HmacSha1:appSecret data:content];


    UIButton *btn = (UIButton*)sender;

    QKEnterLogin *login = [[QKEnterLogin alloc] init];
    login.appKey = appKey;
    login.session = session;
    login.objId = objId;
    login.roomId = roomId;
    login.role = role;
    login.sig = sig;
    login.saveRecord = true;

//    NSString *objId = @"YTCASWVNLZIDLLVBJPKBLIRSSVIXVWQV";
//    NSString *session = @"YTCASWVNLZIDLLVBJPKBLIRSSVIXVWQV";
//    roomId = @"398028077";
//    NSString *sig = @"9nBUgYpRP/MOZ/iNUMg5neWX5UI=|1481267655301930|participator";
//
//
//
//
//    QKEnterLogin *login = [QKEnterLogin new];
//    login.objId = objId;
//    login.session = session;
//    login.roomId = roomId;
//    login.avatar = @"";
//    login.name = @"112233";
//    login.battery = 20;
//    login.forceEnter = false;
//    login.sig = sig;
    [rtcManager initManager];
    rtcManager.memberId = objId;
    rtcManager.roomId = roomId;
    rtcManager.role = role;

    [QKRTCCloud enterRoom:login callback:^(int code, NSArray *res, NSString *msg) {
        if(code == 0){
            QKRTCController *controller = [QKRTCController new];
            controller.memberId = objId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    QKAuth *auth = [QKAuth new];
    auth.appKey = appKey;
    auth.objId = objId;
    auth.session = session;
    auth.roomId = roomId;
    auth.sig = sig;
    auth.role = role;
    auth.roomType = QKRTCRoomTypeAnonymous;
    [QKRTCCloud initShareScreen:auth groupName:qkGroupName];
}

-(IBAction)showMeeting:(id)sender{
    WS(weakSelf);
    NSString *roomId = [self checkText:self.fld_roomId.text];
  
      if(roomId == nil){
            return;
      }
      if(roomId.length == 0){
            [self showMsg:@"roomId不能为空"];
            return;
      }

    NSString *appKey = @"6xkksaudj54ldmli";
    NSString *appSecret = @"zhBTugQF7fcTD9uT";
    NSString *session = [self defaultSession];

    NSString *objId = session;
    NSString *role = participatorType;
    NSString *content = [NSString stringWithFormat:@"%@_%@_%@_%@",session,objId,role,roomId];
    NSString *sig = [self HmacSha1:appSecret data:content];



    QKMeetingLogin *login = [QKMeetingLogin new];
    login.appKey = appKey;
    login.objId = objId;
    login.session = session;
    login.roomId = roomId;
    login.role = role;
    login.name = @"yp";
    login.sig = sig;
    [meetingManager initManager];
    meetingManager.memberId = objId;
    meetingManager.roomId = roomId;
    meetingManager.role = role;
    [QKMeetingCloud enterRoom:login callback:^(int code, NSArray *res, NSString *msg) {
        if(code == 0){

            QKMeetingController *controller = [QKMeetingController new];
            controller.memberId = objId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
  
    
}

-(void)showMsg:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString*)checkText:(NSString*)str{
    
   str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   if (str == nil||[str isKindOfClass:[NSNull class]] || [str isEqualToString:@""])
   {
      return @"";
   }
   if([self stringContainsEmoji:str]){
      return nil;
   }
   return str;
}

//判断是否还有特殊表情
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

-(IBAction)hidkeyboard:(id)sender{
    [self.view endEditing:YES];
}



//HmacSHA1加密；key 秘钥  data：数据
-(NSString *)HmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];

    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
    return hash;
}


-(NSString*)defaultSession{
    static NSString *sessionId = nil;
    if(sessionId == nil){
        sessionId = [[NSUUID UUID] UUIDString];
    }
    return sessionId;
}

#pragma mark - 隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
@end
