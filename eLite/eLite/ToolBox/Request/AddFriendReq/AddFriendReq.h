//
//  AddFriendReq.h
//  eLite
//
//  Created by lxx on 16/4/27.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface AddFriendReq : SBaseReq<POST>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *friendid;
@end
@interface AddFriendRes : SBaseRes
@property(nonatomic,copy)NSString *data;
@end