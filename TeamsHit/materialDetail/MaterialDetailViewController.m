//
//  MaterialDetailViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialDetailViewController.h"
#import "global.h"
//#import "BGTopSilderBarCell.h"
#import "BGTopSilderBar.h"
#import "MaterialdetailBigView.h"
#import "MaterialDetaileListCell.h"
#import "MaterialDetailCell.h"
#define maxCount 9

static NSString* ALCELLID = @"MaterialDetaileListCell";

@interface MateriaTypeModel : NSObject


@property (nonatomic, assign)int item;
@property (nonatomic, copy)NSString * materialTypeName;
@property (nonatomic, strong)NSNumber * materiaTypeId; // 素材种类id，请求素材想起用
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int allCount;

@property (nonatomic, strong)NSMutableArray * OriginalArr;
@property (nonatomic, strong)NSMutableArray * ThumbnailArr;



@end

@implementation MateriaTypeModel

- (NSMutableArray *)OriginalArr
{
    if (!_OriginalArr) {
        _OriginalArr = [NSMutableArray array];
    }
    return _OriginalArr;
}

- (NSMutableArray *)ThumbnailArr
{
    if (!_ThumbnailArr) {
        _ThumbnailArr = [NSMutableArray array];
    }
    return _ThumbnailArr;
}

@end

@interface MaterialDetailViewController()<UICollectionViewDataSource,UICollectionViewDelegate, TopsliderBarSelectDelegate, CilckDetailMaterialDelegate, MaterialDetailBigViewDelegate>
{
    MBProgressHUD* hud ;
}
@property (nonatomic, copy)MaterialDetailBlock myBlock;
@property(nonatomic,weak)BGTopSilderBar* silderBar;
@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,assign)int currentBarIndex;

@property (nonatomic, strong)NSMutableArray * materialTyprArr;
@property (nonatomic, strong)NSMutableArray * materiaTypeTitleArr;
@property (nonatomic, strong)MaterialdetailBigView * bigView;
//@property (nonatomic, strong)NSMutableArray * materialDetailArr;// 存放素材详情数组的总数据源

@end



@implementation MaterialDetailViewController

//- (NSMutableArray *)materialDetailArr
//{
//    if (!_materialDetailArr) {
//        _materialDetailArr = [NSMutableArray array];
//    }
//    return _materialDetailArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"素材";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.materialTyprArr = [NSMutableArray array];
    self.materiaTypeTitleArr = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadmateriaType];
            
            [self initCollectView];//初始化底部滑动的collectionView
        });
    });
    
    
//    [self initSilderBar];//初始化顶部BGTopSilderBar
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadmateriaType
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{};
    
    __weak MaterialDetailViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking]getMaterialType:jsonDic success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        NSArray * materialtypearray = [responseObject objectForKey:@"MaterialType"];
        
        for (int i = 0; i < materialtypearray.count; i++) {
            NSDictionary * materiaTypeDic = [materialtypearray objectAtIndex:i];
            MateriaTypeModel * model = [[MateriaTypeModel alloc]init];
            model.materialTypeName = [materiaTypeDic objectForKey:@"MaterialTypeName"];
            model.materiaTypeId = [materiaTypeDic objectForKey:@"MaterialTypeId"];
            model.page = 1;
            model.allCount = 0;
            model.item = i;
            [weakSelf.materialTyprArr addObject:model];
            [weakSelf.materiaTypeTitleArr addObject:model.materialTypeName];
        }
        
        
        [weakSelf initSilderBar:weakSelf.materiaTypeTitleArr];
        [weakSelf reloadMaterialDetailsWithmateriaTypeModel:weakSelf.materialTyprArr[0] indexpath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
            ;
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            NSLog(@"%@", error);
        }
    }];
    
}

- (void)reloadMaterialDetailsWithmateriaTypeModel:(MateriaTypeModel *)model indexpath:(NSIndexPath *)indexpath
{
    
    if (model.ThumbnailArr.count > 0) {
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"Page":@(model.page),
                               @"Count":@maxCount,
                               @"MaterialTypeId":model.materiaTypeId
                               };
    
    __weak MaterialDetailViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking]getMaterialWithType:jsonDic success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        model.allCount = [[responseObject objectForKey:@"AllCount"] intValue];
        NSArray * Materials = [responseObject objectForKey:@"Materials"];
        
        [model.ThumbnailArr removeAllObjects];
        [model.OriginalArr removeAllObjects];
        
        for (NSDictionary * dic in Materials) {
            [model.OriginalArr addObject:[dic objectForKey:@"Original"]];
            [model.ThumbnailArr addObject:[dic objectForKey:@"Thumbnail"]];
        }
        
        [weakSelf.collectView reloadItemsAtIndexPaths:@[indexpath]];
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
            ;
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            NSLog(@"%@", error);
        }
    }];
}

