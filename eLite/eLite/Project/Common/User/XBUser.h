//
//  XBUser.h
//  eLite
//
//  Created by lxx on 16/4/26.
//  Copyright © 2016年 lxx. All rights reserved.
//
#import "AVUser.h"

@interface XBUser : AVUser<NSCoding>
@property (nonatomic, strong) NSString *cls; //!< 班级
@property (nonatomic, strong) NSString *hobby; //!< 爱好
@property (nonatomic, strong) NSString *hometown; //!< 家乡
@property (nonatomic, strong) NSString *name; //!< 名字
@property (nonatomic, strong) NSString *phone; //!< 电话
@property (nonatomic, strong) NSString *photo; //!< 头像
@property (nonatomic, strong) NSString *school; //!< 学校
@property (nonatomic, strong) NSString *sex; //!< 性别
@property (nonatomic, strong) NSString *userid; //!< 用户id
@property (nonatomic, strong) NSString *sign; //!< 标签
@property (nonatomic, strong) NSString *birthday; //!< 生日
@property (nonatomic, strong) NSString *psw; //!< 密码
@property (nonatomic,strong)UIImage *messageBgImage;//聊天背景
@end
