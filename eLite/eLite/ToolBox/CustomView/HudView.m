//
//  HudView.m
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "HudView.h"
static NSInteger g_imgCount;
enum TYPE {PROCESS,TIP};
@interface HudView()
{
    
}
@property (strong,nonatomic) UIView * viewContent;
@property (strong,nonatomic) UIImageView * viewImg;
@property (strong,nonatomic) UILabel * lbTitle;
@property (strong,nonatomic) UIButton * btnClose;
@property (strong,nonatomic) void (^block)();
@property (assign,nonatomic) enum TYPE  type;
@end
@implementation HudView
-(instancetype)init
{
    if(self=[super init])
    {
        self.frame=[UIScreen mainScreen].bounds;
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        _viewContent=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        _viewContent.center=self.center;
        _viewContent.layer.masksToBounds=YES;
        _viewContent.layer.cornerRadius=10;
        [self addSubview:_viewContent];
        _viewContent.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.9];
        _viewImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 80, 80)];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:30];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @ "HudView" ofType :@ "bundle"];
        for(int i=1;i<=g_imgCount;i++)
        {
            NSString *path=[bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]];
            [arr addObject:[UIImage imageWithContentsOfFile:path]];
        }
        _viewImg.contentMode=UIViewContentModeScaleAspectFill;
        _viewImg.animationImages=arr;
        _viewImg.animationDuration=1.0;
        _viewImg.animationRepeatCount=-1;
        [_viewImg startAnimating];
        [_viewContent addSubview:_viewImg];
        _lbTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 110, 140, 30)];
        _lbTitle.textColor=[UIColor blackColor];
        _lbTitle.textAlignment=NSTextAlignmentCenter;
        _lbTitle.font=[UIFont boldSystemFontOfSize:16];
        [_viewContent addSubview:_lbTitle];
    }
    return  self;
}

-(void)close
{
    if(_block)
    {
        _block();
    }
    [HudView dismiss];
}

+(void)initialize
{
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @ "HudView" ofType :@ "bundle"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(int i=0;;i++)
    {
        NSString *path=[bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i+1]];
        if([fileManager fileExistsAtPath:path])
        {
            g_imgCount++;
        }
        else
        {
            break;
        }
    }
}

+(void)showHud:(NSString*)title CancelBlock:(void (^)())block
{
    UIView *win=[UIApplication sharedApplication].keyWindow;
    for(UIView *v in win.subviews)
    {
        if([v isKindOfClass:[HudView class]])
        {
            return;
        }
    }
    HudView *view=[[HudView alloc] init];
    view.lbTitle.text=title;
    view.block=block;
    view.type=PROCESS;
    view.viewImg.contentMode=UIViewContentModeScaleAspectFill;
}

+(void)dismiss
{
    UIView *win=[UIApplication sharedApplication].keyWindow;
    for(UIView *v in win.subviews)
    {
        if([v isKindOfClass:[HudView class]])
        {
            [UIView animateWithDuration:0.3 animations:^{
                v.alpha=0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
}

+(void)setTitle:(BOOL)bSuccess Title:(NSString *)title
{
    UIView *win=[UIApplication sharedApplication].keyWindow;
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @ "HudView" ofType :@ "bundle"];
    NSString *imagePath;
    if(bSuccess)
    {
        imagePath=[bundlePath stringByAppendingPathComponent:@"ok.png"];
    }
    else
    {
        imagePath=[bundlePath stringByAppendingPathComponent:@"wrong.png"];
    }
    for(UIView *v in win.subviews)
    {
        if([v isKindOfClass:[HudView class]])
        {
            HudView *view=(HudView*)v;
            view.type=TIP;
            [view.viewImg stopAnimating];
            view.viewImg.image=[UIImage imageWithContentsOfFile:imagePath];
            view.viewImg.contentMode=UIViewContentModeCenter;
            view.lbTitle.text=title;
            view.btnClose.hidden=YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    v.alpha=0;
                } completion:^(BOOL finished) {
                    [v removeFromSuperview];
                }];
            });
            return;
        }
    }
    HudView *view=[[HudView alloc] init];
    view.lbTitle.text=title;
    view.type=TIP;
    view.btnClose.hidden=YES;
    [view.viewImg stopAnimating];
    view.viewImg.image=[UIImage imageWithContentsOfFile:imagePath];
    view.viewImg.contentMode=UIViewContentModeCenter;
    view.alpha=0;
    CGRect frame=view.viewContent.frame;
    view.viewContent.frame=CGRectMake(view.center.x, view.center.y, 0, 0);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        view.alpha=1;
        view.viewContent.frame=frame;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha=0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        });
    }];
}

+(void)setTitle:(NSString *)title
{
    UIView *win=[UIApplication sharedApplication].keyWindow;
    for(UIView *v in win.subviews)
    {
        if([v isKindOfClass:[HudView class]])
        {
            HudView *view=(HudView*)v;
            if(view.type==PROCESS)
            {
                view.viewImg.contentMode=UIViewContentModeCenter;
                view.lbTitle.text=title;
            }
            return;
        }
    }
}

@end

