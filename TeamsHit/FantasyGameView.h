//
//  FantasyGameView.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FantasyGameViewProtocol <NSObject>

- (void)changePublicCard;
- (void)changePrivateCard;
- (void)nochangeCard;
- (void)timeoutAction;// 超时不叫
- (void)getGameResultSourceRequest;// 结果展示完毕，获取最后结果
- (void)quitFantasyGameView;
- (void)prepareUI;
@end

@interface FantasyGameView : UIView
@property (nonatomic, assign)id<FantasyGameViewProtocol>delegate;
@property (nonatomic, strong)NSMutableArray * gameUserInformationArr;

- (void)cratGameUserInformation:(NSArray *)userInfoArr withDic:(NSDictionary *)dic;
- (void)changePrivateCard:(NSDictionary *)dic;
- (void)changePublicCardPush:(NSDictionary *)dic;
- (void)changePrivateCardPush:(NSDictionary *)dic;
- (void)nochangeCardPush:(NSDictionary *)dic;
- (void)showGameresultCard:(NSDictionary *)dic;
- (void)begainGame;
- (void)removeALLproperty;

@end
