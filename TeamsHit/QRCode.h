//
//  QRCode.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCode : NSObject

+(QRCode *)shareQRCode;

- (UIImage *)createQRCodeForString:(NSString *)qrString withWidth:(CGFloat)width;

@end
