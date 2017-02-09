//
//  ShuoShuoDetailViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/1/11.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "ShuoShuoDetailViewController.h"
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"
#import "WFReplyBody.h"
#import "YMTapGestureRecongnizer.h"
#import "WFHudView.h"
#import "WFPopView.h"
#import "ShuoshuoFavouriteAndCommentView.h"
#import "YMShowImageView.h"
#import "AppDelegate.h"
#import "UserFriendCircleViewController.h"
#import "WFActionSheet.h"
#import "YMReplyInputView.h"

#define kImageTag 9999
#define IMAGE_SPACE 5
#define bottomSpace 10
#define kAdmin [RCIM sharedRCIM].currentUserInfo.name

@interface ShuoShuoDetailViewController ()<WFCoretextDelegate, UIScrollViewDelegate, shuoshuoviewDelegate, InputDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
{
    MBProgressHUD * hud;
    YMTextData *tempDate;
    UIImageView *replyImageView;
    UILabel * publishTimeLabel;
    YMReplyInputView *replyView ;
    NSInteger _replyIndex;
}
@property (nonatomic, copy)delateShuoShuo myBlock;

@property (nonatomic, strong)UIScrollView * scrollview;
@property (nonatomic, strong)NSMutableArray * imageArray;
@property (nonatomic, strong)NSMutableArray * favouriteArray;
@property (nonatomic, strong)NSMutableArray * commentArray;
@property (nonatomic, strong)NSMutableArray * shuoshuoArray;
@property (nonatomic, strong) NSMutableArray * ymSeperateLinearr;
@property (nonatomic,strong) YMButton *replyBtn;
@property (nonatomic, strong)YMButton * deleteBtn;
@property (nonatomic, strong) ShuoshuoFavouriteAndCommentView * favouriteandCommentView;

@property (nonatomic,strong) WFPopView *operationView;

/**
 *  用户头像imageview
 */
@property (nonatomic,strong) UIImageView *userHeaderImage;

/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *userNameLbl;

/**
 *  用户简介label
 */
@property (nonatomic,strong) UILabel *userIntroLbl;

@end

