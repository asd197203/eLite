//
//  XBTabBarModel.m
//  JiBu
//
//  Created by 常小哲 on 16/4/7.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "XBTabBarModel.h"
#import "XBMessageViewController.h"
#import "XBContactViewController.h"
#import "XBStudyViewController.h"
#import "XBMyselfViewController.h"
#import "CDFriendListVC.h"
static const NSInteger TabBarItemsNumber = 4;

@interface XBTabBarModel () {
    NSArray *_classes;
    NSArray *_titles;
    NSArray *_selectedImages;
    NSArray *_unselectedImages;
}

@end

@implementation XBTabBarModel

@synthesize controllers = _controllers;

- (NSArray *)controllers {
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIViewController *controller = [[self.classes[i] alloc] init];
            controller.title = _titles[i];
            
            UIImage *image = [self.unselectedImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectedImage = [self.selectedImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

            controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:_titles[i]
                                                                  image:image
                                                          selectedImage:selectedImage];
    
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            
            [controllers addObject:nav];
        }

        _controllers = controllers.copy;
    }
    return _controllers;
}

- (NSArray *)classes {
    if (!_classes) {
        _classes = @[
                     [CDConvsVC class],
                     [CDFriendListVC class],
                     [XBStudyViewController class],
                     [XBMyselfViewController class]
                     ];
    }
    return _classes;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"消息",
                    @"联系人",
                    @"学吧",
                    @"我的"
                    ];
    }
    return _titles;
}

- (NSArray *)selectedImages {
    if (!_selectedImages) {
        NSMutableArray *selectedImages = [NSMutableArray new];
        for (int i = 0; i < TabBarItemsNumber; i ++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_selected_%d", i]];
            [selectedImages addObject:img];
        }
        _selectedImages = selectedImages.copy;
    }
    return _selectedImages;
}

- (NSArray *)unselectedImages {
    if (!_unselectedImages) {
        NSMutableArray *unselectedImages = [NSMutableArray new];
        for (int i = 0; i < TabBarItemsNumber; i ++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_unselected_%d", i]];
            [unselectedImages addObject:img];
        }
        _unselectedImages = unselectedImages.copy;
    }
    return _unselectedImages;
}

@end
