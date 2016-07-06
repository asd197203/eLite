//
//  XBHomeworkPageModel.m
//  eLite
//
//  Created by 常小哲 on 16/4/15.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHomeworkPageModel.h"
#import "XBWordSubjectController.h"
#import "XBVoiceController.h"
#import "XBVideoSubjectViewController.h"

@interface XBHomeworkPageModel () {
    NSArray *_classes;
}
@end

@implementation XBHomeworkPageModel

@synthesize controllers = _controllers;
@synthesize cellInfo = _cellInfo;

- (NSArray *)controllers {
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray new];
        for (int i = 0; i < self.cellInfo.count; i ++) {
            UIViewController *controller = [[self.classes[i] alloc] init];
            controller.title = @"";
            [controllers addObject:controller];
        }
        
        _controllers = controllers.copy;
    }
    return _controllers;
}

- (NSArray *)classes {
    if (!_classes) {
        _classes = @[
                     [XBWordSubjectController class],
                     [XBVoiceController class],
                     [XBVideoSubjectViewController class]
                     ];
    }
    return _classes;
}

- (NSArray *)cellInfo {
    if (!_cellInfo) {
        _cellInfo = @[
                      @[@"文字题型", @"homework_subject_word"],
                      @[@"语音题型", @"homework_subject_voice"],
                      @[@"视频题型", @"homework_subject_video"],
                      ];
    }
    return _cellInfo;
}

@end
