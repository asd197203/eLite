//
//  XBUserDefault.h
//  eLite
//
//  Created by lxx on 16/4/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBUser.h"
@interface XBUserDefault : NSObject

+(instancetype)sharedInstance;

+(void)saveUserInfoModel:(XBUser*)model;

- (BOOL)isAvailable;

@property(nonatomic,strong)XBUser * resModel;
@end
