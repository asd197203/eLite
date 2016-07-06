//
//  NSString+Roster.h
//  RPAntus
//
//  Created by Crz on 15/11/20.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Roster)

/** 第一个字符 为字母就大写 其他符号替换为# */
@property (nonatomic, copy, readonly) NSString *firstLetter;

/** 是否包含汉字 */
@property (nonatomic, assign, readonly) BOOL containChinese;

/** 汉字转拼音 */
@property (nonatomic, copy, readonly) NSString *translateChineseIntoSpelling;


///** 是否包含汉字 */
//- (BOOL)isContainChinese;

/** 汉字转拼音 */
//- (NSString *)translateChineseIntoSpelling;

// 两种取首字母的方法
/** 取联系人名字第一个字符  为字母就大写 不为字母照旧 */
//- (NSString *)getInitialToUpper;

///** 取联系人名字第一个字符 为字母就大写 其他符号替换为# */
//- (NSString *)getFirstLetter;

@end
