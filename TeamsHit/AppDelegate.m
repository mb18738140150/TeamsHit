//
//  AppDelegate.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TeamsHitNavigationViewController.h"
#import "NSDictionary+Unicode.h"
#import "JRSwizzle.h"

#import "ConfigurationWiFiViewController.h"
#import "ConfigurationWiFiSecondViewController.h"
#import "MyTabBarController.h"

#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
#import "UIColor+RCColor.h"
#import "RCWKNotifier.h"
#import "RCWKRequestHandler.h"
#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDTestMessage.h"
#import "RCDUtilities.h"
#import "MobClick.h"
#import "RCFriendCircleUserInfo.h"
#import "WXApiManager.h"
#import <sys/utsname.h>
#import "WelcomeViewController.h"
#import "BragGameChatViewController.h"

//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>

//#define RONGCLOUD_IM_APPKEY @"8luwapkvu3wol" // 测试 
#define RONGCLOUD_IM_APPKEY @"8brlm7ufrwl93"// 正式

#define UMENG_APPKEY @"563755cbe0f55a5cb300139c"

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)

@interface AppDelegate ()<RCWKAppInfoProvider>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (nil != remoteNotification) {
        NSLog(@"remoteNotification = %@", remoteNotification);
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersions = [defaults stringForKey:@"lastVersions"];
    NSString *newVersions = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    
    if ([newVersions isEqualToString:lastVersions]) {//版本相同
        //设置跟视图控制器
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
            NSString * accountNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountNumber"];
            NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
            if (accountNumber && password) {
                __weak typeof(self) weakself = self;
                NSDictionary * jsonDic = @{
                                           @"Account":accountNumber,
                                           @"Password":password,
                                           };
                [[HDNetworking sharedHDNetworking] POST:@"user/login" parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
                    ;
                } success:^(id  _Nonnull responseObject) {
                    
                    NSLog(@"**%@", responseObject);
                    
                    if ([[responseObject objectForKey:@"Code"] intValue] != 200) {
                        [weakself pushLoginVC];
                    }else
                    {
                        [UserInfo shareUserInfo].userToken = [responseObject objectForKey:@"UserToken"];
                        [UserInfo shareUserInfo].rongToken = [responseObject objectForKey:@"RongToken"];
                        
                        RCUserInfo *user = [RCUserInfo new];
                        user.userId = [NSString stringWithFormat:@"%@", responseObject[@"UserId"]];
                        //            user.name = [NSString stringWithFormat:@"name%@", [NSString stringWithFormat:@"%@", responseObject[@"UserId"]]];
                        user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                        [RCIM sharedRCIM].currentUserInfo = user;
                        [RCDHTTPTOOL refreshUserInfoByUserID:[NSString stringWithFormat:@"%@", responseObject[@"UserId"]]];
                        // 连接融云服务器
                        [[RCIM sharedRCIM] connectWithToken:[UserInfo shareUserInfo].rongToken success:^(NSString *userId) {
                            NSLog(@"连接融云成功");
                            [weakself pushTabBarVC];
                        } error:^(RCConnectErrorCode status) {
                            NSLog(@"连接融云失败");
                            [weakself pushLoginVC];
                        } tokenIncorrect:^{
                            NSLog(@"IncorrectToken");
                            [weakself pushLoginVC];
                            
                        }];
                        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogin"];
                        
                        // 同步好友列表
                        NSString * url = [NSString stringWithFormat:@"%@userinfo/getFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
                        [RCDDataSource syncFriendList:url complete:^(NSMutableArray *friends) {}];
                        
                        // 同步组群
                        [RCDDataSource syncGroups];
                        [weakself pushTabBarVC];
                    }
                    
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"error = %@", error);
                    [weakself pushLoginVC];
                }];
            }else
            {
                LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                self.window.rootViewController = nav;
            }
        }else
        {
            [self pushLoginVC];
        }
        [self.window makeKeyAndVisible];
        
    } else {
        //设置介绍APP界面为跟视图()
        
        WelcomeViewController * welcomeVC = [[WelcomeViewController alloc]init];
        self.window.rootViewController = welcomeVC;
        
        //并储存新版本号
        [defaults setObject:newVersions forKey:@"lastVersions"];
        [defaults synchronize];
    }
    
    [WXApi registerApp:@"wxac84b8b5d1acbad9"];
    
    // 崩溃日志检测
