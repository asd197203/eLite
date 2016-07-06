//
//  GetUserListReq.h
//  eLite
//
//  Created by lxx on 16/5/4.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface GetUserListReq : SBaseReq<GET>
@property(nonatomic,copy)NSString  *userid;
@property(nonatomic,copy)NSString  *users;
@end
@interface GetUerLisyModel : JSONModel
@property(nonatomic,strong)NSNumber <Optional>*isfriend;
@property(nonatomic,strong)NSNumber <Optional>*userid;
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>*photo;
@property(nonatomic,copy)NSString <Optional>*remark;
@end
@protocol GetUerLisyModel <NSObject>
@end
@interface GetUserListRes : SBaseRes
@property(nonatomic,strong)NSArray <GetUerLisyModel,Optional>*data;
@end