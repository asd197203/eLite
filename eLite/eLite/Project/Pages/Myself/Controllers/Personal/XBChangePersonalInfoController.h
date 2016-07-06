//
//  XBChangePersonalInfoController.h
//  eLite
//
//  Created by 常小哲 on 16/4/21.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ControllerStyle) {
    ControllerStyle_avatar = 0,
    ControllerStyle_edit
};

@interface XBChangePersonalInfoController : UIViewController

- (instancetype)initWithStyle:(ControllerStyle)style;

- (instancetype)initWithPhotoURL:(NSString *)urlStr;

@end
