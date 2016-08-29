//
//  TipView.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TipViewDelegate <NSObject>

- (void)complete;

@end

@interface TipView : UIView

- (instancetype)initWithFrame:(CGRect)frame Message:(NSString *)message delete:(BOOL)isDelete;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title message:(NSString *)message delete:(BOOL)isDelete;

- (void)show;

@property (nonatomic, assign) id<TipViewDelegate> delegate;

@end
