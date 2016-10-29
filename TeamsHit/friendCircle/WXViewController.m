//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"

#import "AppDelegate.h"
#import <MJRefresh.h>

#import "PublishCircleOfFriendViewController.h"
#import "ExchangeBackwallImageViewController.h"
#import "FriendCircleMessgaeViewController.h"
#import "NoreadMessageCell.h"
#import "RCFriendCircleUserInfo.h"

#import "UserFriendCircleViewController.h"

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin [RCIM sharedRCIM].currentUserInfo.name


@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UITableView *mainTable;
    
    UIView *popView;
    UIView * backwallView;
    UIImageView * backImageView;
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    
        MBProgressHUD* hud ;
    
}
@property (nonatomic, assign)BOOL isPublish;
@property (nonatomic, strong)NSNumber * AllCount;
@property (nonatomic, assign)int page;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong)UIView * noReadMessageView;

@property (nonatomic, assign)BOOL isHaveNoreadMessage;


@property (nonatomic, strong)YMTextData * deleteYMTextdata;

@end

@implementation WXViewController


#pragma mark - 数据源
- (void)configData{
    
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    NSString * chang = @"http://img4.duitang.com/uploads/item/201602/22/20160222232729_T8Qku.thumb.700_0.jpeg";
    NSString * kuan = @"http://tupian.enterdesk.com/2015/xll/07/4/Zoro7.jpg";
    NSString * fang = @"http://imgsrc.baidu.com/forum/pic/item/5882b2b7d0a20cf4ee25596676094b36adaf99d6.jpg";
    
    RCUserInfo * xiaohuUserinfo = [[RCUserInfo alloc]initWithUserId:@"小虎tiger-100" name:kAdmin portrait:@"hhh"];
    RCUserInfo * honglingjinUserInfo = [[RCUserInfo alloc]initWithUserId:@"红领巾-101" name:@"红领巾" portrait:@"hhh"];
    RCUserInfo * dienUserInfo = [[RCUserInfo alloc]initWithUserId:@"迪恩-102" name:@"迪恩" portrait:@"hhh"];
    RCUserInfo * shanmuUserInfo = [[RCUserInfo alloc]initWithUserId:@"山姆-103" name:@"山姆" portrait:@"hhh"];
    RCUserInfo * leifengUserInfo = [[RCUserInfo alloc]initWithUserId:@"雷锋-104" name:@"雷锋" portrait:@"hhh"];
    RCUserInfo * jiansenakesiUserInfo = [[RCUserInfo alloc]initWithUserId:@"简森·阿克斯-105" name:@"简森·阿克斯" portrait:@"hhh"];
    RCUserInfo * lurenjiaUserInfo = [[RCUserInfo alloc]initWithUserId:@"路人甲-106" name:@"路人甲" portrait:@"hhh"];
    RCUserInfo * xiewanasiUserInfo = [[RCUserInfo alloc]initWithUserId:@"希尔瓦娜斯-107" name:@"希尔瓦娜斯" portrait:@"hhh"];
    RCUserInfo * lukuiUserInfo = [[RCUserInfo alloc]initWithUserId:@"鹿盔-108" name:@"鹿盔" portrait:@"hhh"];
    RCUserInfo * sainaliusiUserInfo = [[RCUserInfo alloc]initWithUserId:@"塞纳留斯-109" name:@"塞纳留斯" portrait:@"hhh"];
    RCUserInfo * heishouUserInfo = [[RCUserInfo alloc]initWithUserId:@"黑手-109" name:@"黑手" portrait:@"hhh"];
    RCUserInfo * geluerUserInfo = [[RCUserInfo alloc]initWithUserId:@"格鲁尔-110" name:@"格鲁尔" portrait:@"hhh"];
    RCUserInfo * moshoushijieUserInfo = [[RCUserInfo alloc]initWithUserId:@"魔兽世界5区石锤人类联盟女圣骑丨阿诺丨-111" name:@"魔兽世界5区石锤人类联盟女圣骑丨阿诺丨" portrait:@"hhh"];
    RCUserInfo * gangtienvwushenUserInfo = [[RCUserInfo alloc]initWithUserId:@"钢铁女武神-113" name:@"钢铁女武神" portrait:@"hhh"];
    RCUserInfo * kesuenUserInfo = [[RCUserInfo alloc]initWithUserId:@"克苏恩-112" name:@"克苏恩" portrait:@"hhh"];
    RCUserInfo * keersujiadeUserInfo = [[RCUserInfo alloc]initWithUserId:@"克尔苏加德-114" name:@"克尔苏加德" portrait:@"hhh"];
    RCUserInfo * gangtieyihuiUserInfo = [[RCUserInfo alloc]initWithUserId:@"钢铁议会-115" name:@"钢铁议会" portrait:@"hhh"];
    RCUserInfo * baolierongyanUserInfo = [[RCUserInfo alloc]initWithUserId:@"爆裂熔岩-116" name:@"爆裂熔岩" portrait:@"hhh"];
    RCUserInfo * aersasiUserInfo = [[RCUserInfo alloc]initWithUserId:@"阿尔萨斯-117" name:@"阿尔萨斯" portrait:@"hhh"];
    RCUserInfo * siwangzhiyiUserInfo = [[RCUserInfo alloc]initWithUserId:@"死亡之翼-118" name:@"死亡之翼" portrait:@"hhh"];
    RCUserInfo * maligousiUserInfo = [[RCUserInfo alloc]initWithUserId:@"玛里苟斯-119" name:@"玛里苟斯" portrait:@"hhh"];
    
    WFReplyBody *body1 = [[WFReplyBody alloc] init];
    body1.replyUser = kAdmin;
    body1.repliedUser = @"红领巾";
    body1.replyInfo = kContentText1;
    body1.repliedUserInfo = honglingjinUserInfo;
    body1.replyUserInfo = xiaohuUserinfo;
    
    WFReplyBody *body2 = [[WFReplyBody alloc] init];
    body2.replyUser = @"迪恩";
    body2.repliedUser = @"";
    body2.replyInfo = kContentText2;
    body2.replyUserInfo = dienUserInfo;
    
    WFReplyBody *body3 = [[WFReplyBody alloc] init];
    body3.replyUser = @"山姆";
    body3.repliedUser = @"";
    body3.replyInfo = kContentText3;
    body3.replyUserInfo = shanmuUserInfo;
    
    WFReplyBody *body4 = [[WFReplyBody alloc] init];
    body4.replyUser = @"雷锋";
    body4.repliedUser = @"简森·阿克斯";
    body4.replyInfo = kContentText4;
    body4.repliedUserInfo = jiansenakesiUserInfo;
    body4.replyUserInfo = leifengUserInfo;
    
    WFReplyBody *body5 = [[WFReplyBody alloc] init];
    body5.replyUser = kAdmin;
    body5.repliedUser = @"";
    body5.replyInfo = kContentText5;
    body5.replyUserInfo = xiaohuUserinfo;
    
    WFReplyBody *body6 = [[WFReplyBody alloc] init];
    body6.replyUser = @"红领巾";
    body6.repliedUser = @"";
    body6.replyInfo = kContentText6;
    body6.repliedUserInfo = honglingjinUserInfo;
    
    WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
    messBody1.posterContent = kShuoshuoText1;
    messBody1.posterPostImage = @[chang];
    messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody1.posterImgstr = @"mao.jpg";
    messBody1.posterName = @"迪恩·温彻斯特";
    messBody1.posterIntro = @"这个人很懒，什么都没有留下";
    messBody1.publishTime = @"2016-8-20";
    messBody1.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔",@"爆裂熔岩", nil];
    messBody1.posterFavourUserArr = [NSMutableArray arrayWithObjects:lurenjiaUserInfo, xiewanasiUserInfo, xiaohuUserinfo, lukuiUserInfo,baolierongyanUserInfo, nil];
    messBody1.isFavour = YES;
    
    WFMessageBody *messBody2 = [[WFMessageBody alloc] init];
    messBody2.posterContent = kShuoshuoText1;
    messBody2.posterPostImage = @[kuan];
    messBody2.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody2.posterImgstr = @"mao.jpg";
    messBody2.posterName = @"山姆·温彻斯特";
    messBody2.posterIntro = @"这个人很懒，什么都没有留下";
    messBody2.publishTime = @"2016-8-20";
    messBody2.posterFavour = [NSMutableArray arrayWithObjects:@"塞纳留斯",@"希尔瓦娜斯",@"鹿盔", nil];
    messBody2.posterFavourUserArr = [NSMutableArray arrayWithObjects:sainaliusiUserInfo, xiewanasiUserInfo, lukuiUserInfo, nil];
    messBody2.isFavour = NO;
    
    
    WFMessageBody *messBody3 = [[WFMessageBody alloc] init];
    messBody3.posterContent = kShuoshuoText3;
    messBody3.posterPostImage = @[chang,kuan,fang];
    messBody3.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body6,body5,body4, nil];
    messBody3.posterImgstr = @"mao.jpg";
    messBody3.posterName = @"伊利丹怒风";
    messBody3.posterIntro = @"这个人很懒，什么都没有留下";
    messBody3.publishTime = @"2016-8-20";
    messBody3.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",kAdmin,@"希尔瓦娜斯",@"鹿盔",@"黑手", nil];
    messBody3.posterFavourUserArr = [NSMutableArray arrayWithObjects:lurenjiaUserInfo, xiaohuUserinfo, xiewanasiUserInfo, lukuiUserInfo, heishouUserInfo, nil];
    messBody3.isFavour = YES;
    
    WFMessageBody *messBody4 = [[WFMessageBody alloc] init];
    messBody4.posterContent = kShuoshuoText4;
    messBody4.posterPostImage = @[chang,kuan,fang,chang,kuan];
    messBody4.posterReplies = [NSMutableArray arrayWithObjects:body1, nil];
    messBody4.posterImgstr = @"mao.jpg";
    messBody4.posterName = @"基尔加丹";
    messBody4.posterIntro = @"这个人很懒，什么都没有留下";
    messBody4.publishTime = @"2016-8-20";
    messBody4.posterFavour = [NSMutableArray arrayWithObjects:nil];
    messBody4.isFavour = NO;
    
    WFMessageBody *messBody5 = [[WFMessageBody alloc] init];
    messBody5.posterContent = kShuoshuoText5;
    messBody5.posterPostImage = @[chang,kuan,chang,chang,kuan,fang,chang];
    messBody5.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5, nil];
    messBody5.posterImgstr = @"mao.jpg";
    messBody5.posterName = @"阿克蒙德";
    messBody5.posterIntro = @"这个人很懒，什么都没有留下";
    messBody5.publishTime = @"2016-8-20";
    messBody5.posterFavour = [NSMutableArray arrayWithObjects:@"希尔瓦娜斯",@"格鲁尔",@"魔兽世界5区石锤人类联盟女圣骑丨阿诺丨",@"钢铁女武神",@"克苏恩",@"克尔苏加德",@"钢铁议会", nil];
    messBody5.posterFavourUserArr = [NSMutableArray arrayWithObjects:xiewanasiUserInfo, geluerUserInfo, moshoushijieUserInfo, gangtienvwushenUserInfo,kesuenUserInfo , keersujiadeUserInfo, gangtieyihuiUserInfo ,nil];
    messBody5.isFavour = NO;
    
    WFMessageBody *messBody6 = [[WFMessageBody alloc] init];
    messBody6.posterContent = kShuoshuoText5;
    messBody6.posterPostImage = @[chang,kuan,fang,chang,chang,kuan,fang,chang,fang];
    messBody6.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5,body4,body6, nil];
    messBody6.posterImgstr = @"mao.jpg";
    messBody6.posterName = @"红领巾";
    messBody6.posterIntro = @"这个人很懒，什么都没有留下";
    messBody6.posterFavour = [NSMutableArray arrayWithObjects:@"爆裂熔岩",@"希尔瓦娜斯",@"阿尔萨斯",@"死亡之翼",@"玛里苟斯", nil];
    messBody6.posterFavourUserArr = [NSMutableArray arrayWithObjects:baolierongyanUserInfo, xiewanasiUserInfo, aersasiUserInfo, siwangzhiyiUserInfo, maligousiUserInfo, nil];
    messBody6.isFavour = NO;
    
    
