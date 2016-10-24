//
//  HDNetworking.m
//  PortableTreasure
//
//  Created by HeDong on 16/2/10.
//  Copyright © 2016年 hedong. All rights reserved.
//

#import "HDNetworking.h"
#import "HDPicModle.h"
#import "UIImage+HDExtension.h"
#import "AFNetworking.h"

@implementation HDNetworking
HDSingletonM(HDNetworking) // 单例实现

/**
 *  网络监测(在什么网络状态)
 *
 *  @param unknown          未知网络
 *  @param reachable        无网络
 *  @param reachableViaWWAN 蜂窝数据网
 *  @param reachableViaWiFi WiFi网络
 */
- (void)networkStatusUnknown:(Unknown)unknown reachable:(Reachable)reachable reachableViaWWAN:(ReachableViaWWAN)reachableViaWWAN reachableViaWiFi:(ReachableViaWiFi)reachableViaWiFi;
{
    // 创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 监测到不同网络的情况
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                unknown();
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                reachable();
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                reachableViaWWAN();
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                reachableViaWiFi();
                break;
                
            default:
                break;
        }
    }] ;
}

/**
 *  封装的get请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];
    
    manager.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure)
        {
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

/**
 *  封装的POST请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POSTwithToken:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    
    NSLog(@"postUrl = %@", URLString);
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)
        {
            progress(uploadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == 3840) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"json数据格式不正确，解析失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
        
        if (failure)
        {
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    }];
}


- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    NSString * urlStr = [self getpostUrlWithStr:URLString];
    
    NSLog(@"postUrl = %@", urlStr);
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)
        {
            progress(uploadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == 3840) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"json数据格式不正确，解析失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
        
        if (failure)
        {
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    }];
}

- (void)POSTwithWiFi:(NSString *)URLString parameters:(id)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    
    NSLog(@"postUrl = %@", URLString);
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)
        {
            progress(uploadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == 3840) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"json数据格式不正确，解析失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
        
        if (failure)
        {
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    }];
}

- (NSString *)getpostUrlWithStr:(NSString *)str
{
    // 拼接请求url
    // 随机数
    NSInteger nonce = arc4random() % ( NSIntegerMax);
    NSString * nonceStr = [NSString stringWithFormat:@"%d", nonce];
    // 时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    /*
     appid : 627515567417   1114a89792a97e51659
     appsecret : aQmo3zbxT6bhsmaZweCd
     url : http://www.api.mstching.com/api/user/gettoken
     */
    
    
    
    NSDictionary * getdic = @{
                              @"appsecret":@"aQmo3zbxT6bhsmaZweCd",
                              @"timestamp":@(timeSp.integerValue),
                              @"nonce":@(nonce)
                              };
    NSArray * values = [getdic allValues];
    NSArray * sortArr = [values sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * obj1Str = [NSString stringWithFormat:@"%@", obj1];
        NSString * obj2Str = [NSString stringWithFormat:@"%@", obj2];
        NSComparisonResult result = [obj1Str compare:obj2Str options:NSCaseInsensitiveSearch];
        return result;
    }];
