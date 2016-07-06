//
//  UIViewController+category.m
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "UIViewController+category.h"
#import <objc/runtime.h>
#import "UIView+EasyShow.h"
static const char g_charModalVC;
@implementation UIViewController (category)
-(UIViewController*)pushViewController:(NSString *)ToView Param:(NSDictionary*)param
{
    Class cls = NSClassFromString(ToView);
    id viewController = [[[cls class] alloc]init];
    if (!param) {
        for (NSString*key in param) {
            id obj = param[key];
            [viewController setValue:obj forKey:key];
        }
    }
     ((UIViewController*)viewController).hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    return  viewController;
}
-(UIViewController*)presentViewController:(NSString *)ToView Param:(NSDictionary*)param
{
    Class cls = NSClassFromString(ToView);
    id viewController = [[[cls class]alloc]init];
    if(!param)
    {
        for (NSString*key in param) {
            id obj =param[key];
             [viewController setValue:obj forKey:key];
        }
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
    return viewController;
}
-(void)dismiss;
{
    UIImage *img= [[UIApplication sharedApplication].keyWindow imageCache];
    UIImageView *view=[[UIImageView alloc] initWithImage:img];
    view.frame=[UIScreen mainScreen].bounds;
    view.layer.zPosition=FLT_MAX;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        view.alpha=0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}
-(void)flipToView:(UIView*)view;
{
    UIImage *img=[[UIApplication sharedApplication].keyWindow imageCache];
    UIImageView *v=[[UIImageView alloc] initWithImage:img];
    v.frame=[UIScreen mainScreen].bounds;
    v.layer.zPosition=FLT_MAX;
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    [UIView transitionFromView:v toView:view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
}
-(void)setModalVC:(UIViewController *)modalVC
{
    objc_setAssociatedObject(self, &g_charModalVC, modalVC, OBJC_ASSOCIATION_ASSIGN);
}

-(UIViewController*)modalVC
{
    return  objc_getAssociatedObject(self, &g_charModalVC);
}
@end
