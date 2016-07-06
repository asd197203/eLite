//
//  NSString+AsymEncrypt.h
//  RPAntus
//
//  Created by Crz on 15/11/20.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AsymEncrypt)

@property (nonatomic, copy, readonly) NSString *base64encode;
@property (nonatomic, copy, readonly) NSString *MD5;
@property (nonatomic, copy, readonly) NSString *SHA1;
@property (nonatomic, copy, readonly) NSString *SHA256;

//- (NSString*) base64encode;
//- (NSString*) MD5;
//- (NSString*) SHA1;
//- (NSString*) SHA256;


@end
