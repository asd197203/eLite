//

//  AppDelegate.m

//  eLite

//

//  Created by lxx on 16/4/11.

//  Copyright © 2016年 lxx. All rights reserved.

//



#import "AppDelegate.h"
#import "XBTabBarController.h"
#import "XBLoginViewController.h"
#import "XBRegisterViewController.h"
#import "XBNavigationViewController.h"
#import "CDCommon.h"
#import "CDLoginVC.h"
#import "CDAbuseReport.h"
#import "CDCacheManager.h"
#import "CYLTabBarControllerConfig.h"
#import "CDUtils.h"
#import "CDAddRequest.h"
#import "CDIMService.h"
#import "LZPushManager.h"
#import <iRate/iRate.h>
#import <iVersion/iVersion.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
#import <OpenShare/OpenShareHeader.h>
#import "MBProgressHUD.h"
#import <SMS_SDK/SMSSDK.h>
#import "XBUser.h"
#import "XBUserDefault.h"
#import "CDUserManager.h"
#import "XBUserDefault.h"
#import "iflyMSC/IFlyMSC.h"


@interface AppDelegate ()

@property(nonatomic,strong)XBLoginViewController *loginVC;
//@property(nonatomic,strong)CDLoginVC *loginVC;

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 讯飞
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];

    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];

    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", xfyun_App_id];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

    
    
    [SMSSDK registerApp:@"11dc50470296c" withSecret:@"fc88b5d4b9401c03675c90fb02f47adb"];
    
    [CDAddRequest registerSubclass];
    [CDAbuseReport registerSubclass];
    
#if USE_US
    
    [AVOSCloud useAVCloudUS];
    
#endif

    // Enable Crash Reporting
    
    [AVOSCloudCrashReporting enable];
    
    //希望能提供更详细的日志信息，打开日志的方式是在 AVOSCloud 初始化语句之后加上下面这句：
    //Objective-C
    
#ifndef __OPTIMIZE__
    
    [AVOSCloud setAllLogsEnabled:YES];
    
#endif
    [AVOSCloud setApplicationId:AVOSAppID clientKey:AVOSAppKey];
    
    //    [AVOSCloud setApplicationId:CloudAppId clientKey:CloudAppKey];
    
    //    [AVOSCloud setApplicationId:PublicAppId clientKey:PublicAppKey];
    [AVOSCloud setLastModifyEnabled:YES];
    if (SYSTEM_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor hexStringToColor:@"#353B3B"]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
    }
    else {
        
        [[UINavigationBar appearance] setTintColor:[UIColor hexStringToColor:@"#353B3B"]];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          
                                                          [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    [self.window makeKeyAndVisible];

    [self mainController];
    [[LZPushManager manager] registerForRemoteNotification];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self initAnalytics];
#ifdef DEBUG
    
    [AVPush setProductionMode:NO];  // 如果要测试申请好友是否有推送，请设置为 YES
    
    //    [AVOSCloud setAllLogsEnabled:YES];
    
#endif
    
    return YES;
}

- (void)initAnalytics {
    [AVAnalytics setAnalyticsEnabled:YES];
#ifdef DEBUG
    [AVAnalytics setChannel:@"Debug"];
#else
    [AVAnalytics setChannel:@"App Store"];
#endif
    // 应用每次启动都会去获取在线参数，这里同步获取即可。可能是上一次启动获取得到的在线参数。不过没关系。
    NSDictionary *configParams = [AVAnalytics getConfigParams];
    DLog(@"configParams: %@", configParams);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[LZPushManager manager] syncBadge];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[[LZPushManager manager] cleanBadge];
    [application cancelAllLocalNotifications];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [[LZPushManager manager] syncBadge];
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AVOSCloudIM handleRemoteNotificationsWithDeviceToken:deviceToken];
    [[LZPushManager manager] saveInstallationWithDeviceToken:deviceToken userId:[AVUser currentUser].objectId];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"%@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive) {
        
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    }
    else {
        //  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
        //        {
        //            aps =     {
        //                alert = "lzwios : sdfsdf";
        //                badge = 4;
        //                sound = default;
        //            };
        //            convid = 55bae86300b0efdcbe3e742e;
        //        }
        [[CDChatManager manager] didReceiveRemoteNotification:userInfo];
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];

    }
    DLog(@"receiveRemoteNotification");
}
-(void)toLogin
{
    CDLoginVC *VC = [[CDLoginVC alloc]init];
    self.window.rootViewController = VC;
}
- (void)toMain {
    [iRate sharedInstance].applicationBundleID = @"com.avoscloud.leanchat";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].previewMode = NO;
    [iVersion sharedInstance].applicationBundleID = @"com.avoscloud.leanchat";
    [iVersion sharedInstance].previewMode = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[CDCacheManager manager] registerUsers:@[[AVUser currentUser]]];
    [CDChatManager manager].userDelegate = [CDIMService service];
    
