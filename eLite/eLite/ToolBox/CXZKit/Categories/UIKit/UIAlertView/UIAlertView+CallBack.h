//
//  UIAlertView+CallBack.h
//  MyAlertView
//
//  Created by RPIOS on 15/7/28.
//  Copyright (c) 2015年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickButtonIndexBlock)(NSInteger index);

@interface UIAlertView (CallBack)

@property (nonatomic, copy) ClickButtonIndexBlock clickButotn; /**< 点击按钮回调 */

@end
