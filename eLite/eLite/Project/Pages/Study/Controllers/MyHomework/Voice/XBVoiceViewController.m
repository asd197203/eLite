//
//  XBVoiceViewController.m
//  eLite
//
//  Created by 常小哲 on 16/5/7.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVoiceViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceView.h"
#import "iflyMSC/IFlyMSC.h"
#import "ISEResultXmlParser.h"
#import "ISEResult.h"
#import "ISEParams.h"
#import "XBVoiceController.h"
#import "XBVoiceDoneViewController.h"
#import "SVProgressHUD.h"
#import "amrFileCodec.h"
#import "RecordAudio.h"
@interface XBVoiceViewController ()<AVAudioPlayerDelegate, IFlySpeechEvaluatorDelegate, ISEResultXmlParserDelegate,AVAudioRecorderDelegate> {
    
    
    __weak IBOutlet NSLayoutConstraint *voiceBtnWidthConstraint;
    __weak IBOutlet UILabel *_subjLabel;
    __weak IBOutlet UILabel *voiceTimeLabel;
    __weak IBOutlet UIButton *voiceBubble;
    
    __weak IBOutlet UIImageView *_playImageView;
    NSURL *urlPlay;
    AVAudioRecorder *recorder;
    AVAudioPlayer *avPlay;
    VoiceView *viewVoice;
    NSMutableData *voiceData;
    NSString *voicePath;
    __weak IBOutlet UIButton *_recordBtn;
    __weak IBOutlet UILabel *_recordLabel;
    NSURL *voicePathUrl;
    
}

@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, strong) ISEParams *iseParams;


@end

@implementation XBVoiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    voiceData = [[NSMutableData alloc]init];
    [self audio];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *name = [NSString stringWithFormat:@"recording_%@.pcm", [self.title componentsSeparatedByString:@"/"][0]];
    voicePath = [cachePath stringByAppendingPathComponent:name];
}

-(void)reloadCategoryText{
    
    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.iFlySpeechEvaluator cancel];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [self.iFlySpeechEvaluator cancel];
    [_playImageView stopAnimating];
    [avPlay stop];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _subjLabel.text = _infoModel.title;

    if (!voiceTimeLabel.hidden && !voiceBubble.hidden && !_playImageView.hidden) {
        _recordBtn.hidden = YES;
        _recordLabel.hidden = YES;
    }else {
        _recordBtn.hidden = NO;
        _recordLabel.hidden = NO;

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        
        if (!self.iFlySpeechEvaluator) {
            self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
        }
        self.iFlySpeechEvaluator.delegate = self;
        //清空参数，目的是评测和听写的参数采用相同数据
        [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        self.iseParams=[ISEParams fromUserDefaults];
        [self reloadCategoryText];
    }
}