/**
 初始化BGTopSilderBar
 */
-(void)initSilderBar:(NSArray * )arrar{
    BGTopSilderBar* silder = [[BGTopSilderBar alloc] initWithFrame:CGRectMake(0,0,screenW, 50) andItemTitleArr:arrar];
    silder.delegate = self;
    silder.contentCollectionView = _collectView;//_collectView必须要在前面初始化,不然这里值为nil
    _silderBar = silder;
    [self.view addSubview:silder];
    [self.collectView reloadData];
}
/**
 初始化底部滑动的collectionView
 */
-(void)initCollectView{
    CGFloat Margin = 0;
    CGFloat W = self.view.hd_width;
    CGFloat H = self.view.hd_height-60;
    CGRect rect = CGRectMake(Margin,60, W,H);
    //初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(W, H);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    UICollectionView* collectView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    collectView.tag = 0;
    collectView.backgroundColor = [UIColor clearColor];
    _collectView = collectView;
    //设置代理
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = NO;
    // 注册cell
    [collectView registerClass:[MaterialDetaileListCell class] forCellWithReuseIdentifier:ALCELLID];
    //设置水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置分页
    collectView.pagingEnabled = YES;
    [self.view addSubview:collectView];
}

#pragma -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.materialTyprArr.count;//此处页面的张数要跟顶部滑动栏的item个数一样
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MateriaTypeModel * model = self.materialTyprArr[indexPath.row];
    MaterialDetaileListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALCELLID forIndexPath:indexPath];
    [cell creatContentviews:model.ThumbnailArr];
    cell.delegate = self;
    cell.isHavenotAddBT = self.isOtnerVc;
    cell.item = indexPath.row;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - TopsliderBarSelectDelegate
- (void)selectItem:(int)item
{
    MateriaTypeModel * model = self.materialTyprArr[item];
    NSLog(@"%@ *** %@", model.materialTypeName, model.materiaTypeId);
    
    [self reloadMaterialDetailsWithmateriaTypeModel:model indexpath:[NSIndexPath indexPathForRow:item inSection:0]];
    
}

#pragma mark - CilckDetailMaterialDelegate
- (void)cilckWithclickItem:(int)clickitem andListItem:(int)listItem
{
    NSLog(@"点击了 %d %d", listItem, clickitem);
    
    MateriaTypeModel * model = self.materialTyprArr[listItem];
    
    self.bigView = [[MaterialdetailBigView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bigView.delegate = self;
    _bigView.listItem = listItem;
    [_bigView refreshImageDateSourceWithImageArr:model.OriginalArr];
    [_bigView show:clickitem];
    
}

- (void)headRefreshWith:(int)item andTarget:(id )collectionView
{
    UICollectionView * collection = (UICollectionView *)collectionView;
    MateriaTypeModel * model = self.materialTyprArr[item];
    model.page = 1;
    NSDictionary * jsonDic = @{
                               @"Page":@(model.page),
                               @"Count":@maxCount,
                               @"MaterialTypeId":model.materiaTypeId
                               };
    
    __weak MaterialDetailViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking]getMaterialWithType:jsonDic success:^(id  _Nonnull responseObject) {
        [collection.mj_header endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        model.allCount = [[responseObject objectForKey:@"AllCount"] intValue];
        NSArray * Materials = [responseObject objectForKey:@"Materials"];
        
        [model.ThumbnailArr removeAllObjects];
        [model.OriginalArr removeAllObjects];
        
        for (NSDictionary * dic in Materials) {
            [model.OriginalArr addObject:[dic objectForKey:@"Original"]];
            [model.ThumbnailArr addObject:[dic objectForKey:@"Thumbnail"]];
        }
        
        NSArray * visiblecellindex = [_collectView visibleCells];
        for (MaterialDetaileListCell * cell in visiblecellindex) {
            NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
            if (path1.row == item) {
                cell.materialDetailsArrar = model.ThumbnailArr;
                break;
            }
            
        }
//        [weakSelf.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
        [collection reloadData];
    } failure:^(NSError * _Nonnull error) {
        [collection.mj_header endRefreshing];
        if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
            ;
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            NSLog(@"%@", error);
        }
    }];
}

