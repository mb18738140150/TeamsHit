//
//  ShuoshuoFavouriteAndCommentView.m
//  TeamsHit
//
//  Created by 仙林 on 17/1/11.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "ShuoshuoFavouriteAndCommentView.h"
#import "PublishCollectionViewCell.h"
#import "ShuoShuoCommentTableViewCell.h"

#define IMAGEWIDTH 15
#define FAVOURITEICONCELLID @"favouriteiconcelID"
#define COMMENTSHUOSHUOCELLID @"commentshuoshuocellID"

@interface ShuoshuoFavouriteAndCommentView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, shuoshuocellDelegate>
{
    YMTextData * ymtextdata;
}
@property (nonatomic,strong) UIImageView *favouriteImageview;//点赞的图
@property (nonatomic, strong)UIImageView *commenImageview;

@property (nonatomic, strong)UICollectionView * favouriteCollectionView;
@property (nonatomic, strong)UITableView * commentTableView;


@end

@implementation ShuoshuoFavouriteAndCommentView

- (instancetype)initWithFrame:(CGRect)frame withData:(YMTextData *)ymdata
{
    if (self = [super initWithFrame:frame]) {
        ymtextdata = ymdata;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self removeAllSubviews];
    self.viewHeight = 0;
    if (ymtextdata.messageBody.posterFavourUserArr.count > 0) {
        self.favouriteImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, IMAGEWIDTH, IMAGEWIDTH)];
        self.favouriteImageview.image = [UIImage imageNamed:@"zan.png"];
        [self addSubview:self.favouriteImageview];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(28, 28);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.favouriteCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(35, 10, self.hd_width - 40, 50) collectionViewLayout:layout];
        [self.favouriteCollectionView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:FAVOURITEICONCELLID];
        self.favouriteCollectionView.delegate = self;
        self.favouriteCollectionView.dataSource = self;
        [self addSubview:self.favouriteCollectionView];
        
        int perlinecount = (self.hd_width - 55) / (28 + 5);
        int linecount;
        if (ymtextdata.messageBody.posterFavourUserArr.count % perlinecount == 0) {
            linecount = ymtextdata.messageBody.posterFavourUserArr.count / perlinecount;
        }else
        {
            linecount = ymtextdata.messageBody.posterFavourUserArr.count / perlinecount + 1;
        }
        
        self.favouriteCollectionView.hd_height = linecount * 28 + (linecount - 1) * 5;
        self.favouriteCollectionView.backgroundColor = [UIColor clearColor];
        
        self.viewHeight = self.favouriteCollectionView.hd_height + 15;
    }
    
    if (ymtextdata.messageBody.posterReplies.count == 0) {
        return;
    }
    
    self.commenImageview = [[UIImageView alloc]init];
    self.commenImageview.image = [UIImage imageNamed:@"shuoshuopinglun"];
    [self addSubview:self.commenImageview];
    if (ymtextdata.messageBody.posterFavourUserArr.count > 0) {
        self.commenImageview.frame = CGRectMake(10, CGRectGetMaxY(self.favouriteCollectionView.frame) + 13, IMAGEWIDTH, IMAGEWIDTH);
        
        if (ymtextdata.messageBody.posterReplies.count > 0) {
            UIView * separeteline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.favouriteCollectionView.frame) + 6, self.hd_width, .5)];
            separeteline.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
            [self addSubview:separeteline];
        }
        
    }else
    {
        self.commenImageview.frame = CGRectMake(10, 22, IMAGEWIDTH, IMAGEWIDTH);
    }
    
    self.commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(35, CGRectGetMinY(self.commenImageview.frame) - 7, self.hd_width - 40, 50) style:UITableViewStylePlain];
    [self.commentTableView registerClass:[ShuoShuoCommentTableViewCell class] forCellReuseIdentifier:COMMENTSHUOSHUOCELLID];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.bounces = NO;
    [self addSubview:self.commentTableView];
    
    self.commentTableView.hd_height = ymtextdata.replyHeight + 17 * ymtextdata.messageBody.posterReplies.count;
    self.commentTableView.backgroundColor = [UIColor clearColor];
    
    if (ymtextdata.messageBody.posterFavourUserArr.count == 0) {
        self.viewHeight += self.commentTableView.hd_height + 15;
    }else
    {
        self.viewHeight += self.commentTableView.hd_height + 13;
    }
    
    [self.favouriteCollectionView reloadData];
    [self.commentTableView reloadData];
    
}

#pragma mark - favouriteIconcollection delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ymtextdata.messageBody.posterFavourUserArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FAVOURITEICONCELLID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    RCUserInfo * favouriteUserInfo = ymtextdata.messageBody.posterFavourUserArr[indexPath.item];
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:favouriteUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logi(1)"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCUserInfo * favouriteUserInfo = ymtextdata.messageBody.posterFavourUserArr[indexPath.item];
    [_delegate viewclickUserName:favouriteUserInfo.userId];
}

#pragma mark - commentTableview delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ymtextdata.messageBody.posterReplies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShuoShuoCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:COMMENTSHUOSHUOCELLID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.replyBody = ymtextdata.messageBody.posterReplies[indexPath.row];
    cell.delegate = self;
    [cell creatSubViews];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShuoShuoCommentTableViewCell getcommentcellHeight:ymtextdata.messageBody.posterReplies[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFReplyBody * replyBody = ymtextdata.messageBody.posterReplies[indexPath.row];
    
    [_delegate clickRichText:replyBody index:indexPath.row];
}


- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex
{
    
}
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex
{
//    [_delegate clickRichText:0 replyIndex:index];
}
- (void)clickUserName:(NSString *)userId
{
    [_delegate viewclickUserName:userId];
}

- (void)refreshUIWith:(YMTextData *)ymdata
{
    ymtextdata = ymdata;
    [self prepareUI];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
