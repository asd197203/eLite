//
//  XBStudyPageModel.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBStudyPageModel.h"
#import "XBRecommendViewController.h"
#import "XBHomeworkViewController.h"
#import "XBEvaluationViewController.h"

@interface XBStudyPageModel () {
    NSArray *_classes;
}
@end

@implementation XBStudyPageModel

@synthesize controllers = _controllers;
@synthesize titles = _titles;
@synthesize images = _images;


- (NSArray *)controllers {
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIViewController *controller = [[self.classes[i] alloc] init];
            controller.title = _titles[i];
            controller.hidesBottomBarWhenPushed = YES;
            [controllers addObject:controller];
        }
        
        _controllers = controllers.copy;
    }
    return _controllers;
}

- (NSArray *)classes {
    if (!_classes) {
        _classes = @[
                     [XBRecommendViewController class],
                     [XBHomeworkViewController class],
                     [XBEvaluationViewController class]
                     ];
    }
    return _classes;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"学霸推荐",
                    @"我的作业",
                    @"教师评估"
                    ];
    }
    return _titles;
}

- (NSArray *)images {
    SafeRun_Return(_images);
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < _titles.count; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"study_cell_head_%d", i]];
        [images addObject:img];
    }
    _images = images.copy;
    return _images;
}


@end
