//
//  MXBasePhotoView.m
//  MXImageSelectView
//
//  Created by maxin on 16/4/27.
//  Copyright © 2016年 maxin. All rights reserved.
//

#import "MXBasePhotoView.h"

@implementation MXBasePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        _showImageView.center = CGPointMake(frame.size.width/2, self.frame.size.height/2);
        _showImageView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_showImageView];
        
        _deleBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleBt.frame = CGRectMake(frame.size.width-14, 0, 14, 14);
        [_deleBt setBackgroundColor:[UIColor redColor]];
        [_deleBt setTitle:@"—" forState:UIControlStateNormal];
        [_deleBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleBt addTarget:self action:@selector(delePhoto:) forControlEvents:UIControlEventTouchUpInside];
        _deleBt.layer.cornerRadius = _deleBt.frame.size.width/2;
        [self addSubview:_deleBt];
        
    }
    return self;
}

- (void)delePhoto:(UIButton *)button
{
    NSLog(@"delete button");
    if (_photoDelegate && [_photoDelegate respondsToSelector:@selector(clickDeleBtToDelePhotoWithView:)])
    {
        [_photoDelegate clickDeleBtToDelePhotoWithView:button.superview];
    }
}

- (void)setImageWidthAndHeight:(CGFloat)imageWidthAndHeight
{
    _imageWidthAndHeight = imageWidthAndHeight;
    CGRect frame = _showImageView.frame;
    frame.origin.x = (self.frame.size.width-imageWidthAndHeight)/2;
    frame.origin.y = (self.frame.size.height-imageWidthAndHeight)/2;
    frame.size = CGSizeMake(imageWidthAndHeight, imageWidthAndHeight);
    _showImageView.frame = frame;
}

- (void)setImageSpaces:(CGFloat)imageSpaces
{
    _imageSpaces = imageSpaces;
    CGRect frame = _showImageView.frame;
    frame.origin = CGPointMake(imageSpaces, imageSpaces);
    frame.size = CGSizeMake(self.frame.size.width-imageSpaces*2, self.frame.size.height-imageSpaces*2);
    _showImageView.frame = frame;
}

- (void)setButtonWidthAndHeight:(CGFloat)buttonWidthAndHeight
{
    _buttonWidthAndHeight = buttonWidthAndHeight;
    CGRect frame = _deleBt.frame;
    frame.origin.x = self.frame.size.width-buttonWidthAndHeight;
    frame.size = CGSizeMake(buttonWidthAndHeight, buttonWidthAndHeight);
    _deleBt.frame = frame;
    _deleBt.layer.cornerRadius = buttonWidthAndHeight/2;
}

@end
