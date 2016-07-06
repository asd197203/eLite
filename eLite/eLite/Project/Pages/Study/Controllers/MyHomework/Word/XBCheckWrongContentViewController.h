//
//  XBCheckWrongContentViewController.h
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBCheckWrongViewController;

@interface XBCheckWrongContentViewController : UIViewController

@property (nonatomic, weak) XBCheckWrongViewController *parentController;
@property (nonatomic, strong) XBHomeworkWordInfoModel *infoModel;
@property (nonatomic, strong) NSDictionary *resultDict;

@end
