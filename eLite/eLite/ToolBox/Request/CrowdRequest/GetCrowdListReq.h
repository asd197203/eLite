//
//  GetCrowdList.h
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface GetCrowdListReq : SBaseReq<GET>
@property(nonatomic,copy)NSString *userid;
@end
@interface GetCrowdListModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*groupid;
@property(nonatomic,copy)NSString <Optional>*groupname;
@end
@protocol GetCrowdListModel <NSObject>

@end
@interface GetCrowdListRes : SBaseRes
@property(nonatomic,strong)NSArray <GetCrowdListModel,Optional>*data;
@end
