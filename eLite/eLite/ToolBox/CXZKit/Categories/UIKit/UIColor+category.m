//
//  UIColor+category.m
//  eLite
//
//  Created by lxx on 16/4/19.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "UIColor+category.h"

@implementation UIColor (category)
+ (UIColor *)getColorByHex:(NSString *) strHex
{
    if([strHex length] !=7 )
        strHex = @"#888888";
    
    NSRange rang;
    rang.location=1;
    rang.length=2;
    NSString *rStr=[strHex substringWithRange:rang];
    rang.location=3;
    NSString *gStr=[strHex substringWithRange:rang];
    rang.location=5;
    NSString *bStr=[strHex substringWithRange:rang];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rStr] scanHexInt:&r];
    [[NSScanner scannerWithString:gStr] scanHexInt:&g];
    [[NSScanner scannerWithString:bStr] scanHexInt:&b];
    return [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:1];
}
@end
