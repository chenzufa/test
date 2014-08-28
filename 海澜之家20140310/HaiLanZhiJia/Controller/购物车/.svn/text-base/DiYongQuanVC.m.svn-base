//
//  DiYongQuanVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "DiYongQuanVC.h"
#import "CashConponCell.h"
#import "ShowContentsView.h"
#import "UITableView+RemindNoData.h"
@interface DiYongQuanVC ()
{
    int currrentIndex;
}

@property (nonatomic,retain)NSIndexPath *lastIndexPath;

@end

@implementation DiYongQuanVC
{
    PullTableView *unUsedTableView;   // 可使用列表
    NSMutableArray *arrUnUsed;
    UIScrollView *sv;
    BangdingView *bdViewNoPsd;           //无密码绑定界面
    BangdingView *bdViewHasPsd;           //无密码绑定界面
    
    int unCurrPage;
    NSString *rule;             //现金券使用规则
}

@synthesize delegate;

- (void)dealloc
{
    [sv release];
    
    [unUsedTableView release];
    [arrUnUsed release];
    
    if (bdViewHasPsd) {
        [bdViewHasPsd release];
    }
    if (bdViewNoPsd) {
        [bdViewNoPsd release];
    }
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    rule = nil;
    
    self.delegate = nil;
    self.lastIndexPath = nil;
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
    
    [self setTitleString:@"抵用券"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"规则"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    currrentIndex = -1;
    
    [self initUI];
    unCurrPage = 1;
    [self request:0 subtype:1 page:unCurrPage cardNum:nil psd:nil];
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
    segment.segments = [NSArray arrayWithObjects:@"可使用",@"无密码绑定",@"有密码绑定", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT + segment.frame.size.height, MainViewWidth, MainViewHeight - TITLEHEIGHT - segment.frame.size.height - 20)];
    [sv setContentSize:CGSizeMake(MainViewWidth * 3, sv.frame.size.height)];
    [sv setPagingEnabled:YES];
    [sv setScrollEnabled:NO];
    [self.view addSubview:sv];
    
    arrUnUsed = [[NSMutableArray alloc]init];
    unUsedTableView = [[PullTableView alloc]initWithFrame:CGRectMake( 10, 0, 300, sv.frame.size.height)];
    [unUsedTableView setShowsVerticalScrollIndicator:NO];
    unUsedTableView.delegate = self;
    unUsedTableView.dataSource = self;
    unUsedTableView.pullDelegate = self;
    [unUsedTableView setBackgroundColor:[UIColor clearColor]];
    [unUsedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    unUsedTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [sv addSubview:unUsedTableView];
//    unUsedTableView.tag = 1;
    
    [segment release];
}

#pragma mark PUllTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:2.0f];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable:) withObject:pullTableView
               afterDelay:2.0f];
}

#pragma mark - 上拉下拉刷新代理方法
- (void)refreshTable:(PullTableView *)pullTableView
{
    NSLog(@"下拉刷新");
    pullTableView.pullTableIsRefreshing = NO;
    unCurrPage = 1;
    [self request:0 subtype:1 page:unCurrPage cardNum:nil psd:nil];
}

- (void)loadMoreDataToTable:(PullTableView *)pullTableView
{
    NSLog(@"上拉加载");
    pullTableView.pullTableIsLoadingMore = NO;
    [self request:0 subtype:pullTableView.tag page:++unCurrPage cardNum:nil psd:nil];
}

- (void)request:(int)type subtype:(int)subtype page:(int)page cardNum:(NSString *)cardNum psd:(NSString *)psd     // type: 0 获取列表 1 绑定  subtype 用于判断是否有密码的绑定 0 没密码 1 有密码
{
    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    DSRequest *request = [[DSRequest alloc]init];
    self.requestOjb = request;
    request.delegate = self;
    if (type == 0) {
        [request requestDataWithInterface:GetUseableShoppingTicket param:[self GetUseableShoppingTicketParam:2 page:page buytype:self.orderType] tag:2];
    }else {
        [request requestDataWithInterface:BindShoppingTicket param:[self BindShoppingTicketParam:cardNum password:psd type:2 haspassword:subtype isscan:0]tag:100];  //此处subtype 用于判断是否有密码的绑定
    }
    
    [request release];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    
    if (tag == 100) {       // 绑定接口
        
        StatusEntity *entiSta = (StatusEntity *)dataObj;
        
        if (entiSta.response == 1) {
            [self.view.window addHUDLabelView:@"绑定成功" Image:nil afterDelay:2];
            
        }else {
            [self.view.window addHUDLabelView:entiSta.failmsg Image:nil afterDelay:2];
        }
        
    }else {
        ShoppingTicketInfoEntity *entiTicketInfo = (ShoppingTicketInfoEntity *)dataObj;
        if (!rule) {
            rule = [entiTicketInfo.rule retain];
        }
        
//        [arrUnUsed addObjectsFromArray:entiTicketInfo.ticketlist];
        
        if (unCurrPage == 1) {
            arrUnUsed = [(NSMutableArray *)entiTicketInfo.ticketlist retain];
        }else {
            [arrUnUsed addObjectsFromArray:entiTicketInfo.ticketlist];
            NSArray *arr = (NSArray *)entiTicketInfo.ticketlist;
            if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                unCurrPage -- ;
            }
        }
        
        if (arrUnUsed.count == 0) {
            [unUsedTableView addRemindWhenNoData:@"对不起，您没有未使用的抵用券"];
        }else {
            [unUsedTableView hiddenReminndWhenNoDatainSupView];
            
        }
        
        for (int i =0; i< [arrUnUsed count];i++){
            ShoppingTicketEntity *aEntity = [arrUnUsed objectAtIndex:i];
            for (ShoppingTicketEntity *entity in self.selectedArray) {
                if ([entity.cardnum isEqualToString:aEntity.cardnum]) {
                    currrentIndex = i;
                }
            }
        }

        [unUsedTableView reloadData];

        
    }
    
    
    [self.view removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
    if (tag == 1) {
//        [self performSelector:@selector(tableViewStopShuaxin:) withObject:unUsedTableView afterDelay:1];
        if (unCurrPage > 1) {
            unCurrPage -- ;   //请求失败时，当前页码退回上一页
        }
    }
}

