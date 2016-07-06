//
//  CocoaCracker.m
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "CocoaCracker.h"

#ifdef DEBUG
# define CCLog(...) NSLog(__VA_ARGS__);
#else
# define CCLog(...);
#endif

@interface CocoaCracker () {
    Class _targetCls;
}

@end

@implementation CocoaCracker

+ (instancetype)handle:(Class)cls {
    return [[self alloc] initWithClass:cls];
}

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        _targetCls = cls;
    }
    return self;
}

#pragma mark-  copy property

- (void)copyModelPropertyName:(void(^)(NSString *pName))block {
    [self copyModelPropertyInfo:^(NSString *pName, NSString *pType) {
        SafeRun_Block(block, pName);
    } copyAttriEntirely:NO];
}


- (void)copyModelPropertyType:(void(^)(NSString *pType))block {
    [self copyModelPropertyInfo:^(NSString *pName, NSString *pType) {
        SafeRun_Block(block, pType);
    } copyAttriEntirely:NO];
}

- (void)copyModelPropertyTypeEntirely:(void(^)(NSString *pTypeEntirely))block {
    [self copyModelPropertyInfo:^(NSString *pName, NSString *pTypeEntirely) {
        SafeRun_Block(block, pTypeEntirely);
    } copyAttriEntirely:YES];
}

- (void)copyModelPropertyInfo:(void(^)(NSString *pName, NSString *pTypeEntirely))block
            copyAttriEntirely:(BOOL)isCopy {
    [self copyModelPropertyList:^(objc_property_t property) {
        NSString *pName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *pType;
        if (isCopy)
            pType = [NSString stringWithUTF8String:property_getAttributes(property)];
        else
            pType = [NSString stringWithUTF8String:property_copyAttributeValue(property, "T")];
        
        SafeRun_Block(block, pName, pType);
    }];
}

- (void)copyModelPropertyList:(void(^)(objc_property_t property))propertyBlock {
    if (!_targetCls) {
        CCLog(@"ERROR: [%@] 为空", _targetCls);
        return;
    }
    u_int count;
    objc_property_t *properties = class_copyPropertyList(_targetCls, &count);
    for (u_int i = 0; i < count; i++) {
        SafeRun_Block(propertyBlock, properties[i]);
    }
    
    free(properties);
}

#pragma mark-  swizzle methods

- (BOOL)swizzleMethod:(SEL)oldSelector withMethod:(SEL)newSelector {
    
    Method oldMethod = class_getInstanceMethod(_targetCls, oldSelector);
    Method newMethod = class_getInstanceMethod(_targetCls, newSelector);
    
    BOOL didAddMethod = class_addMethod(_targetCls,
                                        oldSelector,
                                        method_getImplementation(newMethod),
                                        method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(_targetCls,
                            newSelector,
                            method_getImplementation(oldMethod),
                            method_getTypeEncoding(oldMethod));
    } else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
    return didAddMethod;
}

@end
