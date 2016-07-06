//
//  XBTabBarController.m
//  JiBu
//
//  Created by 常小哲 on 16/4/7.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "XBTabBarController.h"
#import "XBTabBarModel.h"

@interface XBTabBarController ()

@end

@implementation XBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initSelf];
}

- (void)_initSelf {
    XBTabBarModel *model = [[XBTabBarModel alloc] init];
    self.viewControllers = model.controllers;
    self.tabBar.tintColor = [UIColor hexStringToColor:@"#2C97E8"];
}

@end
