//
//  XBPageController.h
//  Test05162047
//
//  Created by 常小哲 on 16/5/16.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBPageControllerDataSource;
@protocol XBPageControllerDelegate;

@interface XBPageController : UIViewController

@property (nonatomic, assign)id<XBPageControllerDataSource> datasouce;
@property (nonatomic, assign)id<XBPageControllerDelegate> delegate;
@property (nonatomic, assign) BOOL scrollEnabled;  // default YES

- (void)reloadData;
- (void)selectedIndex:(NSInteger)index;

@end

@protocol XBPageControllerDataSource <NSObject>
@required

- (NSInteger)numberOfPageInSlidingController:(XBPageController *)slidingController;

- (UIViewController *)slidingController:(XBPageController *)slidingController controllerAtIndex:(NSInteger)index;

@optional

@end

@protocol XBPageControllerDelegate <NSObject>
@optional

- (void)slidingController:(XBPageController *)slidingController selectedIndex:(NSInteger)index;

- (void)slidingController:(XBPageController *)slidingController selectedController:(UIViewController *)controller;

@end
