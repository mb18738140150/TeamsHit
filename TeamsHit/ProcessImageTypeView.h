//
//  ProcessImageTypeView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProcessTypeBlock)(int type);

@interface ProcessImageTypeView : UIView

- (void)getProcessImageType:(ProcessTypeBlock)processBlock;

@end
