//
//  CloudMemberCell.h
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudMemberCell : UICollectionViewCell


@property(copy,nonatomic) NSString *memberId;
@property(copy,nonatomic) NSString *type;

@property(strong,nonatomic) IBOutlet UILabel *lbl_name;
@property(strong,nonatomic) IBOutlet UIImageView *img_back;
@property(strong,nonatomic) IBOutlet UIImageView *img_sign;
@property(strong,nonatomic) IBOutlet UIImageView *img_mic;
@property(strong,nonatomic) IBOutlet UIView *v_back;
@property(strong,nonatomic) IBOutlet UIView *v_layouts;
@property(strong,nonatomic) IBOutlet UIView *v_main;

@property(copy,nonatomic) void (^tabItem)(void);

@end

NS_ASSUME_NONNULL_END
