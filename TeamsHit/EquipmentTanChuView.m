//
//  EquipmentTanChuView.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "EquipmentTanChuView.h"

@interface EquipmentTanChuView ()
@property (nonatomic, strong)NSArray * imageArr;
@end

@implementation EquipmentTanChuView

- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        self.imageArr = [NSArray arrayWithArray:imageArray];
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView * backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    backview.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [self addSubview:backview];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake((self.hd_width - 260) / 2, 20, 260, 320)];
    whiteView.center = self.center;
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    
    self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _removeButton.frame = CGRectMake(260 - 40, 20, 20, 20);
    [_removeButton setImage:[UIImage imageNamed:@"imgErro"] forState:UIControlStateNormal];
    [whiteView addSubview:_removeButton];
    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 60, whiteView.hd_width - 80, whiteView.hd_width - 80)];
    NSMutableArray * imageArr = [NSMutableArray array];
    for (NSString * imageName in self.imageArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    self.imageView.animationImages = imageArr;
    self.imageView.animationDuration = 3.5;
    [self.imageView startAnimating];
    [whiteView addSubview:self.imageView];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 320 - 60, whiteView.hd_width - 80, 40)];
    self.detailLabel.textColor = UIColorFromRGB(0x12B7F5);
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textAlignment = 1;
    self.detailLabel.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:self.detailLabel];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
