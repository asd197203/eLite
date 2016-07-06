//
//  XBPageController.m
//  Test05162047
//
//  Created by 常小哲 on 16/5/16.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "XBPageController.h"

@interface XBPageController ()<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate> {
    
    NSMutableArray *_viewControllers;
    NSInteger _currIndex;
    NSInteger _willIndex;
    NSInteger _dataSourceCount;
}

@property (nonatomic, strong) UIPageViewController *pageController;

@end

@implementation XBPageController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self instance];
}

- (void)instance {
    [self.view addSubview:self.pageController.view];
    
    _viewControllers = [NSMutableArray array];
    
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    
    UIScrollView *sc = (UIScrollView*)_pageController.view.subviews[0];
    [sc setScrollEnabled:scrollEnabled];
}

-(void)reloadData{
    [_viewControllers removeAllObjects];
    _dataSourceCount = 0;
    if ([_datasouce respondsToSelector:@selector(numberOfPageInSlidingController:)]) {
        _dataSourceCount = [_datasouce numberOfPageInSlidingController:self];
    }
    for (NSInteger i = 0 ; i < _dataSourceCount; i++) {
        if ([self.datasouce respondsToSelector:@selector(slidingController:controllerAtIndex:)]) {
            UIViewController *vc = [self.datasouce slidingController:self controllerAtIndex:i];
            [_viewControllers addObject:vc];
        }
    }

    [self.pageController setViewControllers:@[_viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [_viewControllers indexOfObject:viewController];
    if (!index) {
        return nil;
    }
    index --;
    
    return _viewControllers[index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [_viewControllers indexOfObject:viewController];
    if (index == _viewControllers.count - 1) {
        return nil;
    }
    index++;
    
    return _viewControllers[index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSInteger index = [_viewControllers indexOfObject:pendingViewControllers[0]];
    _willIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(completed){
        NSInteger index = [_viewControllers indexOfObject:previousViewControllers[0]];
        NSInteger nextIndex = 0;
        if (index > _willIndex) {
            nextIndex = index - 1;
        }else if (index < _willIndex){
            nextIndex = index + 1;
        }
        [self callBackWithIndex:nextIndex];
    }
}

-(void)callBackWithIndex:(NSInteger)index{
    _currIndex = index;
    if ([self.delegate respondsToSelector:@selector(slidingController:controllerAtIndex:)]) {
        [self.delegate slidingController:self selectedController:_viewControllers[index]];
    }

    if ([self.delegate respondsToSelector:@selector(slidingController:selectedIndex:)]) {
        [self.delegate slidingController:self selectedIndex:index];
    }
}

#pragma mark-   Setter & Getter

-(void)selectedIndex:(NSInteger)index {

    if (index > _dataSourceCount - 1) {
        return;
    }
    __weak XBPageController *weakSelf = self;
    if (_currIndex == 0) {
        [self.pageController setViewControllers:@[_viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }else if (_currIndex < index){
        [self.pageController setViewControllers:@[_viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }else{
        [self.pageController setViewControllers:@[_viewControllers[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }
    
}

- (UIPageViewController *)pageController {
    if (_pageController) {
        return _pageController;
    }
    
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageController.view.frame = self.view.bounds;
    _pageController.dataSource = self;
    _pageController.delegate   = self;
    
    return _pageController;
}

@end
