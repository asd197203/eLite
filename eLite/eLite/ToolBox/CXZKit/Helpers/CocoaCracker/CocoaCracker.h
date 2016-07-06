//
//  CocoaCracker.h
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface CocoaCracker : NSObject

+ (instancetype)handle:(Class)cls;
- (instancetype)initWithClass:(Class)cls;


// copy property
- (void)copyModelPropertyName:(void(^)(NSString *pName))block;

- (void)copyModelPropertyType:(void(^)(NSString *pType))block;
- (void)copyModelPropertyTypeEntirely:(void(^)(NSString *pTypeEntirely))block;

- (void)copyModelPropertyInfo:(void(^)(NSString *pName, NSString *pType))block
            copyAttriEntirely:(BOOL)isCopy;

- (void)copyModelPropertyList:(void(^)(objc_property_t property))propertyBlock;

// swizzle methods
- (BOOL)swizzleMethod:(SEL)oldSelector withMethod:(SEL)newSelector;


@end
