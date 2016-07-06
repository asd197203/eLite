//
//  XBUserDefault.m
//  eLite
//
//  Created by lxx on 16/4/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBUserDefault.h"

@implementation XBUserDefault
+(instancetype)sharedInstance
{
    static XBUserDefault  *obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj=[[[self class] alloc] init];
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSData *data=[user objectForKey:@"userModel"];
        if(data)
        {
            XBUser *res=[NSKeyedUnarchiver unarchiveObjectWithData:data];
            obj.resModel=res;
        }
    });
    return obj;
}

+(void)saveUserInfoModel:(XBUser*)model
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if(model!=nil)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [user setObject:data forKey:@"userModel"];
    }
    else
    {
        [user removeObjectForKey:@"userModel"];
    }
    [user synchronize];
    [XBUserDefault sharedInstance].resModel=model;
}
- (BOOL)isAvailable
{
    return [XBUserDefault sharedInstance].resModel!=nil;
}
@end
