//
//  DropList.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger {
  
    ListWidth = 0,
    ListSize,
    ListAlin,
    
}ListType;

@interface DropList : UIView

- (instancetype)initWithFrame:(CGRect)frame listType:(ListType)listType sourceArr:(NSArray *)sourceArr;

- (void)showWithAnimate:(BOOL)animate;

- (void)dismiss;

@end
