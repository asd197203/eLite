//
//  StartButton.h
//  SlowMotionVideoRecorder
//
//  Created by lxx on 16/5/12.
//  Copyright © 2016年 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartButton : UIView
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) UILabel *label;
-(void)disappearAnimation;
-(void)appearAnimation;
@end