//    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
//    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Buglogfile"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Buglogfile"] length] != 0) {
//        [self sendLogMessage:[[NSUserDefaults standardUserDefaults] objectForKey:@"Buglogfile"]];
//    }
    
    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"af86174cc19c1c7082246dd966c64a97"];
    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"af86174cc19c1c7082246dd966c64a97"];
    
    // 初始化语音包
    [self configIFlySpeech];
    
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
    // 重定向log到本地
    [self redirectNSlogToDocumentFolder];
    [self umengTrack];
    
    BOOL debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"rongcloud appkey debug"];
    //debugMode是为了切换appkey测试用的，请应用忽略关于debugMode的信息，这里直接调用init。
    if (!debugMode) {
        
        //初始化融云SDK
        [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
        
    }
    // 注册自定义测试消息
    [[RCIM sharedRCIM] registerMessageType:[RCDTestMessage class]];
    
    //设置会话列表头像和会话界面头像
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    //  [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
    //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus=YES;
    //开启发送已读回执（只支持单聊）
    [RCIM sharedRCIM].enableReadReceipt=YES;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    //    //设置头像为圆形
    //    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    
    // 网络监听
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                [[NSNotificationCenter defaultCenter]postNotificationName:kNetChangedNotification object:nil];
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
    return YES;
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
// 设置deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if TARGET_IPHONE_SIMULATOR
    // 模拟器不能使用远程推送
#else
    // 请检查App的APNs的权限设置，更多内容可以参考文档 http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"ERROR：%@", error);
#endif
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2 
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    
    NSLog(@"Local notification = %@", notification);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                          getUnreadCount:@[
                                           @(ConversationType_PRIVATE),
                                           @(ConversationType_DISCUSSION),
                                           @(ConversationType_APPSERVICE),
                                           @(ConversationType_PUBLICSERVICE),
                                           @(ConversationType_GROUP)
                                           ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter]postNotificationName:kNetChangedNotification object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)redirectNSlogToDocumentFolder {
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
//      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                           NSUserDomainMask, YES);
//      NSString *documentDirectory = [paths objectAtIndex:0];
//    
//      NSDate *currentDate = [NSDate date];
//      NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
//      [dateformatter setDateFormat:@"MMddHHmmss"];
//      NSString *formattedDate = [dateformatter stringFromDate:currentDate];
//    
//      NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
//      NSString *logFilePath =
//          [documentDirectory stringByAppendingPathComponent:fileName];
//    
//      freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
//              stdout);
//      freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
//              stderr);
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    RCMessage *message = notification.object;
    if (message.messageDirection == MessageDirection_RECEIVE) {
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }
    
}
- (void)application:(UIApplication *)application
handleWatchKitExtensionRequest:(NSDictionary *)userInfo
              reply:(void (^)(NSDictionary *))reply {
    RCWKRequestHandler *handler =
    [[RCWKRequestHandler alloc] initHelperWithUserInfo:userInfo
                                              provider:self
                                                 reply:reply];
    if (![handler handleWatchKitRequest]) {
        // can not handled!
        // app should handle it here
        NSLog(@"not handled the request: %@", userInfo);
    }
}

#pragma mark - RCWKAppInfoProvider
- (NSString *)getAppName {
    return @"融云";
}

- (NSString *)getAppGroups {
    return @"group.cn.rongcloud.im.WKShare";
}

- (NSArray *)getAllUserInfo {
    return [RCDDataSource getAllUserInfo:^ {
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitUserInfoChanged];
    }];
}
- (NSArray *)getAllGroupInfo {
    return [RCDDataSource getAllGroupInfo:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitGroupChanged];
    }];
}
- (NSArray *)getAllFriends {
    return [RCDDataSource getAllFriends:^ {
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitFriendChanged];
    }];
}
- (void)openParentApp {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"rongcloud://connect"]];
}
- (BOOL)getNewMessageNotificationSound {
    return ![RCIM sharedRCIM].disableMessageAlertSound;
}
- (void)setNewMessageNotificationSound:(BOOL)on {
    [RCIM sharedRCIM].disableMessageAlertSound = !on;
}

