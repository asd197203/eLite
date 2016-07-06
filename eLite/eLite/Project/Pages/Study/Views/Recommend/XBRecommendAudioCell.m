//
//  XBRecommendAudioCell.m
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBRecommendAudioCell.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDate+EasyDate.h"
#import "SVProgressHUD.h"

@interface XBRecommendAudioCell ()<AVAudioPlayerDelegate> {
    AVAudioPlayer *_audioPlayer;
    BOOL _isClickPlayBtn;
    NSData *_voieData;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioTime;
@property (weak, nonatomic) IBOutlet UIImageView *playingImageView;

@end

@implementation XBRecommendAudioCell

- (void)setCellModel:(XBRecommendListModel *)cellModel {
    _cellModel = cellModel;
    
    _dateLabel.text = cellModel.time;
}

- (IBAction)playAudio:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    if (button.selected) {
        if(_audioPlayer.isPlaying) {
            return;
        }
        else {
            if (_voieData.length) {
                _audioPlayer = [[AVAudioPlayer alloc] initWithData:_voieData fileTypeHint:AVFileTypeWAVE error:nil];
                [_audioPlayer setVolume:1];
                _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];
                [_audioPlayer play];
                _audioTime.text = [NSString stringWithFormat:@"%.fs", _audioPlayer.duration];
                // 如果可以播放 那么开始动画
                NSMutableArray *imageArr = [NSMutableArray new];
                for (int i = 0; i < 4; i ++) {
                    [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d", i]]];
                }
                _playingImageView.animationImages = imageArr;
                _playingImageView.animationRepeatCount = 0;
                _playingImageView.animationDuration = 1.0;
                [_playingImageView startAnimating];

            }else {
                [SVProgressHUD showWithStatus:@"正在加载"];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString *url = [SERVER_IP stringByAppendingPathComponent:_cellModel.audio];
                    _voieData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    NSString *time = [NSDate stringFromNow];
                    NSURL *audioURL = [NSURL fileURLWithPath:USER_CacheFilePath([@"tmp" stringByAppendingString:time])];
                    [_voieData writeToURL:audioURL atomically:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        _audioPlayer = [[AVAudioPlayer alloc] initWithData:_voieData fileTypeHint:AVFileTypeWAVE error:nil];
                        [_audioPlayer setVolume:1];
                        _audioPlayer.delegate = self;
                        [_audioPlayer prepareToPlay];
                        [_audioPlayer play];
                        _audioTime.text = [NSString stringWithFormat:@"%.fs", _audioPlayer.duration];
                        // 如果可以播放 那么开始动画
                        NSMutableArray *imageArr = [NSMutableArray new];
                        for (int i = 0; i < 4; i ++) {
                            [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d", i]]];
                        }
                        _playingImageView.animationImages = imageArr;
                        _playingImageView.animationRepeatCount = 0;
                        _playingImageView.animationDuration = 1.0;
                        [_playingImageView startAnimating];
                    });
                });
            }
        }
    }else {
        [_audioPlayer stop];
        [_playingImageView stopAnimating];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [_playingImageView stopAnimating];
        _isPlaying = NO;
        _isClickPlayBtn = NO;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"%@", error);
    [_playingImageView stopAnimating];
    _isPlaying = NO;
    _isClickPlayBtn = NO;
}

@end
