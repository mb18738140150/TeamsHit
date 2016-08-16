//
//  EquipmentTanChuView.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentTanChuView : UIView

@property (nonatomic, strong)UIButton * removeButton;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * detailLabel;
- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)imageArray;

@end
