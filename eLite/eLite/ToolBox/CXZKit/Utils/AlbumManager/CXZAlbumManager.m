//
//  CXZAlbumManager.m
//  RPAntus
//
//  Created by 常小哲 on 15/11/24.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "CXZAlbumManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


void CXZImageWriteToPhotosAlbum(UIImage *image,
                                NSString *album,
                                CXZAlbumSaveHandler completionHandler) {
    [[CXZAlbumManager new] saveImage:image
                             toAlbum:album
                   completionHandler:completionHandler];
}

@implementation ALAssetsLibrary (CXZAssetsLibrary)

- (void)writeImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(CXZAlbumSaveHandler)completionHandler {
    [self writeImageToSavedPhotosAlbum:[image CGImage]
                           orientation:(ALAssetOrientation)image.imageOrientation
                       completionBlock:^(NSURL *assetURL, NSError *error) {
                           if (error) {
                               if (completionHandler) {
                                   completionHandler(image, error);
                               }
                           } else {
                               [self addAssetURL:assetURL
                                         toAlbum:album
                               completionHandler:^(NSError *error) {
                                   if (completionHandler) {
                                       completionHandler(image, error);
                                   }
                               }];
                           }
                       }];
}

- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)album completionHandler:(ALAssetsLibraryAccessFailureBlock)completionHandler {
    void (^assetForURLBlock)(NSURL *, ALAssetsGroup *) = ^(NSURL *URL, ALAssetsGroup *group) {
        [self assetForURL:assetURL
              resultBlock:^(ALAsset *asset) {
                  [group addAsset:asset];
                  completionHandler(nil);
              }
             failureBlock:^(NSError *error) { completionHandler(error); }];
    };
    __block ALAssetsGroup *group;
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:^(ALAssetsGroup *_group, BOOL *stop) {
                            if ([album isEqualToString:[_group valueForProperty:ALAssetsGroupPropertyName]]) {
                                group = _group;
                            }
                            if (!_group) {
                                /// 循环结束
                                if (group) {
                                    assetForURLBlock(assetURL, group);
                                } else {
                                    [self addAssetsGroupAlbumWithName:album
                                                          resultBlock:^(ALAssetsGroup *group) { assetForURLBlock(assetURL, group); }
                                                         failureBlock:completionHandler];
                                }
                            }
                        }
                      failureBlock:completionHandler];
}

@end


@interface CXZAlbumManager () {
    ALAssetsLibrary *_assetsLibrary;
}

@end

@implementation CXZAlbumManager

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(CXZAlbumSaveHandler) completionHandler {
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    [_assetsLibrary writeImage:image
                           toAlbum:album
                 completionHandler:^(UIImage *image, NSError *error) {
                     if (completionHandler) {
                         completionHandler(image, error);
                     }
                     /// 注意，这里每次都置空是因为期间如果操作相册了，下次保存之前希望能取到最新状态。
                     _assetsLibrary = nil;
                 }];
}

@end

#pragma clang diagnostic pop
