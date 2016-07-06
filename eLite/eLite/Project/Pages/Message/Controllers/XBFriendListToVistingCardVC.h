//
//  XBFriendListToVistingCardVC.h
//  eLite
//
//  Created by lxx on 16/5/11.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "CDFriendListVC.h"
#import "GetFriendListReq.h"
@protocol SelectFriendToVistingCardDelete <NSObject>
@optional
- (void)selectFriend:(GetFriendModel*)friend;
@end
@interface XBFriendListToVistingCardVC : CDFriendListVC
@property(nonatomic,weak)id<SelectFriendToVistingCardDelete>delegate;
@end
