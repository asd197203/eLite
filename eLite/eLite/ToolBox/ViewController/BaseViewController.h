//
//  BaseViewController.h
//  Study
//
//  Created by lxx on 16/3/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void)onBack;
-(void)hideBackButton;
@property(nonatomic,assign,readonly)BOOL isFirstAppear;
@property(nonatomic,assign) BOOL bHud;
@property(nonatomic,assign) BOOL bAutoHiddenBar;
@property(weak,nonatomic)   UIScrollView *viewScrollAutoHidden;
@property(nonatomic,assign) BOOL  bHideNavigationBottomLine;
@property(nonatomic,assign) BOOL  bInteractive;
@end
