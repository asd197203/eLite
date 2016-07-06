//
//  XBShowViewOnce.m
//  eLite
//
//  Created by lxx on 16/4/27.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBShowViewOnce.h"
#import "MBProgressHUD.h"
@implementation XBShowViewOnce
+ (void)toast:(NSString *)text duration:(NSTimeInterval)duration inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText=text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:duration];
}

+(void)showHUDText:(NSString*)text inVeiw:(UIView*)view{
    [self toast:text duration:2 inView:view];
}
@end
