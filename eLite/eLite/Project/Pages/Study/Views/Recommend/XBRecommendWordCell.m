//
//  XBRecommendWordCell.m
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBRecommendWordCell.h"

@interface XBRecommendWordCell () {
    
    void (^_block)(NSString *);
    NSString *_imageURL;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation XBRecommendWordCell

- (void)setCellModel:(XBRecommendListModel *)cellModel {
    _cellModel = cellModel;
    if (cellModel.title.length > 0) {
        _titleLbl.hidden = NO;
        _titleLbl.text = cellModel.title;
    }else {
        _titleLbl.hidden = YES;
    }
    _dateLabel.text = cellModel.time;
    if (cellModel.img.length > 0) {
        _imgView.hidden = NO;
        _imageURL = [SERVER_IP stringByAppendingPathComponent:cellModel.img];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_imageURL]];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkBigPicture)];
        [_imgView addGestureRecognizer:tap];
    }else {
        _imgView.hidden = YES;
    }
}

- (void)checkBigPicture {
    _block(_imageURL);
}

- (void)clickImageViewOnCell:(void (^)(NSString *url))block {
    _block = ^(NSString *imageURL) {
        block(imageURL);
    };
}

@end
