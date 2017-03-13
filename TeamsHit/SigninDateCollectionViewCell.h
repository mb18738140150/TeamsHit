//
//  SigninDateCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/1.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigninModel.h"
@interface SigninDateCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *backImageView;

@property (strong, nonatomic) IBOutlet UILabel *dateLB;

@property (nonatomic, strong)SigninModel * model;


-(void)cleanContaintView;

@end