//    [_contentDataSource addObject:messBody1];
//    [_contentDataSource addObject:messBody2];
//    [_contentDataSource addObject:messBody3];
//    [_contentDataSource addObject:messBody4];
//    [_contentDataSource addObject:messBody5];
//    [_contentDataSource addObject:messBody6];
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:@"imagedownLoadComplete" object:nil];
    
    hud = nil;
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"CurPage":@1,
                               @"CurCount":@10
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@news/GetFriendCircleList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak WXViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [hud hide:YES];
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (command == 10024) {
            if (code == 200) {
                 [backImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"CoverUrl"]] placeholderImage:[UIImage imageNamed:@"defaultBackimge"]];
                _AllCount = [responseObject objectForKey:@"AllCount"];
                NSArray * FirendCircleList = [NSArray array];
                FirendCircleList = [responseObject objectForKey:@"FriendCircleList"];
                [self getdataWithArray:FirendCircleList];
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }else
        {
            ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [hud hide:YES];
    }];
    
    
}

- (void)getdataWithArray:(NSArray *)array
{
    for (int i= 0; i < array.count; i++) {
        NSDictionary * friendCircleDic = [array objectAtIndex:i];
        
        NSDictionary *publishUserDic = [friendCircleDic objectForKey:@"User"];
        RCUserInfo * publishUser = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@", [publishUserDic objectForKey:@"UserId"]] name:[publishUserDic objectForKey:@"DisplayName"] portrait:[publishUserDic objectForKey:@"PortraitUri"]];
        
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
        messageBody.posterId = [friendCircleDic objectForKey:@"TakeId"];
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
        
        [_contentDataSource addObject:messageBody];
    }
    [self loadTextData];
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

- (void)refreshUI
{
    [mainTable reloadData];
    NSLog(@"刷新界面");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
   self.title = @"朋友圈";
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[[UIImage imageNamed:@"publishshuoshuoCamera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [rightBarItem addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    _page = 1;
    
    if ([[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]) {
        _isHaveNoreadMessage = YES;
    }
    
    [self initTableview];
    [self configData];
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)cameraAction:(UIButton *)button
{
    PublishCircleOfFriendViewController * publishVc = [[PublishCircleOfFriendViewController alloc]init];
    
    [publishVc publishShuoShuoSuccess:^(WFMessageBody *messageBody) {
        [_contentDataSource insertObject:messageBody atIndex:0];
        
        [_tableDataSource removeAllObjects];
        _isPublish = YES;
        [self loadTextData];
        
    }];
    
    [self.navigationController pushViewController:publishVc animated:YES];
}

#pragma mark -加载数据
- (void)loadTextData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
       
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
             
             WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
             YMTextData *ymData = [[YMTextData alloc] init ];
             ymData.messageBody = messBody;
            
             [ymDataArray addObject:ymData];
             
         }
         [self calculateHeight:ymDataArray];
         
    });
}

