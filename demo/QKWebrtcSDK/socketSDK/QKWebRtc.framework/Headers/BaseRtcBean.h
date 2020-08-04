//
//  BaseRtcBean.h
//  BeijingNews
//
//  Created by yang on 2017/8/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseRtcBean : NSObject
@property(copy,nonatomic) NSString *base_name;

+(void)setDict:(NSMutableDictionary*)dict setObject:(id)anObject forKey:(NSString*)key;
+(id)getDict:(NSDictionary*)dict forKey:(NSString*)key;
+(id)getStringDict:(NSDictionary*)dict forKey:(NSString*)key;
+(BaseRtcBean*)getBeanByDic:(NSDictionary*)dic;
-(BaseRtcBean*)getBeanByDic:(NSDictionary*)dic;

//获取返回的对象的array
+(NSMutableArray*)getArray:(NSArray*)array bean:(BaseRtcBean*)bean;


/**
 将对象列表转为dic列表
 */
+(NSMutableArray*)getObjectsToDics:(NSArray*)array;
+(NSString*)getObjectsToJson:(NSArray*)array;



-(NSMutableDictionary*)getBeanDic;
-(NSString*)getJsonStr;

+(BOOL)isNillOrNull:(NSDictionary*)dic;
@end