@implementation ShuoShuoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.delegate = self;
    [self.view addSubview:self.scrollview];
    
    _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 43, TableHeader)];
    _userHeaderImage.backgroundColor = [UIColor clearColor];
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:self.shuoshuoUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    [self.scrollview addSubview:_userHeaderImage];
    _userHeaderImage.userInteractionEnabled = YES;
    _userHeaderImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * backtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [_userHeaderImage addGestureRecognizer:backtap];
    
    _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15 + TableHeader + 9, 5, screenWidth - 120, TableHeader/2)];
    _userNameLbl.textAlignment = NSTextAlignmentLeft;
    _userNameLbl.font = [UIFont systemFontOfSize:15.0];
    _userNameLbl.textColor = UIColorFromRGB(0x5B7883);
    _userNameLbl.text = _shuoshuoUserInfo.name;
    [self.scrollview addSubview:_userNameLbl];
    UITapGestureRecognizer * lookUserShuoshuotap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookUserShuoshuoAction)];
    [_userNameLbl addGestureRecognizer:lookUserShuoshuotap];
    
    _userIntroLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 20, 5 + TableHeader/2 , screenWidth - 120, TableHeader/2)];
    _userIntroLbl.numberOfLines = 1;
    _userIntroLbl.font = [UIFont systemFontOfSize:14.0];
    _userIntroLbl.textColor = [UIColor grayColor];
    //        [self.contentView addSubview:_userIntroLbl];
    
    _imageArray = [[NSMutableArray alloc] init];
    _commentArray = [[NSMutableArray alloc] init];
    _shuoshuoArray = [[NSMutableArray alloc] init];
    _favouriteArray = [[NSMutableArray alloc] init];
    _ymSeperateLinearr = [[NSMutableArray alloc] init];
    
    replyImageView = [[UIImageView alloc] init];
    
    replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self.scrollview addSubview:replyImageView];
    
    _replyBtn = [YMButton buttonWithType:0];
    [_replyBtn setImage:[UIImage imageNamed:@"fw_r2_c2.png"] forState:0];
    [self.scrollview addSubview:_replyBtn];
    [self.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    publishTimeLabel = [[UILabel alloc]init];
    publishTimeLabel.textColor = [UIColor grayColor];
    publishTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollview addSubview:publishTimeLabel];
    
    _deleteBtn = [YMButton buttonWithType:0];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:UIColorFromRGB(0x5B7883) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollview addSubview:_deleteBtn];
    
    [self.deleteBtn addTarget:self action:@selector(deletection:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _favouriteandCommentView = [[ShuoshuoFavouriteAndCommentView alloc] initWithFrame:CGRectZero];
    [self.scrollview addSubview:_favouriteandCommentView];
    
    _replyIndex = -1;
    [self loadData];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lookUserShuoshuoAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deletection:(UIButton *)button
{
    NSLog(@"删除");
    
    NSDictionary * jsonDic = @{
                               @"TakeId":self.takeId,
                               @"UserId":@([RCIM sharedRCIM].currentUserInfo.userId.intValue)
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@news/deleteTake?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak ShuoShuoDetailViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSLog(@"删除成功");
            if (weakSelf.myBlock) {
                weakSelf.myBlock(@"delate");
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}
- (void)deleteshuoshuoBlock:(delateShuoShuo)block
{
    self.myBlock = [block copy];
}
- (void)loadData
{
    NSDictionary * jsonDic = @{
                               @"TakeId":self.takeId
                               };
    NSLog(@"takeId = %@", self.takeId);
    NSString * url = [NSString stringWithFormat:@"%@news/GetFriendCircleTake?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak ShuoShuoDetailViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [wxVC getdataWithdic:responseObject];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getdataWithdic:(NSDictionary *)dic
{
    NSDictionary * friendCircleDic = dic;
    
    RCUserInfo * publishUser = [[RCUserInfo alloc]initWithUserId:self.shuoshuoUserInfo.userId name:self.shuoshuoUserInfo.name portrait:self.shuoshuoUserInfo.portraitUri];
    
    // 点赞数据
    BOOL isFavor = NO;
    NSMutableArray *posterFavourArr = [NSMutableArray array];
    NSMutableArray *posterFavourUserArr = [NSMutableArray array];
    NSArray * FavoriteLists = [friendCircleDic objectForKey:@"FavoriteLists"];
    for (int j = 0; j < FavoriteLists.count; j++) {
        
        NSDictionary * favoriteDic = [FavoriteLists objectAtIndex:j];
        
        NSNumber * FavoriteId = [favoriteDic objectForKey:@"FavoriteId"];
        NSDictionary * favoriteUserDic = [favoriteDic objectForKey:@"User"];
        RCUserInfo * favoriteUser = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@", [favoriteUserDic objectForKey:@"UserId"]] name:[favoriteUserDic objectForKey:@"DisplayName"] portrait:[favoriteUserDic objectForKey:@"PortraitUri"]];
        [posterFavourArr addObject:favoriteUser.name];
        [posterFavourUserArr addObject:favoriteUser];
        
        if (isFavor) {
            continue;
        }
        if ([favoriteUser.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            isFavor = YES;
        }
    }
    
    // 评论数据源
    NSArray * CommentLists = [friendCircleDic objectForKey:@"CommentLists"];
    NSMutableArray * posterReplies = [NSMutableArray array];
    for (int j = 0; j < CommentLists.count; j++) {
        NSDictionary * replyDic = [CommentLists objectAtIndex:j];
        WFReplyBody * body = [[WFReplyBody alloc]init];
        body.commentId = [replyDic objectForKey:@"CommentId"];
        body.replyInfo = [replyDic objectForKey:@"Content"];
        
        NSDictionary * userDic = [replyDic objectForKey:@"User"];
        RCUserInfo * User = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]] name:[userDic objectForKey:@"DisplayName"] portrait:[userDic objectForKey:@"PortraitUri"]];
        body.replyUser = User.name;
        body.replyUserInfo = User;
        
        NSDictionary * ToReplyUserDic = [replyDic objectForKey:@"ToReplyUser"];
        if (![ToReplyUserDic isEqual:[NSNull null]]) {
            RCUserInfo * toReplyUser = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@", [ToReplyUserDic objectForKey:@"UserId"]] name:[ToReplyUserDic objectForKey:@"DisplayName"] portrait:[ToReplyUserDic objectForKey:@"PortraitUri"]];
            body.repliedUser = toReplyUser.name;
            body.repliedUserInfo = toReplyUser;
            
        }else{
            body.repliedUser = @"";
            body.repliedUserInfo = [RCUserInfo new];
        }
        [posterReplies addObject:body];
    }
    
    WFMessageBody * messageBody = [[WFMessageBody alloc]init];
    messageBody.posterContent = [friendCircleDic objectForKey:@"TakeContent"];
    messageBody.posterId = self.takeId;
    messageBody.publishTime = [self getTimeStr:[friendCircleDic objectForKey:@"CreateTime"]];
    
    NSString * photoLists = [friendCircleDic objectForKey:@"PhotoLists"];
    if (![photoLists isEqual:[NSNull null]]) {
        if ([photoLists containsString:@","]) {
            NSArray * imageArr = [[friendCircleDic objectForKey:@"PhotoLists"] componentsSeparatedByString:@","];
            NSMutableArray * thumbnailImageArr = [NSMutableArray array];
            if (imageArr.count > 1) {
                messageBody.posterPostImage = imageArr;
                for (NSString * imageUrl in imageArr) {
                    NSString * newImageAtr = [imageUrl stringByAppendingString:@".w150.png"];
                    [thumbnailImageArr addObject:newImageAtr];
                }
                
            }else
            {
                messageBody.posterPostImage = @[imageArr.firstObject];
                for (NSString * imageUrl in imageArr) {
                    NSString * newImageAtr = [imageUrl stringByAppendingString:@".w375.png"];
                    [thumbnailImageArr addObject:newImageAtr];
                }
            }
            
            messageBody.thumbnailPosterImage = [thumbnailImageArr copy];
            //                messageBody.posterPostImage = [[friendCircleDic objectForKey:@"PhotoLists"] componentsSeparatedByString:@","];
        }else
        {
            messageBody.posterPostImage = @[[friendCircleDic objectForKey:@"PhotoLists"]];
            messageBody.thumbnailPosterImage = @[[NSString stringWithFormat:@"%@%@", [friendCircleDic objectForKey:@"PhotoLists"],@".w375.png" ]];
        }
    }
    messageBody.posterReplies = posterReplies;
    messageBody.posterImgstr = publishUser.portraitUri;
    messageBody.posterName = publishUser.name;
    messageBody.posterUserId = publishUser.userId;
    messageBody.posterFavour = posterFavourArr;
    messageBody.posterFavourUserArr = posterFavourUserArr;
    messageBody.isFavour = isFavor;
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        
            
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = messageBody;
        
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        [ymData.attributedDataFavour removeAllObjects];
        [ymData.attributedDataShuoshuo removeAllObjects];
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself refreshUIWith:ymData];
        });
        
    });
    
}

