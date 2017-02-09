//
//  TypeofGameTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/26.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BegainGameBlock)();
typedef void(^LookRullerBlock)();

@interface TypeofGameTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *typeOfGameImageView;
@property (strong, nonatomic) IBOutlet UILabel *titlelabel;
@property (strong, nonatomic) IBOutlet UILabel *begainGameLabel;
@property (strong, nonatomic) IBOutlet UILabel *rullerLabel;

- (void)begainGame:(BegainGameBlock)block;
- (void)lookRuller:(LookRullerBlock)block;

@end
