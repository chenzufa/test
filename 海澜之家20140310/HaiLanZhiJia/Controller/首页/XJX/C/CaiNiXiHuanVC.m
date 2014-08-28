//
//  CaiNiXiHuanVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CaiNiXiHuanVC.h"
#import "GoodEntity.h"
#import "PullTableView.h"
#import "SPGongGeCell.h"
#import "ShangPingDetailVC.h"

@interface CaiNiXiHuanVC ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,SPGongGeCellDelegate>
@property(nonatomic,retain)PullTableView *tableView;
@property(nonatomic,retain)NSMutableArray *spArr;
@property(nonatomic,assign)NSUInteger currentPage;
@property(nonatomic,retain)UILabel *tiShiLabel;
@property(nonatomic,assign)BOOL isNeedAddPage;
@end

@implementation CaiNiXiHuanVC
-(void)dealloc
{
    [_spArr release];_spArr=nil;
    [_tableView release];_tableView=nil;
    [_tiShiLabel release];_tiShiLabel=nil;
    [super dealloc];
}
-(void)leftAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super leftAction];
}
-(void)initDataSource
{
    if (_spArr == nil)
    {
        _spArr = [[NSMutableArray arrayWithCapacity:0]retain];
    }else
    {
        [_spArr removeAllObjects];
    }
    _currentPage = 1;
}
-(void)requestDatasource
{
    [self addHud:@""];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:YourFavourateIntroduce param:[self YourFavourateIntroduceParam:_spId page:_currentPage] tag:1];
    [request release];
}
#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    self.tableView.pullTableIsRefreshing = NO;
    self.tableView.pullTableIsLoadingMore = NO;
    
    NSMutableArray *objectArr = (NSMutableArray*)dataObj;
    _tiShiLabel.hidden = YES;
    if (_currentPage==1)
    {
        if (objectArr.count<=0)
        {
            if (_tiShiLabel==nil)
            {
                UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,[self getTitleBarHeight],MainViewWidth, 20)] autorelease];
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.textColor = RGBCOLOR(160,160,160);
                lbl.font = [UIFont systemFontOfSize:14.0f];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.text = @"暂时没有推荐商品,请稍后再来";
                lbl.hidden = NO;
                lbl.tag = 0x7474;
                self.tiShiLabel = lbl;
                [self.tableView addSubview:lbl];
            }
            if (self.spArr.count<=0)
            {
                self.tiShiLabel.hidden = NO;
            }
            _isNeedAddPage=NO;
            return;
        }
        self.spArr = objectArr;
        _isNeedAddPage=YES;
        
    }else if(_currentPage>1)
    {
        if (objectArr.count<=0)
        {
            [self addFadeLabel:@"对不起,猜不出更多你喜欢的商品了"];
            _isNeedAddPage=NO;
            return;
        }
        [self.spArr addObjectsFromArray:objectArr];
        _isNeedAddPage=YES;
    }
    [self.tableView reloadData];
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    [self addFadeLabel:@"对不起,还没猜出你喜欢的商品"];
    _isNeedAddPage=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setTitleString:@"商品推荐"];
    self.view.backgroundColor =RGBCOLOR(242, 242, 242);
    
    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];
}
-(void)doAfterViewDidLoad
{
    [self initSubview];
    [self initDataSource];
    [self requestDatasource];
}
-(void)initSubview
{
    
    CGFloat y = [self getTitleBarHeight];
    PullTableView *tableView = [[PullTableView alloc]initWithFrame:CGRectMake(0,y, 320, MainViewHeight-20-[self getTitleBarHeight])];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pullDelegate = self;
    tableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    tableView.pullBackgroundColor = RGBCOLOR(245, 245, 245);
    tableView.pullTextColor = [UIColor blackColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView  = view;
    [view release];
    
}
#pragma mark -- tableviewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_spArr.count%2==0)?_spArr.count/2:_spArr.count/2+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSArray *arr=nil;
        if ((indexPath.row*2+1)==_spArr.count)
        {
            arr = [NSArray arrayWithObjects:_spArr[indexPath.row*2], nil];
        }else
        {
            arr = [NSArray arrayWithObjects:_spArr[indexPath.row*2],_spArr[indexPath.row*2+1], nil];
            
        }

        static NSString *cell1 = @"goonGe";
        SPGongGeCell *cell =(SPGongGeCell*)[tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell)
        {
            cell = [[[SPGongGeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1 rankCount:arr.count]autorelease];
        }
        cell.objects = arr;
        cell.delegate = self;
        [cell setNeedsLayout];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPGongGeCell cellHeight:nil];
}
#pragma mark -- spGongGeCellDelegate
-(void)cell:(SPGongGeCell *)cell imageBtnClicked:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int row = indexPath.row;
    GoodEntity *object = nil;
    if (btn.tag==1)//点击左边的商品
    {
        object = _spArr[row*2];
    }
    if (btn.tag==2)//点击右边的商品
    {
        object = _spArr[row*2+1];
    }
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = object.goodsid;
    [self pushViewController:vc];
    [vc release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- pulltableview delegate
-(void)refreshTable
{
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}
//上啦更新数据再这里加载
-(void)loadMoreDataToTable
{
    self.tableView.pullTableIsLoadingMore = NO;
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    _currentPage=1;
    [self requestDatasource];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
    if (_isNeedAddPage==YES)
    {
        _currentPage++;
    }
    [self requestDatasource];

}

@end
