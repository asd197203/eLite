//
//  XBNavigationViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/18.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBNavigationViewController.h"

@interface XBNavigationViewController ()<
UIGestureRecognizerDelegate,
UINavigationControllerDelegate>

@end

@implementation XBNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak XBNavigationViewController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    if (self.viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = YES;

    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
     if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

@end
