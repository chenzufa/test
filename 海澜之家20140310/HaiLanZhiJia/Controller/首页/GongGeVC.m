//  GongGeVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GongGeVC.h"
#import "PullTableView.h"
#import "SPGongGeCell.h"
#import "UIImageView+WebCache.h"
#import "PullImageCell.h"
#import "PullPsCollectionView.h"
#import "SingleCell.h"
@interface GongGeVC ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate,SPGongGeCellDelegate,DSRequestDelegate,PKCollectionViewDataSource,PullPsCollectionViewDelegate,UIScrollViewDelegate,pubuCelldelegate,PKCollectionViewDelegate>{
    UIImageView *headView;
    int currentPage;
    UILabel *noteLabel;
    int flag;
    int type;//请求类型
    int currentType;//当前类型

}

@property(nonatomic,retain)PullTableView *tableView;
@property(nonatomic,retain)NSMutableArray *goodListAry;
@property(nonatomic,retain)NSString *huoDongImg;
@property(nonatomic,retain)NSString *huoRule;
@property(nonatomic,retain)DSRequest *aRequest;
@property(nonatomic,retain)UIView *failView;
@property (nonatomic , retain) PullPsCollectionView *collectionView;  //瀑布流列表 UI



@end

@implementation GongGeVC

- (void)dealloc
{
    
//    [_goodListAry release];
    self.goodListAry = nil;
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    self.huoRule = nil;
    self.huoDongImg = nil;
    self.strTitle = nil;
    self.tableView = nil;
    self.collectionView = nil;
    [headView release];
    headView = nil;
    if(_failView)
    {
        [_failView release];
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //kCurrUserId
    }
    return self;
}
//九宫格
- (void)viewDidLoad
{
    [super viewDidLoad];
    flag = 1         ;
    _goodListAry =[[NSMutableArray alloc]initWithCapacity:0];
//    [self setTitleString:self.strTitle];
    currentPage = 1;
    [self createMyButtonWithTitleAndImage];
    self.myRightButton.hidden = YES;
   
    
    [self initView];
  //  [self addHud:Loading];
    
}


-(void)initData:(int)page andTag:(int)tag
{
    if (self.aRequest == nil) {
        DSRequest *requestObj = [[DSRequest alloc]init];
        self.aRequest = requestObj;
        requestObj.delegate = self;//self.zhuanTiId
        
        [requestObj release];
    }
    
    [self.aRequest requestDataWithInterface:GetSpecialActivityList param:[self GetSpecialActivityListParam:self.zhuanTiId page:page] tag:tag];
}

