//
//  XBVoiceViewController.h
//  eLite
//
//  Created by 常小哲 on 16/5/7.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBVoiceController;

@interface XBVoiceViewController : UIViewController

@property (nonatomic, weak) XBVoiceController *parentController;
@property (nonatomic, strong) XBHomeworkVoiceInfoModel *infoModel;

@end
