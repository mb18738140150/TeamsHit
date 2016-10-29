//
//  ChatViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ChatViewController.h"

#import "RealTimeLocationViewController.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationEndCell.h"
#import "RCDTestMessageCell.h"

#import "MaterialViewController.h"

#import "ChatSettingViewController.h"
#import "FriendInformationViewController.h"
#import "FriendInformationModel.h"

#import "MeDetailInfomationViewController.h"

//#import "RCChatSessionInputBarControl.h"

@interface ChatViewController ()<UIActionSheetDelegate, UIAlertViewDelegate, RCRealTimeLocationObserver, RCMessageCellDelegate, RealTimeLocationStatusViewDelegate>
{
    MBProgressHUD* hud ;
}
@property (nonatomic, weak)id<RCRealTimeLocationProxy> realTimeLocation;
@property (nonatomic, strong)RealTimeLocationStatusView *realTimeLocationStatusView;
@property (nonatomic, strong)RCDGroupInfo *groupInfo;
@property (nonatomic, strong)NSMutableArray *groupMemberList;

// 好友详情
@property (nonatomic, strong)FriendInformationModel * friendmodel;
@property (nonatomic, assign)BOOL isRightBarItem;
@property (nonatomic, assign)BOOL isSelect;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.enableInteractivePopGestureRecognizer = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
    self.isRightBarItem = NO;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
