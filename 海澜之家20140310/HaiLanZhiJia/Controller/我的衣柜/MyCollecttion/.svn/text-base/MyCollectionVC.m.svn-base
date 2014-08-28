//
//  MyCollectionVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyCollectionVC.h"
#import "UITableView+RemindNoData.h"
#import "ShangPingDetailVC.h"
#define FirstPage 1
@interface MyCollectionVC ()

@end

@implementation MyCollectionVC
{
    BOOL editedHidden;
    PullTableView *mcTableView;
    NSMutableArray *arrMyCollects;
    
    int currPage;
    int deleOne;
}

typedef enum {
    
    RequestTypeGetCollectList,
    RequestTypeDelete
    
}RequestType;

- (void)dealloc
{
    [mcTableView release];
    
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    [arrMyCollects release];
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
    
    currPage = FirstPage;
    
    [self setTitleString:@"我的收藏"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"编辑"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    [self.myRightButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.myRightButton setHidden:YES];     // 编辑按钮隐藏，有收藏才显示出来
    
//    arrMyCollects = [[NSMutableArray alloc]init];
    mcTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], MainViewWidth, MainViewHeight - [self getTitleBarHeight] - 20)];
    [mcTableView setShowsVerticalScrollIndicator:NO];
    mcTableView.delegate = self;
    mcTableView.dataSource = self;
    mcTableView.pullDelegate = self;
//    [mcTableView setPullBackgroundColor:[UIColor clearColor]];
    mcTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    if ([mcTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mcTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:mcTableView];
    
    editedHidden = YES;
    
//    [self request:RequestTypeGetCollectList page:currPage];
    if (mcTableView.pullTableIsRefreshing == NO) {
        mcTableView.pullTableIsRefreshing = YES;
    }
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
}

- (void)afterDelay
{
    [self request:RequestTypeGetCollectList page:currPage];
}

- (void)myRightButtonAction:(UIButton *)button
{
    [self.myRightButton setSelected:!self.myRightButton.selected];
    
    editedHidden = !self.myRightButton.selected;
    [mcTableView reloadData];
}

- (void)request:(RequestType)type page:(int)page   //type 0 获取收藏列表   1 删除收藏
{
//    [mcTableView addHUDActivityView:Loading];  //提示 加载中
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    if (type == RequestTypeGetCollectList) {
        [self.requestOjb requestDataWithInterface:GetMySaveList param:[self GetMySaveListParam:page] tag:type];
    }else {
        NSLog(@"++++++++++++++  page = %i  arrMyCollecdt.count = %i",page,arrMyCollects.count);
        if (page < arrMyCollects.count) {
//            [mcTableView addHUDActivityView:@"正在删除"];  //提示
            [self.view.window addHUDActivityView:@"正在删除"];
            GoodEntity *oneEnti = [arrMyCollects objectAtIndex:page];
            deleOne = page;     // 获取到删除的收藏下标
            [self.requestOjb requestDataWithInterface:DeleteSaving param:[self DeleteSavingParam:[NSArray arrayWithObject:oneEnti.goodsid]] tag:type];
        }
        
    }
    
    
}


#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");    
    if (tag == RequestTypeGetCollectList) {
        [self tableViewStopShuaxin:mcTableView];
//        if (currPage == FirstPage) {
//            [arrMyCollects removeAllObjects];
//        }
//        [arrMyCollects addObjectsFromArray:dataObj];

        if (currPage == FirstPage) {
            arrMyCollects = [(NSMutableArray *)dataObj retain];
        }else {
            [arrMyCollects addObjectsFromArray:dataObj];
            NSArray *arr = (NSArray *)dataObj;
            if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                currPage -- ;
            }
        }
        
        if (arrMyCollects.count == 0) {
            [mcTableView addRemindWhenNoData:@"您没有收藏商品"];
            [self.myRightButton setHidden:YES];
        }else {
            [mcTableView hiddenReminndWhenNoDatainSupView];
            [self.myRightButton setHidden:NO];
            
        }
        [mcTableView reloadData];
        

        
    }else {
        
        [self.view.window removeHUDActivityView];        //删除成功  停止转圈
        
        StatusEntity *entiStatus = (StatusEntity *)dataObj;
        NSLog(@"enti = %i   1 成功 2失败",entiStatus.response);
        if (entiStatus.response == 1) {
//            currPage = FirstPage;
            [arrMyCollects removeObjectAtIndex:deleOne];
            
            if (arrMyCollects.count == 0) {
                [mcTableView addRemindWhenNoData:@"您没有收藏商品"];
                [self.myRightButton setHidden:YES];
            }else {
                [mcTableView hiddenReminndWhenNoDatainSupView];
                [self.myRightButton setHidden:NO];
                
            }
            [mcTableView reloadData];
//            [arrMyCollects removeAllObjects];
//            [self request:RequestTypeGetCollectList page:currPage];
        }

    }
    
//    [mcTableView removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    if (tag == RequestTypeDelete){
        [mcTableView removeHUDActivityView];        //删除失败  停止转圈并弹出提示框
    }else if (tag == RequestTypeGetCollectList){
        if (currPage > 1) {
            currPage -- ;   //请求失败时，当前页码退回上一页
        }
    }
    [mcTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
    [self performSelector:@selector(tableViewStopShuaxin:) withObject:mcTableView afterDelay:1];
}

#pragma mark PUllTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
//    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:2.0f];
//    mcTableView.pullTableIsLoadingMore = NO;
    currPage ++;
    [self request:RequestTypeGetCollectList page:currPage];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    currPage = FirstPage;
    
    [self request:RequestTypeGetCollectList page:currPage];
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

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMyCollects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    MycollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[MycollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.delegate = self;
    }
    [cell setBtnDeleteTag:indexPath.row];  //根据row设置删除按钮的tag值
    [cell setBtnDeleteHidden:editedHidden];//设置删除按钮的显隐
    
    GoodEntity *oneEnti = [arrMyCollects objectAtIndex:indexPath.row];
    
    [cell setImgViewHead:oneEnti.goodsimg labTitle:oneEnti.goodsname labMoney:oneEnti.price];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodEntity *oneEnti = [arrMyCollects objectAtIndex:indexPath.row];
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = oneEnti.goodsid;
    [self pushViewController:vc];
    [vc release];
}

#pragma mark MyCollectionCellDelegate
- (void)myCollectionCell:(MycollectionCell *)cell clickedDeleteButton:(UIButton *)btn
{
    NSLog(@"row = %i",btn.tag);
    [self request:RequestTypeDelete page:btn.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
