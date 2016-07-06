//
//  AppDelegate.h
//  eLite
//
//  Created by lxx on 16/4/11.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
- (void)toMain;
- (void)toLogin;
- (void)mainController;
- (void)loginController;
@end

