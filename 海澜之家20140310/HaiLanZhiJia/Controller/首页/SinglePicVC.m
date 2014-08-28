//
//  SinglePicVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SinglePicVC.h"
#import "UIImageView+WebCache.h"
#import "SPGongGeCell.h"
#import "PullImageCell.h"
#import "PullPsCollectionView.h"
@interface SinglePicVC ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,DSRequestDelegate,SPGongGeCellDelegate,PKCollectionViewDataSource,PullPsCollectionViewDelegate,PKCollectionViewDelegate,PullPsCollectionViewDelegate,UIScrollViewDelegate,pubuCelldelegate>
{
    UITableView *picListTable;
    UIImageView *headView;
    int currentPage;
    UILabel *noteLabel;
    int type;
    int flag;
    int currentType;
}

@property(nonatomic,retain)NSMutableArray *googAry;

@property(nonatomic,retain)NSString *huoDongImg;

@property(nonatomic,retain)NSString *huoRule;

@property(nonatomic,retain)PullTableView *tableView;

@property(nonatomic,retain)DSRequest *aRequset;
@property(nonatomic,retain)UIView *failView;
@property (nonatomic , retain) PullPsCollectionView *collectionView;  //瀑布流列表 UI


@end

@implementation SinglePicVC

- (void)dealloc
{
    NSLog(@"bbbbbbbbb     %d",self.googAry.retainCount);
    [noteLabel release];
    [picListTable release];
//    [_googAry release];
    self.googAry = nil;
    if(_failView)
    {
        [_failView release],_failView = nil;
    }
    [headView release];
    self.tableView = nil;
    self.aRequset.delegate = nil;
    self.aRequset = nil;
    self.huoDongImg = nil;
    self.huoRule = nil;
    self.zhuantiId = nil;
    self.strTitle = nil;
    self.collectionView = nil;
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
    flag = 1;
    _googAry =[[NSMutableArray alloc]initWithCapacity:0];
    
     currentPage=1;
  //   [self initDate:1 andTag:0];
    
    [self createMyButtonWithTitleAndImage];
//    self.rightButton.hidden = YES;
//    [self setMyRightButtonTitle:@"规则"];
//    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
//    [self setTitleString:self.strTitle];
    [self initView];
//    [self addHud:@"请稍后"];
   
    
    
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
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,140-45,MainViewWidth, 20)] autorelease];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = RGBCOLOR(62, 62, 62);
    lbl.font = [UIFont systemFontOfSize:15.0f];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"咦，数据加载失败了";
    [_failView addSubview:lbl];
    
    UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(0,170-45,MainViewWidth, 20)] autorelease];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.textColor = RGBCOLOR(82, 82, 82);
    lbl2.font = [UIFont systemFontOfSize:14.0f];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.text = @"请检查下您的网络，重新加载吧";
    [_failView addSubview:lbl2];
    
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
    [_failView addSubview:btn];
    
}

-(void)refreshDataWhenFailRequest
{
    [self initDate:1 andTag:0];
}

#pragma mark -----------DSRequest
-(void)initDate:(int)page andTag:(int)tag
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequset = requestObj;
    [requestObj requestDataWithInterface:GetSpecialActivityList param:[self GetSpecialActivityListParam:self.zhuantiId page:page] tag:tag];
    [requestObj release];
}

