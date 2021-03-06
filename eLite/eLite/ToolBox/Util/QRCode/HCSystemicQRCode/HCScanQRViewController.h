//
//  HCScanQRViewController.h
//  HCSystemicQRCodeDemo
//
//  Created by Caoyq on 16/5/4.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^successBlock)(NSString *QRCodeInfo);

@protocol HCScanQRViewControllerDelegate <NSObject>

- (void)successfulGetCodeInfo:(NSString*)info;
@end

@interface HCScanQRViewController : UIViewController

@property (strong, nonatomic) successBlock block;
@property (nonatomic,weak)id<HCScanQRViewControllerDelegate>delegate;
/**
 *将扫码成功后获得的 二维码/条形码 信息进行回传
 */
- (void)successfulGetQRCodeInfo:(successBlock)success;

@end
