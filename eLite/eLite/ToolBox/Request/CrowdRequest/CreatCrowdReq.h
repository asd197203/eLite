//
//  CreatCrowdReq.h
//  eLite
//
//  Created by lxx on 16/4/29.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface CreatCrowdReq : SBaseReq<POST>
@property(nonatomic,assign)NSInteger userid;
@property(nonatomic,copy)  NSString *groupid;
@property(nonatomic,copy)  NSString * users;
@property(nonatomic,copy)  NSString * name;
@property(nonatomic,copy)  NSString * createtime;
@end
@interface CreatCrowdRes : SBaseRes
@end