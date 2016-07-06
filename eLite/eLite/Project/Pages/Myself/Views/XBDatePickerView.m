//
//  XBDatePickerView.m
//  Test0421
//
//  Created by 常小哲 on 16/4/21.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "XBDatePickerView.h"

@interface XBDatePickerView ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation XBDatePickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        CGRect rect = self.frame;
        rect.origin.y = self.frame.size.height;
        self.frame = rect;
    }
    return self;
}

- (void)flyUp {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, -self.frame.size.height);
    }
                     completion:nil];
    
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
                     completion:nil];
}

- (IBAction)cancel:(id)sender {
    self.topView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformTranslate(self.transform, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)done:(id)sender {
    if (_block) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *date = [formatter stringFromDate:self.datePicker.date];
        _block(date);
    }
    [self cancel:nil];
}
- (IBAction)tap:(id)sender {

    [self cancel:nil];
}

- (IBAction)datePickerChanged:(id)sender {
    
}

@end
