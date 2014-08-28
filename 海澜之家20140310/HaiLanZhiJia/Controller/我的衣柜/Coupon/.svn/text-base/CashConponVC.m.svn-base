//
//  CashConponVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CashConponVC.h"
#import "CashConponCell.h"
#import "ShowContentsView.h"
#import "ConponScanBangdingVC.h"
#import "UITableView+RemindNoData.h"
#define FirstPage 1
@interface CashConponVC ()

@end

@implementation CashConponVC
{
    PullTableView *beenUsedTableView; // 已使用列表
    PullTableView *unUsedTableView;   // 未使用列表
    
    NSMutableArray *arrBeenUsed;
    NSMutableArray *arrUnUsed;
    
    UIScrollView *sv;
    BangdingView *bdView;           //绑定界面
    
    int beenCurrPage;
    int unCurrPage;
    
    NSString *rule;             //现金券使用规则
}

typedef enum{           //网络请求的类型
    RequestTypeGetList = 0,
    RequestTypeBangDing
}RequestType;

- (void)dealloc
{
    [sv release];
    [beenUsedTableView release];
    [arrBeenUsed release];
    if (unUsedTableView) {
        [unUsedTableView release];
        [arrUnUsed release];
    }
    
    if (bdView) {
        [bdView release];
    }
    rule = nil;
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    unCurrPage = FirstPage;
    beenCurrPage = FirstPage;
    
    [self setTitleString:@"现金券"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"规则"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self initUI];
//    [self request:RequestTypeGetList subtype:1 page:beenCurrPage cardNum:nil psd:nil];
    if (beenUsedTableView.pullTableIsRefreshing == NO) {
        beenUsedTableView.pullTableIsRefreshing = YES;
    }
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
}

- (void)afterDelay
{
    [self request:RequestTypeGetList subtype:1 page:beenCurrPage cardNum:nil psd:nil];
}

- (void)myRightButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    ShowContentsView *contentsView = [[ShowContentsView alloc]init];
    [contentsView setContentsText:rule];
    [self.view addSubview:contentsView];
    [contentsView release];
}

- (void)initUI
{
    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, 50, 50)];
    segment.segments = [NSArray arrayWithObjects:@"已使用",@"未使用",@"绑定", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT + segment.frame.size.height, MainViewWidth, MainViewHeight - TITLEHEIGHT - segment.frame.size.height - 20)];
    [sv setContentSize:CGSizeMake(MainViewWidth * 3, sv.frame.size.height)];
    [sv setPagingEnabled:YES];
    [sv setScrollEnabled:NO];
    [self.view addSubview:sv];
    
//    arrBeenUsed = [[NSMutableArray alloc]init];
    beenUsedTableView = [[PullTableView alloc]initWithFrame:CGRectMake(10, 0, 300, sv.frame.size.height)];
    [beenUsedTableView setShowsVerticalScrollIndicator:NO];
    beenUsedTableView.delegate = self;
    beenUsedTableView.dataSource = self;
    beenUsedTableView.pullDelegate = self;
    [beenUsedTableView setPullBackgroundColor:[UIColor clearColor]];
    [beenUsedTableView setBackgroundColor:[UIColor clearColor]];
    beenUsedTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [beenUsedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [sv addSubview:beenUsedTableView];
    beenUsedTableView.tag = 1;
    
    [segment release];
}

#pragma mark PUllTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
//    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:2.0f];
    if (pullTableView.tag == 1) {
        [self request:RequestTypeGetList subtype:pullTableView.tag page:++beenCurrPage cardNum:nil psd:nil];
    }else {
        [self request:RequestTypeGetList subtype:pullTableView.tag page:++unCurrPage cardNum:nil psd:nil];
    }
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    if (pullTableView.tag == 1) {
        
        beenCurrPage = FirstPage;
        [self request:RequestTypeGetList subtype:pullTableView.tag page:beenCurrPage cardNum:nil psd:nil];
    }else if (pullTableView.tag == 2){
        unCurrPage = FirstPage;
        [self request:RequestTypeGetList subtype:pullTableView.tag page:unCurrPage cardNum:nil psd:nil];
    }
}

