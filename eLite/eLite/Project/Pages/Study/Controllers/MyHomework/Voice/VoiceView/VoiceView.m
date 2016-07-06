//
//  VoiceView.m
//  RunMan-User
//
//  Created by 孙昕 on 15/5/22.
//  Copyright (c) 2015年 孙昕. All rights reserved.
//

#import "VoiceView.h"
#import <POP.h>
@interface VoiceView()
{
    UIImageView *imgView;
    UILabel *lbText;
    CGRect viewFrame;
}
@end
@implementation VoiceView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        viewFrame=frame;
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 120)];
        imgView.center=self.center;
        imgView.contentMode=UIViewContentModeCenter;
        imgView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imgView.image=[UIImage imageNamed:@"record_animate_01"];
        [self addSubview:imgView];
        lbText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
        lbText.numberOfLines=2;
        lbText.textAlignment=NSTextAlignmentCenter;
        lbText.center=imgView.center;
        CGRect frame=lbText.frame;
        frame.origin.y=imgView.frame.origin.y+60;
        lbText.frame=frame;
        lbText.textColor=[UIColor whiteColor];
        lbText.text=@"上滑取消录音(最长可录60秒)";
        lbText.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:lbText];
    }
    return self;
}

-(void)setVoiceImage:(NSString*)image
{
    imgView.image=[UIImage imageNamed:image];
}

-(void)showInView:(UIView*)view
{
	imgView.image=[UIImage imageNamed:@"record_animate_01"];
    self.frame=CGRectMake(viewFrame.origin.x+viewFrame.size.width/2, viewFrame.origin.y+viewFrame.size.height/2, 0, 0);
    [view addSubview:self];
    POPBasicAnimation *ani=[POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    ani.toValue=[NSValue valueWithCGRect:viewFrame];
    ani.duration=0.3;
    [self pop_addAnimation:ani forKey:@"show"];
}

-(void)remove
{
    POPBasicAnimation *ani=[POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    ani.toValue=[NSValue valueWithCGRect:CGRectMake(viewFrame.origin.x+viewFrame.size.width/2, viewFrame.origin.y+viewFrame.size.height/2, 0, 0)];
    ani.duration=0.3;
    [ani setCompletionBlock:^(POPAnimation *ani, BOOL bFinish) {
        [self removeFromSuperview];
    }];
    [self pop_addAnimation:ani forKey:@"hide"];
}

@end









