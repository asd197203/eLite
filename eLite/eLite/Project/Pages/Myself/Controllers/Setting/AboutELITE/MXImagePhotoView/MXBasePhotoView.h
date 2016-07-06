//
//  MXBasePhotoView.h
//  MXImageSelectView
//
//  Created by maxin on 16/4/27.
//  Copyright © 2016年 maxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXBasePhotoViewDelegate <NSObject>

- (void)clickDeleBtToDelePhotoWithView:(UIView *)view;

@end
@interface MXBasePhotoView : UIView

//图片视图
@property (nonatomic , strong) UIImageView *showImageView;
//删除按钮
@property (nonatomic , strong) UIButton *deleBt;
//图片宽高  按钮宽高
@property (nonatomic) CGFloat imageWidthAndHeight;
@property (nonatomic) CGFloat buttonWidthAndHeight;
//图片间隙
@property (nonatomic) CGFloat imageSpaces;


//代理
@property (nonatomic) id<MXBasePhotoViewDelegate>photoDelegate;
@end
