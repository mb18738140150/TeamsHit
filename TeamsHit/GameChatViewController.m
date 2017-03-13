//
//  GameChatViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GameChatViewController.h"

#import "RealTimeLocationViewController.h"
#import "RealTimeLocationStartCell.h"
//#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationEndCell.h"
#import "RCDTestMessageCell.h"

#import "MaterialViewController.h"

#import "ChatSettingViewController.h"
#import "FriendInformationViewController.h"
#import "FriendInformationModel.h"

#import "MeDetailInfomationViewController.h"
//#import "BrageGameViewHeaderView.h"
#import "GroupDetailViewController.h"
#import "SlideBlockView.h"
#import "GroupDetailSetTipView.h"

#define ConversationViewHeight ([UIScreen mainScreen].bounds.size.height / 3) * 2 - 64

@interface GameChatViewController ()<UIActionSheetDelegate, UIAlertViewDelegate, RCMessageCellDelegate, RCChatSessionInputBarControlDelegate, BrageGameViewHeaderViewProtocol>
{
    MBProgressHUD* hud ;
}
//@property (nonatomic, weak)id<RCRealTimeLocationProxy> realTimeLocation;
//@property (nonatomic, strong)RealTimeLocationStatusView *realTimeLocationStatusView;
@property (nonatomic, strong)RCDGroupInfo *groupInfo;
@property (nonatomic, strong)NSMutableArray *groupMemberList;

@property (nonatomic, strong)SlideBlockView * slideBlockView;

// 好友详情
@property (nonatomic, strong)FriendInformationModel * friendmodel;
@property (nonatomic, assign)BOOL isRightBarItem;

@property (nonatomic, assign)CGFloat conversationMessageCollectionViewHeight;
@property (nonatomic, assign)CGFloat conversationMessageCollectionView_y;

@end

@implementation GameChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.enableInteractivePopGestureRecognizer = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.enableSaveNewPhotoToLocalSystem = YES;
    self.isRightBarItem = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];;
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"groupSetup"]];
    [rightBarItem addTarget:self action:@selector(setUpGameChatGroup) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    self.groupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:self.targetId];
    
    
    // 设置聊天界面frame
    self.chatSessionInputBarControl.delegate = self;
    
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"pluginBoardViewmstchingCoin"] title:@"碰碰币" tag:10006];
    
    if (screenWidth > 320) {
        self.conversationMessageCollectionView.frame = CGRectMake(0, ConversationViewHeight + 100, self.view.hd_width, ([UIScreen mainScreen].bounds.size.height / 3) - 40);
        self.conversationMessageCollectionViewHeight = self.conversationMessageCollectionView.hd_y - self.chatSessionInputBarControl.hd_y;
        self.conversationMessageCollectionViewHeight = ([UIScreen mainScreen].bounds.size.height / 3) - 40;
        self.conversationMessageCollectionView_y = self.conversationMessageCollectionView.hd_y;
        
    }else
    {
        self.conversationMessageCollectionView.frame = CGRectMake(0, ConversationViewHeight + 100, self.view.hd_width, ([UIScreen mainScreen].bounds.size.height / 3) - 64 - 20 - 10);
        self.conversationMessageCollectionViewHeight = self.conversationMessageCollectionView.hd_y - self.chatSessionInputBarControl.hd_y;
        self.conversationMessageCollectionViewHeight = ([UIScreen mainScreen].bounds.size.height / 3) - 64 - 30;
        self.conversationMessageCollectionView_y = self.conversationMessageCollectionView.hd_y;
    }
    
    self.title = @"";
    
    // 游戏
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height)];
    NSLog(@"游戏背景名 %@", [[RCDataBaseManager shareInstance] getGameBackImagenameWith:self.targetId userID:[RCIM sharedRCIM].currentUserInfo.userId]);
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"GamebackImage" ofType :@"bundle"];
    NSLog(@"bundlePath = %@", [[RCDataBaseManager shareInstance] getGameBackImagenameWith:self.targetId userID:[RCIM sharedRCIM].currentUserInfo.userId]);
    if ([[RCDataBaseManager shareInstance] getGameBackImagenameWith:self.targetId userID:[RCIM sharedRCIM].currentUserInfo.userId]) {
        NSLog(@"获取到了");
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"gamebackimagename%@.png", [[RCDataBaseManager shareInstance] getGameBackImagenameWith:self.targetId userID:[RCIM sharedRCIM].currentUserInfo.userId]]];
        _backImageView.image = [UIImage imageWithContentsOfFile:imgPath];
    }else
    {
        NSLog(@"没获取到");
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"gamebackimagename0.png"]];
        _backImageView.image = [UIImage imageWithContentsOfFile:imgPath];
    }
    [self.view addSubview:_backImageView];
    self.backImageView.userInteractionEnabled = YES;
    [self.view insertSubview:_backImageView belowSubview:self.conversationMessageCollectionView];
    self.navigationItem.titleView.userInteractionEnabled = YES;
    
    // 滑块view
    self.slideBlockView = [[SlideBlockView alloc]initWithFrame:CGRectMake(self.view.hd_width / 2 - 24, self.conversationMessageCollectionView.hd_y - 30, 48, 30)];
    __weak GameChatViewController * weakSelf = self;
    [self.slideBlockView resignBlock:^{
        [weakSelf.chatSessionInputBarControl.inputTextView resignFirstResponder];
    }];
    [self.slideBlockView moveSlideBlock:^(CGPoint point) {
        
        CGFloat offsetHeight = weakSelf.slideBlockView.hd_y - weakSelf.conversationMessageCollectionView.hd_y;
        
        weakSelf.conversationMessageCollectionView.hd_y = CGRectGetMaxY(weakSelf.slideBlockView.frame);
        weakSelf.conversationMessageCollectionView.hd_height = -weakSelf.conversationMessageCollectionView.hd_y + weakSelf.chatSessionInputBarControl.hd_y;;
        
        weakSelf.conversationMessageCollectionViewHeight = weakSelf.conversationMessageCollectionView.hd_height;
        weakSelf.conversationMessageCollectionView_y = weakSelf.conversationMessageCollectionView.hd_y;
    }];
    

