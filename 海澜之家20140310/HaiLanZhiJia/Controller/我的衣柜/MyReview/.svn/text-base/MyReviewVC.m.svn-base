//
//  MyReviewVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyReviewVC.h"
#import "MyReviewCell.h"
#import "UITableView+RemindNoData.h"
#import "ShangPingDetailVC.h"
#define FirstPage 1
@interface MyReviewVC ()

@end

@implementation MyReviewVC
{
    PullTableView *unReviewTableView;
    PullTableView *beenReviewTableView;
    UIScrollView *sv;
    
    NSMutableArray *arrUnReviews;      //未评论列表数组
    NSMutableArray *arrBeenReviews;    //已评论列表数组
    
    int unCurrPage;
    int beenCurrPage;
}

typedef enum{
    
    RequestTypeUnReview = 1,
    RequestTypeBeenReview
    
}RequestType;

- (void)dealloc
{
    [sv release];
    [unReviewTableView release];
    
    if (beenReviewTableView) {
        [beenReviewTableView release];
    }
    
    [arrUnReviews release];
    
    if (arrBeenReviews) {
        [arrBeenReviews release];
    }
    
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
    
    [self setTitleString:@"我的评论"];
    
    [self initUI];
//    [self request:RequestTypeUnReview page:unCurrPage];
    if (unReviewTableView.pullTableIsRefreshing == NO) {
        unReviewTableView.pullTableIsRefreshing = YES;
    }
    
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
}

- (void)afterDelay
{
    [self request:RequestTypeUnReview page:unCurrPage];
}

- (void)initUI
{
    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], 50, 50)];
    segment.segments = [NSArray arrayWithObjects:@"未评论",@"已评论", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    [segment release];
    
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT + segment.frame.size.height, MainViewWidth, MainViewHeight - segment.frame.origin.y - segment.frame.size.height - 20)];
    [sv setShowsHorizontalScrollIndicator:NO];
    [sv setScrollEnabled:NO];
    [sv setPagingEnabled:YES];
    [sv setContentSize:CGSizeMake(MainViewWidth * 2, sv.frame.size.height)];
    [self.view addSubview:sv];
    
