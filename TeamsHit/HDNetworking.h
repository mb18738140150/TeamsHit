//
//  HDNetworking.h
//  PortableTreasure
//
//  Created by HeDong on 16/2/10.
//  Copyright © 2016年 hedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@class HDPicModle;

typedef void (^ _Nullable Success)(id responseObject);     // 成功Block
typedef void (^ _Nullable Failure)(NSError *error);        // 失败Blcok
typedef void (^ _Nullable Progress)(NSProgress * _Nullable progress); // 上传或者下载进度Block
typedef NSURL * _Nullable (^ _Nullable Destination)(NSURL *targetPath, NSURLResponse *response); //返回URL的Block
typedef void (^ _Nullable DownLoadSuccess)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath); // 下载成功的Blcok

typedef void (^ _Nullable Unknown)();          // 未知网络状态的Block
typedef void (^ _Nullable Reachable)();        // 无网络的Blcok
typedef void (^ _Nullable ReachableViaWWAN)(); // 蜂窝数据网的Block
typedef void (^ _Nullable ReachableViaWiFi)(); // WiFi网络的Block

@interface HDNetworking : NSObject
HDSingletonH(HDNetworking) // 单例声明

/**
 *  上传图片大小(kb)
 */
@property (nonatomic, assign) NSUInteger picSize;

/**
 *  超时时间(默认20秒)
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 *  可接受的响应内容类型
 */
@property (nonatomic, copy) NSSet <NSString *> *acceptableContentTypes;

/**
 *  网络监测(在什么网络状态)
 *
 *  @param unknown          未知网络
 *  @param reachable        无网络
 *  @param reachableViaWWAN 蜂窝数据网
 *  @param reachableViaWiFi WiFi网络
 */
- (void)networkStatusUnknown:(Unknown)unknown reachable:(Reachable)reachable reachableViaWWAN:(ReachableViaWWAN)reachableViaWWAN reachableViaWiFi:(ReachableViaWiFi)reachableViaWiFi;

/**
 *  封装的GET请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

/**
 *  封装的POST请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POSTwithToken:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure;
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure;

- (void)POSTwithWiFi:(NSString *)URLString parameters:(id)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
 *  封装POST图片上传(多张图片) // 可扩展成多个别的数据上传如:mp3等
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param picArray   存放图片模型(HDPicModle)的数组
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 */
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters andPicArray:(NSArray *)picArray progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
 *  封装POST图片上传(单张图片) // 可扩展成单个别的数据上传如:mp3等
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param picModle   上传的图片模型
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 */



- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters andPic:(HDPicModle *)picModle progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
 *  封装POST上传url资源
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param picModle   上传的图片模型(资源的url地址)
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 */
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters andPicUrl:(HDPicModle *)picModle progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
 *  下载
 *
 *  @param URLString       请求的链接
 *  @param progress        进度的回调
 *  @param destination     返回URL的回调
 *  @param downLoadSuccess 发送成功的回调
 *  @param failure         发送失败的回调
 */
- (NSURLSessionDownloadTask *)downLoadWithURL:(NSString *)URLString progress:(Progress)progress destination:(Destination)destination downLoadSuccess:(DownLoadSuccess)downLoadSuccess failure:(Failure)failure;

// 设置好友备注名
- (void)setFriendDisplayName:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 好友朋友圈权限设置
- (void)setTargetPermission:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 我的朋友圈权限设置
- (void)setUserPermission:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 获取朋友圈权限状态
- (void)getPermission:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 获取个人详细资料getDetailInfor
- (void)getDetailInfor:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

// 修改群组名称
- (void)modifyGroupName:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 修改群组类型
- (void)modifyGroupType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 修改最低碰碰币
- (void)modifyGroupLeastCoins:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 退出群组
- (void)quitGroup:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 修改游戏人数
- (void)modifyGamePeople:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 修改群组验证类型
- (void)modifyGroupVerifition:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

// 根据群号快速进群
- (void)quickJoinWithGroupid:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

// 根据群组类型随机分配房间
- (void)randomAssignWithGroupType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;


// 获取素材分类
- (void)getMaterialType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
// 获取素材
- (void)getMaterialWithType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

@end

NS_ASSUME_NONNULL_END