#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{

    
    NSDate* tmpStartData = [NSDate date];
    int page = 1;
    if (!_isPublish) {
        page = _page;
    }
    
    for (int i = 0 + (page - 1) * 10; i < dataArray.count; i++) {
        YMTextData *ymData = [dataArray objectAtIndex:i];
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        [ymData.attributedDataFavour removeAllObjects];
        [ymData.attributedDataShuoshuo removeAllObjects];
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _isPublish = NO;
        [mainTable reloadData];
      
    });
}

- (void) initTableview{

    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
     mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.tableHeaderView = [self getMainTableHeadView];
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];

    mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mainTable.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData
{
    _page = 1;
    [mainTable.mj_header beginRefreshing];
    mainTable.mj_footer.state = MJRefreshStateIdle;
    NSDictionary * jsonDic = @{
                               @"CurPage":@1,
                               @"CurCount":@10
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@news/GetFriendCircleList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak WXViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [mainTable.mj_header endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (command == 10024) {
            if (code == 200) {
                
                _AllCount = [responseObject objectForKey:@"AllCount"];
                [backImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"CoverUrl"]] placeholderImage:[UIImage imageNamed:@"defaultBackimge"]];
                if (_contentDataSource.count > 0) {
                    [_contentDataSource removeAllObjects];
                }
                if (_tableDataSource.count > 0) {
                    [_tableDataSource removeAllObjects];
                }
                NSArray * FirendCircleList = [NSArray array];
                FirendCircleList = [responseObject objectForKey:@"FriendCircleList"];
                [wxVC getdataWithArray:FirendCircleList];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }else
        {
            ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [mainTable.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData
{
    _page++;
    
    if (_tableDataSource.count >= _AllCount.intValue) {
        [mainTable.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSNumber * page = @(_page);
    
    NSDictionary * jsonDic = @{
                               @"CurPage":page,
                               @"CurCount":@10
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@news/GetFriendCircleList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak WXViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [mainTable.mj_footer endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (command == 10024) {
            if (code == 200) {
                
                NSArray * FirendCircleList = [NSArray array];
                FirendCircleList = [responseObject objectForKey:@"FriendCircleList"];
                if (FirendCircleList.count > 0) {
                    [wxVC getdataWithArray:FirendCircleList];
                }else
                {
                    [mainTable.mj_footer endRefreshingWithNoMoreData];
                }
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }else
        {
            ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [mainTable.mj_footer endRefreshing];
    }];
}

//**
// *  ///////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return  _tableDataSource.count;
    }else
    {
        if (_isHaveNoreadMessage) {
            return 1;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if (indexPath.section == 1) {
        YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
        BOOL unfold = ym.foldOrNot;
        
        if (ym.showImageHeight == 0) {
            return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance) - 50;
        }
        return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance) - 30;
    }else
    {
        if (_isHaveNoreadMessage) {
            return 60;
        }
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"ILTableViewCell";
        
        YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.stamp = indexPath.row;
        cell.replyBtn.appendIndexPath = indexPath;
        [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteBtn.appendIndexPath = indexPath;
        
        __weak WXViewController * weakSelf = self;
        [cell deleteTake:^{
            NSLog(@"删除说说");
            [weakSelf deleteTake:[_tableDataSource objectAtIndex:indexPath.row]];
        }];
        
        [cell lookUserShuoshuo:^(NSString * string){
            if ([string isEqualToString:@"tap"]) {
                NSLog(@"查看说说详情");
                YMTextData * data = [_tableDataSource objectAtIndex:indexPath.row];
                
                [weakSelf lookUserFriendCircle:[NSString stringWithFormat:@"%@", data.messageBody.posterUserId]];
            }else
            {
                [self showActionSheet:[_tableDataSource objectAtIndex:indexPath.row]];
            }
            
        }];
        
        cell.delegate = self;
        [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
        
        UITapGestureRecognizer * removeOprationViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeOperationAction)];
        [cell addGestureRecognizer:removeOprationViewTap];
        
        return cell;
    }else
    {
        NoreadMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:KNoreadFriendCircleMessgaeCellIdentifire];
        if (cell == nil) {
            cell = [[NoreadMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KNoreadFriendCircleMessgaeCellIdentifire];
        }
        RCFriendCircleUserInfo * model = [[RCDataBaseManager shareInstance]getFriendcircleMessage];
        [cell creatCellWithFrame:tableView.frame];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@条未读评论", model.number];
        
        UITapGestureRecognizer * readNewMessageCommentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(readNewMessageComment)];
        [cell.backView addGestureRecognizer:readNewMessageCommentTap];
        
        return cell;
    }
}

- (void)removeOperationAction
{
    [self.operationView dismiss];
}

- (void)showActionSheet:(YMTextData *)data
{
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * payhistoryaction = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * url = [NSString stringWithFormat:@"%@userinfo/report?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:[NSDictionary dictionary] progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"感谢举报，我们会尽快查实并进行处理!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            NSLog(@"%@", error);
        }];
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    
    [alertcontroller addAction:payhistoryaction];
    [alertcontroller addAction:cancelAction];
    
    [self presentViewController:alertcontroller animated:YES completion:^{
        ;
    }];
}

- (UIView *)getMainTableHeadView
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_width - 40)];
    
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headView.hd_width, headView.hd_height - 30)];
    backImageView.image = [UIImage imageNamed:@"defaultBackimge"];
    [backImageView setContentMode:UIViewContentModeScaleAspectFill];
    backImageView.clipsToBounds = YES;
    [headView addSubview:backImageView];
    headView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * walltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeBackWallImage)];
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:walltap];
    
    UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headView.hd_width - 95, headView.hd_height - 80, 80, 80)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    [headView addSubview:iconImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookselfFriendCirclr)];
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:tap];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, iconImageView.hd_y + 15, headView.hd_width - 15 * 3 - iconImageView.hd_width, 20)];
    nameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = 2;
    [headView addSubview:nameLabel];
    
    return headView;
}

