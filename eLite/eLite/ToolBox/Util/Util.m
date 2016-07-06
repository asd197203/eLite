//
//  Util.m
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "Util.h"

@implementation Util
+ (UIViewController*)topViewController {
    return [Util topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [Util topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [Util topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [Util topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
//获取字符串的size
+(CGSize)getSizeWithText:(NSString*)text fontSize:(int)fontSize
{
    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    return size;
}

//获取字符串的size
+(CGSize)getSizeWithText:(NSString*)text font:(UIFont*)font
{
    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: font}];
    return size;
}

+(CGSize)getSizeWithText:(NSString*)text boldfontSize:(int)fontSize
{
    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]}];
    return size;
}
//获取字符窜大小
+(CGSize)sizeWithString:(NSString*) string  font:(UIFont*)font size:(CGSize)size
{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    
    NSDictionary *attribute = @{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize textSize = [string boundingRectWithSize:size
                                           options:\
                       NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    return textSize;
}

//获取字符窜大小
+(CGSize)sizeWithString:(NSString*) string  attribute:(NSDictionary*)attribute size:(CGSize)size
{
    CGSize textSize = [string boundingRectWithSize:size
                                           options:\
                       NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    return textSize;
}

@end
