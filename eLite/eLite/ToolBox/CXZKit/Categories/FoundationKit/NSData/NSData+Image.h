//
//  NSData+Image.h
//  RPAntus
//
//  Created by Crz on 15/11/24.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Image)

/** 判断图片的后缀名 jpg png gif等等 */
- (NSString *)detectImageSuffix;

@end