#pragma mark - 停止上拉下拉动画
- (void)tableViewStopShuaxin:(PullTableView *)tableView
{
    if (tableView.pullTableIsRefreshing == YES) {
        tableView.pullTableIsRefreshing = NO;
    }
    if (tableView.pullTableIsLoadingMore == YES) {
        tableView.pullTableIsLoadingMore = NO;
    }
}

- (void)request:(RequestType)type subtype:(int)subtype page:(int)page cardNum:(NSString *)cardNum psd:(NSString *)psd     //   subtype: 1 已使用  2 未使用
{
//    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    if (type == RequestTypeGetList) {
        [self.requestOjb requestDataWithInterface:ShoppingTicketInfo param:[self ShoppingTicketInfoParam:1 subtype:subtype page:page] tag:subtype];
    }else if (type == RequestTypeBangDing){
        [self.view addHUDActivityView:@"正在绑定"];  //提示 正在绑定
        [self.requestOjb requestDataWithInterface:BindShoppingTicket param:[self BindShoppingTicketParam:cardNum password:psd type:1 haspassword:1 isscan:0]tag:100];
    }
    
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    
    if (tag == 100) {       // 绑定接口
        [self.view removeHUDActivityView];        //绑定成功  停止转圈
        
        StatusEntity *entiSta = (StatusEntity *)dataObj;
        
        if (entiSta.response == 1) {
            [self.view.window addHUDLabelView:@"绑定成功" Image:nil afterDelay:2];
            [bdView cleanTextField];
        }else {
            [self.view.window addHUDLabelView:entiSta.failmsg Image:nil afterDelay:2];
        }
        
    }else {
        ShoppingTicketInfoEntity *entiTicketInfo = (ShoppingTicketInfoEntity *)dataObj;
        if (!rule) {
            rule = [entiTicketInfo.rule retain];
        }
        switch (tag) {
            case 1:
                [self tableViewStopShuaxin:beenUsedTableView];
                
//                if (beenCurrPage == FirstPage) {        //第一页时  清空属猪中的数据以添加新数据
//                    [arrBeenUsed removeAllObjects];
//                }
//                [arrBeenUsed addObjectsFromArray:entiTicketInfo.ticketlist];
                
                if (beenCurrPage == FirstPage) {
                    arrBeenUsed = [(NSMutableArray *)entiTicketInfo.ticketlist retain];
                }else {
                    [arrBeenUsed addObjectsFromArray:entiTicketInfo.ticketlist];
                    NSArray *arr = (NSArray *)entiTicketInfo.ticketlist;
                    if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                        beenCurrPage -- ;
                    }
                }
                
                if (arrBeenUsed.count == 0) {
                    [beenUsedTableView addRemindWhenNoData:@"您没有已使用的现金券"];
                }else {
                    [beenUsedTableView hiddenReminndWhenNoDatainSupView];
                }
                
                [beenUsedTableView reloadData];
                
                
                break;
            case 2:
                [self tableViewStopShuaxin:unUsedTableView];
//                if (unCurrPage == FirstPage) {          //第一页时  清空属猪中的数据以添加新数据
//                    [arrUnUsed removeAllObjects];
//                }
//                [arrUnUsed addObjectsFromArray:entiTicketInfo.ticketlist];
                
                if (unCurrPage == FirstPage) {
                    arrUnUsed = [(NSMutableArray *)entiTicketInfo.ticketlist retain];
                }else {
                    [arrUnUsed addObjectsFromArray:entiTicketInfo.ticketlist];
                    NSArray *arr = (NSArray *)entiTicketInfo.ticketlist;
                    if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                        unCurrPage -- ;
                    }
                }
                
                if (arrUnUsed.count == 0) {
                    [unUsedTableView addRemindWhenNoData:@"您没有未使用的现金券"];
                }else {
                    [unUsedTableView hiddenReminndWhenNoDatainSupView];
                   
                }
                [unUsedTableView reloadData];
                break;
                
            default:
                break;
        }
    }
    
    
