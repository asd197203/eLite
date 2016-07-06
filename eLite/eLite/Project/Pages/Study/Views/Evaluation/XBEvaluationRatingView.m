//
//  XBEvaluationRatingView.m
//  eLite
//
//  Created by 常小哲 on 16/4/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBEvaluationRatingView.h"

@interface XBEvaluationRatingView () {
    UIView *_grayView; // 灰色星星视图
    UIView *_yellowView; // 金色星星视图

}

@end

@implementation XBEvaluationRatingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self _initRatingView:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self _initRatingView:self.frame];
    }
    return self;
}

- (void)_initRatingView:(CGRect)frame
{
    self.backgroundColor = Color_Clear;
    UIImage *grayImage = Image_Named(@"evaluation_gray_star");
    UIImage *yellowImage = Image_Named(@"evaluation_yellow_star");
    
    CGFloat imageWidth = grayImage.size.width;
    CGFloat imageHeight = grayImage.size.height;
    
    //1、创建灰色星星视图
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, imageWidth * 5, imageHeight)];
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImage];
    
    [self addSubview:_grayView];
    
    //2、创建金色星星视图
    _yellowView = [[UIView alloc] initWithFrame:_grayView.bounds];
    _yellowView.backgroundColor = [UIColor colorWithPatternImage:yellowImage];
    [self addSubview:_yellowView];
    
    //4.设置视图的坐标
    self.frame = _grayView.frame;
    
    _grayView.frame = CGRectMake(0, 0, self.width, self.height);
    _yellowView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)setRating:(CGFloat)rating {
    _rating = rating;
    
    _yellowView.frame = CGRectMake(0, 0, self.width* _rating / 5.0, self.height);
    
}

@end
