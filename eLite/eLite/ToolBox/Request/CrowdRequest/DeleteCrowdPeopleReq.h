//
//  DeleteCrowdPeopleReq.h
//  eLite
//
//  Created by lxx on 16/5/6.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface DeleteCrowdPeopleReq : SBaseReq<PUT>
@property(nonatomic,copy)NSString *groupid;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *id;
@end
@interface DeleteCrowdPeopleRes : SBaseRes

@end