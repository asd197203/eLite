//
//  CXZNotificationHelper.h
//  TTAntusheng
//
//  Created by Crz on 15/12/1.
//  Copyright © 2015年 Crz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CXZNotificationBlock)(NSNotification *notification);

#define CXZNoti_Center    [NSNotificationCenter defaultCenter]

@interface CXZNotificationHelper : NSObject{} @end


 
@interface NSObject (NotificationHelper)

@property (nonatomic, readonly, strong) NSMutableDictionary *notiContainer;

- (void)cxz_observeNotification:(NSString *)aName block:(CXZNotificationBlock)block;
- (void)cxz_observeNotification:(NSString *)aName object:(id)anObject block:(CXZNotificationBlock)block;
- (void)cxz_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector;
- (void)cxz_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector object:(id)anObject;

//----------------------------------通知默认在主线程发送----------------------------------
- (void)cxz_postNotification:(NSString *)aName;
- (void)cxz_postNotification:(NSString *)aName object:(id)anObject;
- (void)cxz_postNotification:(NSString *)aName userInfo:(NSDictionary *)aUserInfo;
- (void)cxz_postNotification:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

- (void)cxz_removeNotification:(NSString *)aName;
- (void)cxz_removeAllNotification;

@end