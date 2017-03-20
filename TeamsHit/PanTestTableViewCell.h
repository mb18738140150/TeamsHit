//
//  PanTestTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/14.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanTestTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>


@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingLeftLayoutConstraintConstant;

@property (strong, nonatomic) IBOutlet UIButton *selectBT;

@property (strong, nonatomic) IBOutlet UIView *myContenview;
@property (strong, nonatomic) IBOutlet UILabel *myLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mycontentviewLeftConstration;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mycontentviewRightConstration;

@end
