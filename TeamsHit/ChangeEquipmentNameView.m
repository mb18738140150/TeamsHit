//
//  ChangeEquipmentNameView.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ChangeEquipmentNameView.h"

@interface ChangeEquipmentNameView ()

@property (nonatomic, copy)EquipmentNameBlock equipmentBlock;

@end

@implementation ChangeEquipmentNameView
- (IBAction)cancleAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)changeNameAction:(id)sender {
    if (self.equipmentNameTF.text.length == 0) {
        if (self.title && self.title.length != 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@不能为空", self.title] delegate:nil
                                                   cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备名不能为空" delegate:nil
                                                   cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else
    {
        if (self.equipmentBlock) {
            _equipmentBlock(self.equipmentNameTF.text);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)getEquipmentOption:(EquipmentNameBlock)equipmentBlock
{
    self.equipmentBlock = [equipmentBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
