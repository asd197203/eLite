//
//  CXZNotificationHelper.m
//  TTAntusheng
//
//  Created by Crz on 15/12/1.
//  Copyright © 2015年 Crz. All rights reserved.
//

#import "CXZNotificationHelper.h"
#import <objc/runtime.h>

@interface CXZNotificationHelper () {
    @package
    __weak id            _notiTarget;     //!< 处理通知那个类的实例 用来调用接受通知后的方法
    __weak id            _postNotiObject; //!< 通知的来源 即谁发的通知 为nil时接受所有的通知
    SEL                  _notiSelector;   //!< 接受到通知后调用的方法
    CXZNotificationBlock _block;          //!< 传递参数的回调
    NSString            *_notiName;       //!< 通知的名字
    NSDictionary        *_userInfo;       //!< 通知传递的参数NSNotification的属性 类型为字典
    
}

@end

@implementation CXZNotificationHelper

- (void)dealloc {
    [CXZNoti_Center removeObserver:self name:_notiName object:nil];
}

- (instancetype)initWithName:(NSString *)aName target:(id)target selector:(SEL)aSelector object:(id)anObject {
    if (self == [super init]) {
        _notiTarget = target;
        _notiSelector = aSelector;
        _notiName = aName;
        _postNotiObject = anObject;

        [CXZNoti_Center addObserver:self
                           selector:@selector(handleNotification:)
                               name:aName
                             object:anObject];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)aName object:(id)anObject block:(CXZNotificationBlock)block {
    if (self == [super init]) {
        _notiName = aName;
        _postNotiObject = anObject;
        _block  = block;
        [CXZNoti_Center addObserver:self
                           selector:@selector(handleNotification:)
                               name:aName
                             object:anObject];
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)handleNotification:(NSNotification *)notification {
    if (_block) {
        _block(notification);
    }else {
        [_notiTarget performSelector:_notiSelector withObject:notification];
    }
}

#pragma clang diagnostic pop

@end


@implementation NSObject (NotificationHelper)

static const char *Notification_Container = "Notification_Container";

- (NSMutableDictionary *)notiContainer {
    return objc_getAssociatedObject(self, Notification_Container) ?: ({
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, Notification_Container, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic;
    });
}
#pragma mark-  add observer of notification

- (void)cxz_observeNotification:(NSString *)aName block:(CXZNotificationBlock)block {
    [self cxz_observeNotification:aName object:nil block:block];
}

- (void)cxz_observeNotification:(NSString *)aName object:(id)anObject block:(CXZNotificationBlock)block {
    NSAssert(block, @"block 必须存在");
    NSAssert(aName.length > 0, @"NotificationName 不能为空");

    CXZNotificationHelper *notification = [[CXZNotificationHelper alloc] initWithName:aName
                                                                               object:anObject
                                                                                block:block];
    NSString *key = [NSString stringWithFormat:@"%@", aName];
    self.notiContainer[key] = notification;
}

- (void)cxz_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector {

    [self cxz_observeNotification:aName target:target selector:aSelector object:nil];
}

- (void)cxz_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector object:(id)anObject {
    NSAssert([target respondsToSelector:aSelector], @"selector & target 必须存在");
    NSAssert(aName.length > 0, @"NotificationName 不能为空");

    CXZNotificationHelper *notification = [[CXZNotificationHelper alloc] initWithName:aName
                                                                               target:target
                                                                             selector:aSelector
                                                                               object:anObject];

    NSString *key = [NSString stringWithFormat:@"%@", aName];
    self.notiContainer[key] = notification;
}

#pragma mark-  post notification

- (void)cxz_postNotification:(NSString *)aName {
    [self cxz_postNotification:aName object:nil userInfo:nil];
}

- (void)cxz_postNotification:(NSString *)aName object:(id)anObject {
    [self cxz_postNotification:aName object:anObject userInfo:nil];
}

- (void)cxz_postNotification:(NSString *)aName userInfo:(NSDictionary *)aUserInfo {
    [self cxz_postNotification:aName object:nil userInfo:aUserInfo];
}

- (void)cxz_postNotification:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CXZNoti_Center postNotificationName:aName object:anObject userInfo:aUserInfo];
    });
}

#pragma mark- remove notification

- (void)cxz_removeNotification:(NSString *)aName {
    [self.notiContainer removeObjectForKey:aName];
}

- (void)cxz_removeAllNotification {
    [self.notiContainer removeAllObjects];
}


@end