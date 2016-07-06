//
//  XBUserInfoVC.h
//  eLite
//
//  Created by lxx on 16/4/18.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUserManager.h"
#import "CDCacheManager.h"
#import "CDUtils.h"
#import "CDIMService.h"
#import "LZPushManager.h"
#import "CDBaseVC.h"
#import "XBUser.h"
#import "CDFriendListVC.h"
@interface XBUserInfoVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *hearImageView;
@property (strong, nonatomic) IBOutlet UILabel *remarkNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nichengLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sexIImageView;
@property (strong, nonatomic) IBOutlet UILabel *brithDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *schoolLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteFriendButton;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addFriendButtonTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *remarkNameLabelWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *schoolLabelWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *classLabelWidth;
@property (strong, nonatomic) IBOutlet UIView *setRemarkView;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) AVUser *user;
- (BOOL)alertError:(NSError *)error;
@property CDFriendListVC *friendListVC;
@end