//    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    if (tag == RequestTypeBangDing) {
        [self.view removeHUDActivityView];        //绑定失败  停止转圈并弹出提示框
    }
    
    switch (tag) {
        case 1:
            [beenUsedTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
            [self performSelector:@selector(tableViewStopShuaxin:) withObject:beenUsedTableView afterDelay:1];
            if (beenCurrPage > 1) {
                beenCurrPage -- ;   //请求失败时，当前页码退回上一页
            }
            break;
        case 2:
            [unUsedTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
            [self performSelector:@selector(tableViewStopShuaxin:) withObject:unUsedTableView afterDelay:1];
            if (unCurrPage > 1) {
                unCurrPage -- ;   //请求失败时，当前页码退回上一页
            }
            break;
            
        default:
            break;
    }
    
}

#pragma mark BangdingViewDelegate
- (void)bangdingView:(BangdingView *)bdView clickedAnIndex:(int)index cardNum:(NSString *)strNum passWord:(NSString *)strPsd
{
    //  绑定界面的两个按钮点击协议方法
    NSLog(@"index = %i",index);
    switch (index) {
        case 0:
        {
            NSLog(@"strNum = %@  strPsd = %@",strNum,strPsd);
            if (strNum.length > 0 && strPsd.length > 0) {
                [self request:RequestTypeBangDing subtype:0 page:0 cardNum:strNum psd:strPsd];
            }else {
                WCAlertView *alert = [[WCAlertView alloc]initWithTitle:nil message:@"信息填写不完整哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert setStyle:WCAlertViewStyleWhite];
                [alert show];
                [alert release];
            }
            
        }
            break;
        case 1:
        {
            ConponScanBangdingVC *scanBandingVC = [[ConponScanBangdingVC alloc]init];
            [scanBandingVC setConponType:ScanTypeCash];
            [self pushViewController:scanBandingVC];
            [scanBandingVC release];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark MySegMentControlDelegate
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    NSLog(@"index = %i",index);
    [sv scrollRectToVisible:CGRectMake(MainViewWidth * index, 0, sv.frame.size.width, sv.frame.size.height) animated:YES];
    
    
    switch (index) {
        case 0:
            [self.view endEditing:YES];  //收起可能存在的键盘
            break;
        case 1:
            [self.view endEditing:YES];  //收起可能存在的键盘
            if (!unUsedTableView) {
//                arrUnUsed = [[NSMutableArray alloc]init];
                unUsedTableView = [[PullTableView alloc]initWithFrame:CGRectMake(MainViewWidth + 10, 0, 300, sv.frame.size.height)];
                [unUsedTableView setShowsVerticalScrollIndicator:NO];
                unUsedTableView.delegate = self;
                unUsedTableView.dataSource = self;
                unUsedTableView.pullDelegate = self;
                [unUsedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [unUsedTableView setPullBackgroundColor:[UIColor clearColor]];
                [unUsedTableView setBackgroundColor:[UIColor clearColor]];
                unUsedTableView.tableFooterView = [[[UIView alloc]init]autorelease];
                [sv addSubview:unUsedTableView];
                unUsedTableView.tag = 2;
                
                unUsedTableView.pullTableIsRefreshing = YES;
                [self request:RequestTypeGetList subtype:2 page:unCurrPage cardNum:nil psd:nil];
            }
            
            break;
        case 2:
            if (!bdView) {
                bdView = [[BangdingView alloc]initWithFrame:CGRectMake(MainViewWidth * 2, 0, sv.frame.size.width , sv.frame.size.height)];
                bdView.ifHasPsd = 2;
                [bdView initUI];
                bdView.delegate = self;
                [sv addSubview:bdView];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (tableView.tag) {
        case 1:
            return arrBeenUsed.count;
            break;
        case 2:
            return arrUnUsed.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    CashConponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[CashConponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    ShoppingTicketEntity *one;
    switch (tableView.tag) {
        case 1:
            one = [arrBeenUsed objectAtIndex:indexPath.section];
            [cell setlabCardNum:one.cardnum labMoney:one.amount lablimitTime:one.usingdate labState:one.ordernumber type:tableView.tag];
            break;
        case 2:
            one = [arrUnUsed objectAtIndex:indexPath.section];
            [cell setlabCardNum:one.cardnum labMoney:one.amount lablimitTime:one.expireddate labState:one.status type:tableView.tag];
            break;
            
        default:
            one = nil;
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 10)]autorelease];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
