//
//  NSString+SymEncrypt.h
//  RPAntus
//
//  Created by Crz on 15/11/20.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SymEncrypt)

/** 3des加密 */
@property (nonatomic,copy,readonly) NSString *des3_enc;
/** 3des解密 */
@property (nonatomic,copy,readonly) NSString *des3_dec;

//- (NSString *)des3_enc;
//- (NSString *)des3_dec;

@end
