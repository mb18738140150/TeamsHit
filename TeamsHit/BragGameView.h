//
//  BragGameView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BragGameModel.h"
@protocol BragGameViewProtocol <NSObject>

- (void)bragShakeDIceCup;
- (void)bragReshakeCup;
- (void)bragCompleteShakeDiceCup;
- (void)bragChooseCompleteWithnumber:(int)number point:(int )point;// 叫点
- (void)openGameuser:(NSString *)beOpendUserId;// 开点
- (void)timeoutAction;// 超时不叫
- (void)getGameResultSourceRequest;// 结果展示完毕，获取最后结果
- (void)quitBragGameView;

@end

@interface BragGameView : UIView

@property (nonatomic, assign)id<BragGameViewProtocol>delegate;
@property (nonatomic, strong)UITableView * gametableView;
@property (nonatomic, strong)UITableView * scoreTableView;
@property (nonatomic, strong)NSMutableArray * gameUserInformationArr;// 存储用户游戏信息
@property (nonatomic, copy)NSString * finishDicePoint;// 游戏结束被叫的骰子点数
@property (nonatomic, assign)BOOL isHavoOnePoint;// 1点是否被叫过
- (void)begainState;

- (void)cratGameUserInformation:(NSArray *)userInfoArr withDic:(NSDictionary *)dic;
- (void)FirstCallDicePointUser:(NSString *)firstuserId;

- (void)shakeDiceWithDic:(NSDictionary *)dic;// 更新摇点状态
// 自己摇骰子
- (void)selfShakeDice:(NSDictionary *)dic;
// 有人叫点
- (void)callDicePoint:(NSDictionary *)dic;
// 开点
- (void)openDIcePoint:(NSDictionary *)dic;

@end
