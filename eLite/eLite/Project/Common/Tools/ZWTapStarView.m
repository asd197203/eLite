//
//  ZWTapStarView.m
//  HorseRiding
//
//  Created by 联合创想 on 16/3/1.
//  Copyright © 2016年 LHCX. All rights reserved.
//

#import "ZWTapStarView.h"

@interface ZWTapStarView ()
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@end

@implementation ZWTapStarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)setup
{
    self.starBackgroundView = [self configStarViewWithImageName:@"star_gray.png"];
    self.starForegroundView = [self configStarViewWithImageName:@"star_orange.png"];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

- (UIView *)configStarViewWithImageName:(NSString *)iconName
{
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    for (int i = 0; i<5; i++) {
        UIImageView * starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        starImage.frame = CGRectMake(i*self.frame.size.width/5, 0, self.frame.size.width/5, self.frame.size.height);
        [view addSubview:starImage];
    }
    return view;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (CGRectContainsPoint(rect, point)) {
        [self changeStarStatusWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [UIView transitionWithView:self.starForegroundView duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf changeStarStatusWithPoint:point];
    } completion:^(BOOL finished) {
    }];
}

- (void)changeStarStatusWithPoint:(CGPoint)point
{
    CGPoint newPoint = point;
    if (newPoint.x<0) {
        newPoint.x = 0;
    }
    if (newPoint.x>self.frame.size.width) {
        newPoint.x = self.frame.size.width;
    }
    NSString * pointStr = [NSString stringWithFormat:@"%.2f",newPoint.x/self.frame.size.width];
    float score = [pointStr floatValue];
    
    float starScore = score *5;
    NSInteger starValue ;
    if (starScore <= starScore < starScore+1) {
        starValue = (NSInteger)starScore+1;
    }
    
    
    
    newPoint.x = (starValue*self.frame.size.width)/5;
    self.starForegroundView.frame = CGRectMake(0, 0, newPoint.x, self.frame.size.height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(starRatingView:score:)]) {
        [self.delegate starRatingView:self score:score];
    }
}


@end