//    [[NSNotificationCenter defaultCenter]addObserver:self forKeyPath:@"self.chatSessionInputBarControl.frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [self creatHeaderView];
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillshow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    
    
    
    
    [self.chatSessionInputBarControl addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    
    ///注册自定义测试消息Cell
    [self registerClass:[RCDTestMessageCell class] forCellWithReuseIdentifier:RCDTestMessageTypeIdentifier];
    
    [self notifyUpdateUnreadMessageCount];
    
    //    self.chatSessionInputBarControl.hidden = YES;
    //    CGRect intputTextRect = self.conversationMessageCollectionView.frame;
    //    intputTextRect.size.height = intputTextRect.size.height+50;
    //    [self.conversationMessageCollectionView setFrame:intputTextRect];
    //    [self scrollToBottomAnimated:YES];
    
    //默认输入类型为语音
    //self.defaultInputType = RCChatSessionInputBarInputExtention;
    
    
    /***********如何在会话界面插入提醒消息***********************
     
     RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"请不要轻易给陌生人汇钱！" extra:nil];
     BOOL saveToDB = NO;  //是否保存到数据库中
     RCMessage *savedMsg ;
     if (saveToDB) {
     savedMsg = [[RCIMClient sharedRCIMClient] insertMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId sendStatus:SentStatus_SENT content:warningMsg];
     } else {
     savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];//注意messageId要设置为－1
     }
     [self appendAndDisplayMessage:savedMsg];
     */
    //    self.enableContinuousReadUnreadVoice = YES;//开启语音连读功能
    
    
    //房间改名之后，更新当前页面的Title
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renameGroupName:)
                                                 name:@"renameGroupName"
                                               object:nil];
    
    //当前聊天清空聊天记录以后，更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMSG:)
                                                 name:@"ClearHistoryMsg"
                                               object:nil];
        // Do any additional setup after loading the view.
    
    // 更换背景
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeGamebackImage:) name:@"ChangeGamebackImage" object:nil];
}

- (void)creatHeaderView
{
    NSString * type = @"";
    if (self.groupInfo.GroupType == 1) {
        type = @"吹牛";
    }else if (self.groupInfo.GroupType == 2)
    {
        type = @"梦幻";
    }
    NSString * title = [NSString stringWithFormat:@"%@房间", self.targetId];
    self.headerView = [[BrageGameViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, 64) type:type title:title];
    _headerView.delegete = self;
    self.navigationItem.titleView = _headerView;
}

#pragma mark - 键盘回收监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.conversationMessageCollectionView.hd_y = self.chatSessionInputBarControl.hd_y - self.conversationMessageCollectionViewHeight;
    self.conversationMessageCollectionView.hd_height = self.conversationMessageCollectionViewHeight;
}

