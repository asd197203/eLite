//
//  XBTeacherDetailInfoTopCell.m
//  eLite
//
//  Created by 常小哲 on 16/4/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBTeacherDetailInfoTopCell.h"
#import "XBEvaluationRatingView.h"

@interface XBTeacherDetailInfoTopCell () {
    
    __weak IBOutlet UIImageView *_avatar;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UIImageView *_sex;
    __weak IBOutlet XBEvaluationRatingView *_ratingView;
    __weak IBOutlet UILabel *_ratingLabel;
}

@end

@implementation XBTeacherDetailInfoTopCell

- (void)setCellModel:(XBTeacherDetailInfoModel *)cellModel {
    
    [_avatar sd_setImageWithURL:Image_URL(cellModel.photo) placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _name.text = cellModel.name;
    _sex.image = [cellModel.sex isEqualToString:@"男"] ? Image_Named(@"sex_boy") : Image_Named(@"sex_girl");
    _ratingView.rating = [cellModel.score floatValue]/20;
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f分",[cellModel.score floatValue]/20];
    _ratingView.rating = MIN([cellModel.score floatValue], 5.0);
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f分",MIN([cellModel.score floatValue], 5.0)];
}

@end
