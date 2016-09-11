//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 阿虎 on 15/4/29.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFMessageBody : NSObject
/**
 *  用户头像url 此处直接用图片名代替
 */
@property (nonatomic,copy) NSString *posterImgstr;//

/**
 *  用户名
 */
@property (nonatomic,copy) NSString *posterName;
/**
 *  用户Id
 */
@property (nonatomic,copy) NSString *posterUserId;

/**
 *  用户简介
 */
@property (nonatomic,copy) NSString *posterIntro;//

/**
 *  用户说说内容
 */
@property (nonatomic,copy) NSString *posterContent;//

/**
 *  用户说说id
 */
@property (nonatomic,strong) NSNumber *posterId;//
/**
 *  用户发送的图片数组
 */
@property (nonatomic,strong) NSArray *posterPostImage;//

@property (nonatomic, strong)NSArray *thumbnailPosterImage;// 缩略图数组

/**
 *  用户收到的赞 (该数组存点赞的人的昵称)
 */
@property (nonatomic,strong) NSMutableArray *posterFavour;
@property (nonatomic, strong)NSMutableArray *posterFavourUserArr;// 收到的赞的用户信息

/**
 *  用户说说的评论数组
 */
@property (nonatomic,strong) NSMutableArray *posterReplies;//

/**
 *  admin是否赞过
 */
@property (nonatomic,assign) BOOL isFavour;

/**
 *  发布时间
 */
@property (nonatomic,copy) NSString * publishTime;

@end
