//
//  Print.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/26.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "Print.h"
#import "MaterialDataModel.h"

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
    
    text = [text stringByReplacingOccurrencesOfString:@"/n" withString:@""];
    
    NSDictionary * dic = @{@"PrintType":@0,
                           @"PrintContent":[text hd_base64Encode],
                           @"Alignment":@(alignment)
                           };
    NSArray * arr = @[dic];
    NSString * jsonStr = [arr JSONString];
    
    [self printJsonDataStr:jsonStr];
    NSLog(@"%@ *** %@ ** %@",text, dic , jsonStr);
}

- (void)printImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId
{
    self.taskType = taskType;
    self.userId = toUserId;
    NSData * imageData = nil;
    image = [self getDownImge:image];
    image = [self getMirrorImage:image];
    if ([self imageHasAlpha:image]) {
        imageData = UIImagePNGRepresentation(image);
    }else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSDictionary * dic = @{@"PrintType":@1,
                           @"PrintContent":[imageData base64EncodedStringWithOptions:0],
                           @"Alignment":@1
                           };
    NSArray * arr = @[dic];
    NSString * jsonStr = [arr JSONString];
    
    [self printJsonDataStr:jsonStr];
    NSLog(@"%@ ** %@", dic , jsonStr);
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
                [mutableDic setValue:[self getImageStr:model.image] forKey:@"PrintContent"];
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
            [mutableDic setValue:[self getImageStr:model.image] forKey:@"PrintContent"];
            [mutableDic setValue:@1 forKey:@"Alignment"];
        }
        [arr addObject:mutableDic];
        NSLog(@"%@ ", mutableDic );
    }
    NSString * jsonStr = [arr JSONString];
    NSLog(@"%@" , jsonStr);
    [self printJsonDataStr:jsonStr];
}

- (NSString *)getImageStr:(UIImage *)image
{
    NSData * imageData = nil;
    image = [self getDownImge:image];
    image = [self getMirrorImage:image];
    if ([self imageHasAlpha:image]) {
        imageData = UIImagePNGRepresentation(image);
    }else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
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
        formatter.dateFormat = @"YYYY.MM.dd hh:mm:ss";
        
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
    NSString * url = [NSString stringWithFormat:@"%@userinfo/printInformation?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:dic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

- (UIImage *)getDownImge:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextTranslateCTM(context, image.size.width, 0);
    CGContextScaleCTM(context, -1.f, 1.f);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage * downImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return downImage;
}
- (UIImage *)getMirrorImage:(UIImage *)image
{
    CGRect  rect =  CGRectMake(0, 0, image.size.width , image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, false, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, rect);
    CGContextRotateCTM(context, M_PI);
    CGContextTranslateCTM(context, -rect.size.width, -rect.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    UIImage * downImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return downImage;
}

@end
