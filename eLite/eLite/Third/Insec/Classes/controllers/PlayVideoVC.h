//
//  PlayVideoVC.h
//  Pods
//
//  Created by lxx on 16/4/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XHMessageModel.h"

@interface PlayVideoVC : UIViewController
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) id<XHMessageModel> message;
@property (nonatomic ,copy)NSString *url;
@end
