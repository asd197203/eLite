//
//  RecordVideoView.m
//  SlowMotionVideoRecorder
//
//  Created by lxx on 16/5/12.
//  Copyright © 2016年 Shuichi Tsutsumi. All rights reserved.
//

#import "RecordVideoView.h"
#import "MBProgressHUD.h"
@interface RecordVideoView()
@property (nonatomic,strong)    MBProgressHUD *hud;
@end
@implementation RecordVideoView
- (instancetype)init
{
    if (self =[super init]) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
//    CALayer *layer = [[CALayer alloc]init];
//    layer.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    layer.opacity = 0.5;
//    [self.layer addSublayer:layer];
//    [self initStartButton];
  
    UIView*view  = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-214-50, [UIScreen mainScreen].bounds.size.width, 270)];
    self.captureManager = [[AVCaptureManager alloc]initWithPreviewView:view];
    self.captureManager.delegate =self;
    startRcordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startRcordBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startRcordBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [startRcordBtn setBackgroundImage:[UIImage imageNamed:@"录制小视频"] forState:UIControlStateNormal];
    startRcordBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, 150, 50, 50);
    [startRcordBtn addTarget:self action:@selector(recButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:startRcordBtn];
    _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _againBtn.hidden = YES;
    [_againBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [_againBtn addTarget:self action:@selector(resetRecord:) forControlEvents:UIControlEventTouchUpInside];
    _againBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-130, 10, 50, 20);
    [view addSubview:_againBtn];
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    _completeBtn.hidden = YES;
    [_completeBtn addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    _completeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70, 10, 50, 20);
    [view addSubview:_completeBtn];
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-25, 10, 50, 20)];
    self.statusLabel.textColor = [UIColor redColor];
    [view addSubview:self.statusLabel];
    [self addSubview:view];
}
- (void)resetRecord:(UIButton*)sender
{
    startRcordBtn.selected = YES;
    _againBtn.hidden = YES;
    _completeBtn.hidden = YES;
    startTime = [[NSDate date] timeIntervalSince1970];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(timerHandler:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self.captureManager startRecording];
}
- (void)recButtonTapped:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _againBtn.hidden = YES;
        _completeBtn.hidden = YES;
        startTime = [[NSDate date] timeIntervalSince1970];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(timerHandler:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.captureManager startRecording];
    }
    // REC STOP
    else {
        
        [self.captureManager stopRecording];
        _againBtn.hidden = NO;
        _completeBtn.hidden = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - Timer Handler

- (void)timerHandler:(NSTimer *)timer {
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval recorded = current - startTime;
    
    self.statusLabel.text = [NSString stringWithFormat:@"%.1f s", recorded];
    if ([self.statusLabel.text floatValue]>=10.0) {
        [self.captureManager stopRecording];
        [self.timer invalidate];
        self.timer = nil;
        _againBtn.hidden = NO;
        _completeBtn.hidden = NO;
    }
}
-(void)initStartButton{
    startButton = [[StartButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-30, self.bounds.size.height-70, 60,60)];
    [self addSubview:startButton];
}
- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error
{
    if (!error) {
        videoUrl = outputFileURL;
    }
}
- (void)complete:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didFinishRecordingAtURL:error:)]) {
        [self.delegate didFinishRecordingAtURL:videoUrl error:nil];
    }
      [self removeFromSuperview];
}
-(void)videoCompressComplete
{
    [self hideProgress];
    if ([self.delegate respondsToSelector:@selector(didFinishRecordingAtURL:error:)]) {
        [self.delegate didFinishRecordingAtURL:videoUrl error:nil];
    }
    
  
}
-(void)showProgress {
    _hud= [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    _hud.detailsLabelText = @"视频压缩中...";
    _hud.margin = 12.f;
    _hud.removeFromSuperViewOnHide = YES;
    _hud.mode = MBProgressHUDModeText;
}
-(void)hideProgress {
    [_hud hide:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    CGPoint  fl = [touch locationInView: self];
    if (fl.y<[UIScreen mainScreen].bounds.size.height-270) {
         [self removeFromSuperview];
    }
    else
    {
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
