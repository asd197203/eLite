//
//  GetFriendListReq.h
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface GetFriendListReq : SBaseReq<GET>
@property(nonatomic,copy)NSString *userid;
@end
@interface GetFriendModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*remark;
@property(nonatomic,copy)NSNumber <Optional>*userid;
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>*photo;
@property(nonatomic,copy)NSString <Optional>*sex;
@end
@protocol GetFriendModel <NSObject>
@end
@interface GetFriendListRes : SBaseRes
@property(nonatomic,strong)NSArray <GetFriendModel,Optional>*data;
@end