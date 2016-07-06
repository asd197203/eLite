//
//  XBWordSubjectContentController.h
//  eLite
//
//  Created by 常小哲 on 16/4/15.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBWordSubjectController;

@interface XBWordSubjectContentController : UIViewController

@property (nonatomic, weak) XBWordSubjectController *parentController;

@property (nonatomic, strong) XBHomeworkWordInfoModel *infoModel;

@end
