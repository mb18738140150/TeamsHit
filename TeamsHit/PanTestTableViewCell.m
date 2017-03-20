//
//  PanTestTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/14.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "PanTestTableViewCell.h"

#define MAXSPACE 60
static CGFloat const kBounceValue = 20.0f;
@implementation PanTestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContenview addGestureRecognizer:self.panRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)panThisCell:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContenview];
            self.startingLeftLayoutConstraintConstant = self.mycontentviewLeftConstration.constant;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [recognizer translationInView:self.myContenview];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            
            BOOL panningRight = NO;
            if (currentPoint.x > self.panStartPoint.x) {
                panningRight = YES;
            }
            
            if (self.startingLeftLayoutConstraintConstant == 0) {
                if (!panningRight) {
                    CGFloat constant = MAX(deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    }else
                    {
                        self.mycontentviewLeftConstration.constant = constant;
                    }
                }else
                {
                    CGFloat constant = MIN(deltaX, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    }else
                    {
                        self.mycontentviewLeftConstration.constant = constant;
                    }
                }
            }else
            {
                CGFloat adjustMent = self.startingLeftLayoutConstraintConstant + deltaX;
                
                if (!panningRight) {
                    CGFloat constant = MAX(adjustMent, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    }else
                    {
                        self.mycontentviewLeftConstration.constant = constant;
                    }
                }else
                {
                    CGFloat constant = MIN(adjustMent, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    }else
                    {
                        self.mycontentviewLeftConstration.constant = adjustMent;
                    }
                }
                
            }
            
            self.mycontentviewRightConstration.constant = -self.mycontentviewLeftConstration.constant;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.startingLeftLayoutConstraintConstant == 0) {
                if (self.mycontentviewLeftConstration.constant >= MAXSPACE / 4) {
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                }else
                {
                   [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                }
            }else
            {
                if (self.mycontentviewLeftConstration.constant >= MAXSPACE / 4 * 3) {
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                }else
                {
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingLeftLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
            
        default:
            break;
    }
}

- (CGFloat)buttonTotalWidth
{
    return MAXSPACE;
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing
{
    //TODO: Build.
    
    if (self.startingLeftLayoutConstraintConstant == 0 && self.mycontentviewLeftConstration.constant == 0) {
        return;
    }
    
    self.mycontentviewLeftConstration.constant = -kBounceValue;
    self.mycontentviewRightConstration.constant = kBounceValue;
    [self updateConstraintsIfNeeded:YES completion:^(BOOL finished) {
        
        self.mycontentviewLeftConstration.constant = 0;
        self.mycontentviewRightConstration.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingLeftLayoutConstraintConstant = self.mycontentviewLeftConstration.constant;
        }];
        
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    //TODO: Build
    
    if (self.startingLeftLayoutConstraintConstant == [self buttonTotalWidth] && self.mycontentviewLeftConstration.constant == [self buttonTotalWidth]) {
        return;
    }
    
    self.mycontentviewLeftConstration.constant = [self buttonTotalWidth] + kBounceValue;
    self.mycontentviewRightConstration.constant = -[self buttonTotalWidth] - kBounceValue;
    
    [self updateConstraintsIfNeeded:YES completion:^(BOOL finished) {
        
        self.mycontentviewLeftConstration.constant = [self buttonTotalWidth];
        self.mycontentviewRightConstration.constant = -[self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingLeftLayoutConstraintConstant = self.mycontentviewLeftConstration.constant;
        }];
        
    }];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
            {
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
                CGPoint velocity = [pan velocityInView:self];
                CGFloat Vx = fabsf(velocity.x);
                CGFloat Vy = fabsf(velocity.y);
                return !(Vx * 0.5 > Vy);
                
            }
                break;
            case UIGestureRecognizerStateChanged:
                return NO;
                break;
            default:
                break;
        }
    }
    
    return YES;
}


- (IBAction)btClickAction:(id)sender {
}

@end
