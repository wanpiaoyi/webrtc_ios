//
//  QukanAlert.m
//  MobileIPC
//
//  Created by chenyu on 13-11-7.
//  Copyright (c) 2013年 ReNew. All rights reserved.
//

#import "QukanAlert.h"
@implementation QukanAlert

+(void)alertMsg:(NSString*)msg nav:(UINavigationController*)nav{
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
     [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//         [weakSelf hangup:nil];
     }]];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;

     // 由于它是一个控制器 直接modal出来就好了
     [nav presentViewController:alertController animated:YES completion:nil];
}

@end
