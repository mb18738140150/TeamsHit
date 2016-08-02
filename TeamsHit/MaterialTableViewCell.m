//
//  MaterialTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialTableViewCell.h"
#import "MaterialDataModel.h"

#define IMAGEWIDTH 120

@interface MaterialTableViewCell ()

@property (nonatomic, copy)DeleteBlock deleteBlock;
@property (nonatomic, strong)UIImageView * detailImage;
@property (nonatomic, strong)UIButton * deleteButton;

@end

@implementation MaterialTableViewCell

- (void)createSubView:(CGRect)frame
{
    if (!_detailImage) {
        
        self.detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width / 2 - 60, 5, 120, 120)];
        [self.contentView addSubview:self.detailImage];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(frame.size.width - 50, 10, 20, 20);
        [self.deleteButton setImage:[[UIImage imageNamed:@"imgErro"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(deletaItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setMaterialmodel:(MaterialDataModel *)materialmodel
{
    self.detailImage.image = materialmodel.image;
    if (materialmodel.image.size.width > materialmodel.image.size.height) {
        if (materialmodel.image.size.width > 120) {
            self.detailImage.frame = CGRectMake(0, 0, IMAGEWIDTH, IMAGEWIDTH *materialmodel.image.size.height / materialmodel.image.size.width );
            self.detailImage.center = self.contentView.center;
        }else
        {
            self.detailImage.frame = CGRectMake(0, 0, materialmodel.image.size.width, materialmodel.image.size.height);
            self.detailImage.center = self.contentView.center;
        }
    }else
    {
        if (materialmodel.image.size.height > 120) {
            self.detailImage.frame = CGRectMake(0, 0, IMAGEWIDTH *materialmodel.image.size.width / materialmodel.image.size.height, IMAGEWIDTH );
            self.detailImage.center = self.contentView.center;
        }else
        {
            self.detailImage.frame = CGRectMake(0, 0, materialmodel.image.size.width, materialmodel.image.size.height);
            self.detailImage.center = self.contentView.center;
        }
    }
}

- (void)deletaItemAction:(UIButton *)button
{
    if (self.deleteBlock) {
        _deleteBlock();
    }
}

- (void)deleteItem:(DeleteBlock)deleteBlock
{
    self.deleteBlock = [deleteBlock copy];
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
