//
//  MiaoShaVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MiaoShaVC.h"
#import "HuoDongRuleView.h"

@interface MiaoShaVC ()

@end

@implementation MiaoShaVC
@synthesize aRequest;
@synthesize buyListEntity;

@synthesize myTableView;
@synthesize myEntitiesArr;
@synthesize isMiaoSha;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.buyListEntity = nil;
//    [self.myTableView removeFromSuperview];
    self.myTableView = nil;
    self.myEntitiesArr = nil;
    
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    [super dealloc];
}

-(void)leftAction
{
    [super leftAction];
    for (int i = 0; i<=[self.myTableView numberOfRowsInSection:0]-1; i++) {
        MiaoShaCell *cell = (MiaoShaCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell resetTimer];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentPage = 1;

    
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    if (self.isMiaoSha) {
        [self setTitleString:@"秒杀"];
    }else
    {
        [self setTitleString:@"团购"];
    }
    
    
    
    [self addTableView];
    
    [self requestToServerByPage:1];
    
    [self createMyButtonWithTitleAndImage];
    self.myRightButton.hidden = NO;
    [self setMyRightButtonTitle:@"规则"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
	// Do any additional setup after loading the view.
    [self.leftButton setImage:GetImage(@"home.png") forState:UIControlStateNormal];

}

-(void)myRightButtonAction:(UIButton *)button
{
    HuoDongRuleView *ruleView = [[HuoDongRuleView alloc]init];
    ruleView.rule = self.buyListEntity.rule;
    [ruleView setContentsText:self.buyListEntity.rule];
    NSLog(@"%@",self.buyListEntity.rule);
    [self.view addSubview:ruleView];
    SAFETY_RELEASE(ruleView);
    

}

-(void)requestToServerByPage:(int)page
{
    [self.view addTitleBarClickableActivityView:Loading];  //提示 加载中
    
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:GetSpecialBuyList param:[self GetSpecialBuyListParam:_specialId page:page] tag:0];
}

-(void)addTableView
{
    PullTableView  *tableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, self.view.frame.size.width, MainViewHeight- [self getTitleBarHeight] - 20)];  
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView setShowsVerticalScrollIndicator:NO];
    
    tableView.pullDelegate = self;
    tableView.tableFooterView = [[[UIView alloc]init]autorelease];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.scrollEnabled = YES;
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.myTableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    if (!self.myEntitiesArr) {
        NSMutableArray *myarr = [[NSMutableArray alloc]init];
        self.myEntitiesArr = myarr;
        [myarr release];
    }
}

#pragma mark PUllTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:2.0f];
    
    _currentPage++;
    [self requestToServerByPage:_currentPage];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable:) withObject:pullTableView
               afterDelay:2.0f];
    
    _currentPage=1;
    [self requestToServerByPage:_currentPage];

}

