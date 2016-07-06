//
//  HudView.h
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//
#import <UIKit/UIKit.h>
#define E(msg) [HudView setTitle:NO Title:msg]
#define S(msg) [HudView setTitle:YES Title:msg]
@interface HudView : UIView
+(void)showHud:(NSString*)title CancelBlock:(void (^)())block;
+(void)setTitle:(BOOL)bSuccess Title:(NSString *)title;
+(void)setTitle:(NSString *)title;
+(void)dismiss;
@end
