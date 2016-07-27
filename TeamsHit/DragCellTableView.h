//
//  DragCellTableView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DragCellTableView;

@protocol DragCellTableViewDataSource <UITableViewDataSource>
/*将外部数据源数组传入， 以便在移动cell数据发生改变时进行修改重排*/
- (NSArray *)originalArrayDataForTableView:(DragCellTableView *)tableView;

@end

@protocol RTDragCellTableViewDelegate <UITableViewDelegate>
/**将修改重排后的数组传入，以便外部更新数据源*/
- (void)tableView:(DragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray;
@optional
/**选中的cell准备好可以移动的时候*/
- (void)tableView:(DragCellTableView *)tableView cellReadyToMoveAtIndexPath:(NSIndexPath *)indexPath;
/**选中的cell正在移动，变换位置，手势尚未松开*/
- (void)cellIsMovingInTableView:(DragCellTableView *)tableView;
/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingInTableView:(DragCellTableView *)tableView;

@end


@interface DragCellTableView : UITableView

@property (nonatomic, assign)id<DragCellTableViewDataSource> dataSource;
@property (nonatomic, assign)id<RTDragCellTableViewDelegate> delegate;

@end
