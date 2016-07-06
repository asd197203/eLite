//
//  CXZAlbumManager.h
//  RPAntus
//
//  Created by Crz on 15/11/24.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^CXZAlbumSaveHandler)(UIImage *image, NSError *error);

/**
 * @brief 将图片写入相册,使用ALAssetLibrary
 *
 * @param  image    需要写入的图片
 * @param  album    相册名称，如果相册不存在，则新建相册
 * @param  completionHandler 回调
 */
extern void CXZImageWriteToPhotosAlbum(UIImage *image,
                                       NSString *album,
                                       CXZAlbumSaveHandler completionHandler);

@interface CXZAlbumManager : NSObject

/**
 * @brief 将图片写入相册,使用ALAssetLibrary
 *
 * @param  image    需要写入的图片
 * @param  album    相册名称，如果相册不存在，则新建相册
 * @param  completionHandler 回调
 */
- (void)saveImage:(UIImage *)image
          toAlbum:(NSString *)album
completionHandler:(CXZAlbumSaveHandler)completionHandler;

@end
