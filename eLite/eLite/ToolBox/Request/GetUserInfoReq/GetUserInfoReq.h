//
//  GetUserInfoReq.h
//  eLite
//
//  Created by lxx on 16/4/27.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface GetUserInfoReq : SBaseReq<GET>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *friendid;
@end
@interface GetUserInfoRes : SBaseRes
@property(nonatomic,strong)NSDictionary <Optional>*data;
@end