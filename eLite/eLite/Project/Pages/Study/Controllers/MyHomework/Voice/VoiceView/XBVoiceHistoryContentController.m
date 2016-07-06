//
//  XBVoiceHistoryContentController.m
//  eLite
//
//  Created by 常小哲 on 16/5/25.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVoiceHistoryContentController.h"
#import "XBVoiceHistoryController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDate+EasyDate.h"
#import "amrFileCodec.h"

@interface XBVoiceHistoryContentController ()<AVAudioPlayerDelegate> {
    __weak IBOutlet UILabel *_subjLabel;
    __weak IBOutlet UILabel *voiceTimeLabel;
    __weak IBOutlet UIButton *voiceBubble;
    __weak IBOutlet UIImageView *_playImageView;
    
    AVAudioPlayer *_audioPlayer;
}

@end

@implementation XBVoiceHistoryContentController

- (void)viewDidLoad {
    [super viewDidLoad];

    _subjLabel.text = _infoModel.title;

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [_playImageView stopAnimating];
    [_audioPlayer stop];
}

- (IBAction)playVoice:(id)sender {
    if(_audioPlayer.isPlaying) {
        return;
    }
    else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *url = [SERVER_IP stringByAppendingPathComponent:_infoModel.path];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            NSString *time = [NSDate stringFromNow];
            NSURL *audioURL = [NSURL fileURLWithPath:USER_CacheFilePath([@"tmp" stringByAppendingString:time])];
            [data writeToURL:audioURL atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                _audioPlayer = [[AVAudioPlayer alloc] initWithData:DecodeAMRToWAVE(data) fileTypeHint:AVFileTypeWAVE error:nil];
                [_audioPlayer setVolume:1];
                _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];
                [_audioPlayer play];
                voiceTimeLabel.text = [NSString stringWithFormat:@"%.fs", _audioPlayer.duration];
            });
        });
        // 如果可以播放 那么开始动画
        NSMutableArray *imageArr = [NSMutableArray new];
        for (int i = 0; i < 4; i ++) {
            [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d", i]]];
        }
        _playImageView.animationImages = imageArr;
        _playImageView.animationRepeatCount = 0;
        _playImageView.animationDuration = 1.0;
        [_playImageView startAnimating];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [_playImageView stopAnimating];
    }
}

@end
