//
//  GetCrowdDetailReq.h
//  eLite
//
//  Created by lxx on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface GetCrowdDetailReq : SBaseReq<GET>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *groupid;
@end
@interface GetCrowdDetailRes : SBaseRes
@property(nonatomic,strong)NSDictionary  *data;
@end