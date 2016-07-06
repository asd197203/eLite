//
//  XBHomeworkWordCell.m
//  eLite
//
//  Created by 常小哲 on 16/5/1.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHomeworkWordCell.h"

@interface XBHomeworkWordCell () {
}

@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *subjLabel;

@end

@implementation XBHomeworkWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.bgView];
        [_bgView addSubview:self.leftImage];
        [_bgView addSubview:self.subjLabel];
    }
    return self;
}

- (void)setSubject:(NSString *)subject {
    _subjLabel.text = subject;
//    _subjLabel.text = @"adasdasdasdasdasdasdasdasdasdasdasd";
    [_subjLabel sizeToFit];
    
    _bgView.height = MAX(50+_subjLabel.height-30, 50);
    _subjLabel.y = _bgView.height == 50 ? 15 : 10;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _leftImage.image = Image_Named(@"homework_text_selected");
    }else  _leftImage.image = Image_Named(@"homework_text_unselected");

}

- (UIView *)bgView {
    SafeRun_Return(_bgView);
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, Screen_Width - 10*2, 50)];
    _bgView.backgroundColor = Color_White;
    _bgView.cornerRadius = 5.f;
    return _bgView;
}

- (UIImageView *)leftImage {
    SafeRun_Return(_leftImage);
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    _leftImage.contentMode = UIViewContentModeCenter;
    _leftImage.image = Image_Named(@"homework_text_unselected");
    return _leftImage;
}

- (UILabel *)subjLabel {
    SafeRun_Return(_subjLabel);
    _subjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+10+30, 15,kHomeworkWordCellLabelMaxWidth, 20)];
    _subjLabel.numberOfLines = 0;
    _subjLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _subjLabel.font = Font_System(17);
    return _subjLabel;
}

@end
