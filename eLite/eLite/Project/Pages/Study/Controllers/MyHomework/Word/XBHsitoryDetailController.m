//
//  XBHsitoryDetailController.m
//  eLite
//
//  Created by 常小哲 on 16/5/25.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHsitoryDetailController.h"
#import "XBHistoryDetailContentViewController.h"

@interface XBHsitoryDetailController ()<
XBPageControllerDelegate,
XBPageControllerDataSource> {
    
    NSArray *_titles;
    NSArray *_controllers;

}
@end

@implementation XBHsitoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White;
    self.scrollEnabled = YES;
    [self __init];
}

- (void)__init {
    
    self.datasouce = self;
    self.delegate = self;
    NSMutableArray *vcArr = [NSMutableArray new];
    NSMutableArray *titleArr = [NSMutableArray new];

    for (int i = 0; i < _subjects.count; i ++) {
        XBHistoryDetailContentViewController *vc = [XBHistoryDetailContentViewController new];
        vc.parentController = self;
        vc.infoModel = _subjects[i];
        [self addChildViewController:vc];
        [vcArr addObject:vc];
        
        NSString *title = [NSString stringWithFormat:@"%d/%ld", i+1, _subjects.count];
        vc.title = title;
        [titleArr addObject:title];
    }

    _titles      = titleArr.copy;
    _controllers = vcArr.copy;
    
    self.title = _titles[0];
    [self reloadData];
}


#pragma mark dataSouce
- (NSInteger)numberOfPageInSlidingController:(XBPageController *)slidingController{
    return _titles.count;
}
- (UIViewController *)slidingController:(XBPageController *)slidingController controllerAtIndex:(NSInteger)index{
    return _controllers[index];
}

#pragma mark delegate
- (void)slidingController:(XBPageController *)slidingController selectedIndex:(NSInteger)index{
    // presentIndex
    NSLog(@"%ld",index);
    self.title = _titles[index];
}

- (void)slidingController:(XBPageController *)slidingController selectedController:(UIViewController *)controller {
    
}

-(void)dealloc{
    NSLog(@"!dealloc!");
}

@end
