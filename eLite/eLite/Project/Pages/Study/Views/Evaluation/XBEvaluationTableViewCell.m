//
//  XBEvaluationTableViewCell.m
//  eLite
//
//  Created by 常小哲 on 16/4/15.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBEvaluationTableViewCell.h"
#import "XBEvaluationRatingView.h"

@interface XBEvaluationTableViewCell () {
    __weak IBOutlet UIImageView *_avatar;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UIImageView *_sex;
    __weak IBOutlet UILabel *_nationLabel;
    __weak IBOutlet UILabel *_supportLabel;
    __weak IBOutlet XBEvaluationRatingView *_ratingView;
    __weak IBOutlet UILabel *_ratingLabel;
    __weak IBOutlet UILabel *_teachContent;
}
@end

@implementation XBEvaluationTableViewCell

- (void)setCellModel:(XBTeacherInfoModel *)cellModel {
    
   [_avatar sd_setImageWithURL:Image_URL(cellModel.photo) placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _name.text = cellModel.name;
    UIImage *sexImage;
    NSString *sexCall;
    if ([cellModel.sex isEqualToString:@"男"]) {
        sexImage = Image_Named(@"sex_boy");
        sexCall = @"他";
    }else {
        sexImage = Image_Named(@"sex_girl");
        sexCall = @"她";
    }
    _sex.image = sexImage;
    _nationLabel.text = cellModel.country;
    _supportLabel.text = [NSString stringWithFormat:@"%@人赞了%@", cellModel.upcount, sexCall];
    _ratingView.rating = [cellModel.score floatValue]/20;
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f分", MIN([cellModel.score floatValue]/20, 5.0)];
    _ratingView.rating = MIN([cellModel.score floatValue], 5.0);
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f分", MIN([cellModel.score floatValue], 5.0)];
    _teachContent.text = cellModel.content;
}

@end
