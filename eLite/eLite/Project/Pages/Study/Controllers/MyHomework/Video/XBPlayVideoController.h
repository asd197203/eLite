//
//  XBPlayVideoController.h
//  eLite
//
//  Created by 常小哲 on 16/5/8.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBPlayVideoController : UIViewController

//- (instancetype)initWithVideoPath:(NSString *)path;

- (void)addLocationPath:(NSString *)path;
- (void)addRemoteURL:(NSString *)url;

@end