-(void)delayHidHud
{
    [self hideHud:nil];
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    [self performSelector:@selector(delayHidHud) withObject:nil afterDelay:0.1];
    NSLog(@"失败");
    if(tag == 0&&self.goodListAry.count == 0)
    {
        [self initFailView];
        
    }
    
    if(tag ==1)
    {
        currentPage--;
    }
    [self addFadeLabel:error.domain];
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    if(_failView)
    {
        [_failView removeFromSuperview];
    }

    SpecialListEntity *entity = ( SpecialListEntity*)dataObj;
    self.huoDongImg = entity.portalimg;
    type = entity.specialtype;
    NSString *aString = [entity.rule stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bString = [aString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(bString.length>0)
    {
        self.myRightButton.hidden = NO;
        [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
        [self setMyRightButtonTitle:@"规则"];
         self.huoRule = entity.rule;
    }
    [self setTitleString:entity.title];
    //  春装 夏装更换淡色系标题栏背景
//    if ([entity.title isEqualToString:@"春装热卖"]||[entity.title isEqualToString:@"夏装热卖"]) {
//        [self setTitleBarImageStr:@"guide_experience_button_confirm.png"];
//    }
    if(tag == 0)
    {
        if(entity.goodslist.count == 0&&flag == 1)//保证是第一次进入页面
        {
            if(noteLabel ==nil)
            {
                noteLabel = [[UILabel alloc]init];
                noteLabel.font = [UIFont systemFontOfSize:12];
                noteLabel.frame = CGRectMake(0, 0, 320, 20);
                noteLabel.center = CGPointMake(320/2, 180);
                noteLabel.backgroundColor = [UIColor clearColor];
                noteLabel.textAlignment = NSTextAlignmentCenter;
                noteLabel.text = @"暂无商品，请稍后再来";
                [self.tableView addSubview:noteLabel];
                [noteLabel release];
                
            }
            
            return;
        }
        [self.goodListAry removeAllObjects];
        [self.goodListAry  addObjectsFromArray:entity.goodslist];
   
    }
    if(tag == 1)
    {
        if(type!=currentType)//当上啦加载是后台改变了专题类型则直接返回(下拉刷新时再改变类型)
        {
            return;
        }

        if(entity.goodslist.count == 0)
        {
            currentPage--;
            [self addFadeLabel:@"已没有更多商品了"];
        }
        [self.goodListAry  addObjectsFromArray:entity.goodslist];
        
    }
    currentType = type;
    NSLog(@"page:%d,count:%d",currentPage,self.goodListAry.count);
    if(![self.huoDongImg isKindOfClass:[NSNull class]])
    {
        [headView setImageWithURL:[NSURL URLWithString:self.huoDongImg] placeholderImage:GETIMG(@"home_photo.png")];
//        headView.clipsToBounds = YES;
//        headView.contentMode = UIViewContentModeScaleToFill;

    }
    if(type == 1||type==3)
    {
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    else
    {
        self.tableView.hidden = YES;
        if(_collectionView)
        {
            self.collectionView.hidden = NO;
            
        }
        [self initPuBuView];
        [self.collectionView reloadData];//此处注意，无论_collectionView是创建还是存在都要reloadData，否者显示会有问题
        [headView setImageWithURL:[NSURL URLWithString:self.huoDongImg] placeholderImage:GETIMG(@"home_photo.png")];

    }

  
}


-(void)initFailView
{
    if (self.failView==nil)
    {
        
        CGRect myRect  = self.view.bounds;
        _failView = [[UIView alloc]initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height-TITLEHEIGHT)];
        [self.view addSubview:_failView];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,140-45,MainViewWidth, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = RGBCOLOR(62, 62, 62);
        lbl.font = [UIFont systemFontOfSize:15.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"咦，数据加载失败了";
        [_failView addSubview:lbl];
        [lbl release];
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0,170-45,MainViewWidth, 20)];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = RGBCOLOR(82, 82, 82);
        lbl2.font = [UIFont systemFontOfSize:14.0f];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text = @"请检查下您的网络，重新加载吧";
        [_failView addSubview:lbl2];
        [lbl2 release];
        
        UIImage *bgI = [UIImage imageNamed:@"default_button@2x.png"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainViewWidth/2-bgI.size.width/4,210-45,bgI.size.width/2, bgI.size.height/2-5);
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button@2x.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button_press@2x.png"] forState:UIControlStateHighlighted];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(62, 62, 62) forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(refreshDataWhenFailRequest)
      forControlEvents:UIControlEventTouchUpInside];
        //btn.layer.borderWidth=1;
        //btn.layer.borderColor=RGBCOLOR(162, 162, 162).CGColor;
        //btn.layer.cornerRadius=5;
        [_failView addSubview:btn];
    }
    
//    for (UIView *subView in _failView.subviews)
//    {
//        [subView removeFromSuperview];
//    }
    
    
}

-(void)refreshDataWhenFailRequest
{
    [self initData:1 andTag:0];
}


-(void)initView
{
    if(!self.tableView)
    {
        self.tableView = [[[PullTableView alloc]initWithFrame:CGRectMake(0,TITLEHEIGHT, 320, MainViewHeight-20-TITLEHEIGHT)]autorelease];
        _tableView.backgroundColor = VIEW_BACKGROUND_COLOR;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.pullDelegate = self;
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 175)];
        [headView setContentMode:UIViewContentModeScaleAspectFill];
        self.tableView.tableHeaderView = headView;
        self.tableView.tableFooterView = [[[UIView alloc]init] autorelease];
        self.tableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        self.tableView.pullBackgroundColor = VIEW_BACKGROUND_COLOR;
        self.tableView.pullTextColor = [UIColor blackColor];
        [self.view addSubview:self.tableView];
        [self initData:1 andTag:0];
        [self addHud:Loading];
//        if(!self.tableView.pullTableIsRefreshing)
//        {
//            self.tableView.pullTableIsRefreshing = YES;
////            [self initData:<#(int)#> andTag:<#(int)#>]
////            [self refreshTable];
////            [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RefresDelayTime];
//            
//        }
 
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        UIView *sectionView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 10)] autorelease];
        sectionView.backgroundColor = [UIColor clearColor];
        return sectionView;
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //单图高度
    if(currentType == 3)
    {
        return  self.goodListAry.count;
    }
    //宫格高度
    int rows = (self.goodListAry.count%2==0)?self.goodListAry.count/2:self.goodListAry.count/2+1;
    return rows;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(currentType ==3)
    {
        if(section==0)
        {
            return 10;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if(currentType ==3 )//单图
    {
        static NSString *identify1 = @"cell1";
        SingleCell *picCell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if(picCell==nil)
        {
            picCell = [[[SingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1] autorelease];
        }
        picCell.accessoryType = UITableViewCellAccessoryNone;
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        GoodEntity *goodEntity = [self.goodListAry objectAtIndex:indexPath.row];
        [picCell creatCell:goodEntity.goodsimg andName:goodEntity.goodsname andMuch:goodEntity.price];
        return picCell;
     }
    static NSString *identify = @"cell";
    SPGongGeCell *cell =(SPGongGeCell*)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        
        cell = [[[SPGongGeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
    }
 
    if((indexPath.row*2+1)==self.goodListAry.count)
    {
        cell.objects = [NSArray arrayWithObjects:self.goodListAry[indexPath.row*2], nil];
        //每lie两个
        
    }else
    {
        cell.objects = [NSArray arrayWithObjects:self.goodListAry[indexPath.row*2],self.goodListAry[indexPath.row*2+1], nil];
        //最后一列可能只有一个
        
    }
    cell.delegate = self;
    [cell setNeedsLayout];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentType == 3)//单图高度
    {
        GoodEntity *goodEntity = [self.goodListAry objectAtIndex:indexPath.row];
        return [SingleCell getCellHeight:goodEntity];
    }
    return [SPGongGeCell cellHeight:nil];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark ------宫格点击delegate
-(void)cell:(SPGongGeCell *)cell imageBtnClicked:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"SPGongGeCellIndexPath %@",indexPath);
    int row = indexPath.row;
    GoodEntity *object = nil;
    if (btn.tag==1)//点击左边的商品
    {
        object = self.goodListAry[row*2];
    }
    if (btn.tag==2)//点击右边的商品
    {
        object = self.goodListAry[row*2+1];
    }
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = object.goodsid;
    [self pushViewController:vc];
    [vc release];
}



#pragma mark -- pulltableview delegate
-(void)refreshTable
{
    flag++;
    currentPage =1;
    [self initData:currentPage andTag:0];
    if(currentType == 2)
    {
        self.collectionView.pullLastRefreshDate = [NSDate date];
        self.collectionView.pullTableIsRefreshing = NO;
        return;
    }
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}
//上啦更新数据再这里加载
-(void)loadMoreDataToTable
{
    NSLog(@"活动加载");
    currentPage++;
    [self initData:currentPage andTag:1];
    if(currentType ==2)
    {
        self.collectionView.pullTableIsLoadingMore = NO;
        return;
    }
    self.tableView.pullTableIsLoadingMore = NO;
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RefresDelayTime];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RefresDelayTime];
}

