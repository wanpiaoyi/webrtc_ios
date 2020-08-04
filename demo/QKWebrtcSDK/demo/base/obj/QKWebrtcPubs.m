//
//  QKWebrtcPubs.m
//  QKRTCCloud
//
//  Created by 袁儿宝贝 on 2019/9/29.
//  Copyright © 2019 袁儿宝贝. All rights reserved.
//

#import "QKWebrtcPubs.h"

@implementation QKWebrtcPubs

+(QKWebrtcPubs *)sharePubThings{
    static dispatch_once_t once;
    static QKWebrtcPubs *sharedView;
    dispatch_once(&once, ^ {
        
        sharedView = [[QKWebrtcPubs alloc] init];
        
    });
    return sharedView;
}


-(id)init{
    self = [super init];
    if(self){
        self.allWidth = [[UIScreen mainScreen] bounds].size.width;
        self.allHeight = [[UIScreen mainScreen] bounds].size.height;
        // 开始启动的时候，默认不然私有云还是公有云，都使用公有云的地址（在用户选择了私有云并填写appkey成功之后，在将所有的地址换成私有云）
        if(self.screen_height < self.screen_width){
            
            self.allHeight = [[UIScreen mainScreen] bounds].size.width;
            self.allWidth = [[UIScreen mainScreen] bounds].size.height;
            
        }

        self.safeTop = 20;
        // iPhone X以上设备iOS版本一定是11.0以上。
        if(self.screen_height == 812){
            self.safeTop = 44;
            self.safeBottom = 34;
        }
        else if (@available(iOS 11.0, *)) {
            // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            if (window.safeAreaInsets.bottom > 0.0) {
                self.safeTop = window.safeAreaInsets.top;
                self.safeBottom = window.safeAreaInsets.bottom;
            }
        }

    }
    return self;
}

-(UIWindow*)window{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window;
}
-(float)deleteTop{
    if (@available(iOS 11.0, *)) {
        // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
        if (self.safeTop > 20.0) {
            return self.safeTop;
        }
    }
    return 0;
}

-(float)deleteBottom{
    return self.safeBottom;
}


-(float)screen_height{
    if(self.safeTop == 20){
        return self.allHeight - 20;
    }
    return self.allHeight - self.safeTop - self.safeBottom;
}
-(float)screen_width{
    return self.allWidth;
}


@end
