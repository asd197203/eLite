//
//  XBInviteToCrowdVC.h
//  eLite
//
//  Created by lxx on 16/5/6.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDBaseTableVC.h"
#import "AVIMConversation.h"
#import "CDConvDetailVC.h"
@interface XBInviteToCrowdVC : CDBaseTableVC
@property(nonatomic,strong)NSArray *listFriend;
@property(nonatomic,strong)AVIMConversation *conv;
@property(nonatomic,strong)NSArray *isInCrowdArray;
@property CDConvDetailVC *DetailVC;
@end