-(void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
    
    if (self.conversationType == ConversationType_GROUP)
    {
        _groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
        [RCDHTTPTOOL getGroupByID:self.targetId
                successCompletion:^(RCDGroupInfo *group)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 _groupInfo = group;
                 //判断如果是解散的房间，不显示导航栏的setting按钮。
                 if ([group.isDismiss isEqualToString:@"YES"]) {
                     self.navigationItem.rightBarButtonItem = nil;
                 }
                 
                 [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                 _groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
                 if ([_groupMemberList count] == 0) {
                     [RCDHTTPTOOL getGroupMembersWithGroupId:self.targetId Block:^(NSMutableArray *result) {
                         if ([result count] != 0) {
                             _groupMemberList = result;
                             [[RCDataBaseManager shareInstance] insertGroupMemberToDB:result groupId:self.targetId];
                         }
                         
                     }];
                 }
             });
         }];
        //        _groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
        //        if ([_groupMemberList count] == 0) {
        //            [RCDHTTPTOOL getGroupMembersWithGroupId:self.targetId Block:^(NSMutableArray *result) {
        //                if ([result count] != 0) {
        //                    _groupMemberList = result;
        //                    [[RCDataBaseManager shareInstance] insertGroupMemberToDB:result groupId:self.targetId];
        //                }
        //
        //            }];
        //        }
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x12B7F5)];
}

-(void)renameGroupName:(NSNotification*) notification
{
    self.title = [notification object];
}

-(void)clearHistoryMSG:(NSNotification*) notification
{
    [self.conversationDataRepository removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
}

- (void)changeGamebackImage:(NSNotification *)notification
{
    RCDGroupInfo * group = [[RCDataBaseManager shareInstance]getGroupByGroupId:self.targetId];
    RCGroup * groupInfo = [[RCGroup alloc]init];
    groupInfo.groupId = group.groupId;
    groupInfo.groupName = group.groupName;
    
    [[RCDataBaseManager shareInstance]insertGamebackImage:groupInfo userID:[RCIM sharedRCIM].currentUserInfo.userId backImageName:[notification.userInfo objectForKey:@"displayName"]];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"GamebackImage" ofType :@"bundle"];
    NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"gamebackimagename%@.png", [notification.userInfo objectForKey:@"displayName"]]];
    _backImageView.image = [UIImage imageWithContentsOfFile:imgPath];
}

- (void)leftBarButtonItemPressed:(id)sender {
    [self popupChatViewController];
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
//    if (_needPopToRootView == YES) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    _imagePreviewVC.title = @"图片预览";
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:_imagePreviewVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - 更新左上角未读消息数
/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"返回(%d)", count];
        } else if (count >= 1000) {
            backString = @"返回(...)";
        } else {
            backString = @"返回";
        }
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 6, 87, 23);
        UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
        backImg.frame = CGRectMake(-10, 0, 22, 22);
        [backBtn addSubview:backImg];
        UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 85, 22)];
        backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
        //   backText.font = [UIFont systemFontOfSize:17];
        [backText setBackgroundColor:[UIColor clearColor]];
        [backText setTextColor:[UIColor whiteColor]];
        [backBtn addSubview:backText];
        [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        //        [__weakself.navigationItem setLeftBarButtonItem:leftButton];
    });
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

#pragma mark - 扩展板点击功能
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
//            if (self.realTimeLocation) {
//                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送位置", @"位置实时共享", nil];
//                [actionSheet showInView:self.view];
//            } else {
//                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
//            }
            
        } break;
        case 10006: {
            [self showCoinCount];
            
        } break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

#pragma mark - RealTimeLocationStatusViewDelegate
//- (void)onJoin {
//    [self showRealTimeLocationViewController];
//}
//- (RCRealTimeLocationStatus)getStatus {
//    return [self.realTimeLocation getStatus];
//}
//
//- (void)onShowRealTimeLocationView {
//    [self showRealTimeLocationViewController];
//}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent
{
    if ([messageCotent isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)messageCotent;
        textMsg.extra = @"";
    }
    return messageCotent;
}

//- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
//                   atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell.model.content isMemberOfClass:[RCTextMessage class]]) {
//        RCTextMessage * textMessage = cell.model.content;
////        NSLog(@"userId = %@ ** targetID = %@ ** %@",cell.model.userInfo.userId,cell.model.targetId , textMessage.content);
//    }else
//    {
////        NSLog(@"userId = %@ ** targetID = %@ ** %@",cell.model.userInfo.userId,cell.model.targetId , [cell.model.content class]);
//    }
//}
- (void)didSendMessage:(NSInteger)stauts
               content:(RCMessageContent *)messageCotent
{
    if ([messageCotent isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage * textMessage = messageCotent;
//        NSLog(@"%@", textMessage.content);
    }
}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
    RCMessageContent *messageContent = model.content;
    RCMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        RealTimeLocationStartCell *__cell = [collectionView
                                             dequeueReusableCellWithReuseIdentifier:RCRealTimeLocationStartMessageTypeIdentifier
                                             forIndexPath:indexPath];
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        //__cell.locationDelegate=self;
        cell = __cell;
        return cell;
    } else if ([messageContent isMemberOfClass:[RCRealTimeLocationEndMessage class]]) {
        RealTimeLocationEndCell *__cell = [collectionView
                                           dequeueReusableCellWithReuseIdentifier:RCRealTimeLocationEndMessageTypeIdentifier
                                           forIndexPath:indexPath];
        [__cell setDataModel:model];
        cell = __cell;
        return cell;
    } else if ([messageContent isMemberOfClass:[RCDTestMessage class]]) {
        RCDTestMessageCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:RCDTestMessageTypeIdentifier
                                    forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    } else {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
//        [self showRealTimeLocationViewController];
    }
}

