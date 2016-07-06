//
//  CXZKVOHelper.m
//  Test0118
//
//  Created by Crz on 16/1/21.
//  Copyright © 2016年 Ranger. All rights reserved.
//

#import "CXZKVOHelper.h"
#import <objc/runtime.h>

@interface CXZKVOHelper () {
    @package
    __weak id               _target;       ///< 被观察的对象的值改变时后, target会调用响应方法
    __weak id               _sourceObject; ///< 被观察的对象
    SEL                     _selector;     ///< 被观察的对象的值改变时后的响应方法
    CXZKeyValueChangedBlock _block;        ///< 值改变时执行的block
    NSString                *_keyPath;     ///< 被观察的对象的keyPath
}

@end

@implementation CXZKVOHelper

- (void)dealloc {
    if (_sourceObject)
        [_sourceObject removeObserver:self forKeyPath:_keyPath];
}

- (instancetype)initWithObject:(id)anObject keyPath:(NSString *)keyPath target:(id)target selector:(SEL)aSelector {
    if (self == [super init]) {
        _sourceObject = anObject;
        _keyPath      = keyPath;
        _target       = target;
        _selector     = aSelector;
        [_sourceObject addObserver:self
                        forKeyPath:keyPath
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:nil];
    }
    return self;
}

- (instancetype)initWithObject:(id)anObject keyPath:(NSString *)keyPath block:(CXZKeyValueChangedBlock)block {
    if (self = [super init]) {
        _sourceObject = anObject;
        _keyPath      = keyPath;
        _block        = block;
        [_sourceObject addObserver:self
                        forKeyPath:keyPath
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:nil];
    }

    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (_block) {
        _block(change[NSKeyValueChangeNewKey], change[NSKeyValueChangeOldKey]);
    }else {
        [_target performSelector:_selector withObject:_sourceObject withObject:change];
    }
}

#pragma clang diagnostic pop


@end

@implementation NSObject (KVOHelper)

static const char *NSObject_observers = "KVO_Container";

- (NSMutableDictionary *)kvoContainer {
    return objc_getAssociatedObject(self, NSObject_observers) ?: ({
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, NSObject_observers, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic;
    });
}

#pragma mark-  add ovserver

- (void)cxz_observe:(id)anObject keyPath:(NSString *)keyPath target:(id)target selector:(SEL)aSelector {
    NSAssert([target respondsToSelector:aSelector], @"selector & target 必须存在");
    NSAssert(keyPath.length > 0, @"keyPath 不能为空");
    NSAssert(anObject, @"被观察的对象object 必须存在");
    CXZKVOHelper *observer = [[CXZKVOHelper alloc] initWithObject:anObject
                                                          keyPath:keyPath
                                                           target:target
                                                         selector:aSelector];

    NSString *key = [NSString stringWithFormat:@"%@_%@", anObject, keyPath];
    self.kvoContainer[key] = observer;
}

- (void)cxz_observe:(id)anObject keyPath:(NSString *)keyPath block:(CXZKeyValueChangedBlock)block {
    NSAssert(block, @"block 必须存在");
    NSAssert(keyPath.length > 0, @"keyPath 不能为空");
    NSAssert(anObject, @"被观察的对象object 必须存在");

    CXZKVOHelper *observer = [[CXZKVOHelper alloc] initWithObject:anObject
                                                          keyPath:keyPath
                                                            block:block];

    NSString *key = [NSString stringWithFormat:@"%@_%@", anObject, keyPath];
    self.kvoContainer[key] = observer;
}

#pragma mark-  remove observer

- (void)cxz_removeObserver:(id)anObject keyPath:(NSString *)keyPath {
    NSString *key = [NSString stringWithFormat:@"%@_%@", anObject, keyPath];
    [self.kvoContainer removeObjectForKey:key];
}

- (void)cxz_removeObserver:(id)anObject {
    NSString *prefix = [NSString stringWithFormat:@"%@", anObject];
    [self.kvoContainer enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([key hasPrefix:prefix]) {
            [self.kvoContainer removeObjectForKey:key];
        }
    }];

}

- (void)cxz_removeAllObserver {
    [self.kvoContainer removeAllObjects];
}

@end