- (void)audio
{
    NSError *error1;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
    [session setActive:YES error:&error1];
    //录音设置
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%.0f.caf",strUrl,[NSDate timeIntervalSinceReferenceDate] * 1000.0]];
    urlPlay = url;
    NSLog(@"urlPlay---%@",urlPlay);
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}
- (IBAction)playVoice:(UIButton *)sender {
    if (_playImageView.isAnimating) {
        return;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    NSInteger index = [self.title componentsSeparatedByString:@"/"].firstObject.integerValue;
//    avPlay = [[AVAudioPlayer alloc] initWithData:DecodeAMRToWAVE(self.parentController.voicePathArray[index-1]) fileTypeHint:AVFileTypeWAVE error:&err];
    NSLog(@"urlPlay---%@",urlPlay);
    NSLog(@"---%@",[NSData dataWithContentsOfURL:urlPlay]);
    avPlay =[[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfURL:urlPlay] error:&err];
    if (err) {
        NSLog(@"播放错误-------------> %@", err);
    }
    [avPlay setVolume:1];
    avPlay.delegate = self;
    if(avPlay.isPlaying)
    {
        return;
    }
    else
    {
        if ([avPlay prepareToPlay]) {
            [avPlay play];
            NSMutableArray *imageArr = [NSMutableArray new];
            for (int i = 0; i < 4; i ++) {
                [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d", i]]];
            }
            _playImageView.animationImages = imageArr;
            _playImageView.animationRepeatCount = 0;
            _playImageView.animationDuration = 1.0;
            [_playImageView startAnimating];
        }else
        {
            NSLog(@"播放失败---");
        }
    }
}
- (IBAction)touchDown:(id)sender {
    viewVoice=[[VoiceView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [viewVoice showInView:self.view];
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    [self onBtnStart];
}

- (IBAction)touchDragExit:(id)sender {
    [recorder stop];
    [SVProgressHUD showWithStatus:@"正在评分"];
    [viewVoice remove];
}

- (IBAction)touchUpInside:(id)sender {
    [recorder stop];
    [SVProgressHUD showWithStatus:@"正在评分"];
    [viewVoice remove];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [_playImageView stopAnimating];
    }
}

/*!
 *  开始录音
 *
 *  @param sender startBtn
 */
- (void)onBtnStart {
    
    [self.iFlySpeechEvaluator setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    NSString *name = [NSString stringWithFormat:@"recording_%@.pcm", [self.title componentsSeparatedByString:@"/"][0]];
    [self.iFlySpeechEvaluator setParameter:name forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSLog(@"text encoding:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
    NSLog(@"language:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
    
    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    BOOL isZhCN=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
    
    BOOL needAddTextBom=isUTF8&&isZhCN;
    NSMutableData *buffer = nil;
    if(needAddTextBom){
        NSLog(@"aaaa-------------> %@", _subjLabel.text);
        if(_subjLabel.text && [_subjLabel.text length]>0){
            Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
            buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
            [buffer appendData:[_subjLabel.text dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
        }
    }else{
        buffer= [NSMutableData dataWithData:[_subjLabel.text dataUsingEncoding:encoding]];
        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
    }
        [self.iFlySpeechEvaluator startListening:buffer params:nil];
}

#pragma mark-  timer

#pragma mark - IFlySpeechEvaluatorDelegate
/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {

    double lowPassResults = volume/20.f;
    
    if (0<lowPassResults<=0.06) {
        [viewVoice setVoiceImage:@"record_animate_01.png"];
    }else if (0.06<lowPassResults<=0.13) {
        [viewVoice setVoiceImage:@"record_animate_02.png"];
    }else if (0.13<lowPassResults<=0.20) {
        [viewVoice setVoiceImage:@"record_animate_03.png"];
    }else if (0.20<lowPassResults<=0.27) {
        [viewVoice setVoiceImage:@"record_animate_04.png"];
    }else if (0.27<lowPassResults<=0.34) {
        [viewVoice setVoiceImage:@"record_animate_05.png"];
    }else if (0.34<lowPassResults<=0.41) {
        [viewVoice setVoiceImage:@"record_animate_06.png"];
    }else if (0.41<lowPassResults<=0.48) {
        [viewVoice setVoiceImage:@"record_animate_07.png"];
    }else if (0.48<lowPassResults<=0.55) {
        [viewVoice setVoiceImage:@"record_animate_08.png"];
    }else if (0.55<lowPassResults<=0.62) {
        [viewVoice setVoiceImage:@"record_animate_09.png"];
    }else if (0.62<lowPassResults<=0.69) {
        [viewVoice setVoiceImage:@"record_animate_10.png"];
    }else if (0.69<lowPassResults<=0.76) {
        [viewVoice setVoiceImage:@"record_animate_11.png"];
    }else if (0.76<lowPassResults<=0.83) {
        [viewVoice setVoiceImage:@"record_animate_12.png"];
    }else if (0.83<lowPassResults<=0.9) {
        [viewVoice setVoiceImage:@"record_animate_13.png"];
    }else {
        [viewVoice setVoiceImage:@"record_animate_14.png"];
    }
//    [voiceData appendData:buffer];
}

/*!
 *  开始录音回调
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech {
    
}

/*!
 *  停止录音回调
 *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onEndOfSpeech {
   
}

/*!
 *  正在取消
 */
- (void)onCancel {
    
}

- (void)onResults:(NSData *)results isLast:(BOOL)isLast{
    if (results) {
        
        NSString *showText = @"";
        
        const char* chResult=[results bytes];
        
        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        NSString* strResults=nil;
        if(isUTF8){
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"result encoding: gb2312");
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        if(strResults){
            showText = [showText stringByAppendingString:strResults];
        }
        
        ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
        parser.delegate=self;
        [parser parserXml:showText];
        
        if(isLast){

        }
    }
    else{
        if(isLast){

        }
    }
}

- (void)onError:(IFlySpeechError *)errorCode {
    if(errorCode && errorCode.errorCode!=0){
        [SVProgressHUD dismiss];
        [XBShowViewOnce showHUDText:@"评测失败，请重新录制" inVeiw:self.view];
        NSLog(@"错误码-------------> %d", errorCode.errorCode);
        
    }
}
#pragma mark - ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result{
    NSLog(@"result-------------> %@", [result toString]);
    [SVProgressHUD dismiss];
    self.parentController.correntSubject ++;
    voiceTimeLabel.hidden = NO;
    voiceBubble.hidden = NO;
    _playImageView.hidden = NO;
    voiceTimeLabel.text = [NSString stringWithFormat:@"%ds", MAX(result.time_len/100 - 2, 1)];
    self.parentController.score += result.total_score;
    [self.parentController.voicePathArray addObject:[NSData dataWithContentsOfURL:urlPlay]];
    if (self.parentController.correntSubject == self.parentController.allSubjectCount) {
        XBVoiceDoneViewController *vc = [[XBVoiceDoneViewController alloc] init];
        vc.allSubjectCount = self.parentController.allSubjectCount;
        vc.allSubjectID = self.parentController.allSubjectID;
        vc.voiceArray = [NSArray arrayWithArray:self.parentController.voicePathArray];
        vc.score = self.parentController.score;
        [self.parentController.navigationController pushViewController:vc animated:YES];
    }
    [self.parentController selectedIndex:[self.title componentsSeparatedByString:@"/"].firstObject.integerValue];
}

@end
