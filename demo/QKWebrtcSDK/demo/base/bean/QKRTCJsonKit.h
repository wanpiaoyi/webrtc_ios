//
//  QKJsonKit.h
//  BeijingNews
//
//  Created by yang on 2017/8/1.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKRTCJsonKit : NSObject
+ (NSString *)JSONString:(id)theData;
+ (id)JSONValue:(id)data;
@end
