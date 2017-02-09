//
//  ShuoShuoCommentTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/1/11.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "ShuoShuoCommentTableViewCell.h"
#import "ILRegularExpressionManager.h"
#import "NSString+NSString_ILExtension.h"

@interface ShuoShuoCommentTableViewCell ()

@property (nonatomic, strong)UIImageView * replyUserIconImageView;
@property (nonatomic, strong)UILabel * replyUsernameLB;
@property (nonatomic, strong)WFTextView * replyView;

@end

@implementation ShuoShuoCommentTableViewCell

- (void)creatSubViews
{
    [self.contentView removeAllSubviews];
    
    self.replyUserIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 28, 28)];
    [self.replyUserIconImageView sd_setImageWithURL:[NSURL URLWithString:self.replyBody.replyUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    [self.contentView addSubview:self.replyUserIconImageView];
    
    self.replyUsernameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.replyUserIconImageView.frame) + 7, 5, self.contentView.hd_width - 40, 11)];
    self.replyUsernameLB.font = [UIFont systemFontOfSize:10];
    self.replyUsernameLB.textColor = UIColorFromRGB(0x5E5E5E);
    self.replyUsernameLB.text = self.replyBody.replyUserInfo.name;
    [self.contentView addSubview:self.replyUsernameLB];
    
    NSString *matchString;
    NSMutableArray *feedBackArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if ([self.replyBody.repliedUser isEqualToString:@""]) {
        matchString = [NSString stringWithFormat:@"%@:%@",_replyBody.replyUser,_replyBody.replyInfo];
        NSString *range = NSStringFromRange(NSMakeRange(0, _replyBody.replyUser.length));
        [tempArr addObject:range];
    }else
    {
        matchString = [NSString stringWithFormat:@"%@回复%@:%@",_replyBody.replyUser,_replyBody.repliedUser,_replyBody.replyInfo];
        NSString *range1 = NSStringFromRange(NSMakeRange(0, _replyBody.replyUser.length));
        NSString *range2 = NSStringFromRange(NSMakeRange(_replyBody.replyUser.length + 2, _replyBody.repliedUser.length));
        [tempArr addObject:range1];
        [tempArr addObject:range2];
    }
    [feedBackArray addObject:tempArr];
    
    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder];
    
    
    NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
    if (feedBackArray.count != 0) {
        NSArray *tArr = [feedBackArray objectAtIndex:0];
        for (int i = 0; i < [tArr count]; i ++) {
            NSString *string = [matchString substringWithRange:NSRangeFromString([tArr objectAtIndex:i])];
            [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
        }
        
    }
    
    WFTextView * commentView = [[WFTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.replyUserIconImageView.frame) + 7, CGRectGetMaxY(self.replyUsernameLB.frame) + 7, self.contentView.hd_width - 40, 11)];
    commentView.delegate = self;
    commentView.isDraw = YES;
    commentView.isFold = NO;
    commentView.attributedData = totalArr;
    commentView.canClickAll = NO;
    [commentView setOldString:matchString andNewString:newString];
    commentView.hd_height = [commentView getTextHeight];
    commentView.datauserInfoArr = [NSMutableArray arrayWithObjects:self.replyBody.replyUserInfo, self.replyBody.repliedUserInfo, nil];
    [self.contentView addSubview:commentView];
}

+(CGFloat)getcommentcellHeight:(WFReplyBody *)replyBody
{
    CGFloat height;
    
    NSString *matchString;
    NSMutableArray *feedBackArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if ([replyBody.repliedUser isEqualToString:@""]) {
        matchString = [NSString stringWithFormat:@"%@:%@",replyBody.replyUser,replyBody.replyInfo];
        NSString *range = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
        [tempArr addObject:range];
    }else
    {
        matchString = [NSString stringWithFormat:@"%@回复%@:%@",replyBody.replyUser,replyBody.repliedUser,replyBody.replyInfo];
        NSString *range1 = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
        NSString *range2 = NSStringFromRange(NSMakeRange(replyBody.replyUser.length + 2, replyBody.repliedUser.length));
        [tempArr addObject:range1];
        [tempArr addObject:range2];
    }
    [feedBackArray addObject:tempArr];
    
    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder];
    
    
    NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
    if (feedBackArray.count != 0) {
        NSArray *tArr = [feedBackArray objectAtIndex:0];
        for (int i = 0; i < [tArr count]; i ++) {
            NSString *string = [matchString substringWithRange:NSRangeFromString([tArr objectAtIndex:i])];
            [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
        }
        
    }
    
    WFTextView * commentView = [[WFTextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth - 95, 11)];
    commentView.isDraw = YES;
    commentView.isFold = NO;
    commentView.attributedData = totalArr;
    commentView.canClickAll = NO;
    [commentView setOldString:matchString andNewString:newString];
    commentView.hd_height = [commentView getTextHeight];
    
    height = 22 + [commentView getTextHeight];
    
    return height;
}

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if ([clickString isEqualToString:@""] && index != -1) {
        //reply
        //NSLog(@"reply");
        [_delegate clickRichText:0 replyIndex:index];
    }else{
        if ([clickString isEqualToString:@""]) {
            //
        }else{
            if ([NSString isTelPhoneNub:clickString] ) {
                return;
            }
            
            NSLog(@"clickString id = %@", clickString);
            //            [WFHudView showMsg:clickString inView:nil];
            
            [_delegate clickUserName:clickString];
            
        }
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