#pragma mark - 上拉下拉刷新代理方法
- (void)refreshTable:(PullTableView *)pullTableView
{
    NSLog(@"下拉刷新");
    pullTableView.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable:(PullTableView *)pullTableView
{
    NSLog(@"上拉加载");
    pullTableView.pullTableIsLoadingMore = NO;
//    [self request:0 subtype:pullTableView.tag page:++unCurrPage cardNum:nil psd:nil];
}


#pragma mark - Table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.buyListEntity.goodslist count];
//    return [self.myEntitiesArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MiaoShaCell *cell = (MiaoShaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        
        cell = [[[MiaoShaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isMiaoSha = self.isMiaoSha;
    }
    cell.cellIndex = indexPath.row;
    cell.delegate = self;
    SpecialBuyEntity *aEntity = [self.buyListEntity.goodslist objectAtIndex:indexPath.row];
    [cell resetViewByEntity:&aEntity];
     //NSLog(@"*****%@ timeleft%li--timelast%li",aEntity.goodsid,aEntity.timeleft,aEntity.timelast);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialBuyEntity *aEntity = [self.buyListEntity.goodslist objectAtIndex:indexPath.row];
    MIaoShaTuanGouDetailVC *detail = [[MIaoShaTuanGouDetailVC alloc]init];
    detail.isMiaoSha = self.isMiaoSha;
    detail.spId = aEntity.goodsid;
    [self pushViewController:detail];
    [detail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFailView
{
    if (_failView==nil)
    {
        CGRect myRect  = self.view.bounds;
        _failView = [[UIView alloc]initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height-TITLEHEIGHT)];
        [self.view addSubview:_failView];
    }
    for (UIView *subView in _failView.subviews)
    {
        [subView removeFromSuperview];
    }
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,140,MainViewWidth, 20)] autorelease];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = RGBCOLOR(62, 62, 62);
    lbl.font = [UIFont systemFontOfSize:15.0f];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"咦，数据加载失败了";
    [_failView addSubview:lbl];
    
    UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(0,170,MainViewWidth, 20)] autorelease];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.textColor = RGBCOLOR(82, 82, 82);
    lbl2.font = [UIFont systemFontOfSize:14.0f];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.text = @"请检查下您的网络，重新加载吧";
    [_failView addSubview:lbl2];
    
    UIImage *bgI = [UIImage imageNamed:@"default_button@2x.png"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(MainViewWidth/2-bgI.size.width/4,210,bgI.size.width/2, bgI.size.height/2-5);
    [btn setBackgroundImage:[UIImage imageNamed:@"default_button@2x.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"default_button_press@2x.png"] forState:UIControlStateHighlighted];
    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(62, 62, 62) forState:UIControlStateNormal];
    //btn.backgroundColor = RGBCOLOR(237, 237, 237);
    [btn addTarget:self
            action:@selector(requestToServer)
  forControlEvents:UIControlEventTouchUpInside];
    //btn.layer.borderWidth=1;
    //btn.layer.borderColor=RGBCOLOR(162, 162, 162).CGColor;
    //btn.layer.cornerRadius=5;
    [_failView addSubview:btn];
}

-(void)requestToServer{
    _currentPage = 1;
    [self requestToServerByPage:_currentPage];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    
    self.myTableView.hidden = YES;
    [self initFailView];
    self.failView.hidden = NO;
    
    [self.view removeHUDActivityView];        //加载失败  停止转圈
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    if(tag == 0)
    {
        if (_currentPage ==1) {
            self.buyListEntity = dataObj;
            [self.myTableView reloadData];
        }else
        {
            SpecialBuyListEntity *entity = dataObj;
            NSMutableArray *myArr = [NSMutableArray arrayWithArray:self.buyListEntity.goodslist];
            [myArr addObjectsFromArray:entity.goodslist];
            if (dataObj && ![dataObj isKindOfClass:[NSNull class]]) {
                self.buyListEntity = dataObj;
            }
            
            self.buyListEntity.goodslist =myArr;
            [self.myTableView reloadData];
        }
        
        NSString *aString = [self.buyListEntity.rule stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *bString = [aString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (isStringEmputy(bString)) {
            self.myRightButton.hidden = YES;
        }else
        {
            self.myRightButton.hidden = NO;
        }
        
    }
    self.myTableView.hidden = NO;
    self.failView.hidden = YES;
    
    [self.view removeHUDActivityView];        //加载成功  停止转圈
}

#pragma mark ### cell delegate ###
-(void)SelectedIndex:(int)index
{
    SpecialBuyEntity *aEntity = [self.buyListEntity.goodslist objectAtIndex:index
                                 ];
    MIaoShaTuanGouDetailVC *detail = [[MIaoShaTuanGouDetailVC alloc]init];
    detail.specialEntity = aEntity;
    detail.isMiaoSha = self.isMiaoSha;
    detail.spId = aEntity.goodsid;
    [self pushViewController:detail];
    [detail release];
}

@end
