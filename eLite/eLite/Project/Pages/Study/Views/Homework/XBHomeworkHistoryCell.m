//
//  XBHomeworkHistoryCell.m
//  eLite
//
//  Created by 常小哲 on 16/5/24.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHomeworkHistoryCell.h"

@interface XBHomeworkHistoryCell () {
    
    __weak IBOutlet UILabel *_levelLabel;
    __weak IBOutlet UILabel *_scoreLabel;
    __weak IBOutlet UILabel *_typeLabel;
    __weak IBOutlet UILabel *_dateLabel;
    
}

@end

@implementation XBHomeworkHistoryCell

- (void)setCellModel:(XBHomeworkHistoryInfoModel *)cellModel {
    _cellModel = cellModel;
    
    _levelLabel.text =  [NSString stringWithFormat:@"%@",cellModel.level[@"level"]];
    if (cellModel.score) {
        _scoreLabel.text =  [NSString stringWithFormat:@"%@",cellModel.score];
    }else {
        _scoreLabel.text = @"无";
    }
    _dateLabel.text = cellModel.date;;

}

- (void)setTypeStr:(NSString *)typeStr {
    _typeStr = typeStr;
    _typeLabel.text = typeStr;

}

@end
