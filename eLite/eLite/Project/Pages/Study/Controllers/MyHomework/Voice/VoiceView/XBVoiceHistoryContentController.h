//
//  XBVoiceHistoryContentController.h
//  eLite
//
//  Created by 常小哲 on 16/5/25.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBVoiceHistoryController;

@interface XBVoiceHistoryContentController : UIViewController

@property (nonatomic, weak) XBVoiceHistoryController *parentController;
@property (nonatomic, strong) XBHomeworkHistoryItemInfoModel *infoModel;

@end
