//
//  UIViewController+category.h
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (category)
-(UIViewController*)pushViewController:(NSString *)ToView Param:(NSDictionary*)param;
-(UIViewController*)presentViewController:(NSString *)ToView Param:(NSDictionary*)param;
-(void)dismiss;
-(void)flipToView:(UIView*)view;
@property (weak,nonatomic) UIViewController* modalVC;
@end
