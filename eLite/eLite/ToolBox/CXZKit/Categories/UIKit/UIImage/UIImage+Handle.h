//
//  UIImage+Handle.h
//  RPAntus
//
//  Created by Crz on 15/11/24.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Handle)

/** 使用coreImage进行模糊 */
- (UIImage *)coreImage_blurryWithLevel:(CGFloat)radius;

/** 使用vImage API进行模糊  */
- (UIImage *)vImageBox_blurryWithLevel:(CGFloat)radius;

/** 修复图片方向问题 */
- (UIImage *)fixOrientation;

/** 通过指定宽度 重绘图片的size压缩图片大小 */
- (UIImage *)clipImageWithWidth:(CGFloat)defineWidth;


@end
