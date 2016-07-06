//
//  CXZSelectAvatarController.h
//  Test1208
//
//  Created by 常小哲 on 15/12/8.
//  Copyright © 2015年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CXZGetSelectedPictureBlock)(UIImage *selectedImage);

@protocol CXZSelectAvatarControllerDelegate;



@interface CXZSelectAvatarController : UIViewController

@property (nonatomic, weak) id<CXZSelectAvatarControllerDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller;

- (void)show;
- (void)showForPicture:(CXZGetSelectedPictureBlock)takePicture;

@end

@protocol CXZSelectAvatarControllerDelegate <NSObject>

@optional
- (void)getSelectedPicture:(UIImage *)image;

@end