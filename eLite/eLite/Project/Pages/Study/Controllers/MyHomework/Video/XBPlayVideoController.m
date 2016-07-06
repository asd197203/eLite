//
//  XBPlayVideoController.m
//  eLite
//
//  Created by 常小哲 on 16/5/8.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBPlayVideoController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XBPlayVideoController () {
    NSString *_videoPath;
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation XBPlayVideoController

- (instancetype)initWithVideoPath:(NSString *)path {
    if (self == [super init]) {
        _videoPath = path;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(back) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

}

- (void)addLocationPath:(NSString *)path {
    self.moviePlayerController.contentURL = [NSURL fileURLWithPath:path];
    [self.moviePlayerController play];

}

- (void)addRemoteURL:(NSString *)url {
    self.moviePlayerController.contentURL = [NSURL URLWithString:url];
    [self.moviePlayerController play];
}

-(void)back {
//    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)dealloc {
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [self.moviePlayerController stop];
}

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeNone;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

@end
