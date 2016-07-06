//
//  DeleteCrowd.h
//  eLite
//
//  Created by lxx on 16/5/6.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface DeleteCrowdReq : SBaseReq<DELETE>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *groupid;
@end
@interface DeleteCrowdRes : SBaseRes
@end