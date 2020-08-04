//
//  NSDictionry+NoNull.m
//  BeijingNews
//
//  Created by yang on 2017/8/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "NSDictionry+NoNull.h"

@implementation NSDictionary(NoNull)

-(id)objectForKeyId:(id)aKey{
    if(aKey == nil){
        return nil;
    }
    id value = [self objectForKey:aKey];
    if([value isKindOfClass:[NSNull class]]){
        return nil;
    }
    return value;
}
@end
