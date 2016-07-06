//
//  PlayVideoVC.m
//  Pods
//
//  Created by lxx on 16/4/13.
//
//

#import "PlayVideoVC.h"

@implementation PlayVideoVC

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

//- (void)setMessage:(id<XHMessageModel>)message {
//    _message = message;
//    self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
//    self.moviePlayerController.contentURL = [NSURL fileURLWithPath:[message videoPath]];
//    [self.moviePlayerController play];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    if ([self.message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        [self.moviePlayerController stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(back) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
    self.moviePlayerController.contentURL = [NSURL fileURLWithPath:self.url];
    [self.moviePlayerController play];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)dealloc {
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
