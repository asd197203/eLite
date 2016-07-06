//
//  RecordVideoView.h
//  SlowMotionVideoRecorder
//
//  Created by lxx on 16/5/12.
//  Copyright © 2016年 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCaptureManager.h"
#import "StartButton.h"

@protocol RecordVideoViewDelegate <NSObject>

- (void)didFinishRecordingAtURL:(NSURL *)outputFileURL
                          error:(NSError *)error;

@end
@interface RecordVideoView : UIView<AVCaptureManagerDelegate>
{
    NSTimeInterval startTime;
    StartButton *startButton;
    NSURL *videoUrl;
    UIButton *startRcordBtn;
}
@property(nonatomic,strong)AVCaptureManager *captureManager;
@property(nonatomic,strong)UIButton *againBtn;
@property(nonatomic,strong)UIButton *completeBtn;
@property(nonatomic,strong)UILabel  *statusLabel;
@property(nonatomic, assign) NSTimer *timer;
@property(nonatomic, weak)id<RecordVideoViewDelegate>delegate;
@end
