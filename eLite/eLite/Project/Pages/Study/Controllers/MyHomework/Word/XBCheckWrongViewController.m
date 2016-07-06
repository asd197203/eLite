//
//  XBCheckWrongViewController.m
//  eLite
//
//  Created by 常小哲 on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBCheckWrongViewController.h"
#import "XBCheckWrongContentViewController.h"

@interface XBCheckWrongViewController ()<
XBPageControllerDelegate,
XBPageControllerDataSource> {
    
    NSArray *_titles;
    NSArray *_controllers;
    NSArray *_allData;
    
}


@end

@implementation XBCheckWrongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    [self __init];
}

- (void)__init {
    
    self.datasouce = self;
    self.delegate = self;
    
    NSMutableArray *vcArr = [NSMutableArray new];
    NSMutableArray *titleArr = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;

    [_wrongSubjectDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, XBHomeworkWordInfoModel *obj, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        XBCheckWrongContentViewController *vc = [XBCheckWrongContentViewController new];
        vc.parentController = strongSelf;
        vc.infoModel = obj;
        vc.resultDict = strongSelf.myWorkResults[[[_wrongSubjectDict allKeys] indexOfObject:key]];
        [strongSelf addChildViewController:vc];
        [vcArr addObject:vc];
        vc.title = key;
        [titleArr addObject:key];
    }];
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
