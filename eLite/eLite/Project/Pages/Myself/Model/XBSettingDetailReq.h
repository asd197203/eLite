//
//  XBSettingDetailReq.h
//  eLite
//
//  Created by 常小哲 on 16/4/27.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

#pragma mark-  修改头像

@interface XBPersonAvatarReq : SBaseReq<POST>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, strong) NSData *photo;

@end

@interface XBPersonAvatarRes : SBaseRes

@property(nonatomic, copy) NSString <Optional>*data;

@end

#pragma mark-  修改昵称

@interface XBPersonNameReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *name;

@end

@interface XBPersonNameRes : SBaseRes

@property(nonatomic, copy) NSString <Optional>*data;

@end

#pragma mark-  修改学校

@interface XBPersonSchoolReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *school;

@end

@interface XBPersonSchoolRes : XBPersonNameRes

@end

//@interface XBPersonSchoolRes : SBaseRes
//
//@property(nonatomic, copy) NSString <Optional>*data;
//
//@end

#pragma mark-  修改班级

@interface XBPersonClassReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *cls;

@end

@interface XBPersonClassRes : XBPersonNameRes

@end

//@interface XBPersonClassRes : SBaseRes
//
//@property(nonatomic, copy) NSString <Optional>*data;
//
//@end

#pragma mark-  修改生日

@interface XBPersonBirthdayReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *birthday;

@end

@interface XBPersonBirthdayRes : XBPersonNameRes

@end

//@interface XBPersonBirthdayRes : SBaseRes
//
//@property(nonatomic, copy) NSString <Optional>*data;
//
//@end

#pragma mark-  修改性别

@interface XBPersonSexReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *sex;

@end

@interface XBPersonSexRes : XBPersonNameRes

@end

//@interface XBPersonSexRes : SBaseRes
//
//@property(nonatomic, copy) NSString <Optional>*data;
//
//@end

#pragma mark-  修改个性签名

@interface XBPersonSignReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *sign;

@end

@interface XBPersonSignRes : XBPersonNameRes

@end

//@interface XBPersonSignRes : SBaseRes
//
//@property(nonatomic, copy) NSString <Optional>*data;
//
//@end

