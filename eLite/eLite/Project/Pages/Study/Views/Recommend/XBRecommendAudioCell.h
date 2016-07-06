//
//  XBRecommendAudioCell.h
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBRecommendAudioCell : UITableViewCell

@property (nonatomic, strong) XBRecommendListModel *cellModel;
@property (nonatomic, assign) BOOL isPlaying;

@end
