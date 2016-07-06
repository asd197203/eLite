//
//  EditCrowdNameReq.h
//  eLite
//
//  Created by lxx on 16/5/9.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface EditCrowdNameReq : SBaseReq<PUT>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *groupid;
@property(nonatomic,copy)NSString *name;
@end
@interface EditCrowdNameRes : SBaseRes

@end