- (void)logout {
    [DEFAULTS removeObjectForKey:@"userName"];
    [DEFAULTS removeObjectForKey:@"userPwd"];
    [DEFAULTS removeObjectForKey:@"userToken"];
    [DEFAULTS removeObjectForKey:@"userCookie"];
    if (self.window.rootViewController != nil) {
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];   UINavigationController *navi =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
    }
    [[RCIMClient sharedRCIMClient] disconnect:NO];
}
- (BOOL)getLoginStatus {
    NSString *token = [DEFAULTS stringForKey:@"userToken"];
    if (token.length) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - RCIMConnectionStatusDelegate
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        if ([[self getCurrentVC] isKindOfClass:[BragGameChatViewController class]]) {
            BragGameChatViewController * bragVC = (BragGameChatViewController *)[self getCurrentVC];
            [bragVC removeAllsubViews];
            [bragVC.navigationController popToRootViewControllerAnimated:NO];
        }
        LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.notAutoLogin = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
        // [loginVC defaultLogin];
        // RCDLoginViewController* loginVC = [storyboard
        // instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *_navi =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
        
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            loginVC.notAutoLogin = YES;
            UINavigationController *_navi = [[UINavigationController alloc]
                                             initWithRootViewController:loginVC];
            self.window.rootViewController = _navi;
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Token已过期，请重新登录"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    NSLog(@"message.targetId = %@, *** message.senderUserId = %@ *** 发送者 %@", message.targetId, message.senderUserId, message.content.senderUserInfo.userId);
    
    // 通知类消息
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg=(RCInformationNotificationMessage *)message.content;
        //NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        if ([msg.message rangeOfString:@"你已添加了"].location!=NSNotFound) {
            
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId complete:^(NSMutableArray *friends) {
            }];
        }
    } else if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        // 好友请求消息类
        RCContactNotificationMessage *msg = (RCContactNotificationMessage *)message.content;
        
        NSLog(@"msg.operation = %@", msg.operation);
        if ([msg.operation isEqualToString:ContactNotificationMessage_ContactOperationRequest]) {
            [self updateNewFriendRequestDB:msg.senderUserInfo];
        }
        
        if ([msg.operation isEqualToString:ContactNotificationMessage_ContactOperationAcceptResponse]) {
            
//            NSLog(@"msg.senderUserInfo.userid = %@ msg.senderUserInfo.name = %@ ** %@", msg.senderUserInfo.userId, msg.senderUserInfo.name, msg.senderUserInfo.portraitUri);
            
            NSString * url = [NSString stringWithFormat:@"%@userinfo/getFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
            [RCDDataSource syncFriendList:url complete:^(NSMutableArray *friends) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"newFriendAcceptNotification" object:nil];
            }];
        }
        if ([msg.operation isEqualToString:@"DelFriend"]) {
            
            NSLog(@"收到删除好友的通知了");
            
                NSString * strId = msg.sourceUserId;
                [self deleteFriendWithUserId:strId];
        }
        if ([msg.operation isEqualToString:@"LatestFriendCircleMessage"]) {
            NSLog(@"被评论了");
            [self updateFriendCircleMessageDB: msg.senderUserInfo];
        }
        
    }else if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
        //  群组通知消息类
        RCGroupNotificationMessage *msg = (RCGroupNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"Dismiss"] && [msg.operatorUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]){
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
        } else if ([msg.operation isEqualToString:@"Rename"]) {
            
            NSLog(@"修改群名称  %@", msg.message);
            
            [RCDHTTPTOOL getGroupByID:message.targetId
                    successCompletion:^(RCDGroupInfo *group) {
                        [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                        [[RCIM sharedRCIM] refreshGroupInfoCache:group
                                                     withGroupId:group.groupId];
                    }];
        }
    }
}

-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName
{
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        // 好友请求消息类
        RCContactNotificationMessage *msg = (RCContactNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"DelFriend"]) {
            return YES;
        }
    }
    return NO;
}