-(void)delayHidHud
{
    [self hideHud:nil];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
//    NSLog(@"失败");
//    [self addFadeLabel:@"无法连接网络"];
    [self performSelector:@selector(delayHidHud) withObject:nil afterDelay:0.1];
    if(tag == 0&&self.googAry.count == 0)
    {
        [self initFailView];
        
    }
    if(tag == 1)
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
       //@property (retain) int specialtype;//	int	专题类型1.宫格 2.瀑布流 3.单图
    SpecialListEntity *entity = ( SpecialListEntity*)dataObj;
    self.huoDongImg = entity.portalimg;
    type = entity.specialtype;
    NSString *aString = [entity.rule stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bString = [aString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(bString.length>0)
    {
        self.rightButton.hidden = NO;
        [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
        [self setMyRightButtonTitle:@"规则"];
        self.huoRule = entity.rule;
    }
    [self setTitleString:entity.title];
    if(tag == 0)//刷新
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
            }

            return;
        }
        [self.googAry removeAllObjects];
        [self.googAry addObjectsFromArray:entity.goodslist];
  
    }
    
    if(tag == 1)//加载
    {
        if(currentType != type)//当加载更多的时候专题类型变了侧什么也不做.
        {
            return;
        }

        if(entity.goodslist.count == 0)
        {
            currentPage--;
            [self addFadeLabel:@"已没有更多商品了"];
            return;
        }
        
        [self.googAry addObjectsFromArray:entity.goodslist];
    }
    currentType = type;
    
     NSLog(@"sum:%d,currentPage:%d",self.googAry.count,currentPage);
    [headView setImageWithURL:[NSURL URLWithString:self.huoDongImg] placeholderImage:GETIMG(@"home_photo.png")];
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
            self.collectionView.hidden = NO;//////////
        }
        [self initPuBuView];
        [self.collectionView reloadData];
        [headView setImageWithURL:[NSURL URLWithString:self.huoDongImg] placeholderImage:GETIMG(@"home_photo.png")];

    }
 
}



#pragma mark -------UI

-(void)initView
{
    if(!_tableView)
    {
        self.tableView = [[[PullTableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20)] autorelease];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.pullDelegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 150)];
        self.tableView.tableHeaderView = headView;
        
        self.tableView.tableFooterView = [[[UIView alloc]init] autorelease];
        self.tableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        self.tableView.pullBackgroundColor = RGBCOLOR(245, 245, 245);
        self.tableView.pullTextColor = [UIColor blackColor];
        [self.view addSubview:self.tableView];
        [self initDate:1 andTag:0];
        [self addHud:Loading];
//        if(!self.tableView.pullTableIsRefreshing)
//        {
//            self.tableView.pullTableIsRefreshing = YES;
//            [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RefresDelayTime];
//        }
 
    }
       
}
#pragma mark ----------table delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  return 20;
    if(currentType == 3)
    {
        return  self.googAry.count;
    }
    int rows = (self.googAry.count%2==0)?self.googAry.count/2:self.googAry.count/2+1;
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentType == 1)//宫格cell
    {
        static NSString *identify = @"cell";

        SPGongGeCell *cell =(SPGongGeCell*)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[[SPGongGeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
        }
        
        if((indexPath.row*2+1)==self.googAry.count)
        {
            cell.objects = [NSArray arrayWithObjects:self.googAry[indexPath.row*2], nil];
            //每lie两个
            
        }else
        {
            cell.objects = [NSArray arrayWithObjects:self.googAry[indexPath.row*2],self.googAry[indexPath.row*2+1], nil];
            //最后一列可能只有一个
            
        }
        cell.delegate = self;
        [cell setNeedsLayout];
        return cell;
 
    }
    static NSString *identify1 = @"cell1";

    SingleCell *picCell = [tableView dequeueReusableCellWithIdentifier:identify1];
    if(picCell==nil)
    {
        picCell = [[[SingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1] autorelease];
    }
    
    picCell.accessoryType = UITableViewCellAccessoryNone;
    picCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodEntity *goodEntity = [self.googAry objectAtIndex:indexPath.row];
    [picCell creatCell:goodEntity.goodsimg andName:goodEntity.goodsname andMuch:goodEntity.price];
    return picCell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentType ==3)
    {
        //商品详情月面
        GoodEntity *goodEntity = [self.googAry objectAtIndex:indexPath.row];
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = goodEntity.goodsid;
        [self pushViewController:vc];
        [vc release];
    }
    
}
#pragma mark -----宫格图片点击delegate
-(void)cell:(SPGongGeCell *)cell imageBtnClicked:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"SPGongGeCellIndexPath %@",indexPath);
    int row = indexPath.row;
    GoodEntity *object = nil;
    if (btn.tag==1)//点击左边的商品
    {
        object = self.googAry[row*2];
    }
    if (btn.tag==2)//点击右边的商品
    {
        object = self.googAry[row*2+1];
    }
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = object.goodsid;
    [self pushViewController:vc];
    [vc release];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentType == 1)
    {
         return [SPGongGeCell cellHeight:nil];
    }
    GoodEntity *goodEntity = [self.googAry objectAtIndex:indexPath.row];
    return [SingleCell getCellHeight:goodEntity];
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

