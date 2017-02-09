//
//  TypeofGameTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/26.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TypeofGameTableViewCell.h"

@interface TypeofGameTableViewCell ()

@property (nonatomic, strong)BegainGameBlock begainGameblock;
@property (nonatomic, strong)LookRullerBlock lookRullerblock;

@end

@implementation TypeofGameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer * begaingameTip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(begainGameAction:)];
    [self.begainGameLabel addGestureRecognizer:begaingameTip];
    
    UITapGestureRecognizer * lookRullerTip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookRullerAction:)];
    [self.rullerLabel addGestureRecognizer:lookRullerTip];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)begainGameAction:(id)sender {
    
    if (self.begainGameblock) {
        _begainGameblock();
    }
    
}
- (IBAction)lookRullerAction:(id)sender {
    
    if (self.lookRullerblock) {
        _lookRullerblock();
    }
    
}

- (void)begainGame:(BegainGameBlock)block
{
    self.begainGameblock = [block copy];
}

- (void)lookRuller:(LookRullerBlock)block
{
    self.lookRullerblock = [block copy];
}

@end
