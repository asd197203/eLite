//
//  XBSettingDetailReq.m
//  eLite
//
//  Created by 常小哲 on 16/4/27.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBSettingDetailReq.h"

#pragma mark-  修改头像
@implementation XBPersonAvatarReq

- (NSString *)url {
    return @"/user/photo";
}

@end

@implementation XBPersonAvatarRes

@end

#pragma mark-  修改昵称
@implementation XBPersonNameReq

- (NSString *)url {
    return @"/user/name";
}

@end

@implementation XBPersonNameRes

@end

#pragma mark-  修改学校
@implementation XBPersonSchoolReq

- (NSString *)url {
    return @"/user/school";
}

@end

@implementation XBPersonSchoolRes

@end

#pragma mark-  修改班级
@implementation XBPersonClassReq

- (NSString *)url {
    return @"/user/class";
}

@end

@implementation XBPersonClassRes

@end

#pragma mark-  修改生日

@implementation XBPersonBirthdayReq

- (NSString *)url {
    return @"/user/birthday";
}

@end

@implementation XBPersonBirthdayRes

@end

#pragma mark-  修改性别

@implementation XBPersonSexReq

- (NSString *)url {
    return @"/user/sex";
}

@end

@implementation XBPersonSexRes

@end

#pragma mark-  修改个性签名

@implementation XBPersonSignReq

- (NSString *)url {
    return @"/user/sign";
}

@end

@implementation XBPersonSignRes

@end