//刷新  pullPsCollectionViewDidTriggerRefresh
- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RefresDelayTime];
}

//加载
- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RefresDelayTime];
}


-(void)myRightButtonAction:(UIButton *)button
{
    HuoDongRuleView *ruleView = [[HuoDongRuleView alloc]init];
    ruleView.rule = self.huoRule;
    [ruleView setContentsText:self.huoRule];
    NSLog(@"%@",self.huoRule);
    [self.view addSubview:ruleView];
    SAFETY_RELEASE(ruleView);
}


#pragma mark---------- 实现PSCollectionViewDelegate Delegate和DataSource(注意和table区分)
- (NSInteger)numberOfViewsInCollectionView:(PKCollectionView *)collectionView
{
    return self.goodListAry.count;
}

- (PKCollectionViewCell *)collectionView:(PKCollectionView *)collectionView viewAtIndex:(NSInteger)index
{
    PullImageCell *cell = (PullImageCell *)[self.collectionView dequeueReusableView];
    if (cell == nil) {
        cell = [[[PullImageCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.delgate = self;
        cell.userInteractionEnabled = YES;
    }
   
    GoodEntity *goodEntity = [self.goodListAry objectAtIndex:index];
    [cell creatCell:goodEntity.goodsimg andName:goodEntity.goodsname andMuch:goodEntity.price andIndex:index];
    return cell;
    
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index
{
    GoodEntity *goodEntity = [self.goodListAry objectAtIndex:index];
    return [PullImageCell getCellHeight:goodEntity andIndex:index];
    
}

-(void)selectPuBuCell:(int)index
{
    NSLog(@"!!!!!!!!!!!!%d",index);
    GoodEntity *goodEntity = [self.goodListAry objectAtIndex:index];
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = goodEntity.goodsid;
    [self pushViewController:vc];
    [vc release];
    
}

-(void)initPuBuView
{
    if(!_collectionView)
    {
        _collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, TITLEHEIGHT, self.view.frame.size.width, MainViewHeight-TITLEHEIGHT-20 )];
        [self.view insertSubview:_collectionView atIndex:0];
        _collectionView.collectionViewDelegate = self;
        _collectionView.collectionViewDataSource = self;
        _collectionView.pullDelegate=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 175)];
        [headView setContentMode:UIViewContentModeScaleAspectFill];
     //   [headView setImageWithURL:[NSURL URLWithString:self.huoDongImg] placeholderImage:GETIMG(@"home_photo.png")];
        self.collectionView.headerView = headView;
        _collectionView.numColsPortrait = 2;
        _collectionView.numColsLandscape = 3;
        _collectionView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        _collectionView.pullBackgroundColor = VIEW_BACKGROUND_COLOR;
        _collectionView.pullTextColor = [UIColor blackColor];
        
    }
 
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
