//
//  XBUser.m
//  eLite
//
//  Created by lxx on 16/4/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBUser.h"

@implementation XBUser
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cls forKey:@"cls"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeObject:_hobby forKey:@"hobby"];
    [aCoder encodeObject:_hometown forKey:@"hometown"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_photo forKey:@"photo"];
    [aCoder encodeObject:_school forKey:@"school"];
    [aCoder encodeObject:_userid forKey:@"userid"];
    [aCoder encodeObject:_sign forKey:@"sign"];
    [aCoder encodeObject:_psw forKey:@"psw"];
    [aCoder encodeObject:_messageBgImage forKey:@"messageBgImage"];
}

/** 解码*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.cls = [aDecoder decodeObjectForKey:@"cls"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.sex = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"sex"]];
        self.hobby = [aDecoder decodeObjectForKey:@"hobby"];
        self.hometown = [aDecoder decodeObjectForKey:@"hometown"];
        self.name = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"name"]];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.photo = [aDecoder decodeObjectForKey:@"photo"];
        self.school = [aDecoder decodeObjectForKey:@"school"];
        self.userid = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"userid"]];
        self.sign = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"sign"]];
        self.psw = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"psw"]];
        self.messageBgImage = [aDecoder decodeObjectForKey:@"messageBgImage"];
    }
    return self;
}
@end