- (void)didTapCellPortrait:(NSString *)userId{
    
    if (self.conversationType == ConversationType_GROUP) {
        
        if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            MeDetailInfomationViewController * meinfoVC = [[MeDetailInfomationViewController alloc]initWithNibName:@"MeDetailInfomationViewController" bundle:nil];
            [self.navigationController pushViewController:meinfoVC animated:YES];
        }else
        {
            FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
            friend.targetId = userId;
            [self.navigationController pushViewController:friend animated:YES];
            
        }
        
    }
}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    } else if ([messageContent isMemberOfClass:[RCDTestMessage class]]) {
        return CGSizeMake(collectionView.frame.size.width, [RCDTestMessageCell getBubbleBackgroundViewSize:(RCDTestMessage *)messageContent].height + 40);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}
/**
 *  重写方法实现未注册的消息的显示
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
//    NSLog(@"message objectName = %@", model.objectName);
    RCMessageCell *cell = [collectionView
                           dequeueReusableCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier
                           forIndexPath:indexPath];
    [cell setDataModel:model];
    return cell;
}

/**
 *  重写方法实现未注册的消息的显示的高度
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize) rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                       layout:(UICollectionViewLayout *)collectionViewLayout
                       sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
//    NSLog(@"message objectName = %@", model.objectName);
    return CGSizeMake(collectionView.frame.size.width, 66);
}
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [super pluginBoardView:self.pluginBoardView clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
        }
            break;
        case 1:
        {
//            [self showRealTimeLocationViewController];
        }
            break;
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    SEL selector = NSSelectorFromString(@"_alertController");
    
    if ([actionSheet respondsToSelector:selector]){
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]]){
            alertController.view.tintColor = [UIColor blackColor];
        }
    }else{
        for( UIView * subView in actionSheet.subviews ){
            if( [subView isKindOfClass:[UIButton class]] ){
                UIButton * btn = (UIButton*)subView;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - RCRealTimeLocationObserver
//- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
//    __weak typeof(&*self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf updateRealTimeLocationStatus];
//    });
//}
//
//- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
//    __weak typeof(&*self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf updateRealTimeLocationStatus];
//    });
//}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享", userId]];
            }
        }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享", userId]];
            }
        }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
    });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}

- (void)onFailUpdateLocation:(NSString *)description {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
//        [self.realTimeLocation quitRealTimeLocation];
        [self popupChatViewController];
    }
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message
{
    return message;
}

/*******************实时地理位置共享***************/
//- (void)showRealTimeLocationViewController{
//    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
//    lsvc.realTimeLocationProxy = self.realTimeLocation;
//    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
//        [self.realTimeLocation joinRealTimeLocation];
//    }else if([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE){
//        [self.realTimeLocation startRealTimeLocation];
//    }
//    [self.navigationController presentViewController:lsvc animated:YES completion:^{
//        
//    }];
//}
//- (void)updateRealTimeLocationStatus {
//    if (self.realTimeLocation) {
////        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
//        __weak typeof(&*self) weakSelf = self;
//        NSArray *participants = nil;
//        switch ([self.realTimeLocation getStatus]) {
//            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
////                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
//                break;
//            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
//            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
//                participants = [self.realTimeLocation getParticipants];
//                if (participants.count == 1) {
//                    NSString *userId = participants[0];
////                    [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
//                    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
//                        if (userInfo.name.length) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
////                                [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%@正在共享位置", userInfo.name]];
//                            });
//                        }
//                    }];
//                } else {
////                    if(participants.count<1)
////                        [self.realTimeLocationStatusView removeFromSuperview];
////                    else
////                        [self.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
//                }
//                break;
//            default:
//                break;
//        }
//    }
//}

- (void)dealloc
{
    [self.chatSessionInputBarControl removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClearHistoryMsg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"renameGroupName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeGamebackImage" object:nil];
    NSLog(@"释放了");
}

#pragma mark - BrageGameViewHeaderViewProtocol
- (void)setUpGameChatGroup
{
//    NSLog(@"房间设置");
//    GroupDetailViewController * groupDetailVC = [[GroupDetailViewController alloc]init];
//    groupDetailVC.groupID = self.targetId;
//    [self.navigationController pushViewController:groupDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCoinCount
{
    [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
            
            GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"碰碰币" message:[NSString stringWithFormat:@"您共有碰碰币%@个", [dic objectForKey:@"CoinCount"]]];
            [setTipView show];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取碰碰币失败请从新获取" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
    }];
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
