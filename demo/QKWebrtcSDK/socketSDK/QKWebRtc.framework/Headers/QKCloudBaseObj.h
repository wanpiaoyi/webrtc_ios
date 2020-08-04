//
//  CloudBaseObj.h
//  QKWebRtc
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#define previewType @"preview"
#define mainType @"main"
#define screenType @"screen"

//参与者可以推流
#define participatorType @"participator"
//围观人员，不能推流
#define watcherType @"watcher"



#define studioType @"studio"
#define ownerType @"owner"

NS_ASSUME_NONNULL_BEGIN

@interface QKCloudBaseObj : NSObject
-(NSDictionary*)getParams;

@end

NS_ASSUME_NONNULL_END
