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

#import "MaterialDetaileListCell.h"
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

@interface MaterialDetailViewController()<UICollectionViewDataSource,UICollectionViewDelegate, TopsliderBarSelectDelegate, CilckDetailMaterialDelegate>
{
    MBProgressHUD* hud ;
}
@property(nonatomic,weak)BGTopSilderBar* silderBar;
@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,assign)int currentBarIndex;

@property (nonatomic, strong)NSMutableArray * materialTyprArr;
@property (nonatomic, strong)NSMutableArray * materiaTypeTitleArr;

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
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"素材"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.materialTyprArr = [NSMutableArray array];
    self.materiaTypeTitleArr = [NSMutableArray array];
    
    [self reloadmateriaType];
    
    [self initCollectView];//初始化底部滑动的collectionView
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
                               @"Count":@9,
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
    CGFloat H = self.view.hd_height-60 - 64;
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
}

- (void)headRefreshWith:(int)item andTarget:(id )collectionView
{
    UICollectionView * collection = (UICollectionView *)collectionView;
    MateriaTypeModel * model = self.materialTyprArr[item];
    model.page = 1;
    NSDictionary * jsonDic = @{
                               @"Page":@(model.page),
                               @"Count":@9,
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
    model.page++;
    UICollectionView * collection = (UICollectionView *)collectionView;
    if (model.ThumbnailArr.count < model.allCount) {
        MateriaTypeModel * model = self.materialTyprArr[item];
        NSDictionary * jsonDic = @{
                                   @"Page":@(model.page),
                                   @"Count":@9,
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


@end
