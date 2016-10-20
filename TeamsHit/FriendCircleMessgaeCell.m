//
//  FriendCircleMessgaeCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendCircleMessgaeCell.h"
#import "FriendCircleMessgaeModel.h"

NSString * const KFriendCircleMessgaeCellIdentifire = @"FriendCircleMessgaeCellIdentifire";

@implementation FriendCircleMessgaeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)creatcellUIwith:(CGRect *)rect
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.commentUserIcon) {
        self.commentUserIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 63, 63)];
        [self.contentView addSubview:self.commentUserIcon];
        
        self.commentUserNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 19, 20, 16)];
        _commentUserNameLabel.textColor = UIColorFromRGB(0x12B7F5);
        _commentUserNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_commentUserNameLabel];
        
        self.likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(92, 41, 18, 17)];
        self.likeImageView.image = [UIImage imageNamed:@"zan1.png"];
        [self.contentView addSubview:self.likeImageView];
        
        self.commentContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(93, 43, CommentWidth, 14)];
        self.commentContentLabel.font = [UIFont systemFontOfSize:14];
        self.commentContentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentContentLabel];
        
        self.commentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 69, 100, 12)];
        self.commentTimeLabel.textColor = UIColorFromRGB(0x999999);
        self.commentTimeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_commentTimeLabel];
        
        
        self.takeImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width - 77, 17, 62, 62)];
        self.takeImageIcon.backgroundColor = UIColorFromRGB(0xEAEAEA);
        [self.contentView addSubview:self.takeImageIcon];
        
        self.takeContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 77, 17, 62, 62)];
        self.takeContentLabel.numberOfLines = 0;
        self.takeContentLabel.textColor = UIColorFromRGB(0x999999);
        self.takeContentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.takeContentLabel];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FriendCircleMessgaeModel *)model
{
    [self.commentUserIcon sd_setImageWithURL:[NSURL URLWithString:model.userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1).png"]];
    self.commentUserNameLabel.text = model.userInfo.name;
    
    CGSize nameSize = [self.commentUserNameLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.commentUserNameLabel.frame = CGRectMake(88, 19, nameSize.width, 16);
    
    if (model.IsFavoriteAndComenmt.integerValue == 2) {
        self.commentContentLabel.hidden = NO;
        self.commentContentLabel.text = model.CommentContent;
        CGSize contentSize = [self.commentContentLabel.text boundingRectWithSize:CGSizeMake(CommentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        self.commentContentLabel.frame =CGRectMake(93, 43, CommentWidth, contentSize.height);
        self.likeImageView.hidden = YES;
    }else
    {
        self.commentContentLabel.hidden = YES;
        self.likeImageView.hidden = NO;
        self.likeImageView.frame = CGRectMake(self.commentUserIcon.hd_width + self.commentUserIcon.hd_x + 16, self.likeImageView.hd_y, self.likeImageView.hd_width, self.likeImageView.hd_height);
    }
    self.commentTimeLabel.frame = CGRectMake(self.commentTimeLabel.hd_x , self.commentContentLabel.hd_y + model.commentHeight + 11, self.commentTimeLabel.hd_width, self.commentTimeLabel.hd_height);
    
    self.commentTimeLabel.text = [self getTimeStr:model.CreateTime];
    
    if (model.TakePhoto) {
        [self.takeImageIcon sd_setImageWithURL:[NSURL URLWithString:model.TakePhoto] placeholderImage:[UIImage imageNamed:@"logo(1).png"]];
        self.takeContentLabel.hidden = YES;
    }else
    {
        self.takeImageIcon.image = nil;
        self.takeContentLabel.hidden = NO;
        self.takeContentLabel.text = model.TakeContent;
    }
}
- (NSString *)getTimeStr:(NSNumber *)number
{
    double lastactivityInterval = [number doubleValue];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    
    NSLog(@"time = %.0f", time);
    
    if (time < 60 && time >= 0) {
        return @"刚刚";
    } else if (time >= 60 && time < 3600) {
        return [NSString stringWithFormat:@"%.0f分钟前", time / 60];
    } else if (time >= 3600 && time < 3600 * 24) {
        return [NSString stringWithFormat:@"%.0f小时前", time / 3600];
    } else if (time >= 3600 * 24 && time < 3600 * 24 * 2) {
        return @"昨天";
    } else if (time >= 3600 * 24 * 2 && time < 3600 * 24 * 30) {
        return [NSString stringWithFormat:@"%.0f天前", time / 3600 / 24];
    } else if (time >= 3600 * 24 * 30 && time < 3600 * 24 * 30 * 12) {
        return [NSString stringWithFormat:@"%.0f月前", time / 3600 / 24 / 30];
    } else if (time >= 3600 * 24 * 30 * 12) {
        return [NSString stringWithFormat:@"%.0f年前", time / 3600 / 24 / 30 / 12];
    } else {
        return @"刚刚";
    }
    
    NSString * dateString = [fomatter stringFromDate:date];
    
    return dateString;
    
}
@end