- (void)updateNewFriendRequestDB:(RCUserInfo *)userinfo
{
    RCUserInfo * model = [[RCUserInfo alloc]init];
    model.userId = userinfo.userId;
    model.name = userinfo.name;
    model.portraitUri = userinfo.portraitUri;
    
    BOOL ishave = NO;
    NSArray * newFriendRequestArr = [[RCDataBaseManager shareInstance]getAllNewFriendRequests];
    if (newFriendRequestArr) {
        for (RCUserInfo * User in newFriendRequestArr) {
            if ([User.userId isEqualToString:userinfo.userId]) {
                ishave = YES;
                break;
            }
        }
    }
    if (!ishave) {
        [[RCDataBaseManager shareInstance]insertNewFriendUserInfo:model];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"newFriendRequestNotification" object:nil];
    }
}

#pragma mark - 更新说说评论数据库
- (void)updateFriendCircleMessageDB:(RCUserInfo *)userinfo
{
    RCFriendCircleUserInfo * model = [[RCFriendCircleUserInfo alloc]init];
    model.name = userinfo.name;
    model.userId = userinfo.userId;
    model.portraitUri = userinfo.portraitUri;
    NSInteger number = [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber];
    model.number = [NSString stringWithFormat:@"%d", number + 1];
    
    [[RCDataBaseManager shareInstance]insertFriendcircleMessageToDB:model];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateFriendCircleMessageCount" object:nil];
}

#pragma mark - 被解除好友关系操作
- (void)deleteFriendWithUserId:(NSString * )strId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"被删除" message:@"你被好友删除！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
        
    });
    
    [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_PRIVATE targetId:strId success:^{
        ;
    } error:^(RCErrorCode status) {
        ;
    }];
    
    [[RCIMClient sharedRCIMClient]removeConversation:ConversationType_PRIVATE targetId:strId];
    NSLog(@"删除好友通知");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteFriendNotification" object:nil];
    // 同步好友列表
    NSString * url = [NSString stringWithFormat:@"%@userinfo/getFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [RCDDataSource syncFriendList:url complete:^(NSMutableArray *friends) {}];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}

- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"application userInfo = %@", userInfo);
     //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
    if (application.applicationState == UIApplicationStateActive) {
        //显示警告内容
    }
}

#pragma mark - 初始化语音包
- (void)configIFlySpeech
{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"12345678"];
    [IFlySpeechUtility createUtility:initString];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
    
}
#define ERRORPATH  [NSString stringWithFormat:@"%@/error.log",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]]
//void UncaughtExceptionHandler(NSException *exception) {
//    NSArray *stackArr = [exception callStackSymbols];//得到当前调用栈信息
//    NSString *reasonStr = [exception reason];//非常重要，就是崩溃的原因
//    NSString *nameStr = [exception name];//异常类型
//    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",nameStr, reasonStr, stackArr];
//    NSMutableArray *carshArr = [NSMutableArray arrayWithArray:stackArr];
//    [carshArr insertObject:reasonStr atIndex:0];
//    //保存到本地
//    [exceptionInfo writeToFile:ERRORPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"崩溃日志路径:%@",ERRORPATH);
//    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", nameStr, reasonStr, stackArr);
//}

- (void)pushTabBarVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MyTabBarController * myTabbarVC = [[MyTabBarController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:myTabbarVC];
        self.window.rootViewController = nav;
    });
}

- (void)pushLoginVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    });
}

- (void)sendLogMessage:(NSString *)buglogfile
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:buglogfile delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    NSDictionary * jsonDic = @{
                               @"Model": [self iphoneType],
                               @"AndroidVer":[[UIDevice currentDevice] systemVersion],
                               @"ErrorLog":buglogfile
                               };
    [[HDNetworking sharedHDNetworking] POST:@"version/UpdateBugLog" parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        NSLog(@"**%@", responseObject);
        
        if ([[responseObject objectForKey:@"Code"] intValue] != 200) {
            [self sendLogMessage:buglogfile];
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Buglogfile"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}
- (NSString *)iphoneType {
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";

    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}


@end
