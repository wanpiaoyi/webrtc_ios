//
//  QKRTCRenderView.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/7/17.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, QKRenderMode) {
    QKRenderModeFit,      //等比例显示视频
    QKRenderModeFill,     // 全屏等比显示，超出部分画面会被截取。
    QKRenderModeScale,     // 拉伸画面铺满全屏
};


@interface QKRTCRenderView : UIView
@property(copy,nonatomic) NSString *memberId;
@property(copy,nonatomic) NSString *type;
/*
 默认为QKRenderModeFit
 */
@property(nonatomic) QKRenderMode videoMode;

@end

