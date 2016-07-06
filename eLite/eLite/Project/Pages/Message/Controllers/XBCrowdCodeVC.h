//
//  XBCrowdCodeVC.h
//  eLite
//
//  Created by lxx on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBMyCodeVC.h"
#import "HCCreateQRCode.h"
#import "AVIMConversation+Custom.h"
@interface XBCrowdCodeVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *CodeImageView;
@property(nonatomic,strong)AVIMConversation *conv;
@end
