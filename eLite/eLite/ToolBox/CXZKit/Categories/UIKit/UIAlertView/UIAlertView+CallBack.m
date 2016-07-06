//
//  UIAlertView+CallBack.m
//  MyAlertView
//
//  Created by RPIOS on 15/7/28.
//  Copyright (c) 2015年 Ranger. All rights reserved.
//

#import "UIAlertView+CallBack.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


static void *CXZAlertViewKey = @"CXZAlertViewKey";

@interface UIAlertView ()<UIAlertViewDelegate>
@end

@implementation UIAlertView (CallBack)

@dynamic clickButotn;

- (ClickButtonIndexBlock)clickButotn{
    return objc_getAssociatedObject(self, CXZAlertViewKey);
}

- (void)setClickButotn:(ClickButtonIndexBlock)clickButotn{
    self.delegate = self;
    objc_setAssociatedObject(self, CXZAlertViewKey, clickButotn, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.clickButotn) {
        self.clickButotn(buttonIndex);
    }
//    self.clickButotn = nil;  是否需要这样 我没试呢
}

@end

#pragma clang diagnostic pop
