//
//  ExpressionView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExpressionBlock)(UIImage * expressionImage);

@interface ExpressionView : UIView

- (void)getExpressionImage:(ExpressionBlock)expressionBlock;

@end
