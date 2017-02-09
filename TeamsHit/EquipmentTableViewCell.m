//
//  EquipmentTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "EquipmentTableViewCell.h"
#import "EquipmentCollectionViewCell.h"
#import "EquipmentcollectionModel.h"
#import "EquipmentModel.h"
#define CELL_ICENTIFIRE @"equipmentCollectionviewcellid"

@interface EquipmentTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, copy)EquipmentTypeBlock equipmentBlock;
@property (nonatomic, strong)UILabel * equipmentTitle;
@property (nonatomic, strong)UIButton * cancleBindingBT;
@property (nonatomic, strong)UICollectionView * collectionView;

@property (nonatomic, strong)NSMutableArray * array;

@end

@implementation EquipmentTableViewCell

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)createSubView:(CGRect)frame
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!_equipmentTitle) {
        self.equipmentTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 113, 15)];
        self.equipmentTitle.font = [UIFont systemFontOfSize:15];
        self.equipmentTitle.textColor = UIColorFromRGB(0x323232);
        self.equipmentTitle.text = @"设备名称(状态)";
        [self.contentView addSubview:self.equipmentTitle];
        
        self.cancleBindingBT = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBindingBT.frame = CGRectMake(frame.size.width - 110, 10, 100, 15);
        self.cancleBindingBT.backgroundColor = [UIColor whiteColor];
        [self.cancleBindingBT setTitle:@"解除账户绑定" forState:UIControlStateNormal];
        [self.cancleBindingBT setTitleColor:UIColorFromRGB(0xFF4C6A) forState:UIControlStateNormal];
        self.cancleBindingBT.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.cancleBindingBT];
        [self.cancleBindingBT addTarget:self action:@selector(cancleBind) forControlEvents:UIControlEventTouchUpInside];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(frame.size.width / 4, 111);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
         layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 31, frame.size.width, 111) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView registerClass:[EquipmentCollectionViewCell class] forCellWithReuseIdentifier:CELL_ICENTIFIRE];
        NSArray * imageArr = @[@"equipicon1", @"equipicon2", @"equipicon3", @"equipicon4-1"];
        NSArray * titleArr = @[@"配置WiFi", @"设备名称", @"蜂鸣器开关", @"指示灯开关"];
        for (int i = 0; i<4; i++) {
            EquipmentcollectionModel * model = [[EquipmentcollectionModel alloc]init];
            model.imageName = imageArr[i];
            model.titleName = titleArr[i];
            model.isbuzzer = NO;
            model.isIndicatorLight = NO;
            
            [self.array addObject:model];
        }
    }
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里没有cell的话，collectionView会自己创建该wifeCell,不用我们管（更深层次的原因是，我们已经把wifeCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    EquipmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ICENTIFIRE forIndexPath:indexPath];
    EquipmentcollectionModel * model = self.array[indexPath.row];
    
    cell.photoImageView.image = [UIImage imageNamed:model.imageName];
    cell.titleLB.text = model.titleName;
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    
    if (model.isbuzzer) {
        cell.photoImageView.image = [UIImage imageNamed:@"equipicon3-2"];
    }
    
    if (model.isIndicatorLight) {
        cell.photoImageView.image = [UIImage imageNamed:@"equipicon4-2"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.equipmentBlock) {
        _equipmentBlock(indexPath.item);
    }
}

- (void)getEquipmentOption:(EquipmentTypeBlock)equipmentBlock
{
    self.equipmentBlock = [equipmentBlock copy];
}

- (void)setEmodel:(EquipmentModel *)emodel
{
    
    switch (emodel.state.intValue) {
        case 0:
        {
            self.equipmentTitle.text = [NSString stringWithFormat:@"%@(在线)", emodel.deviceName];
        }
            break;
        case 1:
        {
            self.equipmentTitle.text = [NSString stringWithFormat:@"%@(缺纸)", emodel.deviceName];
        }
            break;
        case 2:
        {
            self.equipmentTitle.text = [NSString stringWithFormat:@"%@(温度保护报警)", emodel.deviceName];
        }
            break;
        case 3:
        {
            self.equipmentTitle.text = [NSString stringWithFormat:@"%@(忙碌)", emodel.deviceName];
        }
            break;
        case 4:
        {
            self.equipmentTitle.text = [NSString stringWithFormat:@"%@(离线，请配置WiFi)", emodel.deviceName];
        }
            break;
            
        default:
            break;
    }
    
    CGSize size = [self.equipmentTitle.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.equipmentTitle.hd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.equipmentTitle.hd_width = size.width;
    
    if (emodel.buzzer.intValue == 1) {
        EquipmentcollectionModel * model = self.array[2];
        model.isbuzzer = YES;
    }else
    {
        EquipmentcollectionModel * model = self.array[2];
        model.isbuzzer = NO;
    }
    
    if (emodel.indicator.intValue == 1) {
        EquipmentcollectionModel * model = self.array[3];
        model.isIndicatorLight = YES;
    }else
    {
        EquipmentcollectionModel * model = self.array[3];
        model.isIndicatorLight = NO;
    }
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cancleBind
{
    if (self.equipmentBlock) {
        _equipmentBlock(100);
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, .95, .95, .95, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 142);
    CGContextAddLineToPoint(context, self.hd_width, 142);
    CGContextStrokePath(context);
}

@end