#pragma mark - 查看个人说说详情
- (void)lookselfFriendCirclr
{
    [self lookUserFriendCircle:[RCIM sharedRCIM].currentUserInfo.userId];
}

- (void)lookUserFriendCircle:(NSString *)userId
{
    [self.operationView dismiss];
    
    UserFriendCircleViewController * vc = [[UserFriendCircleViewController alloc]init];
    vc.userId = @(userId.intValue);
    [vc exchangeWallImage:^(UIImage *image) {
        if (image) {
            backImageView.image = image;
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
     
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
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

#pragma mark - 删除说说

- (void)deleteTake:(YMTextData *)ymData
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除此说说？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10000;
    [alert show];
    self.deleteYMTextdata = ymData;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else
    {
        if (alertView.tag == 10000) {
            NSDictionary * jsonDic = @{
                                       @"TakeId":self.deleteYMTextdata.messageBody.posterId,
                                       @"UserId":@([RCIM sharedRCIM].currentUserInfo.userId.intValue)
                                       };
            
            NSString * url = [NSString stringWithFormat:@"%@news/deleteTake?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
            
            __weak WXViewController * wxVC = self;
            [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
                ;
            } success:^(id  _Nonnull responseObject) {
                NSLog(@"responseObject = %@", responseObject);
                int code = [[responseObject objectForKey:@"Code"] intValue];
                if (code == 200) {
                    NSLog(@"删除成功");
                    [_tableDataSource removeObject:self.deleteYMTextdata];
                    [mainTable reloadData];
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
}

#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    
    NSString * myUserIdStr = [RCIM sharedRCIM].currentUserInfo.userId;
    NSNumber * myUserId = @(myUserIdStr.intValue);
    
    if (m.isFavour == YES) {//此时该取消赞
        
        NSDictionary * jsonDic = @{
                                   @"UserId":m.posterUserId,
                                   @"TakeId":m.posterId
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@news/canclethumbsUp?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak WXViewController * wxVC = self;
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
                    [wxVC reloadWithYmdata:ymData andMessageBody:m];
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
        
        __weak WXViewController * wxVC = self;
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
                [wxVC reloadWithYmdata:ymData andMessageBody:m];
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

- (void)reloadWithYmdata:(YMTextData *)ymData andMessageBody:(WFMessageBody *)m
{
    ymData.messageBody = m;
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [mainTable reloadData];
}

#pragma mark - 评论
- (void)replyMessage:(YMButton *)sender{
    
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];

}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
}

#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
   [self.operationView dismiss];
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds byClick:clickTag appendArray:imageViews];
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

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{

    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;

}

#pragma mark - 点击赞或者评论的人
- (void)clickUserName:(NSString *)userId
{
    [self.operationView dismiss];
    [self lookUserFriendCircle:userId];
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
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
        [self.view addSubview:replyView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    [self.operationView dismiss];
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {

        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
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
        
        __weak WXViewController * wxVC = self;
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
                [self reloadReplyWithYmdata:ymData withIndex:inputTag];
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
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
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
        
        __weak WXViewController * wxVC = self;
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
                [self reloadReplyWithYmdata:ymData withIndex:inputTag];
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

- (void)reloadReplyWithYmdata:(YMTextData *)ymData withIndex:(NSInteger)inputTag
{
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
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
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        WFReplyBody * body = [m.posterReplies objectAtIndex:_replyIndex];
        NSDictionary * jsonDic = @{
                                   @"TakeId":m.posterId,
                                   @"CommentId":body.commentId
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@news/deleteComment?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        __weak WXViewController * wxVC = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                [m.posterReplies removeObjectAtIndex:_replyIndex];
                ymData.messageBody = m;
                [ymData.completionReplySource removeAllObjects];
                [ymData.attributedDataReply removeAllObjects];
                
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
                
                [mainTable reloadData];
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

#pragma mark - 读取新评论
- (void)readNewMessageComment
{
    [self.operationView dismiss];
    [[RCDataBaseManager shareInstance]clearFriendcircleMessage];
    _isHaveNoreadMessage = NO;
    FriendCircleMessgaeViewController * messageVc = [[FriendCircleMessgaeViewController alloc]init];
    [messageVc noreadAction:^{
        [mainTable reloadData];
    }];
    [self.navigationController pushViewController:messageVc animated:YES];
}


#pragma mark - 修改背景墙
- (void)exchangeBackWallImage
{
    [self.operationView dismiss];
    
    backwallView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backwallView.backgroundColor = [UIColor clearColor];
    
    UIView * clearView = [[UIView alloc]initWithFrame:backwallView.bounds];
    clearView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [backwallView addSubview:clearView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissexchangeView)];
    [clearView addGestureRecognizer:tap];
    
    UIButton * exchangeBackWallImageBT = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBackWallImageBT.frame = CGRectMake((screenWidth - 218) / 2, 64 + screenWidth - 75, 218, 38);
    exchangeBackWallImageBT.layer.cornerRadius = 3;
    exchangeBackWallImageBT.layer.masksToBounds = YES;
    exchangeBackWallImageBT.backgroundColor = [UIColor whiteColor];
    [exchangeBackWallImageBT setTitle:@"更换背景封面" forState:UIControlStateNormal];
     [exchangeBackWallImageBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    exchangeBackWallImageBT.titleLabel.font = [UIFont systemFontOfSize:18];
    [backwallView addSubview:exchangeBackWallImageBT];
    
    [exchangeBackWallImageBT addTarget:self action:@selector(exchangeImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:backwallView];
    
}
- (void)dismissexchangeView
{
    [backwallView removeFromSuperview];
}
- (void)exchangeImageAction
{
    [backwallView removeFromSuperview];
    ExchangeBackwallImageViewController * exchangeVC = [[ExchangeBackwallImageViewController alloc]initWithNibName:@"ExchangeBackwallImageViewController" bundle:nil];
    [exchangeVC getBackWallImage:^(UIImage *image) {
        if (image) {
            backImageView.image = image;
        }
    }];
    [self.navigationController pushViewController:exchangeVC animated:YES];
    
}

- (void)dealloc{
    NSLog(@"销毁");
}

@end
