//
//  NewFriendListTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "NewFriendListTableViewCell.h"
#import "NewFriendModel.h"
@interface NewFriendListTableViewCell ()

@property (nonatomic, strong)UIImageView * detailImage;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * detaileLabel;
@property (nonatomic, strong)UIButton * acceptButton;

@property (nonatomic, copy)AcceptRequestBlock myBlock;

@end

@implementation NewFriendListTableViewCell

- (void)createSubView:(CGRect)frame
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!_detailImage) {
        
        self.detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 49, 49)];
        self.detailImage.layer.cornerRadius = 3;
        self.detailImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.detailImage];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_detailImage.frame) + 15, 14, 30, 16)];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = UIColorFromRGB(0x323232);
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        self.nameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.nameLabel.layer.borderWidth = .5;
//        NSLog(@"%f", self.nameLabel.layer.borderWidth);
        [self.contentView addSubview:self.nameLabel];
        
        self.detaileLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_detailImage.frame) + 15, CGRectGetMaxY(_nameLabel.frame) + 8, 30, 14)];
        self.detaileLabel.font = [UIFont systemFontOfSize:14];
        self.detaileLabel.textColor = UIColorFromRGB(0x999999);
        self.detaileLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.detaileLabel];
        
        self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.acceptButton.frame = CGRectMake(frame.size.width - 75, 17, 60, 30);
        [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
        self.acceptButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.acceptButton];
        self.acceptButton.layer.cornerRadius = 2;
        self.acceptButton.layer.masksToBounds = YES;
        self.acceptButton.backgroundColor = UIColorFromRGB(0x12B7F5);
        [self.acceptButton addTarget:self action:@selector(acceptItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setNFriendModel:(NewFriendModel *)nFriendModel
{
    [self.detailImage sd_setImageWithURL:[NSURL URLWithString:nFriendModel.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    self.nameLabel.text = nFriendModel.nickname;
    CGSize size = [self.nameLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.nameLabel.hd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    self.nameLabel.hd_width = size.width + 5;
    self.detaileLabel.text = nFriendModel.message;
    CGSize dsize = [self.detaileLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.detaileLabel.hd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.detaileLabel.hd_width = dsize.width;
    
    if (nFriendModel.status.intValue == 1) {
        self.acceptButton.enabled = NO;
        self.acceptButton.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.acceptButton setTitle:@"已添加" forState:UIControlStateNormal];
        [self.acceptButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        self.acceptButton.layer.cornerRadius = 2;
//        self.acceptButton.layer.masksToBounds = YES;
//        self.acceptButton.layer.borderWidth = .5;
//        self.acceptButton.layer.borderColor = [UIColor grayColor].CGColor;
    }else if (nFriendModel.status.intValue == 2)
    {
        self.acceptButton.enabled = YES;
        [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
        self.acceptButton.backgroundColor = UIColorFromRGB(0x12B7F5);
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (nFriendModel.status.intValue == 3)
    {
        self.acceptButton.enabled = NO;
        [self.acceptButton setTitle:@"等待验证" forState:UIControlStateNormal];
        self.acceptButton.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.acceptButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 0.95, 0.95, 0.95, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 63);
    CGContextAddLineToPoint(context, self.hd_width, 63);
    CGContextStrokePath(context);
    
}

- (void)acceptItemAction:(UIButton *)button
{
    if (self.myBlock) {
        _myBlock();
    }
}

- (void)acceptRequest:(AcceptRequestBlock)acceptRequestBlock
{
    self.myBlock = [acceptRequestBlock copy];
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