//    NSArray * sortArr = [values sortedArrayUsingSelector:@selector(compare:)];
    NSString * signatureStr = @"";
    for (int i = 0; i < sortArr.count; i++) {
        NSString * secStr = [NSString stringWithFormat:@"%@",[sortArr objectAtIndex:i]];
        signatureStr = [signatureStr stringByAppendingString:secStr];
    }
    
    NSLog(@"%@", [getdic description]);
    NSLog(@"加密前*** %@", signatureStr);
    signatureStr = [signatureStr sha1];
    NSLog(@"加密后*** %@", signatureStr);
    NSString * getStr = [NSString stringWithFormat:@"%@%@?appid=%@&timestamp=%@&nonce=%@&signature=%@", POST_URL, str, @"627515567417", timeSp, nonceStr, signatureStr];
    
    return getStr;
}

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
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters andPicArray:(NSArray *)picArray progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应不使用AFN默认转换,保持原有数据
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSInteger count = picArray.count;
        NSString *fileName = @"";
        NSData *data = [NSData data];
        
        for (int i = 0; i < count; i++)
        {
            @autoreleasepool {
                HDPicModle *picModle = picArray[i];
                fileName = [NSString stringWithFormat:@"%@.jpg", picModle.picName];
                /**
                 *  压缩图片然后再上传(1.0代表无损 0~~1.0区间)
                 */
                data = UIImageJPEGRepresentation(picModle.pic, 1.0);
                CGFloat precent = self.picSize / (data.length / 1024.0);
                if (precent > 1)
                {
                    precent = 1.0;
                }
                data = nil;
                data = UIImageJPEGRepresentation(picModle.pic, precent);
                
                [formData appendPartWithFileData:data name:picModle.picName fileName:fileName mimeType:@"image/jpeg"];
                data = nil;
                picModle.pic = nil;
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)
        {
            progress(uploadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}

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
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters andPic:(HDPicModle *)picModle progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    
//    manager.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应不使用AFN默认转换,保持原有数据
    
    
    NSLog(@"url = %@", URLString);
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**
         *  压缩图片然后再上传(1.0代表无损 0~~1.0区间)
         */
        NSData *data = UIImageJPEGRepresentation(picModle.pic, 1.0);
        CGFloat precent = self.picSize / (data.length / 1024.0);
        if (precent > 1)
        {
            precent = 1.0;
        }
        data = nil;
        data = UIImageJPEGRepresentation(picModle.pic, precent);
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", picModle.picName];
        
        [formData appendPartWithFileData:data name:picModle.picName fileName:picModle.picFile mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)
        {
            progress(uploadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}

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
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : 20);
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应不使用AFN默认转换,保持原有数据
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", picModle.picName];
        // 根据本地路径获取url(相册等资源上传)
        NSURL *url = [NSURL fileURLWithPath:picModle.url]; // [NSURL URLWithString:picModle.url] 可以换成网络的图片在上传
        
        [formData appendPartWithFileURL:url name:picModle.picName fileName:fileName mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)
        {
            progress(uploadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}

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
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress)
        {
            progress(downloadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (destination)
        {
            return destination(targetPath, response);
        }
        else
        {
            return nil;
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error)
        {
            failure(error);
        }
        else
        {
            downLoadSuccess(response, filePath);
        }
    }];
    
    // 开始启动任务
    [task resume];
    
    return task;
}

// 设置好友备注名
- (void)setFriendDisplayName:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@userinfo/setDisplayName?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:nil success:success failure:failure];
    
}
// 好友朋友圈权限设置
- (void)setTargetPermission:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@userinfo/setTargetPermission?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:nil success:success failure:failure];
}
// 我的朋友圈权限设置
- (void)setUserPermission:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@userinfo/setUserPermission?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:nil success:success failure:failure];
}
// 获取朋友圈权限状态
- (void)getPermission:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@userinfo/getPermission?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:nil success:success failure:failure];
}

// 获取个人详细资料getDetailInfor
- (void)getDetailInfor:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@userinfo/getDetailInfor?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 修改群组名称
- (void)modifyGroupName:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/modifyGroupName?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
       
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
// 修改群组类型
- (void)modifyGroupType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/modifyGroupType?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
// 修改最低碰碰币
- (void)modifyGroupLeastCoins:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/modifyGroupLeastCoins?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
// 退出群组
- (void)quitGroup:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/quitGroup?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
// 修改游戏人数
- (void)modifyGamePeople:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/setGamePeople?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
// 修改群组验证类型
- (void)modifyGroupVerifition:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/setGroupVerifition?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

// 根据群号快速进群
- (void)quickJoinWithGroupid:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/quickJoinWithGroupid?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 根据群组类型随机分配房间
- (void)randomAssignWithGroupType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@groups/randomAssignWithGroupType?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


// 获取素材分类
- (void)getMaterialType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@material/getMaterialType?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 获取素材
- (void)getMaterialWithType:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@material/getMaterialWithType?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [self POSTwithToken:url parameters:parameters progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (success) {
                success(responseObject);
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            NSError * error = [NSError errorWithDomain:@"" code:100000 userInfo:@{@"miss":@"请求失败"}];
            if (failure) {
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
