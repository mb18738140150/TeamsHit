//
//  NSDictionary+Unicode.m
//  Delivery
//
//  Created by 仙林 on 16/1/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary (Unicode)
- (NSString * )my_description
{
    NSString * desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}
@end
