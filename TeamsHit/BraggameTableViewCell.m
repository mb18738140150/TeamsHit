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

@interface BraggameTableViewCell ()

@property (nonatomic, copy)ChooseDicepointCallOrOpenBlock myBlock;
@property (nonatomic, strong)BragGameModel * bragGameModel_refresh;
@end

@implementation BraggameTableViewCell

- (void)creatCell
{
    [self.contentView removeAllSubviews];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 11, 35, 35)];
    self.iconImageView.layer.cornerRadius = 17.5;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 7, 14, 55, 10)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.nameLabel];
    
    self.resultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 7, CGRectGetMaxY(self.nameLabel.frame) + 5, 23, 23)];
    [self.contentView addSubview:self.resultImageView];
    
    self.calldicePointStateView = [[CallDicePointStateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 7, CGRectGetMaxY(self.nameLabel.frame) + 3, 60, 28)];
    
    self.dicecupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 95, 13, 29, 32)];
    [self.contentView addSubview:self.dicecupImageView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((self.hd_width - 150 - 24) / 5, (self.hd_width - 150 - 24) / 5);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 6;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.diceCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 45, (self.hd_height - (self.hd_width - 150 - 24) / 5) / 2, self.hd_width - 150, (self.hd_width - 150 - 24) / 5) collectionViewLayout:layout];
    self.diceCollection.delegate = self;
    self.diceCollection.dataSource = self;
    self.diceCollection.backgroundColor = [UIColor clearColor];
    [self.diceCollection registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:DICECOLLECTIONCELL_IDENTIFIRE];
    
    [self.contentView addSubview:self.diceCollection];
    [self.contentView addSubview:self.calldicePointStateView];
    
    self.chooseDicecallTypeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseDicecallTypeBT.backgroundColor = [UIColor clearColor];
    self.chooseDicecallTypeBT.frame = CGRectMake(CGRectGetMaxX(self.diceCollection.frame) + 10, (self.hd_height - 30)/ 2, 30, 30);
    [self.contentView addSubview:self.chooseDicecallTypeBT];
    [self.chooseDicecallTypeBT addTarget:self action:@selector(chooseDicecallTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNeedsDisplay];
}

#pragma mark - collectionviewdelegate datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bragGameModel_refresh.showDicePointArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DICECOLLECTIONCELL_IDENTIFIRE forIndexPath:indexPath];
    
    cell.photoImageView.image = [UIImage imageNamed:self.bragGameModel_refresh.showDicePointArr[indexPath.row]];
     cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - refresh UI With Model
- (void)setBragGameModel:(BragGameModel *)bragGameModel
{
    self.bragGameModel_refresh = bragGameModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:bragGameModel.gameUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon"]];
    self.nameLabel.text = bragGameModel.gameUserInfo.name;
    
    if (bragGameModel.isFinish) {// 游戏结束
        self.calldicePointStateView.hidden = YES;
        self.chooseDicecallTypeBT.hidden = YES;
        self.dicecupImageView.hidden = YES;
        self.resultImageView.hidden = NO;
        self.diceCollection.hidden = NO;
        if (bragGameModel.isWin == IsWinTheGame_win) {
            self.resultImageView.image = [UIImage imageNamed:@"赢"];
        }else if(bragGameModel.isWin == IsWinTheGame_lose)
        {
            self.resultImageView.image = [UIImage imageNamed:@"输"];
        }
        
    }else
    {// 游戏还没有结束
        self.resultImageView.hidden = YES;
        
        // calldicePointStateBT 显示状态及内容
        self.calldicePointStateView.hidden = NO;
        if (bragGameModel.calledDicePointState != 0) {
            if (bragGameModel.calledDicePointState == CalledDicePoint_Now) {
                self.calldicePointStateView.content = [NSString stringWithFormat:@"%@个", bragGameModel.diceCount];
                self.calldicePointStateView.dicePointImage = [UIImage imageNamed:[NSString stringWithFormat:@"骰子%@", bragGameModel.dicePoint]];
            }else if (bragGameModel.calledDicePointState == CalledDicePoint_Wait)
            {
                self.calldicePointStateView.content = @"纠结中";
            }else
            {
#warning calldicePointStateView ******** 
                self.calldicePointStateView.hidden = YES;
            }
            
        }else
        {
            self.calldicePointStateView.hidden = YES;
        }
        
        if (bragGameModel.isUserself) {
            self.diceCollection.hidden = NO;
            self.dicecupImageView.hidden = YES;
            self.chooseDicecallTypeBT.hidden = NO;
            
        }else
        {
            self.diceCollection.hidden = YES;
            self.dicecupImageView.hidden = NO;
            self.chooseDicecallTypeBT.hidden = YES;
            
            // 不是玩家本人，判断是否已经摇过骰盅
            if (bragGameModel.isShakeDiceCup) {
                self.dicecupImageView.image = [UIImage imageNamed:@"小骰盅"];
            }else
            {
                self.dicecupImageView.image = [UIImage imageNamed:@"小骰盅-1"];
            }
            
        }
        
        // 是玩家本人
        if (bragGameModel.choosecallOrOpenType == ChooseCallOrOpen_Call) {
            [self.chooseDicecallTypeBT setImage:[UIImage imageNamed:@"chooseDicepointCallOrOpen_call"] forState:UIControlStateNormal];
        }else if (bragGameModel.choosecallOrOpenType == ChooseCallOrOpen_Open)
        {
            self.chooseDicecallTypeBT.hidden = NO;
            [self.chooseDicecallTypeBT setImage:[UIImage imageNamed:@"chooseDicepointCallOrOpen_open"] forState:UIControlStateNormal];
        }else
        {
            self.chooseDicecallTypeBT.hidden = YES;
        }
    }
    
    [self.diceCollection reloadData];
}

#pragma mark - chooseDicecallType 
- (void)chooseDicecallTypeAction:(UIButton *)button
{
    if (button.imageView.image) {
        UIImage * buttonImage = button.imageView.image;
        NSData * buttonImagedata = UIImagePNGRepresentation(buttonImage);
        NSData * callImageData = UIImagePNGRepresentation([UIImage imageNamed:@"chooseDicepointCallOrOpen_call"]);
        NSData * openImageData = UIImagePNGRepresentation([UIImage imageNamed:@"chooseDicepointCallOrOpen_open"]);
        
        if ([buttonImagedata isEqual:callImageData]) {
            if (self.myBlock) {
                _myBlock(@"叫点");
            }
        }else if ([buttonImagedata isEqual:openImageData])
        {
            if (self.myBlock) {
                _myBlock(@"开");
            }
        }
        
    }
    
}

- (void)getchooseDicepointCallOrOpen:(ChooseDicepointCallOrOpenBlock)block
{
    self.myBlock = [block copy];
}

#pragma mark - draw bottom line
- (void)drawRect:(CGRect)rect
{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 12, 59);
    CGContextAddLineToPoint(context, screenWidth - 42, 59);
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
