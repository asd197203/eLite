//
//  XHDisplayLocationViewController.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "XHBaseViewController.h"
#import "XHMessageModel.h"
typedef void(^GetGeolocationsCompledBlock)(NSArray *placemarks,CLLocation*loc);
@interface XHDisplayLocationViewController : XHBaseViewController
@property (nonatomic,assign)BOOL  isLocationMessage;
@property (nonatomic, strong) id<XHMessageModel> message;
@property (nonatomic, copy) GetGeolocationsCompledBlock GetGeolocationsCompledBlock;
@end
