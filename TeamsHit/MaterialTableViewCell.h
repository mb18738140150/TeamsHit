//
//  MaterialTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaterialDataModel;

typedef void(^DeleteBlock)();

@interface MaterialTableViewCell : UITableViewCell

@property (nonatomic, strong)MaterialDataModel * materialmodel;

- (void)createSubView:(CGRect)frame;

- (void)deleteItem:(DeleteBlock)deleteBlock;

@end
