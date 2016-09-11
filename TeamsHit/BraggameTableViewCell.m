//
//  BraggameTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BraggameTableViewCell.h"
#import "PublishCollectionViewCell.h"

#define DICECOLLECTIONCELL_IDENTIFIRE @"dicecollectioncell"


@implementation BraggameTableViewCell

- (void)creatCell
{
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 11, 35, 35)];
    self.iconImageView.layer.cornerRadius = 17.5;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 7, 14, 25, 10)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.nameLabel];
    
    self.resultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 7, CGRectGetMaxY(self.nameLabel.frame) + 5, 23, 23)];
    [self.contentView addSubview:self.resultImageView];
    
    self.dicecupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 95, 13, 29, 32)];
    [self.contentView addSubview:self.dicecupImageView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(27, 27);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 6;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.diceCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 60, 17, [UIScreen mainScreen].bounds.size.width - 197, 27) collectionViewLayout:layout];
    self.diceCollection.delegate = self;
    self.diceCollection.dataSource = self;
    self.diceCollection.backgroundColor = [UIColor clearColor];
    [self.diceCollection registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:DICECOLLECTIONCELL_IDENTIFIRE];
    
    [self.contentView addSubview:self.diceCollection];
    
    [self setNeedsDisplay];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DICECOLLECTIONCELL_IDENTIFIRE forIndexPath:indexPath];
     cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 12, 58);
    CGContextAddLineToPoint(context, screenWidth - 42, 58);
    CGContextStrokePath(context);
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
