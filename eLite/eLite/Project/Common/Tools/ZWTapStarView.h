//
//  ZWTapStarView.h
//  HorseRiding
//
//  Created by 联合创想 on 16/3/1.
//  Copyright © 2016年 LHCX. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^scoreBlock)(NSString *scoreValue);
@class ZWTapStarView;

@protocol ZWTapStarViewDelegate <NSObject>

@optional
-(void)starRatingView:(ZWTapStarView *)view score:(float)score;

@end

@interface ZWTapStarView : UIView

@property (nonatomic, weak) id <ZWTapStarViewDelegate> delegate;

@end