- (NSString *)getTimeStr:(NSNumber *)number
{
    double lastactivityInterval = [number doubleValue];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    
    NSLog(@"time = %.0f", time);
    
    if (time < 60 && time >= 0) {
        return @"刚刚";
    } else if (time >= 60 && time < 3600) {
        return [NSString stringWithFormat:@"%.0f分钟前", time / 60];
    } else if (time >= 3600 && time < 3600 * 24) {
        return [NSString stringWithFormat:@"%.0f小时前", time / 3600];
    } else if (time >= 3600 * 24 && time < 3600 * 24 * 2) {
        return @"昨天";
    } else if (time >= 3600 * 24 * 2 && time < 3600 * 24 * 30) {
        return [NSString stringWithFormat:@"%.0f天前", time / 3600 / 24];
    } else if (time >= 3600 * 24 * 30 && time < 3600 * 24 * 30 * 12) {
        return [NSString stringWithFormat:@"%.0f月前", time / 3600 / 24 / 30];
    } else if (time >= 3600 * 24 * 30 * 12) {
        return [NSString stringWithFormat:@"%.0f年前", time / 3600 / 24 / 30 / 12];
    } else {
        return @"刚刚";
    }
    
    NSString * dateString = [fomatter stringFromDate:date];
    
    return dateString;
    
}

