//
//  XBDatePickerView.h
//  Test0421
//
//  Created by 常小哲 on 16/4/21.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickerViewBlock)(NSString *);

@interface XBDatePickerView : UIView

@property (nonatomic, copy) DatePickerViewBlock block;

- (void)flyUp;

@end
