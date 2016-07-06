//
//  XBRegistReq.h
//  eLite
//
//  Created by lxx on 16/4/24.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseReq.h"
@interface XBRegistReq : SBaseReq<POST>
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *pwd;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *school;
@property(nonatomic,copy)NSString *cls;
@property(nonatomic,copy)NSString *hometown;
@property(nonatomic,copy)NSString *hobby;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,strong)NSData *photo;
@end
@interface XBRegistRes : SBaseRes
@property(nonatomic,strong)NSDictionary <Optional>*data;
@end