//    self.title = @"";
    [leftBarItem addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    if (![self.targetId isEqualToString:@"200"]) {
        [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"passNotes.png"] title:@"传纸条" tag:10006];
    }
    [self.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if (self.conversationType != ConversationType_CHATROOM) {
        if (self.conversationType == ConversationType_DISCUSSION) {
            [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
                if (discussion != nil && discussion.memberIdList.count>0) {
                    if ([discussion.memberIdList containsObject:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25, 25)];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_normal"]];
                        imageView.frame = CGRectMake(7,-1, 25, 25);
                        [button addSubview:imageView];
                        [button addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                                           initWithCustomView:button];
                        self.navigationItem.rightBarButtonItem = rightBarButton;
                    }else
                    {
                        self.navigationItem.rightBarButtonItem = nil;
                    }
                }
            } error:^(RCErrorCode status) {
                
            }];
        }else{
            UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25, 25)];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_normal"]];
            imageView.frame = CGRectMake(7,-1, 25, 25);
            [button addSubview:imageView];
            [button addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                               initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = rightBarButton;
        }
        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if ([self.targetId isEqualToString:@"200"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
/*******************实时地理位置共享***************/
    [self registerClass:[RealTimeLocationStartCell class] forCellWithReuseIdentifier:RCRealTimeLocationStartMessageTypeIdentifier];
    [self registerClass:[RealTimeLocationEndCell class] forCellWithReuseIdentifier:RCRealTimeLocationEndMessageTypeIdentifier];
    [self registerClass:[RCUnknownMessageCell class] forCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier];
    
    __weak typeof(&*self) weakSelf = self;
    [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:self.conversationType targetId:self.targetId success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
        weakSelf.realTimeLocation = realTimeLocation;
        [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
        [weakSelf updateRealTimeLocationStatus];
    } error:^(RCRealTimeLocationErrorCode status) {
        NSLog(@"get location share failure with code %d", (int)status);
    }];
/******************实时地理位置共享**************/
    
    ///注册自定义测试消息Cell
    [self registerClass:[RCDTestMessageCell class] forCellWithReuseIdentifier:RCDTestMessageTypeIdentifier];
    
    [self notifyUpdateUnreadMessageCount];
    
    //    self.chatSessionInputBarControl.hidden = YES;
    //    CGRect intputTextRect = self.conversationMessageCollectionView.frame;
    //    intputTextRect.size.height = intputTextRect.size.height+50;
    //    [self.conversationMessageCollectionView setFrame:intputTextRect];
    //    [self scrollToBottomAnimated:YES];
    /***********如何自定义面板功能***********************
     自定义面板功能首先要继承RCConversationViewController，如现在所在的这个文件。
     然后在viewDidLoad函数的super函数之后去编辑按钮：
     插入到指定位置的方法如下：
     [self.pluginBoardView insertItemWithImage:imagePic
     title:title
     atIndex:0
     tag:101];
     或添加到最后的：
     [self.pluginBoardView insertItemWithImage:imagePic
     title:title
     tag:101];
     删除指定位置的方法：
     [self.pluginBoardView removeItemAtIndex:0];
     删除指定标签的方法：
     [self.pluginBoardView removeItemWithTag:101];
     删除所有：
     [self.pluginBoardView removeAllItems];
     更换现有扩展项的图标和标题:
     [self.pluginBoardView updateItemAtIndex:0 image:newImage title:newTitle];
     或者根据tag来更换
     [self.pluginBoardView updateItemWithTag:101 image:newImage title:newTitle];
     以上所有的接口都在RCPluginBoardView.h可以查到。
     
     当编辑完扩展功能后，下一步就是要实现对扩展功能事件的处理，放开被注掉的函数
     pluginBoardView:clickedItemWithTag:
     在super之后加上自己的处理。
     
     */
    
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
    //打开单聊强制从demo server 获取用户信息更新本地数据库
    if (self.conversationType == ConversationType_PRIVATE) {
        if (![self.targetId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//            [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
//#warning getPrivateInformation ****
//                [[RCDHttpTool shareInstance]updateUserInfo:self.targetId success:^(RCUserInfo * user) {
//                    //                if (![userInfo.name isEqualToString:user.name]) {
////                    self.navigationItem.title = user.name;
//                    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
//                    RCDUserInfo *friendInfo = [[RCDataBaseManager shareInstance] getFriendInfo:user.userId];
//                    friendInfo.name = user.name;
//                    friendInfo.portraitUri = user.portraitUri;
//                    [[RCDataBaseManager shareInstance] insertFriendToDB:friendInfo];
//                    //                    [[NSNotificationCenter defaultCenter]
//                    //                     postNotificationName:@"kRCUpdateUserNameNotification"
//                    //                     object:user];
//                    //                }
//                    
//                } failure:^(NSError *err) {
//                    
//                }];
//            }];
        }
    }
    
    //群组改名之后，更新当前页面的Title
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renameGroupName:)
                                                 name:@"renameGroupName"
                                               object:nil];
    
    //当前聊天清空聊天记录以后，更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMSG:)
                                                 name:@"ClearHistoryMsg"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(renamefriendName:) name:@"renameFriendName" object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 键盘回收监听
-(void)keyboardWillHide:(NSNotification *)note{
    [self setChatSessionInputBarStatus:KBottomBarDefaultStatus animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.isSelect = NO;
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
    if (self.conversationType == ConversationType_GROUP)
    {
        _groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
        [RCDHTTPTOOL getGroupByID:self.targetId
                successCompletion:^(RCDGroupInfo *group)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 _groupInfo = group;
                 //判断如果是解散的群组，不显示导航栏的setting按钮。
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
    if (self.conversationType == ConversationType_PRIVATE) {
        [self getfriendInformation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@""]];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x12B7F5)];
}

-(void)renameGroupName:(NSNotification*) notification
{
    self.title = [notification object];
}

- (void)renamefriendName:(NSNotification *)notification
{
    NSLog(@"displayName = %@", notification);
    if (_friendmodel) {
        _friendmodel.displayName = [notification.userInfo objectForKey:@"displayName"];
    }
    
    RCUserInfo * info = [RCUserInfo new];
    info.userId = [NSString stringWithFormat:@"%@", _friendmodel.userId];
    info.portraitUri = _friendmodel.iconUrl;
    info.name = _friendmodel.displayName;
    
    [[RCIM sharedRCIM]refreshUserInfoCache:info withUserId:info.userId];
    
    RCDUserInfo * userinfo = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", _friendmodel.userId]];
    userinfo.displayName = [notification.userInfo objectForKey:@"displayName"];
    [[RCDataBaseManager shareInstance]insertFriendToDB:userinfo];
}

-(void)clearHistoryMSG:(NSNotification*) notification
{
    [self.conversationDataRepository removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
    
}

- (void)leftBarButtonItemPressed:(id)sender {
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
        [self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"离开聊天，位置共享也会结束，确认离开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        [self popupChatViewController];
    }
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
    [self.realTimeLocation removeRealTimeLocationObserver:self];
    if (_needPopToRootView == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonItemClicked:(id)sender {
    if (self.conversationType == ConversationType_PRIVATE) {
        
        //    RCDPrivateSettingViewController *settingVC =
        //        [[RCDPrivateSettingViewController alloc] init];
        //    settingVC.conversationType = self.conversationType;
        //    settingVC.targetId = self.targetId;
        //    settingVC.conversationTitle = self.userName;
        //    //设置讨论组标题时，改变当前聊天界面的标题
        //    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
        //      self.title = discussTitle;
        //    };
        
        UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        RCDPrivateSettingsTableViewController *settingsVC = [secondStroyBoard instantiateViewControllerWithIdentifier:@"RCDPrivateSettingsTableViewController"];
//        settingsVC.userId = self.targetId;
        
        //
//        [self.navigationController pushViewController:settingsVC animated:YES];
        if (!self.friendmodel) {
            self.isSelect = YES;
            self.isRightBarItem = YES;
            [self getfriendInformation];
        }else
        {
            ChatSettingViewController * chatSettingVC = [[ChatSettingViewController alloc]initWithNibName:@"ChatSettingViewController" bundle:nil];
            chatSettingVC.model = _friendmodel;
            chatSettingVC.userId = self.targetId;
            [self.navigationController pushViewController:chatSettingVC animated:YES];
            
            
//            FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
//            friend.model = _friendmodel;
        }
        
    } else if (self.conversationType == ConversationType_DISCUSSION) {
        
//        RCDDiscussGroupSettingViewController *settingVC =
//        [[RCDDiscussGroupSettingViewController alloc] init];
//        settingVC.conversationType = self.conversationType;
//        settingVC.targetId = self.targetId;
//        settingVC.conversationTitle = self.userName;
//        //设置讨论组标题时，改变当前聊天界面的标题
//        settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
//            self.title = discussTitle;
//        };
//        //清除聊天记录之后reload data
//        __weak RCDChatViewController *weakSelf = self;
//        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
//            if (isSuccess) {
//                [weakSelf.conversationDataRepository removeAllObjects];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.conversationMessageCollectionView reloadData];
//                });
//            }
//        };
//        
//        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    //聊天室设置
    else if (self.conversationType == ConversationType_CHATROOM) {
//        RCDRoomSettingViewController *settingVC =
//        [[RCDRoomSettingViewController alloc] init];
//        settingVC.conversationType = self.conversationType;
//        settingVC.targetId = self.targetId;
//        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    //群组设置
    else if (self.conversationType == ConversationType_GROUP) {
//        UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        RCDGroupSettingsTableViewController *settingsVC = [secondStroyBoard instantiateViewControllerWithIdentifier:@"RCDGroupSettingsTableViewController"];
//        if (_groupInfo == nil) {
//            //          settingsVC.Group = _groupInfo;
//            settingsVC.Group = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.targetId];
//            //          settingsVC.GroupMemberList = _groupMemberList;
//        }
//        else
//        {
//            settingsVC.Group = _groupInfo;
//            //          settingsVC.Group = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.targetId];
//        }
//        settingsVC.GroupMemberList = _groupMemberList;
//        [self.navigationController pushViewController:settingsVC animated:YES];
        
        //      [self.navigationController pushViewController:settingsVC animated:YES];
        //           return;
        
        //      RCDGroupDetailViewController *detail=[secondStroyBoard instantiateViewControllerWithIdentifier:@"RCDGroupDetailViewController"];
        //      NSMutableArray *groups=RCDHTTPTOOL.allGroups ;
        //      __weak RCDChatViewController *weakSelf = self;
        //      detail.clearHistoryCompletion = ^(BOOL isSuccess) {
        //          if (isSuccess) {
        //              [weakSelf.conversationDataRepository removeAllObjects];
        //              dispatch_async(dispatch_get_main_queue(), ^{
        //                  [weakSelf.conversationMessageCollectionView reloadData];
        //              });
        //          }
        //      };
        //
        //      [RCDHTTPTOOL getGroupByID:self.targetId
        //              successCompletion:^(RCDGroupInfo *group)
        //       {
        //                     dispatch_async(dispatch_get_main_queue(), ^{
        //                         [[RCDataBaseManager shareInstance] insertGroupToDB:group];
        //                         settingsVC.Group = group;
        //                         [self.navigationController pushViewController:settingsVC animated:NO];
        //                     });
        
        //           detail.groupInfo=group;
        //           [self.navigationController pushViewController:detail animated:YES];
        //           return;
        //       }];
        //      if (groups) {
        //          for (RCDGroupInfo *group in groups) {
        //              if ([group.groupId isEqualToString: self.targetId]) {
        //                  detail.groupInfo=group;
        //                  [self.navigationController pushViewController:detail animated:YES];
        //                  return;
        //              }
        //          }
        //      }
        
        //没有找到群组信息，可能是获取群组信息失败，这里重新获取一些群众信息。
        //      [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        //
        //      }];
        //      [RCDDataSource getGroupInfoWithGroupId:self.targetId completion:^(RCGroup *groupInfo) {
        //          detail.groupInfo=[[RCDGroupInfo alloc]init];
        //          detail.groupInfo.groupId=groupInfo.groupId;
        //          detail.groupInfo.groupName=groupInfo.groupName;
        //          dispatch_async(dispatch_get_main_queue(), ^{
        //              [self.navigationController pushViewController:detail animated:NO];
        //          });
        //
        //      }];
        
        
    }
    //客服设置
    else if (self.conversationType == ConversationType_CUSTOMERSERVICE || self.conversationType == ConversationType_SYSTEM) {
//        RCDSettingBaseViewController *settingVC = [[RCDSettingBaseViewController alloc] init];
//        settingVC.conversationType = self.conversationType;
//        settingVC.targetId = self.targetId;
//        //清除聊天记录之后reload data
//        __weak RCDChatViewController *weakSelf = self;
//        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
//            if (isSuccess) {
//                [weakSelf.conversationDataRepository removeAllObjects];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.conversationMessageCollectionView reloadData];
//                });
//            }
//        };
//        [self.navigationController pushViewController:settingVC animated:YES];
    }else if (ConversationType_APPSERVICE == self.conversationType ||
              ConversationType_PUBLICSERVICE == self.conversationType) {
        RCPublicServiceProfile *serviceProfile = [[RCIMClient sharedRCIMClient]
                                                  getPublicServiceProfile:(RCPublicServiceType)self.conversationType
                                                  publicServiceId:self.targetId];
        
        RCPublicServiceProfileViewController *infoVC =
        [[RCPublicServiceProfileViewController alloc] init];
        infoVC.serviceProfile = serviceProfile;
        infoVC.fromConversation = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    
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

- (void)setRealTimeLocation:(id<RCRealTimeLocationProxy>)realTimeLocation {
    _realTimeLocation = realTimeLocation;
}

#pragma mark - 扩展板点击功能
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
            if (self.realTimeLocation) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送位置", @"位置实时共享", nil];
                [actionSheet showInView:self.view];
            } else {
                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            }
            
        } break;
        case 10006: {
            
            NSString * url = [NSString stringWithFormat:@"%@userinfo/testTeamState?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
            NSDictionary * dic = @{@"ToUserId":@(self.targetId.intValue)
                                   };
            [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:dic progress:^(NSProgress * _Nullable progress) {
                ;
            } success:^(id  _Nonnull responseObject) {
                NSLog(@"responseObject = %@", responseObject);
                int code = [[responseObject objectForKey:@"Code"] intValue];
                if (code == 200) {
                    MaterialViewController * processVC = [[MaterialViewController alloc]init];
                    processVC.userId = @(self.targetId.intValue);
                    [self.navigationController pushViewController:processVC animated:YES];
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                }
                
            } failure:^(NSError * _Nonnull error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败请重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                NSLog(@"%@", error);
            }];
            
            
        } break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}
- (RealTimeLocationStatusView *)realTimeLocationStatusView {
    if (!_realTimeLocationStatusView) {
        _realTimeLocationStatusView = [[RealTimeLocationStatusView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        _realTimeLocationStatusView.delegate = self;
        [self.view addSubview:_realTimeLocationStatusView];
    }
    return _realTimeLocationStatusView;
}
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus {
    return [self.realTimeLocation getStatus];
}

- (void)onShowRealTimeLocationView {
    [self showRealTimeLocationViewController];
}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent
{
    if ([messageCotent isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)messageCotent;
        textMsg.extra = @"";
    }
    return messageCotent;
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.model.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage * textMessage = cell.model.content;
        NSLog(@"userId = %@ ** targetID = %@ ** %@",cell.model.userInfo.userId,cell.model.targetId , textMessage.content);
    }else
    {
        NSLog(@"userId = %@ ** targetID = %@ ** %@",cell.model.userInfo.userId,cell.model.targetId , [cell.model.content class]);
    }
    
    
}
- (void)didSendMessage:(NSInteger)stauts
               content:(RCMessageContent *)messageCotent
{
    if ([messageCotent isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage * textMessage = messageCotent;
        NSLog(@"%@", textMessage.content);
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
        [self showRealTimeLocationViewController];
    }
}

- (void)didTapCellPortrait:(NSString *)userId{
    if (self.conversationType == ConversationType_GROUP || self.conversationType == ConversationType_DISCUSSION) {
        [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            [[RCDHttpTool shareInstance]updateUserInfo:userId success:^(RCUserInfo * user) {
                if (![userInfo.name isEqualToString:user.name]) {
                    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
                    
                }
                NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
                BOOL isGotoDetailView = NO;
                for (RCDUserInfo *USER in friendList) {
                    if ([userId isEqualToString:USER.userId] && [USER.status isEqualToString:@"20"]) {
                        isGotoDetailView = YES;
                    }
                    else if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]){
                        isGotoDetailView = YES;
                    }
                }
                if (isGotoDetailView == YES) {
//                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    RCDPersonDetailViewController *temp = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDPersonDetailViewController"];
//                    temp.userInfo = user;
//                    [self.navigationController pushViewController:temp animated:YES];
                }
                else{
//                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    RCDAddFriendViewController *addViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddFriendViewController"];
//                    addViewController.targetUserInfo = userInfo;
//                    [self.navigationController pushViewController:addViewController animated:YES];
                }
            } failure:^(NSError *err) {
                
            }];
        }];
        
    }
    if (self.conversationType == ConversationType_PRIVATE) {
        
        if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            MeDetailInfomationViewController * meinfoVC = [[MeDetailInfomationViewController alloc]initWithNibName:@"MeDetailInfomationViewController" bundle:nil];
            [self.navigationController pushViewController:meinfoVC animated:YES];
        }else
        {
            if (!self.friendmodel) {
                self.isSelect = YES;
                self.isRightBarItem = NO;
                [self getfriendInformation];
            }else
            {
                FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
                friend.model = _friendmodel;
                friend.targetId = self.targetId;
                [self.navigationController pushViewController:friend animated:YES];
            }
            
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
    NSLog(@"message objectName = %@", model.objectName);
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
    NSLog(@"message objectName = %@", model.objectName);
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
            [self showRealTimeLocationViewController];
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
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

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
        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}


- (void)onFailUpdateLocation:(NSString *)description {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.realTimeLocation quitRealTimeLocation];
        [self popupChatViewController];
    }
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message
{
    return message;
}



/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController{
    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    }else if([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE){
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc animated:YES completion:^{
        
    }];
}
- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
                break;
            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
                    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
                        if (userInfo.name.length) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%@正在共享位置", userInfo.name]];
                            });
                        }
                    }];
                } else {
                    if(participants.count<1)
                        [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 获取target信息详情
- (void)getfriendInformation
{
    NSDictionary * jsonDic = @{
                               @"Account":self.targetId
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/SearchFriend?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak ChatViewController * chatVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            self.friendmodel = [[FriendInformationModel alloc]initWithDictionery:responseObject];
            
            if (self.isSelect) {
                if (!self.isRightBarItem) {
                    FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
                    friend.model = _friendmodel;
                    friend.targetId = self.targetId;
                    [self.navigationController pushViewController:friend animated:YES];
                }else
                {
                    ChatSettingViewController * chatSettingVC = [[ChatSettingViewController alloc]initWithNibName:@"ChatSettingViewController" bundle:nil];
                    chatSettingVC.model = _friendmodel;
                    chatSettingVC.userId = self.targetId;
                    [self.navigationController pushViewController:chatSettingVC animated:YES];
                }
            }
            
        }else
        {
            if (self.isRightBarItem) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
     self.isRightBarItem = NO;
    
    if ([self.targetId isEqualToString:@"200"]) {
        RCDUserInfo * userinfo = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", self.targetId]];
        userinfo.name = self.friendmodel.UserName;
        userinfo.portraitUri = self.friendmodel.iconUrl;
        userinfo.displayName = self.friendmodel.displayName;
        [[RCDataBaseManager shareInstance]insertFriendToDB:userinfo];
        
        RCUserInfo * user = [[RCDataBaseManager shareInstance]getUserByUserId:[NSString stringWithFormat:@"%@", self.friendmodel.userId]];
        user.portraitUri = self.friendmodel.iconUrl;
        if (self.friendmodel.displayName.length != 0) {
            user.name = self.friendmodel.displayName;
        }else
        {
            user.name = self.friendmodel.nickName;
        }
        [[RCDataBaseManager shareInstance]insertUserToDB:user];
        
        [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
    }
    
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