//    arrUnReviews = [[NSMutableArray alloc]init];
    unReviewTableView = [[PullTableView alloc]initWithFrame:sv.bounds];
    unReviewTableView.tag = 1;
    [unReviewTableView setShowsVerticalScrollIndicator:NO];
    unReviewTableView.delegate = self;
    unReviewTableView.dataSource = self;
    unReviewTableView.pullDelegate = self;
    if ([unReviewTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [unReviewTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [unReviewTableView setPullBackgroundColor:[UIColor clearColor]];
    unReviewTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [sv addSubview:unReviewTableView];
    
    
}

- (void)initBeenReviewTableView  // 点击 已评价时再初始化已评价列表
{
//    arrBeenReviews = [[NSMutableArray alloc]init];
    beenReviewTableView = [[PullTableView alloc]initWithFrame:CGRectMake(MainViewWidth, 0, MainViewWidth, sv.frame.size.height)];
    beenReviewTableView.tag = 2;
    [beenReviewTableView setShowsVerticalScrollIndicator:NO];
    beenReviewTableView.delegate = self;
    beenReviewTableView.dataSource = self;
    beenReviewTableView.pullDelegate = self;
    if ([beenReviewTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [beenReviewTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [beenReviewTableView setPullBackgroundColor:[UIColor clearColor]];
    beenReviewTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [sv addSubview:beenReviewTableView];
    
}

#pragma mark PUllTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
//    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:2.0f];
    if (pullTableView.tag == 1) {
        [self request:RequestTypeUnReview page:++unCurrPage];
    }else {
        [self request:RequestTypeBeenReview page:++beenCurrPage];
    }
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    if (pullTableView.tag == 1) {
        
        unCurrPage = FirstPage;
        [self request:RequestTypeUnReview page:unCurrPage];
    }else if(pullTableView.tag == 2){
//        [arrBeenReviews removeAllObjects];
        beenCurrPage = FirstPage;
        [self request:RequestTypeBeenReview page:beenCurrPage];
    }
}

- (void)request:(RequestType )type page:(int)page //type = 1 未评论    = 2 已评论
{
//    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    [self.requestOjb requestDataWithInterface:MyCommentList param:[self MyCommentListParam:type page:page] tag:type];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    if (tag== 1) {
        [self tableViewStopShuaxin:unReviewTableView];
//        if (unCurrPage == FirstPage) {              //如果是第一页  删除数组中的数据以重新获得
//            [arrUnReviews removeAllObjects];
//        }
//        [arrUnReviews addObjectsFromArray:dataObj];

        if (unCurrPage == FirstPage) {
            arrUnReviews = [(NSMutableArray *)dataObj retain];
        }else {
            [arrUnReviews addObjectsFromArray:dataObj];
            NSArray *arr = (NSArray *)dataObj;
            if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                unCurrPage -- ;
            }
        }
        
        if (arrUnReviews.count == 0) {
            [unReviewTableView addRemindWhenNoData:@"您还没有可评论商品"];
        }else {
            [unReviewTableView hiddenReminndWhenNoDatainSupView];
        }
        
        [unReviewTableView reloadData];
        
        
    }else {
        [self tableViewStopShuaxin:beenReviewTableView];
//        if (beenCurrPage == FirstPage) {            //如果是第一页  删除数组中的数据以重新获得
//            [arrBeenReviews removeAllObjects];
//        }
//        [arrBeenReviews addObjectsFromArray:dataObj];
        
        if (beenCurrPage == FirstPage) {
            arrBeenReviews = [(NSMutableArray *)dataObj retain];
        }else {
            [arrBeenReviews addObjectsFromArray:dataObj];
            NSArray *arr = (NSArray *)dataObj;
            if (arr.count == 0) {       //如果取到的数据为空  则当前页码退回上一页
                beenCurrPage -- ;
            }
        }
        
        if (arrBeenReviews.count == 0) {
            [beenReviewTableView addRemindWhenNoData:@"您还没有商品评论，赶快评一评"];
        }else {
            [beenReviewTableView hiddenReminndWhenNoDatainSupView];
            [beenReviewTableView reloadData];
        }
        
        
    }
    
//    [self.view removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
//    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    
    if (tag== RequestTypeUnReview) {
        [unReviewTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
        [self performSelector:@selector(tableViewStopShuaxin:) withObject:unReviewTableView afterDelay:1];
        if (unCurrPage > 1) {
            unCurrPage -- ;   //请求失败时，当前页码退回上一页
        }
    }else {
        [beenReviewTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
        [self performSelector:@selector(tableViewStopShuaxin:) withObject:beenReviewTableView afterDelay:1];
        if (beenCurrPage > 1) {
            beenCurrPage -- ;   //请求失败时，当前页码退回上一页
        }
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

#pragma mark MySegmentControlDelegate
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [sv scrollRectToVisible:unReviewTableView.frame animated:YES];
            break;
        case 1:
            if (!beenReviewTableView) {
                [self initBeenReviewTableView];
                
            }
            if (arrBeenReviews.count == 0) {
                beenReviewTableView.pullTableIsRefreshing = YES;
                [self request:RequestTypeBeenReview page:beenCurrPage];
            }
            
            [sv scrollRectToVisible:beenReviewTableView.frame animated:YES];
            break;
        default:
            break;
    }
}
 
#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return  arrUnReviews.count;
    }else return arrBeenReviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (tableView.tag == 0) {               // tag = 1  未评论列表  = 2 已评论列表
        identifier = @"unReviewCell";
    }else identifier = @"beenReviewCell";
    
    MyReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[MyReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        
        if (tableView.tag == 1) {
            [cell initUnReview];
        }else [cell initBeenReviewed];
        
    }
    
    CommentEntity *one;
    
    if (tableView.tag == 1) {  //tag = 1  为评论列表   = 2  已评论列表
        
        one = [arrUnReviews objectAtIndex:indexPath.row];
        [cell setUnReviewImage:one.goodsimg labTitle:one.goodsname labTime:one.buydate labSize:one.sizeandcolor];
        
    }else {
        one = [arrBeenReviews objectAtIndex:indexPath.row];
        [cell setBeenReviewedImage:one.goodsimg labTitle:one.goodsname labSize:one.sizeandcolor imgViewScore:one.score labReviewText:one.comment];
    }
    
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 105;
    }else {
        CommentEntity *one = [arrBeenReviews objectAtIndex:indexPath.row];

        CGSize labelSize = [one.comment sizeWithFont:SetFontSize(14) constrainedToSize:CGSizeMake(300, 60) lineBreakMode:NSLineBreakByCharWrapping];
        
        return 115 + labelSize.height;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        CommentEntity *one = [arrUnReviews objectAtIndex:indexPath.row];
        
        WriteReviewVC *writeVC = [[WriteReviewVC alloc]init];
        writeVC.backDelegate = self;
        writeVC.entiComment = one;
        [self pushViewController:writeVC];
        [writeVC release];
    }else if (tableView.tag == 2) {
        CommentEntity *one = [arrBeenReviews objectAtIndex:indexPath.row];
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = one.goodsid;
        [self pushViewController:vc];
        [vc release];
    }
}

#pragma mark WriteReviewVCDisMissDelegate
- (void)writeReviewVCDisMissedandReloadData
{
    [arrUnReviews removeAllObjects];
    [arrBeenReviews removeAllObjects];
    [self request:RequestTypeUnReview page:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
