//
//  XBCellRightView.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBCellRightView.h"

@interface XBCellRightView () {
    UIImageView *_arrow;
    UIImageView *_imageView;
    UILabel *_titleLabel;
}
@end

@implementation XBCellRightView

+ (instancetype)defaultView {
    return [[self alloc] initWithFrame:(CGRect){CGPointZero, 7, 14}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.arrow];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.arrow];
        [self addSubview:self.titleLabel];
        _titleLabel.text = title;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.arrow];
        [self addSubview:self.imageView];
        _imageView.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSURL *)url {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.arrow];
        [self addSubview:self.imageView];
        [_imageView sd_setImageWithURL:url];
    }
    return self;
}

- (UIImageView *)arrow {
    SafeRun_Return(_arrow);
    _arrow = [[UIImageView alloc] initWithImage:Image_Named(@"myself_setting_arrow")];
    _arrow.frame = CGRectMake(self.right - 7,
                             (self.height - 14) / 2,
                             7,
                             14);
    return _arrow;
}

- (UIImageView *)imageView {
    SafeRun_Return(_imageView);
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.right - self.height - 7, 5, self.height - 10, self.height - 10)];
    _imageView.cornerRadius = 5.0f;
    return _imageView;
}

- (UILabel *)titleLabel {
    SafeRun_Return(_titleLabel);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - 20) / 2, self.width - 7 - 10, 20)];
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.font = Font_System(14.0f);
    _titleLabel.textColor = [UIColor grayColor];
    return _titleLabel;
}

@end
