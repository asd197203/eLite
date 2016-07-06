//
//  XBSettingPageModel.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBSettingPageModel.h"
#import "XBAccountSafeViewController.h"
#import "XBNewMessageViewController.h"
#import "XBCommonSettingViewController.h"
#import "XBAboutUsViewController.h"
#import "XBAccounChangePswVC.h"
@interface XBSettingPageModel () {
    NSArray *_classes;
}
@end

@implementation XBSettingPageModel

@synthesize controllers = _controllers;
@synthesize titles = _titles;

- (NSArray *)controllers {
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIViewController *controller;
            if (i == 1) {
                NSMutableArray *subArray = [NSMutableArray new];
                NSArray *subClasses = self.classes[i];
                for (int j = 0; j < subClasses.count; j ++) {
                    controller = [[subClasses[j] alloc] init];
                    controller.title = self.titles[i][j];
                    [subArray addObject:controller];
                }
                [controllers addObject:subArray];
            }else {
                controller = [[self.classes[i] alloc] init];
                controller.title = _titles[i];
                [controllers addObject:controller];
            }
        }
        
        _controllers = controllers.copy;
    }
    return _controllers;
}

- (NSArray *)classes {
    if (!_classes) {
        _classes = @[
                     [XBAccounChangePswVC class],
                     @[
//                       [XBNewMessageViewController class],
                       [XBCommonSettingViewController class]
                       ],
                     [XBAboutUsViewController class]
                     ];
    }
    return _classes;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"帐号与安全",
                    @[
//                      @"新消息通知",
                      @"通用"
                      ],
                    @"关于ELITE",
                    ];
    }
    return _titles;
}

@end
