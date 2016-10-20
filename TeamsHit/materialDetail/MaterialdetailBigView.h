//
//  MaterialdetailBigView.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/17.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MaterialDetailBigViewDelegate <NSObject>

- (void)beforeClick;
- (void)nextClick;
- (void)addClick:(int )listItem andItem:(int )item;
- (void)printClick:(int )listItem andItem:(int )item;

@end

@interface MaterialdetailBigView : UIView

@property (nonatomic, assign)id<MaterialDetailBigViewDelegate>delegate;
@property (nonatomic, strong)NSMutableArray * dateSourceArray;
@property (nonatomic, assign)int item;
@property (nonatomic, assign)int listItem;

- (void)refreshImageDateSourceWithImageArr:(NSArray *)imagearray;

- (void)show:(int)item;
- (void)closeView;
- (void)haoveNomore;

- (void)moveToindex:(int)item;

@end
