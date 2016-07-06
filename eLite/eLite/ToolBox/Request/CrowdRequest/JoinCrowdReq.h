//
//  JoinCrowdReq.h
//  eLite
//
//  Created by lxx on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface JoinCrowdReq : SBaseReq<PUT>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *groupid;
@end
@interface JoinCrowdRes : SBaseRes

@end