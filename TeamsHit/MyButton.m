//
//  MyButton.m
//  RuntimeTest
//
//  Created by 仙林 on 17/2/21.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    
    [super sendAction:action to:target forEvent:event];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
