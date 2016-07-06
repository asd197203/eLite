//
//  BaseViewController.m
//  Study
//
//  Created by lxx on 16/3/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+category.h"
#import <POP.h>
#import <AFNetworking.h>
#import "Util.h"
static UIImageView *g_navBarHairlineImageView;
static __weak UINavigationController *g_nav;
static NSMutableArray *g_arrImgHud;
static NSString *g_backImg;
@interface BaseViewController ()
{
    UIImageView *imageView;
    CGFloat curScrollViewPos;
    CGRect rectNavBar;
    CGFloat oriTop;
    CGFloat oriBottom;
    NSInteger isApperCount;
    BOOL  bTabShow;
    BOOL  bHiddenBackButton;
    UILabel *titleLabel;
    UIScreenEdgePanGestureRecognizer*edgePanGesture;
    UIPercentDrivenInteractiveTransition *inter;
     __weak UINavigationController *nav;
}
@property (assign,readwrite,nonatomic) BOOL bFirstAppear;
@end

@implementation BaseViewController
+(void)load
{
    g_arrImgHud = [NSMutableArray array];
    NSString *hudImagePath = [[NSBundle mainBundle]pathForResource:@"" ofType:@""];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i=1;; i++) {
        NSString *path = [hudImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]];
        if ([fileManager fileExistsAtPath:path])
        {
            [g_arrImgHud addObject:[UIImage imageNamed:path]];
        }
        else
        {
            return;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isApperCount = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    bHiddenBackButton = NO;
    _bHud = YES;
    _bAutoHiddenBar = NO;
    _isFirstAppear = YES;
    if (self.hidesBottomBarWhenPushed ==YES)
    {
        bTabShow = NO;
    }
    else
    {
       bTabShow = YES;
    }
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
}
-(void)setTitle:(NSString *)title
{
    self.title = titleLabel.text;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    if (_bInteractive&&edgePanGesture!=nil) {
        edgePanGesture=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRec:)];
        edgePanGesture.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:edgePanGesture];
    }
    else if(!_bInteractive && edgePanGesture!=nil)
    {
        [self.view removeGestureRecognizer:edgePanGesture];
        edgePanGesture=nil;
    }
    [super viewDidAppear:animated];
}
-(void)handleRec:(UIScreenEdgePanGestureRecognizer*)GestureRecognizer
{
    nav =[self navigationController];
    CGFloat progress = [GestureRecognizer translationInView:[UIApplication sharedApplication].keyWindow].x / (GestureRecognizer.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (GestureRecognizer.state == UIGestureRecognizerStateBegan) {
        inter = [[UIPercentDrivenInteractiveTransition alloc] init];
        UIViewController *vc=[Util topViewController];
        if(vc.modalVC!=nil)
        {
            [vc.modalVC dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [nav popViewControllerAnimated:YES];
        }
    }
    else if (GestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [inter updateInteractiveTransition:progress];
    }
    else if (GestureRecognizer.state == UIGestureRecognizerStateEnded || GestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.5) {
            [inter finishInteractiveTransition];
        }
        else {
            [inter cancelInteractiveTransition];
        }
        inter = nil;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    if (g_nav != self.navigationController) {
        g_navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        g_nav=self.navigationController;
    }
    [self setNavigationBottomLine:self.bHideNavigationBottomLine];
    
    isApperCount++;
    if(isApperCount==2)
    {
        _bFirstAppear=NO;
    }
    if(!bHiddenBackButton)
    {
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:g_backImg] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
        });
    }
    if(_bAutoHiddenBar && _bFirstAppear && _viewScrollAutoHidden)
    {
        rectNavBar=self.navigationController.navigationBar.frame;
        NSInteger i=0;
        for(NSLayoutConstraint *con in self.view.constraints)
        {
            if(con.firstAttribute==NSLayoutAttributeTop)
            {
                oriTop=con.constant;
                i++;
            }
            else if(con.firstAttribute==NSLayoutAttributeBottom)
            {
                oriBottom=con.constant;
                i++;
            }
            if(i==2)
            {
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoHiddenAction) name:@"scrollViewDidScroll" object:nil];
    }
    if(!_bHud)
    {
        return;
    }
    if(imageView==nil)
    {
        imageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageView.userInteractionEnabled=YES;
        imageView.backgroundColor=[UIColor whiteColor];
        imageView.contentMode=UIViewContentModeCenter;
        imageView.layer.zPosition=MAXFLOAT;
        imageView.animationImages=g_arrImgHud;
        imageView.animationDuration=1.0;
        imageView.animationRepeatCount=-1;
    }
    imageView.alpha=1;
    [self.view addSubview:imageView];
    [imageView startAnimating];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self removeHud];
    if(_bAutoHiddenBar && _viewScrollAutoHidden)
    {
        NSInteger i=0;
        for(NSLayoutConstraint *con in self.view.constraints)
        {
            if(con.firstAttribute==NSLayoutAttributeTop)
            {
                con.constant=oriTop;
                i++;
            }
            else if(con.firstAttribute==NSLayoutAttributeBottom)
            {
                con.constant=oriBottom;
                i++;
            }
            if(i==2)
            {
                break;
            }
        }
        if(bTabShow)
        {
            self.tabBarController.tabBar.hidden=NO;
        }
        self.navigationController.navigationBar.frame=rectNavBar;
        for(UIView *view in self.navigationController.navigationBar.subviews)
        {
            if(![view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
            {
                view.hidden=NO;
            }
            
        }
    }
    
    
}

-(void)autoHiddenAction
{
    int currentPostion = _viewScrollAutoHidden.contentOffset.y;
    
    if (currentPostion - curScrollViewPos > 20  && currentPostion > 0 && _viewScrollAutoHidden.contentSize.height>_viewScrollAutoHidden.bounds.size.height) {
        curScrollViewPos = currentPostion;
        NSInteger i=0;
        for(NSLayoutConstraint *con in self.view.constraints)
        {
            if(con.firstAttribute==NSLayoutAttributeTop)
            {
                con.constant=20;
                i++;
            }
            else if (con.firstAttribute==NSLayoutAttributeBottom)
            {
                con.constant=0;
                i++;
            }
            if(i==2)
            {
                break;
            }
        }
        if(bTabShow)
        {
            self.tabBarController.tabBar.hidden=YES;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.navigationBar.frame=CGRectMake(0, 0, rectNavBar.size.width, 20);
        } completion:^(BOOL finished) {
            for(UIView *view in self.navigationController.navigationBar.subviews)
            {
                if(![view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
                {
                    view.hidden=YES;
                }
            }
        }];
    }
    else if ((curScrollViewPos - currentPostion > 20) && (currentPostion  <= _viewScrollAutoHidden.contentSize.height-_viewScrollAutoHidden.bounds.size.height-5) )
    {
        
        curScrollViewPos = currentPostion;
        NSInteger i=0;
        for(NSLayoutConstraint *con in self.view.constraints)
        {
            if(con.firstAttribute==NSLayoutAttributeTop)
            {
                con.constant=oriTop;
                i++;
            }
            else if(con.firstAttribute==NSLayoutAttributeBottom)
            {
                con.constant=oriBottom;
                i++;
            }
            if(i==2)
            {
                break;
            }
        }
        if(bTabShow)
        {
            self.tabBarController.tabBar.hidden=NO;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.navigationBar.frame=rectNavBar;
        } completion:^(BOOL finished) {
            for(UIView *view in self.navigationController.navigationBar.subviews)
            {
                if(![view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
                {
                    view.hidden=NO;
                }
                
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onBack
{
    if(self.navigationController.viewControllers.count==1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)hideBackButton
{
    if(self.navigationItem!=nil)
    {
        self.navigationItem.leftBarButtonItem=nil;
        bHiddenBackButton=YES;
    }
    
}

-(void)removeHud
{
    [imageView stopAnimating];
    POPBasicAnimation *ani=[POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    ani.toValue=@0;
    ani.duration=0.2;
    [ani setCompletionBlock:^(POPAnimation *ani, BOOL bFinish) {
        [imageView removeFromSuperview];
    }];
    [imageView pop_addAnimation:ani forKey:@"hide"];
}

-(NSString*)title
{
    return titleLabel.text;
}
- (void)setNavigationBottomLine:(BOOL)bHideNavigationBottomLine
{
    
    if (bHideNavigationBottomLine)
    {
        g_navBarHairlineImageView.hidden = YES;
    }
    else
    {
        g_navBarHairlineImageView.hidden = NO;
    }
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *foundImageView = [self findHairlineImageViewUnder:subview];
        if (foundImageView) {
            return foundImageView;
        }
    }
    return nil;
}

-(void)flyIn
{
    NSMutableArray<UIView*> *arr=[NSMutableArray array];
    for(UIView * view in self.view.subviews)
    {
        [arr addObject:view];
    }
    [arr sortUsingComparator:^NSComparisonResult(UIView*  _Nonnull obj1, UIView*  _Nonnull obj2) {
        if(obj1.frame.origin.y<obj2.frame.origin.y)
        {
            return NSOrderedAscending;
        }
        else if(obj1.frame.origin.y>obj2.frame.origin.y)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    int i=0;
    CGFloat delay=0;
    for(UIView * v in arr)
    {
        i++;
        CABasicAnimation *ani=[CABasicAnimation animationWithKeyPath:@"position"];
        ani.removedOnCompletion=NO;
        ani.fillMode=kCAFillModeBackwards;
        ani.fromValue=[NSValue valueWithCGPoint:CGPointMake((i%2==0)?([UIScreen mainScreen].bounds.size.width*1.5+50):(-[UIScreen mainScreen].bounds.size.width*0.5-50), v.layer.position.y)];
        ani.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        ani.duration=0.3;
        ani.toValue=[NSValue valueWithCGPoint:v.layer.position];
        ani.beginTime=CACurrentMediaTime()+delay;
        [v.layer addAnimation:ani forKey:@"move"];
        delay+=0.2;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
