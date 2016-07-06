//
//  Util.h
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Util : NSObject
+ (UIViewController*)topViewController;
+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
//获取字符窜大小
+(CGSize)getSizeWithText:(NSString*)text fontSize:(int)fontSize;
+(CGSize)getSizeWithText:(NSString*)text font:(UIFont*)font;
+(CGSize)getSizeWithText:(NSString*)text boldfontSize:(int)fontSize;
+(CGSize)sizeWithString:(NSString*) string  font:(UIFont*)font size:(CGSize)size;
+(CGSize)sizeWithString:(NSString*) string  attribute:(NSDictionary*)attribute size:(CGSize)size;
@end
