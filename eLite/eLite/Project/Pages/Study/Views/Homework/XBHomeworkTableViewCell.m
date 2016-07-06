//
//  XBHomeworkTableViewCell.m
//  eLite
//
//  Created by 常小哲 on 16/4/15.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHomeworkTableViewCell.h"

@interface XBHomeworkTableViewCell () {
    
    __weak IBOutlet UIImageView *_leftImage;
    __weak IBOutlet UILabel *_title;
}

@end

@implementation XBHomeworkTableViewCell

- (void)setCellInfo:(NSArray *)cellInfo {
    _title.text = cellInfo[0];
    _leftImage.image = Image_Named(cellInfo[1]);
}

@end
