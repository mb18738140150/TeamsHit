//
//  TimeSelectView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSelectView : UIView

- (void)showTimeSelectView:(void(^)(NSString *yearStr, NSString *monthStr, NSString *dayStr))selectStr;

@end
