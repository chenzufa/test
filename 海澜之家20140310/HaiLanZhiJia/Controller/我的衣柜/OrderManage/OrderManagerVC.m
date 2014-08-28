//
//  OderManagerVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderManagerVC.h"
#import "OrderRemindVC.h"
#import "OrderDetailVC.h"
#import "UITableView+RemindNoData.h"
#import "UIView+AddRemind.h"
#import "MyReviewVC.h"
#import "MyClothListVC.h"
#import "RootVC.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "DSRequest.h"

#define RedCircleTag 88
#define FirstPage 1
@interface OrderManagerVC ()<UPPayPluginDelegate,PaySuccessedDelegate>
{
    UIAlertView* mAlert;

}

@end

@implementation OrderManagerVC
{
    int goCurrPage;                   //进行中列表当前页码
    int fiCuffPage;                   //已完成列表当前页码
    int noCuffPage;                   //无效订单列表当前页码
    
    UIScrollView *sv;
    PullTableView *goingTableView;      // 进行中
    PullTableView *finishTableView;     // 已完成
    PullTableView *noServiceTableView;   // 无效订单
    
    NSMutableArray *arrGoinglists;
    NSMutableArray *arrFinishlists;
    NSMutableArray *arrNoServicelists;
    
//    UILabel *labRemindNoData;       //用于提示没有数据
}

typedef enum{
    
    RequestTypeGoing = 1,
    RequestTypeFinish,
    RequestTypeNoService,
    
    RequestTypeCancelOrder = 100,
    RequestTypeConfirmOrder     // 确认收货
//    RequestTypeGetReminderInfo
    
}RequestType;

- (void)dealloc
{
    [sv release];
    [goingTableView release];
    
    if (finishTableView) {
        [finishTableView release];
    }
    
    if (noServiceTableView) {
        [noServiceTableView release];
    }
    
    [arrGoinglists release];
    [arrFinishlists release];
    [arrNoServicelists release];
    
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
//    labRemindNoData = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
    
    goCurrPage = FirstPage;
    fiCuffPage = FirstPage;
    noCuffPage = FirstPage;     // 设置第一页为1
    [self setTitleString:@"我的订单"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"提醒"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];    
    
    [self.myRightButton showRedCircleRemind:self.hasnewRemind];
    
    [self initUI];
//    [self request:RequestTypeGetReminderInfo page:0 OrderNum:nil];  //是否有提醒
    
    if (goingTableView.pullTableIsRefreshing == NO) {
        goingTableView.pullTableIsRefreshing = YES;
    }
    
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifubaoSuccess) name:ZhifubaoSuccess object:nil]; //接受支付宝支付成功的通知
}

- (void)zhifubaoSuccess
{
    //支付回调
    [arrFinishlists removeAllObjects];      //清空已完成订单 用以刷新
    goCurrPage = FirstPage;
    [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];
}

- (void)afterDelay
{
    [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];   //获取列表信息
}

- (void)initUI
{
    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], 50, 50)];
    segment.segments = [NSArray arrayWithObjects:@"进行中",@"已完成",@"无效订单", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT + segment.frame.size.height, MainViewWidth, MainViewHeight - segment.frame.origin.y - segment.frame.size.height - 20)];
    [sv setShowsHorizontalScrollIndicator:NO];
    [sv setScrollEnabled:NO];
    [sv setPagingEnabled:YES];
    [sv setContentSize:CGSizeMake(sv.frame.size.width * 3, sv.frame.size.height)];
    [self.view addSubview:sv];
    