- (void)footRefreshWith:(int)item andTarget:(id )collectionView
{
    MateriaTypeModel * model = self.materialTyprArr[item];
    UICollectionView * collection = (UICollectionView *)collectionView;
    if (model.ThumbnailArr.count < model.allCount) {
        model.page++;
        NSDictionary * jsonDic = @{
                                   @"Page":@(model.page),
                                   @"Count":@maxCount,
                                   @"MaterialTypeId":model.materiaTypeId
                                   };
        
        __weak MaterialDetailViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]getMaterialWithType:jsonDic success:^(id  _Nonnull responseObject) {
            [collection.mj_footer endRefreshing];
            NSLog(@"responseObject = %@", responseObject);
            model.allCount = [[responseObject objectForKey:@"AllCount"] intValue];
            NSArray * Materials = [responseObject objectForKey:@"Materials"];
            
            for (NSDictionary * dic in Materials) {
                [model.OriginalArr addObject:[dic objectForKey:@"Original"]];
                [model.ThumbnailArr addObject:[dic objectForKey:@"Thumbnail"]];
            }
            
            NSArray * visiblecellindex = [_collectView visibleCells];
            for (MaterialDetaileListCell * cell in visiblecellindex) {
                NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
                if (path1.row == item) {
                    cell.materialDetailsArrar = model.ThumbnailArr;
                    break;
                }
                
            }
//            [weakSelf.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
            [collection reloadData];
        } failure:^(NSError * _Nonnull error) {
            [collection.mj_footer endRefreshing];
            if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
                ;
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                NSLog(@"%@", error);
            }
        }];
    }else
    {
        [collection.mj_footer endRefreshing];
        [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:item + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

- (void)materaildetailListAdd:(UIImage *)image
{
    if (self.myBlock) {
        self.myBlock(image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)materaildetailListPrint:(UIImage *)image
{
    NSLog(@"print");
    
    [[Print sharePrint] printImage:image taskType:@1 toUserId:self.userId];
    
}

- (void)getMaterialDetailImage:(MaterialDetailBlock)materialDetailImage
{
    self.myBlock = [materialDetailImage copy];
}


#pragma mark - MaterialDetailBigViewDelegate
- (void)beforeClick
{
    
}
- (void)nextClick
{
    NSLog(@"next");
    
    MateriaTypeModel * model = self.materialTyprArr[self.bigView.listItem];
    
    if (model.ThumbnailArr.count < model.allCount) {
        model.page++;
        NSDictionary * jsonDic = @{
                                   @"Page":@(model.page),
                                   @"Count":@maxCount,
                                   @"MaterialTypeId":model.materiaTypeId
                                   };
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        __weak MaterialDetailViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]getMaterialWithType:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            model.allCount = [[responseObject objectForKey:@"AllCount"] intValue];
            NSArray * Materials = [responseObject objectForKey:@"Materials"];
            
            for (NSDictionary * dic in Materials) {
                [model.OriginalArr addObject:[dic objectForKey:@"Original"]];
                [model.ThumbnailArr addObject:[dic objectForKey:@"Thumbnail"]];
            }
            
            //            [weakSelf.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
            
            [_bigView refreshImageDateSourceWithImageArr:model.OriginalArr];
            [_bigView moveToindex:_bigView.item + 1];
            
            [weakSelf.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.bigView.listItem inSection:0]]];
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
                ;
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                NSLog(@"%@", error);
            }
        }];
    }else
    {
        [self.bigView haoveNomore];
    }
    
}
- (void)addClick:(int )listItem andItem:(int )item
{
    NSLog(@"++++");
    
    UIImage * image;
    NSArray * visiblecellindex = [_collectView visibleCells];
    for (MaterialDetaileListCell * cell in visiblecellindex) {
        NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
        if (path1.row == listItem) {
            BOOL ishave = NO;
            NSArray * visebArr = [cell.materialDetailCollectionView visibleCells];
            for (MaterialDetailCell * cell2 in visebArr) {
                NSIndexPath *path2 = (NSIndexPath *)[cell.materialDetailCollectionView indexPathForCell:cell2];
                if (path2.row == item) {
                    
                    image = cell2.detailImageView.image;
                    ishave = YES;
                    break;
                    
                }
                
            }
            
            if (ishave) {
                break;
            }
        }
        
    }
    
    if (self.myBlock) {
        self.myBlock(image);
    }
    [self.bigView closeView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)printClick:(int )listItem andItem:(int )item
{
    UIImage * image;
    NSArray * visiblecellindex = [_collectView visibleCells];
    for (MaterialDetaileListCell * cell in visiblecellindex) {
        NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
        if (path1.row == listItem) {
            BOOL ishave = NO;
            NSArray * visebArr = [cell.materialDetailCollectionView visibleCells];
            for (MaterialDetailCell * cell2 in visebArr) {
                NSIndexPath *path2 = (NSIndexPath *)[cell.materialDetailCollectionView indexPathForCell:cell2];
                if (path2.row == item) {
                    
                    image = cell2.detailImageView.image;
                    ishave = YES;
                    break;
                    
                }
                
            }
            
            if (ishave) {
                break;
            }
        }
        
    }
     [[Print sharePrint] printImage:image taskType:@1 toUserId:self.userId];
    [self.bigView closeView];
    NSLog(@"print");
}


@end
