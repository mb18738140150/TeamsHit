//
//  NSString+MD5.h
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)sha1;
- (NSString *)md5;
/**
 *  验证手机号
 *
 *  @param str 输入手机号码
 *
 *  @return 手机号正确返回YES, 错误返回NO
 */
+ (BOOL)isTelPhoneNub:(NSString *)str;
//+ (BOOL) validateIdentityCard: (NSString *)identityCard;
/**
 *  验证身份证号码
 *
 *  @param value 身份证号码
 *
 *  @return 身份证正确返回 YES, 错误返回 NO.
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

@end
