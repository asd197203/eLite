//
//  GetCrowdPeopleReq.h
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"
@interface GetCrowdPeopleReq : SBaseReq<GET>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *groupid;
@end
@interface GetCrowdPeopleModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*remark;
@property(nonatomic,copy)NSNumber <Optional>*isfriend;
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>*photo;
@property(nonatomic,copy)NSString <Optional>*sex;
@property(nonatomic,copy)NSNumber <Optional>*userid;
@end
@protocol GetCrowdPeopleModel <NSObject>

@end
@interface GetCrowdPeopleRes : SBaseRes
@property(nonatomic,strong)NSDictionary <Optional>*data;
@property(nonatomic,copy)NSString <Optional>*name;
@end