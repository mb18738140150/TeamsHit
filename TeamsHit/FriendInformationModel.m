//
//  FriendInformationModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendInformationModel.h"

@implementation FriendInformationModel

- (instancetype)initWithDictionery:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.galleriesList = [NSMutableArray array];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"GalleryList"]) {
        for (NSDictionary * imageUrlDic in value) {
            [self.galleriesList addObject:[imageUrlDic objectForKey:@"ImgUrl"]];
        }
    }
    NSLog(@"UndefinedKey = %@", key);
}

@end
