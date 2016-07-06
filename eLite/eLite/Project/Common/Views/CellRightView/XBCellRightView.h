//
//  XBCellRightView.h
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBCellRightView : UIView

+ (instancetype)defaultView;
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image;
- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSURL *)url;

@end
