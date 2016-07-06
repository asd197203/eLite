//
//  CXZSelectAvatarController.m
//  Test1208
//
//  Created by 常小哲 on 15/12/8.
//  Copyright © 2015年 常小哲. All rights reserved.
//

#import "CXZSelectAvatarController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface CXZSelectAvatarController ()<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, copy) CXZGetSelectedPictureBlock takePicture;

@end

@implementation CXZSelectAvatarController

#pragma mark-  init with controller

- (instancetype)initWithController:(UIViewController *)controller {
    if (self == [super init]) {
        [self actionSheet];
        [self addToController:controller];
    }
    return self;
}

#pragma mark-  public methods

- (void)show {
    [_actionSheet showInView:self.view];
}

- (void)showForPicture:(CXZGetSelectedPictureBlock)takePicture {
    [self show];
    _takePicture = ^(UIImage *selectedImage) {
        takePicture(selectedImage);
    };
}

#pragma mark-  UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag != 10086) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    switch (buttonIndex) {
            // 相机
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                NSLog(@"相机功能不可用");
                return;
            }
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        }
            // 图库
        case 1: {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
            // 取消
        case 2: {
            [self removeFromController];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (SafeRun_Delegate_Default(@selector(getSelectedPicture:))) {
        [_delegate getSelectedPicture:image];
    }else {
        if (_takePicture) {
            _takePicture(image);
        }
    }
    [self removeFromController];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self removeFromController];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-  utils

- (void)addToController:(UIViewController *)controller {
    [controller.view addSubview:self.view];
    [controller addChildViewController:self];
}

- (void)removeFromController {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark-   Setter & Getter

- (UIActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照", @"我的相册",nil];
        _actionSheet.tag = 10086;
        _actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }
    return _actionSheet;
}

@end

#pragma clang diagnostic pop

