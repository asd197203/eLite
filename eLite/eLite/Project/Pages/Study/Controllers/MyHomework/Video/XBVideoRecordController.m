//
//  XBVideoRecordController.m
//  eLite
//
//  Created by 常小哲 on 16/5/3.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVideoRecordController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDate+EasyDate.h"
#import "XHMessageVideoConverPhotoFactory.h"
#import "SendVideoReq.h"
#import "NSData+category.h"
#import "MBProgressHUD.h"
#import "XBShowViewOnce.h"
@interface XBVideoRecordController ()<AVCaptureFileOutputRecordingDelegate>
{
    NSTimeInterval startTime;
    
}
@property(nonatomic,strong)UIButton *againBtn;
@property(nonatomic,strong)UIButton *completeBtn;
@property(nonatomic,strong)UIButton *switchBtn;

@property (nonatomic, strong) AVCaptureMovieFileOutput *output;
@property (nonatomic, strong) AVCaptureSession * capSession;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UILabel *statusLabel;
@end

@implementation XBVideoRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _againBtn.hidden = YES;
    [_againBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [_againBtn addTarget:self action:@selector(resetRecord:) forControlEvents:UIControlEventTouchUpInside];
    _againBtn.frame = CGRectMake(0, 0, 50, 20);
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    _completeBtn.hidden = YES;
    [_completeBtn addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    _completeBtn.frame = CGRectMake(0, 0, 50, 20);

    _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _switchBtn.frame = CGRectMake(0, 0, 60, 30);
    [_switchBtn setImage:Image_Named(@"switch_video") forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(switchVideo:) forControlEvents:UIControlEventTouchUpInside];
 
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_switchBtn];
    UIBarButtonItem *again = [[UIBarButtonItem alloc]initWithCustomView:_againBtn];
    UIBarButtonItem *complete = [[UIBarButtonItem alloc]initWithCustomView:_completeBtn];
    
    self.navigationItem.rightBarButtonItems = @[rightItem, again, complete];

    [self.recordBtn setBackgroundImage:Image_Named(@"homework_video_startRecordBtn.png")
                      forState:UIControlStateNormal];
    [self.recordBtn setBackgroundImage:Image_Named(@"homework_video_stopRecordBtn.png")
                      forState:UIControlStateSelected];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:[devices firstObject] error:NULL];
    
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
    self.output = output;
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//    self.captureSession = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPreset352x288;
    if ([session canAddInput:inputVideo]) {
        [session addInput:inputVideo];
    }
    if ([session canAddInput:inputAudio]) {
        [session addInput:inputAudio];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    //    AVLayerVideoGravityResizeAspect
    //    AVLayerVideoGravityResizeAspectFill
    //    AVLayerVideoGravityResize
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preLayer.frame = CGRectMake(0, 100, Screen_Width, Screen_Height-100-100);
//    preLayer.position = self.view.center;
    [self.view.layer addSublayer:preLayer];
    [session startRunning];
    self.capSession = session;
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50,110, 100, 30);
    self.statusLabel.textAlignment=  NSTextAlignmentCenter;
    self.statusLabel.textColor = [UIColor redColor];
    self.statusLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.statusLabel];
    [self.view bringSubviewToFront:self.recordBtn];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}


- (void)switchVideo:(UIButton *)sender {
    NSArray *inputs = self.capSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.capSession beginConfiguration];
            
            [self.capSession removeInput:input];
            [self.capSession addInput:newInput];
            
            [self.capSession commitConfiguration];
            break;
        }
    } 
}

- (void)complete:(UIButton*)sender
{
    self.navigationController.navigationBar.hidden = YES;
    NSLog(@"视频大小===%f",[[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",USER_CacheFilePath(@"test.mov")]]]length]/1024.00 /1024.00);
    _againBtn.hidden = YES;
    _completeBtn.hidden = YES;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:USER_CacheFilePath(@"test.mov")]];
    data.fileType =@"mov";
    [self showProgress];
    [SendVideoReq do:^(id req) {
        SendVideoReq * re = req;
        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
        re.subjects = self.subjects;
        re.file1 = data;
    } Res:^(id res) {
        [self hideProgress];
        SendVideoRes *resq = res;
        if (resq.code==0) {
             self.navigationController.navigationBar.hidden = NO;
            if ([self.delagate respondsToSelector:@selector(completeVideo)]) {
                [self.delagate completeVideo];
            }
            [XBShowViewOnce showHUDText:@"上传成功" inVeiw:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
           [XBShowViewOnce showHUDText:resq.msg inVeiw:self.view];
        }
        
    } ShowHud:NO];
}

-(void)showProgress {
    _hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    _hud.detailsLabelText = @"视频上传中...";
    _hud.margin = 12.f;
    _hud.removeFromSuperViewOnHide = YES;
    _hud.mode = MBProgressHUDModeText;
}
-(void)hideProgress {
    [_hud hide:YES];
}
- (void)resetRecord:(UIButton*)sender
{
    _againBtn.hidden = YES;
    _completeBtn.hidden = YES;
    _recordBtn.selected= YES;
    NSURL *url = [NSURL fileURLWithPath:USER_CacheFilePath(@"test.mov")];
    sender.selected = !sender.selected;
    startTime = [[NSDate date] timeIntervalSince1970];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(timerHandler:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.output startRecordingToOutputFileURL:url
                             recordingDelegate:self];
    
}
- (IBAction)clickVideoBtn:(UIButton *)sender {
    //判断是否在录制,如果在录制，就停止，并设置按钮背景图
    sender.selected =!sender.selected;
//    if ([self.output isRecording]) {
//        [self.output stopRecording];
//        [self.timer invalidate];
//        self.timer = nil;
//        _againBtn.hidden = NO;
//        _completeBtn.hidden = NO;
//        
//        return;
//    }
    if (sender.selected) {
        _againBtn.hidden = YES;
        _completeBtn.hidden = YES;
        startTime = [[NSDate date] timeIntervalSince1970];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(timerHandler:)
                                                    userInfo:nil
                                                     repeats:YES];
#warning put it after login
        [CXZSimpleTool createDirectory:USER_CacheRoot];
        NSURL *url = [NSURL fileURLWithPath:USER_CacheFilePath(@"test.mov")];
        [self.output startRecordingToOutputFileURL:url
                                 recordingDelegate:self];

    }else {
        [self.output stopRecording];
        [self.timer invalidate];
        self.timer = nil;
        _againBtn.hidden = NO;
        _completeBtn.hidden = NO;
    }
    
}
- (void)timerHandler:(NSTimer *)timer {
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval recorded = current - startTime;
    self.statusLabel.text = [NSString stringWithFormat:@"%.1f s", recorded];
}
#pragma mark - AVCaptureFileOutputRecordingDelegate
//录制完成代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    NSLog(@"outputFileURL===%@",outputFileURL);
    NSLog(@"完成录制,可以自己做进一步的处理");
    
}

@end