-(void)initPuBuView
{
    if(!_collectionView)
    {
        _collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, TITLEHEIGHT, self.view.frame.size.width, MainViewHeight-TITLEHEIGHT-20 )];
        [self.view insertSubview:_collectionView atIndex:0];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.collectionViewDelegate = self;
        _collectionView.collectionViewDataSource = self;
        _collectionView.pullDelegate=self;
     //   _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 150)];
//        headView.clipsToBounds = YES;
//        headView.contentMode = UIViewContentModeScaleAspectFill;
        [headView setImageWithURL:[NSURL URLWithString:self.huoDongImg] placeholderImage:GETIMG(@"home_photo.png")];
        self.collectionView.headerView = headView;
        _collectionView.numColsPortrait = 2;
        _collectionView.numColsLandscape = 3;
        _collectionView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        _collectionView.pullBackgroundColor = VIEW_BACKGROUND_COLOR;
        _collectionView.pullTextColor = [UIColor blackColor]; 
    }
}


//下拉
#pragma mark -- pulltableview delegate
-(void)refreshTable
{

    flag++;
    currentPage =1;
    [self initDate:currentPage andTag:0];
    if(currentType == 2)//瀑布流
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
    currentPage++;
    [self initDate:currentPage andTag:1];
    NSLog(@"活动加载");
    if(currentType == 2)//瀑布流
    {
        self.collectionView.pullTableIsLoadingMore = NO;
        return;
    }

    self.tableView.pullTableIsLoadingMore = NO;
}
//pullPsCollectionViewDidTriggerRefresh
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



#pragma mark---------- 实现PSCollectionViewDelegate Delegate和DataSource(注意和table区分)
- (NSInteger)numberOfViewsInCollectionView:(PKCollectionView *)collectionView
{
    return self.googAry.count;
}

- (PKCollectionViewCell *)collectionView:(PKCollectionView *)collectionView viewAtIndex:(NSInteger)index
{
    PullImageCell *cell = (PullImageCell *)[self.collectionView dequeueReusableView];
    if (cell == nil) {
        cell = [[[PullImageCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    cell.delgate = self;
    cell.userInteractionEnabled = YES;
    GoodEntity *goodEntity = [self.googAry objectAtIndex:index];
    [cell creatCell:goodEntity.goodsimg andName:goodEntity.goodsname andMuch:goodEntity.price andIndex:index];
    return cell;
    
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index
{
    GoodEntity *goodEntity = [self.googAry objectAtIndex:index];
    return [PullImageCell getCellHeight:goodEntity andIndex:index];
    
}
//-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(type == 3)
//    {
//        GoodEntity *goodEntity = [self.googAry objectAtIndex:indexPath.row];
//        return [SingleCell getCellHeight:goodEntity];
//    }
//    return [SPGongGeCell cellHeight:nil];
//    
//}

-(void)selectPuBuCell:(int)index
{
    NSLog(@"!!!!!!!!!!!!%d",index);
    GoodEntity *goodEntity = [self.googAry objectAtIndex:index];
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = goodEntity.goodsid;
    [self pushViewController:vc];
    [vc release];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