//    arrGoinglists = [[NSMutableArray alloc]init];  // 先初始化数组
    goingTableView = [[PullTableView alloc]initWithFrame:CGRectMake(10, 0, 300, MainViewHeight - segment.frame.origin.y - segment.frame.size.height - 20)];
    goingTableView.tag = 100;
    [goingTableView setShowsVerticalScrollIndicator:NO];
    goingTableView.delegate = self;
    goingTableView.dataSource = self;
    goingTableView.pullDelegate = self;
    [goingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([goingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [goingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
//    [goingTableView setPullBackgroundColor:[UIColor clearColor]];
    goingTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [sv addSubview:goingTableView];
    
    [segment release];
    
    
    
}

- (void)initFinishTableView         //初始化 已完成列表
{
//    arrFinishlists = [[NSMutableArray alloc]init];
    finishTableView = [[PullTableView alloc]initWithFrame:CGRectMake(10 + MainViewWidth, goingTableView.frame.origin.y, goingTableView.frame.size.width, goingTableView.frame.size.height)];
    finishTableView.tag = 101;
    [finishTableView setShowsVerticalScrollIndicator:NO];
    finishTableView.delegate = self;
    finishTableView.dataSource = self;
    finishTableView.pullDelegate = self;
//    [finishTableView setPullBackgroundColor:[UIColor clearColor]];
    [finishTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    finishTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [sv addSubview:finishTableView];
}

- (void)initNoServceTableView       //初始化 无效订单列表
{
//    arrNoServicelists = [[NSMutableArray alloc]init];
    noServiceTableView = [[PullTableView alloc]initWithFrame:CGRectMake(10 + MainViewWidth * 2, goingTableView.frame.origin.y, goingTableView.frame.size.width, goingTableView.frame.size.height)];
    noServiceTableView.tag = 102;
    [noServiceTableView setShowsVerticalScrollIndicator:NO];
    noServiceTableView.delegate = self;
    noServiceTableView.dataSource = self;
    noServiceTableView.pullDelegate = self;
//    [noServiceTableView setPullBackgroundColor:[UIColor clearColor]];
    [noServiceTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    noServiceTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [sv addSubview:noServiceTableView];
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

- (void)request:(RequestType)type page:(int)page OrderNum:(NSString *)orderNum  // type = 0 进行中 1 已完成 2无效订单
{
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    if (type == RequestTypeCancelOrder) {       // 取消订单接口
        
        [self.view addHUDActivityView:Loading];  //提示 取消中...
        
        [self.requestOjb requestDataWithInterface:CancelOrder param:[self CancelOrderParam:orderNum] tag:type];
        
    }else if(type == RequestTypeConfirmOrder){
        [self.requestOjb requestDataWithInterface:ConfirmOrder param:[self ConfirmOrderParam:orderNum] tag:type];
    }else [self.requestOjb requestDataWithInterface:MyOrderList param:[self MyOrderListParam:type page:page] tag:type];
    
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
//
    if (tag == 10000) {
        [self hideAlert];
        
        StatusEntity *entity = (StatusEntity *)dataObj;
        //1表示成功，2表示失败
        if (entity.response == 1) {
            
            NSString* tn = entity.uppaytn;
            if (tn != nil && tn.length > 0)
            {
                NSLog(@"tn=%@",tn);
                //tn 交易流水号  mode 00正式环境 01测试环境
                [UPPayPlugin startPay:tn mode:kMode viewController:self delegate:self];
            }else
            {
                [self showAlertMessage:@"该订单已付款"];
            }
            
        }else
        {
            [self hideAlert];
            [self showAlertMessage:entity.failmsg];
        }
        
        return;
    }
    
    NSLog(@"请求成功!");
    switch (tag) {
        case RequestTypeGoing:
        {
            [self tableViewStopShuaxin:goingTableView];
//            if (goCurrPage == FirstPage) {
//                [arrGoinglists removeAllObjects];
//            }
//            [arrGoinglists addObjectsFromArray:dataObj];
            
            if (goCurrPage == FirstPage) {
                arrGoinglists = [(NSMutableArray *)dataObj retain];
                
            }else {
                [goingTableView hiddenReminndWhenNoDatainSupView];
                [arrGoinglists addObjectsFromArray:dataObj];
                NSArray *arr = (NSArray *)dataObj;
                if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                    goCurrPage -- ;
                }
            }
            
            if (arrGoinglists.count == 0) {
                [goingTableView addRemindWhenNoData:@"对不起，您暂时没有未完成订单"];
            }else {
                [goingTableView hiddenReminndWhenNoDatainSupView];
                
            }
            
            [goingTableView reloadData];
            
        }
            break;
        case RequestTypeFinish:
        {
            [self tableViewStopShuaxin:finishTableView];
//            if (fiCuffPage == FirstPage) {
//                [arrFinishlists removeAllObjects];
//            }
//            [arrFinishlists addObjectsFromArray:dataObj];
            
            if (fiCuffPage == FirstPage) {
                arrFinishlists = [(NSMutableArray *)dataObj retain];
            }else {
                [arrFinishlists addObjectsFromArray:dataObj];
                NSArray *arr = (NSArray *)dataObj;
                if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                    fiCuffPage -- ;
                }
            }
            
            if (arrFinishlists.count == 0) {
                [finishTableView addRemindWhenNoData:@"对不起，您暂时没有已完成订单"];
            }else {
                [finishTableView hiddenReminndWhenNoDatainSupView];
            }
            
            [finishTableView reloadData];
            
        }
            break;
        case RequestTypeNoService:
        {
            [self tableViewStopShuaxin:noServiceTableView];
//            if (noCuffPage == FirstPage) {
//                [arrNoServicelists removeAllObjects];
//            }
//            [arrNoServicelists addObjectsFromArray:dataObj];
            
            if (noCuffPage == FirstPage) {
                arrNoServicelists = [(NSMutableArray *)dataObj retain];
            }else {
                [arrNoServicelists addObjectsFromArray:dataObj];
                NSArray *arr = (NSArray *)dataObj;
                if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                    noCuffPage -- ;
                }
            }
            
            if (arrNoServicelists.count == 0) {
                [noServiceTableView addRemindWhenNoData:@"对不起，您暂时没有无效订单"];
            }else {
                [noServiceTableView hiddenReminndWhenNoDatainSupView];
            }
            
            [noServiceTableView reloadData];
            
            
        }
            break;
            
            
        case RequestTypeCancelOrder:           //取消订单
        {
            [self.view removeHUDActivityView];        //取消成功  停止转圈
            
            StatusEntity *entiSta = (StatusEntity *)dataObj;
            if (entiSta.response == 1) {
                [self.view.window addHUDLabelView:@"取消成功" Image:nil afterDelay:2];
                goCurrPage = FirstPage;
                [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];
                
                [arrNoServicelists removeAllObjects];
            }else {
                [self.view.window addHUDLabelView:@"操作失败" Image:nil afterDelay:2];
            }
            
        }
            break;
        case RequestTypeConfirmOrder:           //确认订单
        {
            [self.view removeHUDActivityView];        //取消成功  停止转圈
            
            StatusEntity *entiSta = (StatusEntity *)dataObj;
            if (entiSta.response == 1) {
                [self.view.window addHUDLabelView:@"已经确认收货" Image:nil afterDelay:2];
                goCurrPage = FirstPage;
                [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];
                
                [arrNoServicelists removeAllObjects];
            }else {
                [self.view.window addHUDLabelView:@"操作失败" Image:nil afterDelay:2];
            }
            
        }
            break;
//        case RequestTypeGetReminderInfo:           //获取红点提醒
//        {
//            StatusEntity *entiSta = (StatusEntity *)dataObj;
//            if (entiSta.hasneworderremind == 1) {   // 1  有提醒  0  没
//                
//                [self.myRightButton showRedCircleRemind:YES];
//                
//            }else {
//                [self.myRightButton showRedCircleRemind:NO];
//            }
//            
//        }
//            break;
            
        default:
            break;
    }
    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    if (tag == 10000) {
        NSLog(@"失败");
        [self hideAlert];
        [self showAlertMessage:error.domain];
        return;
    }
    NSLog(@"请求失败");
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
    switch (tag) {
        case RequestTypeGoing:
        {
            if (goCurrPage > 1) {
                goCurrPage -- ;   //请求失败时，当前页码退回上一页
            }
            [self performSelector:@selector(tableViewStopShuaxin:) withObject:goingTableView afterDelay:1];

        }
            break;
        case RequestTypeFinish:
        {
            if (fiCuffPage > 1) {
                fiCuffPage -- ;   //请求失败时，当前页码退回上一页
            }
            [self performSelector:@selector(tableViewStopShuaxin:) withObject:finishTableView afterDelay:1];
        }
            break;
        case RequestTypeNoService:
        {
            if (noCuffPage > 1) {
                noCuffPage -- ;   //请求失败时，当前页码退回上一页
            }
            [self performSelector:@selector(tableViewStopShuaxin:) withObject:noServiceTableView afterDelay:1];
            
        }
            break;
        case RequestTypeCancelOrder:
        {
            [self.view removeHUDActivityView];        //取消失败  停止转圈
        }
            break;
            
            
        default:
            break;
    }

}

- (void)myRightButtonAction:(UIButton *)button
{
    [self.myRightButton showRedCircleRemind:NO];
    
    OrderRemindVC *remindVC = [[OrderRemindVC alloc]init];
    [self pushViewController:remindVC];
    [remindVC release];
    
}

#pragma mark SegmentControlDelegate
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    NSLog(@"index = %i",index);
    [sv scrollRectToVisible:CGRectMake(sv.frame.size.width * index, 0, sv.frame.size.width, sv.frame.size.height) animated:YES];
    
    switch (index) {
        case 0:
            
            break;
        case 1:
            
            if (!finishTableView) {
                [self initFinishTableView];
                
            }
            if (arrFinishlists.count == 0) {
                finishTableView.pullTableIsRefreshing = YES;
                [self request:RequestTypeFinish page:fiCuffPage OrderNum:nil];
            }
            break;
        case 2:
            
            if (!noServiceTableView) {
                [self initNoServceTableView];
                
            }
            if (arrNoServicelists.count == 0) {
                noServiceTableView.pullTableIsRefreshing = YES;
                [self request:RequestTypeNoService page:noCuffPage OrderNum:nil];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark PUllTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
//    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:2.0f];
    switch (pullTableView.tag) {
        case 100:
            [self request:RequestTypeGoing page:++goCurrPage OrderNum:nil];
            break;
        case 101:
            [self request:RequestTypeFinish page:++fiCuffPage OrderNum:nil];
            break;
        case 102:
            [self request:RequestTypeNoService page:++noCuffPage OrderNum:nil];
            break;
            
        default:
            break;
    }
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    switch (pullTableView.tag) {
        case 100:       //进行中
        {
            goCurrPage = FirstPage;
//            [arrGoinglists removeAllObjects];
            [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];
        }
            break;
        case 101:       //已完成
        {
            fiCuffPage = FirstPage;
//            [arrFinishlists removeAllObjects];
            [self request:RequestTypeFinish page:fiCuffPage OrderNum:nil];
        }
            break;
        case 102:       //无效订单
        {
            noCuffPage = FirstPage;
//            [arrNoServicelists removeAllObjects];
            [self request:RequestTypeNoService page:noCuffPage OrderNum:nil];
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
        case 100:
            return arrGoinglists.count;
            break;
        case 101:
            return arrFinishlists.count;
            break;
        case 102:
            return arrNoServicelists.count;
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
    OrderManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[OrderManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.delegate = self;
    }
    cell.tag = indexPath.section;
    
    OrderEntity *entiOrder;
    switch (tableView.tag) {
        case 100:
        {
            entiOrder = [arrGoinglists objectAtIndex:indexPath.section];
            [cell setCellType:CellTypeGoing];
//            if (indexPath.section == 2 || indexPath.section == 5) {
//                entiOrder.deliverstatus = 1;
//            }
            
            [cell setContentsByOrderEntity:entiOrder];
//            [cell setcontentsLaborderNum:entiOrder.ordernumber labMoney:entiOrder.amount labOrderTime:entiOrder.orderdate cellType:CellTypeGoing orderstatus:entiOrder.orderstatus deliverstatus:entiOrder.deliverstatus paystatus:entiOrder.paystatus];
        }
            break;
        case 101:
        {
            entiOrder = [arrFinishlists objectAtIndex:indexPath.section];
            [cell setCellType:CellTypeFinish];
            [cell setContentsByOrderEntity:entiOrder];
//            [cell setcontentsLaborderNum:entiOrder.ordernumber labMoney:entiOrder.amount labOrderTime:entiOrder.orderdate cellType:CellTypeFinish orderstatus:entiOrder.orderstatus deliverstatus:entiOrder.deliverstatus paystatus:entiOrder.paystatus];
        }
            break;
        case 102:
        {
            entiOrder = [arrNoServicelists objectAtIndex:indexPath.section];
            [cell setCellType:CellTypeNoService];
            [cell setContentsByOrderEntity:entiOrder];
//            [cell setcontentsLaborderNum:entiOrder.ordernumber labMoney:entiOrder.amount labOrderTime:entiOrder.orderdate cellType:CellTypeNoService orderstatus:entiOrder.orderstatus deliverstatus:entiOrder.deliverstatus paystatus:entiOrder.paystatus];
            
        }
            break;
            
        default:
            break;
    }
     
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 10)]autorelease];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 100:       //进行中
        {
            OrderEntity *entiOrder = [arrGoinglists objectAtIndex:indexPath.section];
            OrderDetailVC *odVC = [[OrderDetailVC alloc]init];
            odVC.payDelegate = self;
            odVC.paystatus = entiOrder.paystatus;
            odVC.orderNum = entiOrder.ordernumber;
            [odVC setOdType:OrderTypeGoing];
            [self pushViewController:odVC];
            [odVC release];
        }
            break;
        case 101:       //已完成
        {
            OrderEntity *entiOrder = [arrFinishlists objectAtIndex:indexPath.section];
            OrderDetailVC *odVC = [[OrderDetailVC alloc]init];
            odVC.orderNum = entiOrder.ordernumber;
            odVC.paystatus = entiOrder.paystatus;
            [odVC setOdType:OrderTypeFinished];
            [self pushViewController:odVC];
            [odVC release];
        }
            break;
        case 102:       //无效订单
        {
            OrderEntity *entiOrder = [arrNoServicelists objectAtIndex:indexPath.section];
            OrderDetailVC *odVC = [[OrderDetailVC alloc]init];
            odVC.orderNum = entiOrder.ordernumber;
            odVC.paystatus = 1;
            [odVC setOdType:orderTypeNoService];
            [self pushViewController:odVC];
            [odVC release];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark PaySuccessedDelegate
- (void)payDidSuccess
{
    [arrFinishlists removeAllObjects];      //清空已完成订单 用以刷新
    goCurrPage = FirstPage;
    [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];   //获取列表信息
}

#pragma mark OrderManagerCellDelegate
- (void)orderManagerCell:(OrderManagerCell *)cell clickedAtButtonIndex:(NSInteger)i cellType:(NSInteger)type
{
//    NSLog(@"cellType = %i cell.tag = %i  i = %i",currCellType,cell.tag,i);
    
    switch (type) {
        case CellTypeGoing:     //进行中
            if (i == 0) {               //取消订单
                
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"您确定要取消订单吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
                [sheet setTag:cell.tag];
                RootVC *rootVC= [RootVC shareInstance];
                [sheet showInView:rootVC.view];
                [sheet release];
                
            }else if(i == 1){                     //在线支付

                OrderEntity *entiOrder = [arrGoinglists objectAtIndex:cell.tag];
                [self payAction:entiOrder];
                
            }else {
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认收货", nil];
                [sheet setTag:2000 + cell.tag];
                RootVC *rootVC= [RootVC shareInstance];
                [sheet showInView:rootVC.view];
                [sheet release];
            }
            break;
        case CellTypeFinish:     //已完成
            if (i == 0) {               //评价
                NSLog(@"评价");
                MyReviewVC *reviewVC = [[MyReviewVC alloc]init];
                [self pushViewController:reviewVC];
                [reviewVC release];
            }else {                     //晒单
                NSLog(@"晒单");
                MyClothListVC* myClothList = [[MyClothListVC alloc] init];
                [self pushViewController:myClothList];
                [myClothList release];
                
            }
            break;
            
        default:
            break;
    }
    
}

-(void)payAction:(OrderEntity *)entiOrder
{
    /*paycode	string	付款方式标识，例如：
     unionpay 银联在线支付
     alipay 支付宝
     bank 银行汇款/转帐
     tenpay 财付通
     onlinepay 在线支付
     */
    //默认支付宝
    if (entiOrder !=nil && [entiOrder.paycode compare:@"unionpay" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        //银联在线支付
        [self upPay:entiOrder];
        return;
    }
    
    [self alixPay:entiOrder];
}
////////
//-------6226440123456785 111101
- (void)upPay:(OrderEntity *)entiOrder
{
    [self showAlertWait];
    
    //
    DSRequest *dsrequest=[[DSRequest alloc]init];
    dsrequest.delegate = self;
    [dsrequest requestDataWithInterface:GetUPPayTN param:[self GetUPPayTNParam:entiOrder.ordernumber] tag:10000];
    [dsrequest release];
}
//------
- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
    [aiv release];
    [mAlert release];
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
    [mAlert release];
}
- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

//-----------
- (void)UPPayPluginResult:(NSString *)result
{
    //银联手机支付控件有三个支付状态返回值:success、fail、cancel,分别代表:支付成功、支付失败、用户取消支付。这三个返回状态值以字符串的形式作为回调函
    NSString* msg = [NSString stringWithFormat:kResult, result];
    if ([result isEqualToString:@"success"])
    {
        msg = [NSString stringWithFormat:kResult,@"支付成功"];
        
        //支付回调
        [arrFinishlists removeAllObjects];      //清空已完成订单 用以刷新
        goCurrPage = FirstPage;
        [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];
        
    }else if ([result isEqualToString:@"fail"])
    {
        msg = [NSString stringWithFormat:kResult,@"支付失败"];
    }else if ([result isEqualToString:@"cancel"])
    {
        msg = [NSString stringWithFormat:kResult,@"用户取消支付"];
    }
    [self showAlertMessage:msg];
    
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.frame = CGRectMake(0, 0, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
    }
}
//////////

-(void)alixPay:(OrderEntity *)one
{
    //将商品信息拼接成字符串
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    
    AlixPayOrder *order = [[[AlixPayOrder alloc] init] autorelease];
    
    // partner seller   关键字段
    order.partner = partner;
    order.seller = seller;
    
    // --------
    order.tradeNO = one.ordernumber;//订单id
    order.productName = one.ordernumber;//@"测试支付"; //商品标题
	order.productDescription = @"海澜之家";// @"123657"; //商品描述
    order.amount = one.amount;// @"0.01";//支付金额
//    order.amount = @"0.01";//支付金额
    // --------
    
    // order.notifyURL =  @"http://www.xxx.com"; //回调URL
//    order.notifyURL = @"http://113.106.90.141:2046/Api/PayCallBack";
    order.notifyURL=[NSString stringWithFormat:@"%@PayCallBack",ZHIFUBAO_ADDRESS];
    NSString *appScheme = @"HaiLanZhiJia";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    // 客户的私钥    关键字段
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle]
                                                 objectForInfoDictionaryKey:@"RSA private key"]);
    //    NSString *privateKey =  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOWJZHgOI+KbXugA1h4T0XV0DnVhhbGY8/aeqD1IXDqkBewYVop2ycyINsC11apu12nX2ESb65gWJwS4n+IeB1c+aW3kzvsMPqP+snEbKuVIWnPq40EFf3/Ii8nJHNqM8iRaoNv+t4biZ88ojtGYMDYhSFgn6NVT5zjb232pw3YlAgMBAAECgYEAyfAS9NAz3/QjDedWeMWkvDlrUveGQFW5JFo21xtnEKwnDavnzw9swEWCLg6LONMlLtgXS10FaxrqHuwytSMH/p1fMijOBrDKuwo2yd0rnJNMMQaXge/z7Sic3ql/Jw/RtRCvyu/H31BIN7dljXFwp1i1NGy1Dp8FA9i2CSUU600CQQD868ipCH83N1v3VyGFd0Ay3q0g1gTzOujdhdeVHdz7B2N6BZgJGlUaqkgq1NmJKpASS4dm9lWX6RKbEO3kPF8zAkEA6FS7glzIG8vqCHnxQ9RcO2KC3cfqCze9UVJl6wdyQlNf9m82hFBNHe/ndRZOE2iNPvW5XkvLubiYvJAIk3K1RwJBAPtD8zGas2fTo5XyBedmNW1UM4Mvm/NYTwfkc+w8otDw4i7TZ9uDQZEgIloK46KVmlPSnU3448frUQSkqPHZ2GkCQAO50CQADul7NK6cHgVjc3M0WjrqSNOTOkMCmkXRocB0i9Zs5CftDb+MKF8VU302MQWwdR+RAZxh3HkxqiGLNmMCQDdnxkMAfvLuxahvNimUFV4VoKtCcayIC+IJrefCUW3BVptCZxulk88aocw7LW56xHwcm0ChdKMlkGmTYamQAoU=";
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    //    NSString *payPublicStr = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQChhJyjxYniah/98EZPwOhcV6u9LdngWGYFN7tK CMCKTgqu0EP0Ir7wuz3AxJWrOixGaV4i6qD3bnKCy7ifGQtDqUSf+Uxy6uQA7dcrmroonE6lRmJY ndwD2WhlXefkbbTXAPcMHYdWbGQbihg6KpsXBVS6wbTzL+WinxWyxz1bIwIDAQAB";
    
    
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",orderString);
        
        if (ret == kSPErrorAlipayClientNotInstalled)
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"您还没有安装支付宝快捷支付，请先安装。" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if(buttonIndex == 1)
                {
                    //进入下载支付宝
                    NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
                }
                
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
            
        }
        else if (ret == kSPErrorSignError)
        {
            NSLog(@"签名错误！");
        }
        
        
    }
    
    // OrderDetailEntity
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %i",buttonIndex); //支付为0  取消为1
    
    if (actionSheet.tag >= 2000) {      //  确认收货
        if (buttonIndex == 0) {
            OrderEntity *entiOrder = [arrGoinglists objectAtIndex:actionSheet.tag - 2000];
            [self request:RequestTypeConfirmOrder page:0 OrderNum:entiOrder.ordernumber];
            
        }
        return;
    }
    
    if (actionSheet.tag >= 1000 && actionSheet.tag < 2000) {        //  在线支付
//        if (buttonIndex == 0) {
//            OrderEntity *entiOrder = [arrGoinglists objectAtIndex:actionSheet.tag - 1000];
//            [self pay:entiOrder];
////            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://113.106.90.141:2046/Api/Order"]];
////            [urlRequest setTimeoutInterval:10];
////            [urlRequest setHTTPMethod:@"POST"];
////            
////            NSString *parm = [NSString stringWithFormat:@"\"sn\":\"%@\"",entiOrder.ordernumber];
////            [urlRequest setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];
////            
////            NSData *received = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
////            NSString *strJson = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
////            NSLog(@"strJson = %@",strJson);
////            [strJson release];
////            [urlRequest release];
//            
//            
//            
//        }
        
        
        
    }else {                             //  取消订单
        if (buttonIndex == 0) {
            OrderEntity *entiOrder = [arrGoinglists objectAtIndex:actionSheet.tag];
            [self request:RequestTypeCancelOrder page:0 OrderNum:entiOrder.ordernumber];
        }
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