#pragma mark BangdingViewDelegate
- (void)bangdingView:(BangdingView *)bdView clickedAnIndex:(int)index cardNum:(NSString *)strNum passWord:(NSString *)strPsd
{
    NSLog(@"index = %i",index);
    if (bdView.tag == 1) {          // 无密码绑定 subtype = 0；
        switch (index) {
            case 0:
            {
                NSLog(@"strNum = %@  strPsd = %@",strNum,strPsd);
                if (strNum.length > 0) {
                    [self request:1 subtype:0 page:0 cardNum:strNum psd:strPsd];
                }else {
                    WCAlertView *alert = [[WCAlertView alloc]initWithTitle:nil message:@"信息填写不完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert setStyle:WCAlertViewStyleWhite];
                    [alert show];
                    [alert release];
                }
                
            }
                break;
            case 1:
            {
                ConponScanBangdingVC *scanBandingVC = [[ConponScanBangdingVC alloc]init];
                [self pushViewController:scanBandingVC];
                [scanBandingVC release];
            }
                break;
                
            default:
                break;
        }
    }else {                 //////有密码绑定 subtype = 1；
        switch (index) {
            case 0:
            {
                NSLog(@"strNum = %@  strPsd = %@",strNum,strPsd);
                if (strNum.length > 0 && strPsd.length > 0) {
                    [self request:1 subtype:1 page:0 cardNum:strNum psd:strPsd];
                }else {
                    WCAlertView *alert = [[WCAlertView alloc]initWithTitle:nil message:@"信息填写不完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert setStyle:WCAlertViewStyleWhite];
                    [alert show];
                    [alert release];
                }
                
            }
                break;
            case 1:
            {
                ConponScanBangdingVC *scanBandingVC = [[ConponScanBangdingVC alloc]init];
                [self pushViewController:scanBandingVC];
                [scanBandingVC release];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark MySegMentControlDelegate
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    NSLog(@"index = %i",index);
    [sv scrollRectToVisible:CGRectMake(MainViewWidth * index, 0, sv.frame.size.width, sv.frame.size.height) animated:YES];
    [self.view endEditing:YES];  //收起可能存在的键盘
    switch (index) {
        case 0:
            
            break;
        case 1:         //ifHasPsd = 1 无密码   = 2  有密码
            if (!bdViewNoPsd) {//  bug：  切换时键盘没有隐藏
                bdViewNoPsd = [[BangdingView alloc]initWithFrame:CGRectMake(MainViewWidth * 1, 0, sv.frame.size.width , sv.frame.size.height)];
                bdViewNoPsd.tag = 1;
                bdViewNoPsd.ifHasPsd = 1;
                [bdViewNoPsd initUI];
                bdViewNoPsd.delegate = self;
                [sv addSubview:bdViewNoPsd];
            }
            
            break;
        case 2:
            if (!bdViewHasPsd) {//  bug：  切换时键盘没有隐藏
                bdViewHasPsd = [[BangdingView alloc]initWithFrame:CGRectMake(MainViewWidth * 2, 0, sv.frame.size.width , sv.frame.size.height)];
                bdViewHasPsd.tag = 2;
                bdViewHasPsd.ifHasPsd = 2;
                [bdViewHasPsd initUI];
                bdViewHasPsd.delegate = self;
                [sv addSubview:bdViewHasPsd];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrUnUsed.count;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ShoppingTicketEntity *one = [arrUnUsed objectAtIndex:indexPath.section];
    [cell setlabCardNum:one.cardnum labMoney:one.amount lablimitTime:one.usingdate labState:one.status type:tableView.tag];
    
    if (currrentIndex == indexPath.section) {
        [cell setCellSelected:YES];
    }else{
        [cell setCellSelected:NO];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currrentIndex == indexPath.section) {
        currrentIndex = -1;
    }else{
        currrentIndex = indexPath.section;
    }
    
    [tableView reloadData];
    
//    // 全部可选
//    ShoppingTicketEntity *one = [arrUnUsed objectAtIndex:indexPath.section];
//    one.isSelected = !one.isSelected;
//    [arrUnUsed replaceObjectAtIndex:indexPath.section withObject:one];
//    
//    CashConponCell *cell = (CashConponCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell setCellSelected:one.isSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftAction
{
    NSMutableArray *myArray = [NSMutableArray array];
    
    if (currrentIndex != -1) {
        ShoppingTicketEntity *entity = [arrUnUsed objectAtIndex:currrentIndex];
        [myArray addObject:entity];
    }
    if ([self.delegate performSelector:@selector(sendFormMessage:Object:)]) {
        [self.delegate sendFormMessage:InfoTypeDiyong Object:myArray];
    }
    self.delegate = nil;
    
    [super leftAction];
}


@end
