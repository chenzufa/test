//
//  ShouQianZiXunVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShouQianZiXunVC.h"
#import "ShouQianZiXunCell.h"
#import "SaleConsultEntity.h"
#import "ZiXunVC.h"
#import "PullTableView.h"
#import "LoginViewCtrol.h"

#define kZiXunBtnTag 0x1111
#define kTableviewTag 0x9999



@interface ShouQianZiXunVC ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
@property(nonatomic,retain)NSMutableArray *ziXunArr;
@property(nonatomic,retain)PullTableView *tableView;
@property(nonatomic,assign)NSUInteger currentPage;
@property(nonatomic,retain)UILabel *tiShiLabel;
@property(nonatomic,assign)BOOL isNeedAddPage;
@end

@implementation ShouQianZiXunVC
-(void)dealloc
{
    [_ziXunArr release];_ziXunArr=nil;
    [_tableView release];_tableView=nil;
    [_spId release]; _spId=nil;
    [_tiShiLabel release];_tiShiLabel = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}
-(void)leftAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super leftAction];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =RGBCOLOR(242, 242, 242);
    [self setTitleString:@"售前咨询"];
    
     [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];
}
-(void)doAfterViewDidLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(ziXunSuccess:) name:kZiXunSuccessNotification object:nil];

    [self initDatasource];
    [self initSubview];
    [self requestDatasource];
}



-(void)initDatasource
{
    if (_ziXunArr==nil)
    {
        _ziXunArr = [[NSMutableArray arrayWithCapacity:0]retain];
    }else
    {
        [_ziXunArr removeAllObjects];
    }
    _currentPage = 1;
}
-(void)requestDatasource
{
    [self addHud:@""];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:GetSaleConsultList param:[self GetSaleConsultListParam:_spId page:_currentPage] tag:1];
    [request release];
}
#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    self.tableView.pullTableIsLoadingMore = NO;
    self.tableView.pullTableIsRefreshing = NO;
    
    NSMutableArray *objectArr = (NSMutableArray*)dataObj;
    
    _tiShiLabel.hidden = YES;
    if (_currentPage==1)
    {
        if (objectArr.count<=0)
        {
            if (_tiShiLabel==nil)
            {
                UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,15,MainViewWidth, 20)] autorelease];
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.textColor = RGBCOLOR(160,160,160);
                lbl.font = [UIFont systemFontOfSize:14.0f];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.text = @"暂时没有咨询";
                lbl.hidden = NO;
                lbl.tag = 0x7474;
                self.tiShiLabel = lbl;
                [self.tableView addSubview:lbl];
            }
            if (_ziXunArr.count<=0)
            {
                self.tiShiLabel.hidden = NO;
            }
            _isNeedAddPage=NO;
            [self.tableView reloadData];
            return;
        }
        _isNeedAddPage=YES;
        self.ziXunArr = objectArr;


    }else if(_currentPage>1)
    {
        if (objectArr.count<=0)
        {
            [self addFadeLabel:@"没有更多咨询了哦"];
            _isNeedAddPage=NO;
            return;
        }
        _isNeedAddPage=YES;
        [self.ziXunArr addObjectsFromArray:objectArr];
    }
    [self.tableView reloadData];
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    if (_currentPage==1)
    {
        [self addFadeLabel:@"暂时没有咨询"];
    }else if(_currentPage>1)
    {
       [self addFadeLabel:@"没有更多咨询了哦"]; 
    }
    _isNeedAddPage=NO;
}

-(void)initSubview
{
    
    UIImage *rightImage=[UIImage imageNamed:@"button1@2x.png"];
    CGFloat x = 250;
    CGFloat y = [self getTitleBarHeight]/2.0-rightImage.size.height/4.0;
    CGFloat w = rightImage.size.width/1.5;
    CGFloat h = rightImage.size.height/2.0;
    UIButton *ziXunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ziXunBtn.tag = kZiXunBtnTag;
    ziXunBtn.frame = CGRectMake(x,y,w,h);
    [ziXunBtn setBackgroundImage:GETIMG(@"button1_press@2x.png") forState:UIControlStateHighlighted];
    [ziXunBtn setBackgroundImage:GETIMG(@"button1@2x.png") forState:UIControlStateNormal];
    [ziXunBtn setTitle:@"咨询" forState:UIControlStateNormal];
    [ziXunBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:ziXunBtn];
    
    y = [self getTitleBarHeight]+3;
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
    self.tableView = tableView;
    tableView.tag = kTableviewTag;
    [tableView release];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView  = view;
    [view release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- tableviewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return _ziXunArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetify = @"tableviewCell";
    ShouQianZiXunCell *cell =(ShouQianZiXunCell*)[tableView dequeueReusableCellWithIdentifier:cellIdetify];
    if (!cell)
        {
            cell = [[[ShouQianZiXunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetify]autorelease];
        }
        if (indexPath.row<_ziXunArr.count)
        {
            cell.ziXunObject = _ziXunArr[indexPath.row];
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return [ShouQianZiXunCell cellHeight:_ziXunArr[indexPath.row]];
}

#pragma mark -- btnClicked
-(void)buttonClicked:(UIButton*)btn
{
    if (isNotLogin)
    {
        LoginViewCtrol *vc = [[LoginViewCtrol alloc]init];
        [self pushViewController:vc];
        [vc release];
    }else
    {
        ZiXunVC *vc = [[ZiXunVC alloc]init];
        vc.spId = _spId;
        [self pushViewController:vc];
        [vc release];
    }
   
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
    _currentPage = 1;
    [self requestDatasource];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
    if (_isNeedAddPage==YES)
    {
        _currentPage ++;
    }
    [self requestDatasource];
}
#pragma mark--咨询成功 界面刷新
-(void)ziXunSuccess:(NSNotification*)noti
{
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:GetSaleConsultList param:[self GetSaleConsultListParam:_spId page:1] tag:1];
    [request release];
}
@end
