//
//  BragGameOverView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BragGameOverView.h"

@interface BragGameOverView()

@property (strong, nonatomic) IBOutlet UIView *gameResultBackView;
@property (strong, nonatomic) IBOutlet UILabel *gameResultLabel;

@property (strong, nonatomic) IBOutlet UIImageView *gameUserIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *teamhitCoinImageView;
@property (strong, nonatomic) IBOutlet UILabel *winCoins;
@property (strong, nonatomic) IBOutlet UIImageView *winGameUserIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *winLabel;
@property (strong, nonatomic) IBOutlet UIImageView *loseGameuserIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *loseLabel;

@end

@implementation BragGameOverView


- (void)creatUIWithDic:(NSDictionary *)dic
{
    self.winLabel.layer.cornerRadius = 9.5;
    self.winLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.winLabel.layer.borderWidth = 1;
    self.winLabel.layer.masksToBounds = YES;
    self.loseLabel.layer.cornerRadius = 9.5;
    self.loseLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loseLabel.layer.borderWidth = 1;
    self.loseLabel.layer.masksToBounds = YES;
    if ([RCIM sharedRCIM].currentUserInfo.userId.intValue == [[dic objectForKey:@"WinUserId"] intValue]) {
        // 赢家
        self.gameResultBackView.backgroundColor = UIColorFromRGB(0xFC5B6A);
        self.gameResultLabel.text = @"游戏获胜";
        self.winCoins.text = [NSString stringWithFormat:@"+%@个", [dic objectForKey:@"WinCoins"]];
        [self.gameUserIconImageView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        [self.winGameUserIconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"WinUserIcon"]] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        [self.loseGameuserIconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"LoseUserIcon"]] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        
    }else if ([RCIM sharedRCIM].currentUserInfo.userId.intValue == [[dic objectForKey:@"LoseUserId"] intValue])
    {
        // 输家
        self.gameResultBackView.backgroundColor = UIColorFromRGB(0x19CBB3);
        self.gameResultLabel.text = @"游戏失败";
        self.winCoins.text = [NSString stringWithFormat:@"-%@个", [dic objectForKey:@"LoseCoins"]];
        [self.gameUserIconImageView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        [self.winGameUserIconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"WinUserIcon"]] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        [self.loseGameuserIconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"LoseUserIcon"]] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
    }else
    {
        self.gameResultBackView.backgroundColor = UIColorFromRGB(0xA551E7);
        self.gameResultLabel.text = @"游戏结束";
        self.teamhitCoinImageView.hidden = YES;
        self.winCoins.hidden = YES;
        [self.gameUserIconImageView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        [self.winGameUserIconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"WinUserIcon"]] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
        [self.loseGameuserIconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"LoseUserIcon"]] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon.png"]];
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
