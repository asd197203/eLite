//
//  XBTeacherDetailInfoTableViewCell.m
//  eLite
//
//  Created by 常小哲 on 16/4/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBTeacherDetailInfoTableViewCell.h"

@interface XBTeacherDetailInfoTableViewCell () {
    
    __weak IBOutlet UILabel *_nation;
    __weak IBOutlet UILabel *_teachStyle;
    __weak IBOutlet UILabel *_teachContent;
    __weak IBOutlet UILabel *_introduce;
}

@end

@implementation XBTeacherDetailInfoTableViewCell

- (void)setCellModel:(XBTeacherDetailInfoModel *)cellModel {
    
    _nation.text = cellModel.country;
    _teachStyle.text = cellModel.style;
    _teachContent.text = cellModel.content;
    _introduce.text = cellModel.des;
}

@end
