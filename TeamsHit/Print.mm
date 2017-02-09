//
//  Print.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/26.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "Print.h"
#import "MaterialDataModel.h"
#import "AppDelegate.h"
#import "ImageUtil.h"
#include <sys/time.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>

#define SELF_WIDTH 384

#ifdef DEBUG

#define NSLog1(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define NSLog1(FORMAT, ...) nil

#endif

@interface Print()
{
    MBProgressHUD* hud ;
}
@property (nonatomic, assign)BOOL materailImage;
@end

@implementation Print

+ (Print *)sharePrint
{
    static Print * print = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        print = [[Print alloc]init];
    });
    return print;
}

- (void)printText:(NSString *)text taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId Alignment:(int )alignment
{
    self.taskType = taskType;
    self.userId = toUserId;
    
//    text = [text stringByReplacingOccurrencesOfString:@"/n" withString:@""];
    
    NSDictionary * dic = @{@"PrintType":@0,
                           @"PrintContent":[text hd_base64Encode],
                           @"Alignment":@(alignment)
                           };
    NSArray * arr = @[dic];
    NSString * jsonStr = [arr JSONString];
    
    [self printJsonDataStr:jsonStr];
    NSLog(@"%@ *** %@ ** %@",text, dic , jsonStr);
}
- (void)printMaterailImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId
{
    self.materailImage = YES;
    [self printImage:image taskType:taskType toUserId:toUserId];
}
- (void)printImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId
{
    if (image.size.width > 384) {
        image = [self calculateImagesize:image];
        NSLog(@"适应宽度");
    }
    
    self.taskType = taskType;
    self.userId = toUserId;
    
    if (self.materailImage) {
        self.materailImage = NO;
        image = [ImageUtil ditherImage:image];
        image = [ImageUtil erzhiBMPImage:image];
    }else
    {
        image = [ImageUtil erzhiBMPImage:image];
    }
    [self printditherImage:image taskType:taskType toUserId:toUserId];
}

- (UIImage *)calculateImagesize:(UIImage *)image
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(SELF_WIDTH, (int)(SELF_WIDTH *size.height / size.width)));
    [image drawInRect:CGRectMake(0, 0, SELF_WIDTH, (int)(SELF_WIDTH *size.height / size.width))];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)printditherImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId
{
    self.taskType = taskType;
    self.userId = toUserId;
    
    NSString* fileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.bmp", [UserInfo shareUserInfo].timeStr]];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* imageData = [[NSData alloc] init];
    imageData = [fm contentsAtPath:fileName];
    
    NSDictionary * dic = @{@"PrintType":@1,
                           @"PrintContent":[imageData base64EncodedStringWithOptions:0],
                           @"Alignment":@1
                           };
    NSArray * arr = @[dic];
    NSString * jsonStr = [arr JSONString];
    
    [self printJsonDataStr:jsonStr];
    NSLog1(@"dither ** jsonStr = %@", jsonStr);
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (void)printWithArr:(NSArray *)dataArr taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId
{
    self.taskType = taskType;
    self.userId = toUserId;
    NSMutableArray * arr = [NSMutableArray array];
    
    for (MaterialDataModel * model in dataArr) {
        NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
        if (model.imageModel == TextEditImageModel) {
            if (model.title.length == 0) {
                [mutableDic setValue:@1 forKey:@"PrintType"];
                [mutableDic setValue:[self getImageStr:model.fileName] forKey:@"PrintContent"];
                [mutableDic setValue:@1 forKey:@"Alignment"];
            }else
            {
                [mutableDic setValue:@0 forKey:@"PrintType"];
                [mutableDic setValue:[model.title hd_base64Encode] forKey:@"PrintContent"];
                [mutableDic setValue:@(model.Alignment) forKey:@"Alignment"];
            }
        }else
        {
            [mutableDic setValue:@1 forKey:@"PrintType"];
            [mutableDic setValue:[self getImageStr:model.fileName] forKey:@"PrintContent"];
            [mutableDic setValue:@1 forKey:@"Alignment"];
        }
        [arr addObject:mutableDic];
    }
    NSString * jsonStr = [arr JSONString];
    NSLog(@"%@" , jsonStr);
    [self printJsonDataStr:jsonStr];
}

- (NSString *)getImageStr:(NSString *)imageName
{
    NSString* fileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.bmp", imageName]];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* imageData = [[NSData alloc] init];
    imageData = [fm contentsAtPath:fileName];
    
    return  [imageData base64EncodedStringWithOptions:0];
}

- (void)printJsonDataStr:(NSString *)jsonStr
{
    NSString * url = [NSString stringWithFormat:@"%@userinfo/testTeamState?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    NSDictionary * dic = @{@"ToUserId":self.userId
                           };
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:dic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            [self print:jsonStr];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败请重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        NSLog(@"%@", error);
    }];
    
    if (self.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"YYYY.MM.dd HH:mm:ss";
        
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSString * printStr = [formatter stringFromDate:date];
        [[NSUserDefaults standardUserDefaults]setObject:printStr forKey:@"PrintTime"];
    }
    
}

- (void)print:(NSString *)jsonStr
{
    NSDictionary * dic = @{@"ToUserId":self.userId,
                         @"TaskType":self.taskType,
                         @"DataArray":jsonStr
                         };
    NSLog(@"%@", dic);
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    hud= [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    hud.labelText = @"发送中...";
    [hud show:YES];
    NSString * url = [NSString stringWithFormat:@"%@userinfo/printInformation?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:dic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [hud hide:YES];
    }];

}
@end