#ifdef DEBUG
#warning 使用开发证书来推送，方便调试，具体可看这个变量的定义处
    [CDChatManager manager].useDevPushCerticate = YES;
#endif
    //提示正在登陆
    [self toast:@"正在登陆" duration:MAXFLOAT];
    [[CDChatManager manager] openWithClientId:[AVUser currentUser].objectId callback: ^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if (succeeded) {
            
            _window.rootViewController = [[XBTabBarController alloc] init];
        } else {
            
            [self toLogin];
            DLog(@"%@", error);
        }
    }];
}
- (void)toast:(NSString *)text duration:(NSTimeInterval)duration {
    
    [AVAnalytics event:@"toast" attributes:@{@"text": text}];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud hide:YES afterDelay:duration];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url

{
    [AVOSCloudSNS handleOpenURL:url];
    [OpenShare handleOpenURL:url];
    [[IFlySpeechUtility getUtility] handleOpenURL:url];

    return YES;
}

- (void)mainController {
    [self toast:@"正在登陆" duration:MAXFLOAT];
    if ([[XBUserDefault sharedInstance] isAvailable]) {
        //此段代码别删，先放在这里
//        if([AVUser currentUser]==nil)
//        {
//            //此前去注册leancloud失败了，再次注册
//            [[CDUserManager manager] registerWithUsername:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid] phone:nil password:@"123456" block:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    NSString *str =[NSString stringWithFormat:@"注册成功,您的账号是%@",resq.data[@"userid"]];
//                    ALERT_ONE(str);
//                    alert.delegate = self;.
//                }
//                else
//                {
//                    ALERT_ONE(@"注册失败,请重新注册");
//                }
//            }];
//        }
            [[CDCacheManager manager] registerUsers:@[[AVUser currentUser]]];
        [CDChatManager manager].userDelegate = [CDIMService service];
        [[CDChatManager manager] openWithClientId:[AVUser currentUser].objectId callback: ^(BOOL succeeded, NSError *error) {
            [self hideProgress];
            if (succeeded) {
                _window.rootViewController = [[XBTabBarController alloc] init];
            } else {
                XBNavigationViewController *nav = [[XBNavigationViewController alloc] initWithRootViewController:[[XBLoginViewController  alloc] init]];
                _window.rootViewController = nav;
                DLog(@"%@", error);
            }
        }];
        
    }else {
        [self hideProgress];
        XBNavigationViewController *nav = [[XBNavigationViewController alloc] initWithRootViewController:[[XBLoginViewController  alloc] init]];
        _window.rootViewController = nav;
    }
}
- (void)loginController {
    if ([[XBUserDefault sharedInstance] isAvailable]) {
        //此段代码别删，先放在这里
        //        if([AVUser currentUser]==nil)
        //        {
        //            //此前去注册leancloud失败了，再次注册
        //            [[CDUserManager manager] registerWithUsername:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid] phone:nil password:@"123456" block:^(BOOL succeeded, NSError *error) {
        //                if (succeeded) {
        //                    NSString *str =[NSString stringWithFormat:@"注册成功,您的账号是%@",resq.data[@"userid"]];
        //                    ALERT_ONE(str);
        //                    alert.delegate = self;.
        //                }
        //                else
        //                {
        //                    ALERT_ONE(@"注册失败,请重新注册");
        //                }
        //            }];
        //        }
        [[CDCacheManager manager] registerUsers:@[[AVUser currentUser]]];
        [CDChatManager manager].userDelegate = [CDIMService service];
        AVIMClientOpenOption *option = [[AVIMClientOpenOption alloc] init];
        option.force = YES;
        [[CDChatManager manager] openWithClientId:[AVUser currentUser].objectId callback: ^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                _window.rootViewController = [[XBTabBarController alloc] init];
            } else {
                XBNavigationViewController *nav = [[XBNavigationViewController alloc] initWithRootViewController:[[XBLoginViewController  alloc] init]];
                _window.rootViewController = nav;
                DLog(@"%@", error);
            }
        }];
        
    }else {
        XBNavigationViewController *nav = [[XBNavigationViewController alloc] initWithRootViewController:[[XBLoginViewController  alloc] init]];
        _window.rootViewController = nav;
    }
}
#pragma mark-   Setter & Getter
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:Screen_Bounds];
        _window.rootViewController = [[UIViewController alloc]init];
        _window.backgroundColor = Color_White;
    }
    return _window;
}
@end

