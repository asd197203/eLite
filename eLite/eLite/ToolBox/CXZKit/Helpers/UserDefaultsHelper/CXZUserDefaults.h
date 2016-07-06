//
//  CXZUserDefaults.h
//  CXZ
//
//  Created by Crz on 15/12/3.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXZUserDefaults : NSObject

@property (nonatomic, assign) BOOL isLogin; //!< 是否已经登录过了
@property (nonatomic, copy) NSString *currentUserAccount; //!< 当前登录的用户帐号 也是手机号
@property (nonatomic, assign) BOOL needCheckAddBuddy; //!< 添加我为好友是否需要验证
@property (nonatomic, assign) BOOL canSeekMeByPhoneNumber; //!< 可通过手机号搜索到我
@property (nonatomic, assign) BOOL needRecommendFriendOfContacts; //!< 想是否需要推荐通讯录好友
@property (nonatomic, assign) BOOL isEarphoneMode;  //!< 是否开启听筒模式
@property (nonatomic, assign) BOOL openSound; //!< 是否开启声音提醒
@property (nonatomic, assign) BOOL openShock; //!< 是否开启震动提醒
@property (nonatomic, assign) BOOL showMsgDetailByNotification; //!< 通知是否显示消息详情

/** 非单例 */
+ (instancetype)setup;

/** 根据key删除一条userDefault数据 */
+ (void)removeObjectForKey:(NSString *)key;

/** 批量删除指定userDefault数据 */
+ (void)removeObjectsForKeys:(NSArray *)keys;

/** 清空userDefault所有数据 */
+ (void)cleanUserdefaults;


@end