- (void)refreshUIWith:(YMTextData *)ymData
{
    tempDate = ymData;
#pragma mark -  //头像 昵称 简介
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:tempDate.messageBody.posterImgstr] placeholderImage:[UIImage imageNamed:@"logo(1)"]];;
    _userNameLbl.text = tempDate.messageBody.posterName;
    _userIntroLbl.text = tempDate.messageBody.posterIntro;
    publishTimeLabel.text = tempDate.messageBody.publishTime;
    
    if (![[NSString stringWithFormat:@"%@",ymData.messageBody.posterUserId]isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId] ) {
        _deleteBtn.hidden = YES;
    }else
    {
        _deleteBtn.hidden = NO;
    }
    
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _shuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_shuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_shuoshuoArray removeAllObjects];
    
#pragma mark - // /////////添加说说view
    
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X, 10 + TableHeader/2, screenWidth - offSet_X - offSet_X_right, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataShuoshuo;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    
    [self.scrollview addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;

    textView.frame = CGRectMake(offSet_X, 10 + TableHeader/2, screenWidth -offSet_X_right - offSet_X, hhhh);
    
    [_shuoshuoArray addObject:textView];
    
#pragma mark - /////// //图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
        
    }
    
    [_imageArray removeAllObjects];
    
    if ([ymData.showImageArray count] > 1) {
        for (int  i = 0; i < [ymData.showImageArray count]; i++) {
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(offSet_X + IMAGE_SPACE*(i%3) + ((screenWidth - offSet_X - 2 * offSet_X_right) / 3)*(i%3), TableHeader + 5 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30) - 30, ShowImage_H, ShowImage_H)];
            image.userInteractionEnabled = YES;
            [image setContentMode:UIViewContentModeScaleAspectFill];
            image.clipsToBounds = YES;
            YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [image addGestureRecognizer:tap];
            tap.appendArray = ymData.showImageArray;
            image.backgroundColor = [UIColor clearColor];
            image.tag = kImageTag + i;
            //        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
            
            [image sd_setImageWithURL:[NSURL URLWithString:[ymData.thumbnailShowImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
            
            [self.scrollview addSubview:image];
            [_imageArray addObject:image];
            
        }
    }else if ([ymData.showImageArray count] == 1)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(offSet_X , TableHeader + hhhh + kDistance + (ymData.islessLimit?0:30) - 30, ymData.showImageWidth, ymData.showImageHeight)];
        image.userInteractionEnabled = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        tap.appendArray = ymData.showImageArray;
        image.backgroundColor = [UIColor clearColor];
        image.tag = kImageTag;
        
        [image sd_setImageWithURL:[NSURL URLWithString:[ymData.thumbnailShowImageArray firstObject]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
        
        [self.scrollview addSubview:image];
        [_imageArray addObject:image];
    }
    
    self.favouriteandCommentView = [[ShuoshuoFavouriteAndCommentView alloc]initWithFrame:CGRectMake(10, ymData.showImageHeight + ymData.unFoldShuoHeight + 52 + 49, screenWidth - 20, 1000) withData:ymData];
    self.favouriteandCommentView.hd_height = self.favouriteandCommentView.viewHeight;
    [self.scrollview addSubview:self.favouriteandCommentView];
    _favouriteandCommentView.delegate = self;
    CGSize publishSize = [self getpublishSizeWith:ymData.messageBody.publishTime];
    
//    replyImageView.frame = CGRectMake(offSet_X, TableHeader + 10 + ymData.showImageHeight + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 0, 0);
    _replyBtn.frame = CGRectMake(screenWidth - offSet_X_right - 40 + 6,ymData.unFoldShuoHeight + ymData.showImageHeight + 49, 40, 18);
    publishTimeLabel.frame = CGRectMake(offSet_X , CGRectGetMinY(_replyBtn.frame), publishSize.width, publishSize.height);
    _deleteBtn.frame = CGRectMake(CGRectGetMaxX(publishTimeLabel.frame) + 15 , CGRectGetMinY(_replyBtn.frame), 30, publishSize.height);
    
    self.scrollview.contentSize = CGSizeMake(screenWidth, ymData.showImageHeight + ymData.unFoldShuoHeight + self.favouriteandCommentView.hd_height + 52 + 49 + 64);
}
- (CGSize)getpublishSizeWith:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return size;
}
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    UIImageView * imageView = (UIImageView *)tapGes.view;
    [self.operationView dismiss];
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds byClick:tapGes.view.tag appendArray:tapGes.appendArray placeImage:imageView.image];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
}


- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = self.replyBtn.frame;
    CGFloat origin_Y =  sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    YMTextData *ym = tempDate;
    [self.operationView showAtView:self.scrollview rect:targetRect isFavour:ym.messageBody.isFavour];
}
- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws addLike];
                    break;
                case WFOperationTypeReply:
                    [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}
#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
}


#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = tempDate;
    WFMessageBody *m = ymData.messageBody;
    
    NSString * myUserIdStr = [RCIM sharedRCIM].currentUserInfo.userId;
    NSNumber * myUserId = @(myUserIdStr.intValue);
    
    if (m.isFavour == YES) {//此时该取消赞
        
        NSDictionary * jsonDic = @{
                                   @"UserId":m.posterUserId,
                                   @"TakeId":m.posterId
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@news/canclethumbsUp?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak ShuoShuoDetailViewController * weakself = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                [m.posterFavour removeObject:kAdmin];
                for (int i = 0; i < m.posterFavourUserArr.count; i++) {
                    RCUserInfo * userInfo = [m.posterFavourUserArr objectAtIndex:i];
                    if ([kAdmin isEqualToString:userInfo.name]) {
                        [m.posterFavourUserArr removeObject:userInfo];
                        break;
                    }
                }
                m.isFavour = NO;
                ymData.favourHeight = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself refreshUIWithnewdata:ymData];
                });
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }else{
        
        NSDictionary * jsonDic = @{
                                   @"UserId":m.posterUserId,
                                   @"TakeId":m.posterId
                                   };
        NSLog(@"jsonDic = %@", jsonDic);
        NSString * url = [NSString stringWithFormat:@"%@news/thumbsUp?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak ShuoShuoDetailViewController * weakself = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                [m.posterFavour addObject:kAdmin];
                RCUserInfo * xiaohuUserinfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:kAdmin portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri];
                [m.posterFavourUserArr addObject:xiaohuUserinfo];
                m.isFavour = YES;
                ymData.favourHeight = [ymData calculateFavourHeightWithWidth:weakself.view.frame.size.width];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself refreshUIWithnewdata:ymData];
                });
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }
    
}
#pragma mark - 评论
- (void)replyMessage:(YMButton *)sender{
    
    NSLog(@"评论");
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    [self.view addSubview:replyView];
    
}

