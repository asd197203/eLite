//
//  XBConstants.h
//  eLite
//
//  Created by 常小哲 on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_ID [NSString stringWithFormat:@"%@", [XBUserDefault sharedInstance].resModel.userid]

#define Image_URL(__url__)   [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl, __url__]]

#define USER_CacheRoot    [SandBox_Caches stringByAppendingPathComponent:USER_ID]
#define USER_CacheFilePath(__fileName__)     [USER_CacheRoot stringByAppendingPathComponent:__fileName__]




// UI
#define kHomeworkWordCellLabelMaxWidth  Screen_Width-(10+10+10+30)-10-10
CXZ_EXTERN CGFloat const kCommonButtonHeight; //!< 按钮的统一高度


// 通知
CXZ_EXTERN NSString *const kCDNotificationMyFriendListRefresh;
CXZ_EXTERN NSString *const kCDNotificationGetMyFriendListRefresh;


// APP id
CXZ_EXTERN NSString *const xfyun_App_id;

