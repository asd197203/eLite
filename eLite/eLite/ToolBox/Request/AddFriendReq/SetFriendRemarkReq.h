//
//  SetFriendRemarkReq.h
//  eLite
//
//  Created by lxx on 16/5/18.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface SetFriendRemarkReq : SBaseReq<PUT>
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *friendid;
@property (nonatomic,copy)NSString *remark;
@end
@interface SetFriendRemarkRes : SBaseRes
@end