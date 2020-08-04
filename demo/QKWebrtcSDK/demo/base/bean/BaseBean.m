//
//  BaseBean.m
//  BeijingNews
//
//  Created by yang on 2017/8/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BaseBean.h"
#import "QKRTCJsonKit.h"

@implementation BaseBean
+(void)setDict:(NSMutableDictionary*)dict setObject:(id)anObject forKey:(NSString*)key{
    if(anObject != nil &&key!=nil){
        [dict setObject:anObject forKey:key];
    }
//    else if(key!=nil){
//        [dict setObject:@"" forKey:key];
//    }
}

+(id)getDict:(NSDictionary*)dict forKey:(NSString*)key{
    id value = dict[key];
    if([value isKindOfClass:[NSNull class]]){
        return nil;
    }
    return value;
}

+(id)getStringDict:(NSDictionary*)dict forKey:(NSString*)key{
    id value = dict[key];
    if([value isKindOfClass:[NSNull class]]){
        return @"";
    }
    return value;
}

-(BaseBean*)getBeanByDic:(NSDictionary*)dic{
    return [[self class] getBeanByDic:dic];
}
+(BaseBean*)getBeanByDic:(NSDictionary*)dic{
    
    return [[BaseBean alloc] init];
}

+(NSMutableArray*)getArray:(NSArray*)array bean:(BaseBean*)bean{
    NSMutableArray *array_return = [[NSMutableArray alloc] init];
    if(array == nil || [array isKindOfClass:[NSNull class]]){
        return array_return;
    }
    for(NSDictionary *dict in array){
        [array_return addObject:[bean getBeanByDic:dict]];
    }
    return array_return;
}

-(NSMutableDictionary*)getBeanDic{
    NSLog(@"error getBeanDic:%@",self);
    return [NSMutableDictionary new];
}

-(NSString*)getJsonStr{
    NSMutableDictionary *dic = [self getBeanDic];
    NSString *strJson = [QKRTCJsonKit JSONString:dic];
    return strJson;
}

+(NSMutableArray*)getObjectsToDics:(NSArray*)array{
    
    NSMutableArray *array_return = [[NSMutableArray alloc] init];
    if(array == nil || [array isKindOfClass:[NSNull class]]){
        return array_return;
    }
    
    if(array != nil){
        for(BaseBean *bean in array){
            [array_return addObject:[bean getBeanDic]];
        }
    }
    return array_return;
}

+(NSString*)getObjectsToJson:(NSArray*)array{
    
    NSMutableArray *array_return = [[NSMutableArray alloc] init];
    if(array == nil || [array isKindOfClass:[NSNull class]]){
        return [QKRTCJsonKit JSONString:array_return];
    }
    
    if(array != nil){
        for(BaseBean *bean in array){
            [array_return addObject:[bean getBeanDic]];
        }
    }
    return [QKRTCJsonKit JSONString:array_return];
}
@end