- (void)clickRichText:(WFReplyBody *)replyBody index:(NSInteger)index
{
    [self.operationView dismiss];
    
    YMTextData *ymData = tempDate;
    WFReplyBody *b = replyBody;
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        
    }else{
        //回复
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        _replyIndex = index;
        [self.view addSubview:replyView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    [self.operationView dismiss];
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        ymData = tempDate;
        WFMessageBody *m = ymData.messageBody;
        
        NSDictionary * jsonDic = @{
                                   @"TakeId":m.posterId,
                                   @"TargetId":@0,
                                   @"CommentId":@0,
                                   @"Isreply":@2,
                                   @"Reviewcontent":replyText,
                                   @"TakeUserId":@(m.posterUserId.intValue)
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@news/publishComment?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak ShuoShuoDetailViewController * wxVC = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            NSNumber * CommentId = [responseObject objectForKey:@"CommentId"];
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUser = kAdmin;
                body.repliedUser = @"";
                RCUserInfo * xiaohuUserinfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:kAdmin portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri];
                body.replyUserInfo = xiaohuUserinfo;
                body.replyInfo = replyText;
                body.commentId = CommentId;
                
                [m.posterReplies addObject:body];
                ymData.messageBody = m;
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:wxVC.view.frame.size.width];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wxVC refreshUIWithnewdata:ymData];
                });
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        _replyIndex = -1;
    }else{
        
        ymData = tempDate;
        WFMessageBody *m = ymData.messageBody;
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.commentId = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] commentId];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        body.replyUserInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:kAdmin portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri];
        WFReplyBody * body1 = [m.posterReplies objectAtIndex:_replyIndex];
        body.repliedUserInfo = [[RCUserInfo alloc]initWithUserId:body1.replyUserInfo.userId name:body1.replyUserInfo.name portrait:body1.replyUserInfo.portraitUri];;
        
        
        NSDictionary * jsonDic = @{
                                   @"TakeId":m.posterId,
                                   @"TargetId":@(body.repliedUserInfo.userId.intValue),
                                   @"CommentId":body.commentId,
                                   @"Isreply":@1,
                                   @"Reviewcontent":replyText,
                                   @"TakeUserId":@(m.posterUserId.intValue)
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@news/publishComment?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak ShuoShuoDetailViewController * wxVC = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                NSNumber * CommentId = [responseObject objectForKey:@"CommentId"];
                body.commentId = CommentId;
                [m.posterReplies addObject:body];
                ymData.messageBody = m;
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:wxVC.view.frame.size.width];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wxVC refreshUIWithnewdata:ymData];
                });
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
    
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        _replyIndex = -1;
    }
    
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = tempDate;
        WFMessageBody *m = ymData.messageBody;
        WFReplyBody * body = [m.posterReplies objectAtIndex:actionSheet.actionIndex];
        NSDictionary * jsonDic = @{
                                   @"TakeId":m.posterId,
                                   @"CommentId":body.commentId
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@news/deleteComment?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak ShuoShuoDetailViewController * weakself = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                [m.posterReplies removeObjectAtIndex:actionSheet.actionIndex];
                ymData.messageBody = m;
                [ymData.completionReplySource removeAllObjects];
                [ymData.attributedDataReply removeAllObjects];
                
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:weakself.view.frame.size.width];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself refreshUIWithnewdata:ymData];
                });
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            _replyIndex = -1;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            _replyIndex = -1;
        }];
        
    }else{
        
    }
}

- (void)refreshUIWithnewdata:(YMTextData *)ymData
{
    [self.favouriteandCommentView refreshUIWith:ymData];
    self.favouriteandCommentView.frame = CGRectMake(10, ymData.showImageHeight + ymData.unFoldShuoHeight + 52 + 49, screenWidth - 20, 1000);
    self.favouriteandCommentView.hd_height = self.favouriteandCommentView.viewHeight;
    
    self.scrollview.contentSize = CGSizeMake(screenWidth, ymData.showImageHeight + ymData.unFoldShuoHeight + self.favouriteandCommentView.hd_height + 52 + 49 + 64);
}

- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex
{
    
}
- (void)viewclickUserName:(NSString *)userId
{
    [self.operationView dismiss];
    [self lookUserFriendCircle:userId];
}
- (void)lookUserFriendCircle:(NSString *)userId
{
    [self.operationView dismiss];
    
    UserFriendCircleViewController * vc = [[UserFriendCircleViewController alloc]init];
    vc.userId = @(userId.intValue);
    [vc exchangeWallImage:^(UIImage *image) {
        if (image) {
//            backImageView.image = image;
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index
{
    
}

- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
