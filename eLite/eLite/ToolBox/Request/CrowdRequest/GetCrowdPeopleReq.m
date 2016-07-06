//
//  GetCrowdPeopleReq.m
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "GetCrowdPeopleReq.h"

@implementation GetCrowdPeopleReq
-(NSString*)url
{
    return @"/group/member";
}
@end
@implementation GetCrowdPeopleRes
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"data.name":@"name"}];
}
@end
@implementation GetCrowdPeopleModel
@end