//
//  XBMyselfPageModel.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBMyselfPageModel.h"
#import "XBSettingViewController.h"
#import "XBHelperAndFeedBackVC.h"
#import "XBPersonalViewController.h"

@interface XBMyselfPageModel () {
    NSArray *_classes;
}

@end

@implementation XBMyselfPageModel

@synthesize controllers = _controllers;
@synthesize titles = _titles;
@synthesize images = _images;

- (NSArray *)controllers {
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIViewController *controller;
            if (i == 0) {
                controller = [[self.classes[i] alloc] init];
                controller.title = _titles[i];
                controller.hidesBottomBarWhenPushed = YES;
                [controllers addObject:controller];
            }else {
                NSMutableArray *subArray = [NSMutableArray new];
                NSArray *subClasses = self.classes[i];
                for (int j = 0; j < subClasses.count; j ++) {
                    controller = [[subClasses[j] alloc] init];
                    controller.title = _titles[i][j];
                    controller.hidesBottomBarWhenPushed = YES;
                    [subArray addObject:controller];
                }
                [controllers addObject:subArray];
            }
        }
        
        _controllers = controllers.copy;
    }
    return _controllers;
}

- (NSArray *)classes {
    if (!_classes) {
        _classes = @[
                     [XBPersonalViewController class],
                     @[
                       [XBSettingViewController class],
                       [XBHelperAndFeedBackVC class]
                       ],
                     ];
    }
    return _classes;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"我的资料",
                    @[
                      @"设置",
                      @"帮助"
                      ]
                    ];
    }
    return _titles;
}

- (NSArray *)images {
    SafeRun_Return(_images);
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < [self.titles.lastObject count]; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"myself_cell_head_%d", i]];
        [images addObject:img];
    }
    _images = images.copy;
    return _images;
}

@end
