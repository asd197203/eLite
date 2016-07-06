//
//  CXZKVOHelper.h
//  Test0118
//
//  Created by Crz on 16/1/21.
//  Copyright © 2016年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CXZKeyValueChangedBlock)(id newValue, id oldValue);

@interface CXZKVOHelper : NSObject{} @end



@interface NSObject (KVOHelper)

@property (nonatomic, readonly, strong) NSMutableDictionary *kvoContainer;

/*  selector 需要在target中手动实现 形式为 - (void)xxxMethod:(id)anObject change:(id)change
    anObject 为被观察的对象  
    change是一个字典
 */

- (void)cxz_observe:(id)anObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)aSelector;
- (void)cxz_observe:(id)anObject keyPath:(NSString*)keyPath block:(CXZKeyValueChangedBlock)block;

- (void)cxz_removeObserver:(id)anObject keyPath:(NSString *)keyPath;
- (void)cxz_removeObserver:(id)anObject;
- (void)cxz_removeAllObserver;


@end