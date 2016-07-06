//
//  CDGroupDetailController.h
//  LeanChat
//
//  Created by lzw on 14/11/6.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDBaseTableVC.h"
/**
 *  点击管理刷新UI的通知
 */
static NSString *const kCDNotificationDelete = @"deleteCrowdUser";

@interface CDConvDetailVC : CDBaseTableVC
@property(nonatomic,copy)NSString *groupid;
@property(nonatomic,assign)BOOL isCrowd;
- (void)refresh;
@end
