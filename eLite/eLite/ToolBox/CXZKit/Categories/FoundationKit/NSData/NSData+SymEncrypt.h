//
//  NSData+SymEncrypt.h
//  RPAntus
//
//  Created by Crz on 15/12/15.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SymEncrypt)

/** 3des加密 */
@property (nonatomic,copy,readonly) NSData *des3_enc;
/** 3des解密 */
@property (nonatomic,copy,readonly) NSData *des3_dec;

@end
