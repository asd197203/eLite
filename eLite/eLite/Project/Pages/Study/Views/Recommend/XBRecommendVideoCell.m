//
//  XBRecommendVideoCell.m
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBRecommendVideoCell.h"

@interface XBRecommendVideoCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumb;

@end

@implementation XBRecommendVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(XBRecommendListModel *)cellModel {
    _cellModel = cellModel;
    
    if (cellModel.title.length > 0) {
        _titleLbl.hidden = NO;
        _titleLbl.text = cellModel.title;
    }else {
        _titleLbl.hidden = YES;
    }
    _dateLabel.text = cellModel.time;
    
}

- (IBAction)playVideo:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clickPlayVideoCallBack:)]) {
        [_delegate clickPlayVideoCallBack:[SERVER_IP stringByAppendingPathComponent:_cellModel.video]];
    }
}

@end
