//
//  CloudMemberCell.m
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "CloudMemberCell.h"

@implementation CloudMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_back.layer.cornerRadius = 3.0;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.tabItem){
        self.tabItem();
    }
}
@end
