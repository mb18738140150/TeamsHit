//
//  MyButton+helper.m
//  RuntimeTest
//
//  Created by 仙林 on 17/2/23.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "MyButton+helper.h"
#import <objc/runtime.h>

// 默认按钮点击时间
static const NSTimeInterval defaultDuration = 3.0f;

// 记录是否忽略按钮点击事件，默认第一次执行事件
static BOOL _isIgnoreEvent = NO;

// 设置执行按钮事件状态
static void resertState(){
    _isIgnoreEvent = NO;
}

@implementation MyButton (helper)
@dynamic clickDurationTime;

+(void)load
{
    SEL originSEL = @selector(sendAction:to:forEvent:);
    SEL mySEL = @selector(my_sendAction:to:forEvent:);
    
    Method originM = class_getInstanceMethod([self class], originSEL);
    const char *typeEncodinds = method_getTypeEncoding(originM);
    
    Method newM = class_getInstanceMethod([self class], mySEL);
    IMP newIMP = method_getImplementation(newM);
    
    if (class_addMethod([self class], mySEL, newIMP, typeEncodinds)) {
        class_replaceMethod([self class], originSEL, newIMP, typeEncodinds);
    }else
    {
        method_exchangeImplementations(originM, newM);
    }
}

- (void)my_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    // 判断下class类型
    if ([self isKindOfClass:[UIButton class]]) {
        //1. 按钮点击间隔事件
        self.clickDurationTime = self.clickDurationTime == 0 ? defaultDuration : self.clickDurationTime;
        // 2.是否忽略按钮点击事件
        if (_isIgnoreEvent) {
            // 2.1 忽略按钮点击事件
            return;
        }else
        {
            //2.2 不忽略按钮点击事件
            // 后续在时间间隔内直接忽略按钮点击事件
            _isIgnoreEvent = YES;
            // 间隔时间后，执行按钮事件
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.clickDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                resertState();
            });
        }
        [self my_sendAction:action to:target forEvent:event];
        
    }else
    {
        [self my_sendAction:action to:target forEvent:event];
    }
    
}

- (void)setClickDurationTime:(NSTimeInterval)clickDurationTime
{
    objc_setAssociatedObject(self, @selector(clickDurationTime), @(clickDurationTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)clickDurationTime
{
    return [objc_getAssociatedObject(self, @selector(clickDurationTime)) doubleValue];
}
@end
