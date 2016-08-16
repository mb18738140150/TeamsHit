//
//  CALayer+UIColor.m
//  SizeClassesTest
//
//  Created by 立元通信 on 16/5/17.
//  Copyright © 2016年 zhang. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)
- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
