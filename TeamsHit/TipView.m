//
//  TipView.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TipView.h"
#import "AppDelegate.h"

@interface TipView ()

@property (nonatomic, assign)BOOL isdelete;

@end

@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame Message:(NSString *)message delete:(BOOL)isDelete
{
    if (self = [super initWithFrame:frame]) {
        [self creatWithMessage:message andTitle:@""];
        self.isdelete = isDelete;
    }
    return self;
}
- (void)creatWithMessage:(NSString *)message andTitle:(NSString *)title
{
    
    UIView * backBlackView = [[UIView alloc]initWithFrame:self.frame];
    backBlackView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [self addSubview:backBlackView];
    
    UIView * backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 30, 180)];
    backWhiteView.backgroundColor = [UIColor whiteColor];
    backWhiteView.layer.cornerRadius = 5;
    backWhiteView.layer.masksToBounds = YES;
    [self addSubview:backWhiteView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 13, backWhiteView.hd_width - 60, 17)];
    titleLabel.text = title;
    titleLabel.textColor = UIColorFromRGB(0x000000);
    titleLabel.backgroundColor = [UIColor whiteColor];
    [backWhiteView addSubview:titleLabel];
    
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, backWhiteView.hd_width - 60, 17)];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize size = [message boundingRectWithSize:CGSizeMake(messageLabel.hd_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    messageLabel.hd_height = size.height;
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.numberOfLines = 0;
    messageLabel.text = message;
    messageLabel.textColor = UIColorFromRGB(0x010101);
    messageLabel.backgroundColor = [UIColor whiteColor];
    [backWhiteView addSubview:messageLabel];
    
    UIButton * cancleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBt.frame = CGRectMake(backWhiteView.hd_width - 125, 130, 40, 16);
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBt setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [backWhiteView addSubview:cancleBt];
    [cancleBt addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * completeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBT.frame = CGRectMake(backWhiteView.hd_width - 65, 130, 40, 16);
    if (self.isdelete) {
        [completeBT setTitle:@"删除" forState:UIControlStateNormal];
        [completeBT setTitleColor:UIColorFromRGB(0xE94F4F) forState:UIControlStateNormal];
    }else
    {
        [completeBT setTitle:@"清空" forState:UIControlStateNormal];
        [completeBT setTitleColor:UIColorFromRGB(0x12B7F5) forState:UIControlStateNormal];
    }
    
    [backWhiteView addSubview:completeBT];
    [completeBT addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    
    backWhiteView.center = self.center;
    
}

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title message:(NSString *)message delete:(BOOL)isDelete
{
    if (self = [super initWithFrame:frame]) {
        self.isdelete = isDelete;
        [self creatWithMessage:message andTitle:title];
    }
    return self;
}

- (void)show
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismissAction
{
    [self removeFromSuperview];
}

- (void)completeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(complete)]) {
        [self.delegate complete];
        [self dismissAction];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
