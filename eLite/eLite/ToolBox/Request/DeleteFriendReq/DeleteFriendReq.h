//
//  DeleteFriendReq.h
//  eLite
//
//  Created by lxx on 16/4/27.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface DeleteFriendReq : SBaseReq<DELETE>
@property(nonatomic,assign)NSInteger userid;
@property(nonatomic,assign)NSInteger friendid;
@end
@interface DeleteFriendRes : SBaseRes
@property(nonatomic,strong)NSString <Optional>*data;
@end