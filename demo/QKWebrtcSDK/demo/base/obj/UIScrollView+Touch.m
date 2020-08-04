//
//  UIScrollView+Touch.m
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/4/30.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "UIScrollView+Touch.h"

@implementation UIScrollView (UITouch)

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
@end

