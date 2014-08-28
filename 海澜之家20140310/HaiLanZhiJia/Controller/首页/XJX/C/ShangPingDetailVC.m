//
//  ShangPingDetailVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS 5
#define ITEM_SPACING 230.0f
#define INCLUDE_PLACEHOLDERS YES

#import "ShangPingDetailVC.h"
#import "DSSegmentControl.h"
#import "LunBoView.h"
#import "UserCommentCell.h"
#import "ShouQianZiXunVC.h"
#import "DaPeiXiaoShouVC.h"
#import "CaiNiXiHuanVC.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "iCarousel.h"
#import "DSImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SKBounceAnimation.h"
#import "PullTableView.h"
#import "GouWuCheVC.h"
#import "SeeBigPhoneVC.h"
#import "UIViewController+Hud.h"
#import "RootVC.h"
#import "UIViewController+Hud.m"

#define fenxiangBtnTag   0x1111
#define shouCangbtnTag   0x1112
#define tableViewTag     0x9999
#define yansebtnBaseTag  0x2222
#define chiMaBtnBaseTag  0x3333
#define indicatorTag     0x8888
#define kShangPinTuPianH 180

typedef enum
{
    jianJie=0,
    tuWen=1,
    pingLun=2,
}DetailType;

typedef enum
{
    jiaRuGouWuChe=1,
    liJiGouMai=2,
}AddGouWuCheType;

@interface ShangPingDetailVC ()<UITableViewDelegate,UITableViewDataSource,DSSegmentControlDelegate,LunBoViewDelegate,UIWebViewDelegate,WXApiDelegate,UIActionSheetDelegate,WeiboRequestDelegate,WeiboAuthDelegate,MFMessageComposeViewControllerDelegate,iCarouselDataSource,iCarouselDelegate,PullTableViewDelegate,UserCommentCellDelegate>
{
     UIActionSheet *mySheet;//点击分享按钮时弹出
    UILabel *ziXunCountL;
    int currConsults;   //当前咨询数
}

@property(nonatomic,retain)UITableView *tableView;//显示商品详情
@property(nonatomic,assign)BOOL isRequestSPDetailEntitySuccess;//请求商品详情实体是否成功
@property(nonatomic,assign)DetailType detailType;//区分：简介，图文，评论
@property(nonatomic,assign)AddGouWuCheType carType;//区分：点击 加入购物车 还是 立即购买
@property(nonatomic,retain)UIWebView *webView;//加载图文详情
@property(nonatomic,assign)BOOL isRequestTuWenDetailSuccess;//请求图文详情是否成功
@property(nonatomic,retain)NSMutableArray *colorArr;//创建的颜色按钮数组
@property(nonatomic,retain)NSMutableArray *chiCunArr;//当前颜色对应创建的尺寸按钮数组
@property(nonatomic,retain)NSMutableArray *curColorChiCunArr;//当前颜色对应尺寸数组
@property(nonatomic,retain)NSMutableArray *colorImageUrlArr;//当前颜色对应商品缩略图数组
@property(nonatomic,retain)iCarousel *carousel;//显示商品缩略图
@property(nonatomic,retain)UILabel *countIndexLabel;//显示商品小图当前滑到第几张
@property(nonatomic,retain)UIButton *gouWuCheBtn;//购物车按钮
@property(nonatomic,retain)UIView *hongDianView;//显示购物车商品件数
@property(nonatomic,assign)NSInteger gouWuCheSpCount;//购物车商品件数
@property(nonatomic,retain)DSImageView *shangPinView;//点击加入购物车按钮时的图片
@property(nonatomic,retain)DSImageView *LiJIGouMaiView;//点击立即购买按钮时的图片
@property(nonatomic,retain)UIButton *liJiGouMaiBtn;//立即购买按钮
@property(nonatomic,retain)UIButton *jiaRuGouWuCheBtn;//加入购物车按钮
@property(nonatomic,copy)NSString *curSelectedColor;//当前选择的颜色
@property(nonatomic,copy)NSString *curSelectedSize;//当前选择的尺寸
@property(nonatomic,copy)NSString *curSelectedColorImage;//当前选择颜色对应的第一张商品小图
@property(nonatomic,assign)NSUInteger curSelectedColorBtnIndex;//当前选择的颜色按钮的索引
@property(nonatomic,retain)UILabel *commentsCountLabel;//显示评论条数
@property(nonatomic,retain)UserCommentsEntity *userCommentsEntity;//用户评论实体
@property(nonatomic,retain)NSMutableArray *commentsArr;//评论实体数组
@property(nonatomic,retain)UILabel *tiShiLabel;//没有评论时用来提示用户
@property(nonatomic,retain)PullTableView *pingLunTable;//显示评论的列表
@property(nonatomic,assign)NSUInteger currentPage;//请求评论的当前页码
@property(nonatomic,assign)BOOL isNeedAddPage;//请求评论加载更多时currentPage是否要加1
@property(nonatomic,assign)BOOL isRequestCommentSuccess;
@property(nonatomic,retain)UIImageView *fenXiangShouCangV;//顶部栏上收藏分享的底图
@property(nonatomic,retain)UIButton *shouCangBtn;//收藏按钮
@property(nonatomic,assign)BOOL isShouCangGuo;//是否收藏过商品
@property(nonatomic,retain)DSRequest *request;
@end

@implementation ShangPingDetailVC

-(void)dealloc
{
    [ziXunCountL release];
    [_tableView release];_tableView=nil;
    [_colorArr release];_colorArr=nil;
    [_chiCunArr release];_chiCunArr=nil;
    [_webView release];_webView=nil;
    [_commentsArr release];_commentsArr=nil;
    [_colorImageUrlArr release];_colorImageUrlArr = nil;
    [_carousel release];_carousel = nil;
    [_gouWuCheBtn release];_gouWuCheBtn = nil;
    [_shangPinView release];_shangPinView = nil;
    [_hongDianView release];_hongDianView = nil;
    [_request release];_request=nil;
    _request.delegate = nil;
    [_pingLunTable release];_pingLunTable = nil;
    [_curSelectedColor release];_curSelectedColor=nil;
    [_curSelectedSize release];_curSelectedSize=nil;
    [_curSelectedColorImage release];_curSelectedColorImage=nil;
    [_commentsCountLabel release];_commentsCountLabel=nil;
    [_userCommentsEntity release];_userCommentsEntity=nil;
    [_LiJIGouMaiView release];_LiJIGouMaiView=nil;
    [_countIndexLabel release];_countIndexLabel=nil;
    [_fenXiangShouCangV release];_fenXiangShouCangV=nil;
    [_shouCangBtn release];_shouCangBtn=nil;
    [_tiShiLabel release];_tiShiLabel=nil;
    [_curColorChiCunArr release];_curColorChiCunArr=nil;
    self.liJiGouMaiBtn=nil;
    self.jiaRuGouWuCheBtn=nil;
    [mySheet release];mySheet=nil;
    self.shopCarGoodEntity=nil;
    self.spDetailObject=nil;
    self.spId=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //胡鹏加的，莫删
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 320, 20)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    [topView release];
    
    self.view.backgroundColor =RGBCOLOR(242, 242, 242);
    [self setTitleString:@"商品详情"];
    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];
}
-(void)doAfterViewDidLoad
{
    //胡鹏
    if(self.wbapi == nil)
    {
        self.wbapi = [[[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI]autorelease] ;
    }
    //子视图创建
    [self initSubview];
    _detailType = jianJie;//默认显示商品简介
    _isRequestSPDetailEntitySuccess=NO;
    _isRequestTuWenDetailSuccess=NO;
    _isRequestCommentSuccess=NO;
    _curSelectedColorBtnIndex=0;//默认选中第一种颜色

    [self initDataSource];
    
    if (_comeFromType!=ComeFromTiaoMa)
    {//不从条码进来请求商品详情
        [self requestDatasource:jianJie];
    }else
    {//从条码近来直接传过来实体不需请求
        _isRequestSPDetailEntitySuccess=YES;
        _spId=_spDetailObject.goodsid;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(soucang:) name:LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(ziXunSuccess:) name:kZiXunSuccessNotification object:nil];
}

- (void)ziXunSuccess:(NSNotification *)noti
{
    ziXunCountL.text = [NSString stringWithFormat:@"售前咨询(%i)",++currConsults];
}

-(void)leftAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _request.delegate=nil;
    
    //保存浏览记录
    [self saveSpDetailObject:self.spDetailObject];
    //从条码进详情返回时用的
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(comeBackFromSpDetailVC)])
        {
            return;
            [self.delegate comeBackFromSpDetailVC];
        }
    }
    
    [super leftAction];
    
}

-(void)initSubview
{
    //收藏分享底图
    UIImage *rightImage=[UIImage imageNamed:@"mall_details_button@2x.png"];
    CGFloat x = 235;
    CGFloat y = [self getTitleBarHeight]/2.0-rightImage.size.height/4.0;
    CGFloat w = rightImage.size.width/2.0;
    CGFloat h = rightImage.size.height/2.0;
    UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    rightImageView.image=rightImage;
    self.fenXiangShouCangV = rightImageView;
    [self.titleBar addSubview:rightImageView];
    [rightImageView release];
    //分享按钮
    UIButton *fenxiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fenxiangBtn.tag = fenxiangBtnTag;
    fenxiangBtn.frame = CGRectMake(x,y,w/2.0,h);
    [fenxiangBtn setBackgroundImage:GETIMG(@"mall_details_button_share_press@2x.png") forState:UIControlStateHighlighted];
    [fenxiangBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:fenxiangBtn];
    //收藏按钮
    x = fenxiangBtn.frame.origin.x+fenxiangBtn.frame.size.width;
    UIButton *shouCangbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shouCangbtn.tag = shouCangbtnTag;
    shouCangbtn.frame = CGRectMake(x,y,w/2.0,h);
    [shouCangbtn setBackgroundImage:GETIMG(@"mall_details_button_collect_press@2x.png") forState:UIControlStateHighlighted];
    [shouCangbtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.shouCangBtn = shouCangbtn;
    [self.titleBar addSubview:shouCangbtn];
    //简介，图文详情，评论
    DSSegmentControl *segmentControl = [[DSSegmentControl alloc]initWithFrame:CGRectMake(0,[self getTitleBarHeight],320,45)];
    segmentControl.backgroundImage = @"tab_bg@2x.png";
    segmentControl.highlightImages = [NSArray arrayWithObjects:@"tab_sel2@2x.png",@"tab_sel3@2x.png",@"tab_sel4@2x.png", nil];
    segmentControl.titles = [NSArray arrayWithObjects:@"商品简介",@"图文详情",@"用户评论", nil];
    segmentControl.colorN = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
    segmentControl.colorH = [UIColor colorWithRed:29/255.0 green:20/255.0 blue:92/255.0 alpha:1];
    segmentControl.delegate = self;
    [segmentControl initSegmentControl];
    [self.view addSubview:segmentControl];
    [segmentControl release];
    
    
    y = segmentControl.frame.size.height+segmentControl.frame.origin.y;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,y, 320, MainViewHeight-20-[self getTitleBarHeight]-45 + 15)];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tag = tableViewTag;
    self.tableView = tableView;
    [tableView release];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView  = view;
    [view release];
    //评论列表
    PullTableView *pingLunTable = [[PullTableView alloc]initWithFrame:CGRectMake(0,y, 320, MainViewHeight-20-[self getTitleBarHeight]-45)];
    [pingLunTable setBackgroundColor:self.view.backgroundColor];
    pingLunTable.delegate = self;
    pingLunTable.dataSource = self;
    pingLunTable.pullDelegate = self;
    pingLunTable.pullLastRefreshDate = nil;
    pingLunTable.pullArrowImage = [UIImage imageNamed:@""];
    pingLunTable.pullBackgroundColor = RGBCOLOR(245, 245, 245);
    pingLunTable.pullTextColor = RGBCOLOR(62, 62, 62);
    pingLunTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:pingLunTable];
    self.pingLunTable=pingLunTable;
    [pingLunTable release];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320,10)];
    view.backgroundColor = [UIColor clearColor];
    pingLunTable.hidden = YES;
    pingLunTable.tableFooterView  = view2;
    [view2 release];
    //购物车按钮
    x = 270;
    y = MainViewHeight-50-20;
    w = 40;
    h = 40;
    UIButton *gouWuCheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gouWuCheBtn.frame = CGRectMake(x,y,w,h);
    [gouWuCheBtn setBackgroundImage:[UIImage imageNamed:@"mall_details_icon_car@2x.png"] forState:UIControlStateNormal];
    [gouWuCheBtn addTarget:self action:@selector(gouWuCheBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gouWuCheBtn];
    self.gouWuCheBtn = gouWuCheBtn;
    //购物车数字视图
    NSNumber *count = [[NSUserDefaults standardUserDefaults]objectForKey:kGouWuCheGoodsCount];
    self.hongDianView = [self hongDianPoint:CGPointMake(18,2) number:count.intValue];
    [self.gouWuCheBtn addSubview:self.hongDianView];
    if (count.intValue==0)
    {
        self.hongDianView.hidden = YES;
    }
    
}
-(void)initDataSource
{
    if (_comeFromType!=ComeFromTiaoMa)
    {
        GoodDetailEntity *object = [[GoodDetailEntity alloc]init];
        object.goodsid = @"";
        object.goodsname = @"";
        object.goodscode = @"";
        object.price = @"";
        object.colorandimgs = [NSArray array];
        object.imgdetail = @"";
        self.spDetailObject = object;
        [object release];
    }
    
    DSRequest *request = [[DSRequest alloc]init];
    self.request = request;
    request.delegate = self;
    [request release];
    
    if (self.commentsArr==nil)
    {
        self.commentsArr = [NSMutableArray arrayWithCapacity:0];
    }else
    {
        [self.commentsArr removeAllObjects];
    }
    
    _curColorChiCunArr = [[NSMutableArray alloc]initWithCapacity:0];
    _colorImageUrlArr = [[NSMutableArray alloc]initWithCapacity:0];
    if (_shopCarGoodEntity!=nil)
    {
        self.curSelectedColor=_shopCarGoodEntity.color;
        self.curSelectedSize=_shopCarGoodEntity.size;
    }
}
- (void)controllerviewDidAppear
{
    //购物车商品数量显示
    int count = [[[NSUserDefaults standardUserDefaults]objectForKey:kGouWuCheGoodsCount] intValue];
    if (count>=0)
    {
        [self setGouWuCheCount:count];
        [self addBounceAnimation:self.hongDianView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)requestDatasource:(DetailType)theType
{
    if (_spId==nil||_spId.length==0)
    {
        return;
    }
    
    if (theType==jianJie)
    {
        [self.tableView addHUDActivityView:@"加载中..."];
        [self.request requestDataWithInterface:GetGoodsDetail param:[self GetGoodsDetailParam:_spId] tag:1];
    }
    if (theType==pingLun)
    {
         [self.pingLunTable addHUDActivityView:@"加载中..."];
        [self.request requestDataWithInterface:GetUserComments param:[self GetUserCommentsParam:_spId page:_currentPage] tag:3];
    }
}
#pragma mark --- 网络请求回调
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    switch (tag)
    {
        case 1://商品详情实体
        {
            [self.tableView removeHUDActivityView];
            GoodDetailEntity *object = (GoodDetailEntity*)dataObj;
            self.spDetailObject = object;
            currConsults = self.spDetailObject.consults;    //获取到实体后拿到当前咨询数量
            
            _isRequestSPDetailEntitySuccess=YES;
            [self.tableView reloadData];
            //购物车商品数量显示
            [self setGouWuCheCount:[[[NSUserDefaults standardUserDefaults]objectForKey:kGouWuCheGoodsCount] intValue]];
            [self addBounceAnimation:self.hongDianView];
            if (object.savestatus==1)
            {
                self.fenXiangShouCangV.image = [UIImage imageNamed:@"mall_details_button_press@2x.png"];
                [_shouCangBtn setBackgroundImage:GETIMG(@"mall_details_button_collect_@2x.png") forState:UIControlStateHighlighted];
            }
        }
            break;
        case 2://商品收藏请求
        {
            StatusEntity *object = (StatusEntity*)dataObj;
            if (object.response==1)
            {
               [self addFadeLabel:@"收藏成功"];
                _isShouCangGuo = YES;
                self.fenXiangShouCangV.image = [UIImage imageNamed:@"mall_details_button_press@2x.png"];
                [_shouCangBtn setBackgroundImage:GETIMG(@"mall_details_button_collect_@2x.png") forState:UIControlStateHighlighted];
            }else
            {
                [self addFadeLabel:@"收藏失败"];
            }
        }
            break;
        case 3:// 用户评论请求
        {
            [self.pingLunTable removeHUDActivityView];
            [self performSelector:@selector(stopPulling) withObject:nil afterDelay:0.1];
            UserCommentsEntity *object = (UserCommentsEntity*)dataObj;
            self.userCommentsEntity = object;
            _isRequestCommentSuccess=YES;
            _tiShiLabel.hidden = YES;
            if (_currentPage==1)//第一次请求或下拉刷新
            {
                if (object.usercomments.count<=0)//没有评论
                {
                    if (_tiShiLabel==nil)
                    {
                        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,50,MainViewWidth, 20)] autorelease];
                        lbl.textAlignment = NSTextAlignmentCenter;
                        lbl.textColor = RGBCOLOR(160,160,160);
                        lbl.font = [UIFont systemFontOfSize:14.0f];
                        lbl.backgroundColor = [UIColor clearColor];
                        lbl.text = @"暂时没有评论";
                        lbl.hidden = NO;
                        lbl.tag = 0x7474;
                        self.tiShiLabel=lbl;
                        [self.pingLunTable addSubview:lbl];
                    }
                    if (_commentsArr.count<=0)//数据源里没有评论显示提示
                    {
                        _tiShiLabel.hidden = NO;
                    }
                    _isNeedAddPage=NO;//下拉还请求当前页的评论
                    [self.pingLunTable reloadData];
                    return;
                }
                if (self.commentsArr.count>0)
                {
                    [self.commentsArr removeAllObjects];
                }
                _isNeedAddPage=YES;//下拉请求下一页的评论
                self.commentsArr = [NSMutableArray arrayWithArray:object.usercomments];
            }else if(_currentPage>1)//加载更多
            {
                if (object.usercomments.count<=0)
                {
                    [self addFadeLabel:@"没有更多评论了"];
                    _isNeedAddPage=NO;
                    return;
                }
                _isNeedAddPage=YES;
                [self.commentsArr addObjectsFromArray:object.usercomments];
            }
            [self.pingLunTable reloadData];
            [self reloadCommentsCountLabel];
        }
            break;
        case 4://加入购物车
        {
            StatusEntity *object = (StatusEntity*)dataObj;
            if (object.response==1)//成功
            {
                [self addToShoppingCarAnimation];
                self.gouWuCheSpCount = object.totalcount;
                 [RootVC setNumber:object.totalcount ofIndex:3];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:object.totalcount] forKey:kGouWuCheGoodsCount];
            }
            if (object.response==2)//失败
            {
                [self addFadeLabel:@"加入购物车失败，请重试"];
            }
        }
            break;
        default:
            break;
    }
    
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    switch (tag)
    {
        case 1:
        {
            [self.tableView removeHUDActivityView];
            if (self.spDetailObject==nil)
            {
                _isRequestSPDetailEntitySuccess=NO;
                [self addFadeLabel:error.domain];
            }
        }
            break;
        case 2:
        {
            [self addFadeLabel:@"收藏失败,请重试"];
        }
            break;
        case 3:
        {
            [self.pingLunTable removeHUDActivityView];
            [self addFadeLabel:@"暂时没有评论哦"];
            _isNeedAddPage=NO;
        }
            break;
        case 4:
        {
            [self addFadeLabel:@"加入购物车失败，请重试"];
        }
            break;
        
        default:
            break;
    }
}
-(void)stopPulling
{
    self.pingLunTable.pullTableIsLoadingMore = NO;
    self.pingLunTable.pullTableIsRefreshing = NO;
}
#pragma mark -- segmentControlDelegate 简介，图文详情，评论
-(void)segmentControl:(DSSegmentControl*)segmentControl clickedAtIndex:(int)index button:(UIButton *)btn
{
    switch (index)
    {
        case 0://简介
        {
            _detailType = jianJie;
            self.pingLunTable.hidden = YES;
            self.tableView.hidden = NO;
            self.tableView.scrollEnabled = YES;
            [self.tableView reloadData];
        }
            break;
        case 1://图文详情
        {
            _detailType = tuWen;
            self.pingLunTable.hidden = YES;
            self.tableView.hidden = NO;
            self.tableView.scrollEnabled = NO;
            [self.tableView reloadData];
            
        }
            break;
        case 2://评论
        {
            _detailType = pingLun;
            self.pingLunTable.hidden = NO;
            self.tableView.hidden = YES;
            self.tableView.scrollEnabled = YES;
            if (_isRequestCommentSuccess==YES)//已经有评论就不请求了
            {
                [self.pingLunTable reloadData];
            }else//木有评论就请求
            {
                _currentPage = 1;
                [self requestDatasource:pingLun];
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark -- UITableView 数据源 委托
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detailType==jianJie)
    {
        return 0;
    }else if (_detailType == tuWen)
    {
        return 0;
    }else if(_detailType == pingLun)
    {
        return _commentsArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetify = @"tableviewCell";
    if (_detailType==pingLun)
    {
        UserCommentCell *cell =(UserCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellIdetify];
        if (!cell)
        {
            cell = [[[UserCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetify]autorelease];
        }
        if (indexPath.row<_commentsArr.count)
        {
            UserCommentEntity *object = _commentsArr[indexPath.row];
            cell.commentObject = object;
        }
        cell.delegate = self;
        return cell;
        
    }else
    {
        UITableViewCell *cell =(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdetify];
        if (!cell)
        {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetify]autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detailType==pingLun)
    {
        if (indexPath.row<_commentsArr.count)
        {
            UserCommentEntity *object = _commentsArr[indexPath.row];
            return [UserCommentCell cellHeight:object];
        }
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#pragma mark -- //商品简介
    if (self.detailType==jianJie&&tableView==self.tableView&&_isRequestSPDetailEntitySuccess==YES)
    {
        //容器视图
        UIView *view = [[[UIView alloc]init]autorelease];
        view.frame = CGRectMake(0,0,320,[self heightForHeader]);
        view.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
        
        if (_spDetailObject.colorandimgs.count>0)
        {//默认选中当前颜色
            if (_curSelectedColor!=nil)
            {
                for (NSDictionary *dic in _spDetailObject.colorandimgs)
                {
                    NSString *color = [dic objectForKey:@"color"];
                    if ([color isEqualToString:_curSelectedColor])
                    {
                       int index = 0;
                       index =[_spDetailObject.colorandimgs indexOfObject:dic];
                       _curSelectedColorBtnIndex=index;
                    }
                }
            }
        }
        //当前颜色对应的缩略图
        if (_spDetailObject.colorandimgs.count>0)
        {
            NSDictionary *colorImages = _spDetailObject.colorandimgs[_curSelectedColorBtnIndex];
            if (colorImages.count>0)
            {
                NSMutableArray *imgUrlArray=[NSMutableArray arrayWithArray:[colorImages objectForKey:@"thumbnailimgs"]];
                if (_colorImageUrlArr.count>0) {
                    [_colorImageUrlArr removeAllObjects];
                }
                [_colorImageUrlArr addObjectsFromArray:imgUrlArray];
            }
        }
        
        iCarousel *carouselView = [[iCarousel alloc]initWithFrame:CGRectMake(0,0,MainViewWidth,(_colorImageUrlArr.count==0)?0:kShangPinTuPianH)];
        carouselView.dataSource = self;
        carouselView.delegate = self;
        carouselView.backgroundColor = [UIColor clearColor];
        carouselView.decelerationRate = 0.5;
        carouselView.type = iCarouselTypeCoverFlow2;
        carouselView.scrollEnabled = YES;
        self.carousel = carouselView;
        [carouselView release];
        [view addSubview:self.carousel];
        
        //缩略图索引label
        if (_colorImageUrlArr.count>0)
        {
            UILabel *countIndexL = [[UILabel alloc]initWithFrame:CGRectMake(MainViewWidth-60,0,50,20)];
            countIndexL.backgroundColor = [UIColor clearColor];
            countIndexL.text = [NSString stringWithFormat:@"1/%d",_colorImageUrlArr.count];
            countIndexL.textAlignment = NSTextAlignmentRight;
            countIndexL.font = [UIFont systemFontOfSize:15];
            countIndexL.textColor = RGBCOLOR(62, 62, 62);
            countIndexL.numberOfLines = 0;
            [view addSubview:countIndexL];
            self.countIndexLabel = countIndexL;
            [countIndexL release];
        }
        //分割线
        UIImage *lineImage=[UIImage imageNamed:@"division line.png"];
        CGFloat x = 0;
        CGFloat y = self.carousel.frame.origin.y+((_colorImageUrlArr.count==0)?0:(kShangPinTuPianH-5));
        CGFloat w = 320;
        CGFloat h = lineImage.size.height/2;
        UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y+5,w,h)];
        lingImageView.image=lineImage;
        [view addSubview:lingImageView];
        lingImageView.hidden = (_colorImageUrlArr.count==0)?YES:NO;
        [lingImageView release];
        //商品名称
        x=10;
        y=y+15;
        w=230;
        h= [_spDetailObject.goodsname sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(230, MAXFLOAT)].height;
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.text = _spDetailObject.goodsname;
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = RGBCOLOR(62, 62, 62);
        titleLab.numberOfLines = 0;
        [view addSubview:titleLab];
        [titleLab release];
        //商品现价
        x=titleLab.frame.origin.x+titleLab.frame.size.width+10;
        y=titleLab.frame.origin.y;
        w=68;
        h= [_spDetailObject.goodsname sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(230, MAXFLOAT)].height;
        UILabel *xianJiaL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        xianJiaL.backgroundColor = [UIColor clearColor];
        NSString *xPStr = nil;
        if ([_spDetailObject.price  hasPrefix:@"¥"])
        {
            xPStr = _spDetailObject.price;
        }else
        {
            xPStr = [NSString stringWithFormat:@"¥%@",_spDetailObject.price];
        }
        
        xianJiaL.text = xPStr;
        xianJiaL.textAlignment = NSTextAlignmentCenter;
        xianJiaL.font = [UIFont systemFontOfSize:15];
        xianJiaL.textColor = RGBCOLOR(221, 54, 58);
        xianJiaL.numberOfLines = 0;
        [view addSubview:xianJiaL];
        [xianJiaL release];
        //商品编码
        x=10;
        y=titleLab.frame.origin.y+titleLab.frame.size.height+5;
        w=300;
        h=20;
        UILabel *bianHaoL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,20))];
        bianHaoL.backgroundColor = [UIColor clearColor];
        bianHaoL.text = [NSString stringWithFormat:@"商品编号：%@",_spDetailObject.goodsid];
        bianHaoL.textAlignment = NSTextAlignmentLeft;
        bianHaoL.font = [UIFont systemFontOfSize:15];
        bianHaoL.textColor = RGBCOLOR(62,62,62);
        bianHaoL.numberOfLines = 0;
        [view addSubview:bianHaoL];
        [bianHaoL release];
#pragma mark-- //商品颜色
        x=10;
        y=bianHaoL.frame.origin.y+bianHaoL.frame.size.height+15;
        w=300;
        h= 35;
         //商品颜色底视图
        UIView *yanSeView = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        yanSeView.backgroundColor = [UIColor clearColor];
        [view addSubview:yanSeView];
        [yanSeView release];
        UILabel *yanSeL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,45,30)];
        yanSeL.backgroundColor = [UIColor clearColor];
        yanSeL.text = @"颜色:";
        yanSeL.textAlignment = NSTextAlignmentLeft;
        yanSeL.font = [UIFont systemFontOfSize:15];
        yanSeL.textColor = RGBCOLOR(62,62,62);
        yanSeL.numberOfLines = 0;
        [yanSeView addSubview:yanSeL];
        [yanSeL release];
        //商品颜色btn
        x=yanSeL.frame.origin.x+yanSeL.frame.size.width;
        y=0;
        w=82;
        h=32;
        _colorArr = [[NSMutableArray arrayWithCapacity:0]retain];
        for (int i=0; i<_spDetailObject.colorandimgs.count; i++)
        {
            UIButton *yansebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            yansebtn.tag = i+yansebtnBaseTag;
            yansebtn.frame = CGRectMake(x,y,w,h);
            NSDictionary *colorObject =  _spDetailObject.colorandimgs[i];
            NSString *colorName = [colorObject objectForKey:@"color"];
            [yansebtn setTitle:(colorName!=nil?colorName:@"") forState:UIControlStateNormal];
            yansebtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [yansebtn setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
            [yansebtn setBackgroundImage:GETIMG(@"mall_button_colour@2x.png") forState:UIControlStateNormal];
            [yansebtn setBackgroundImage:GETIMG(@"mall_button_colour_sel@2x.png") forState:UIControlStateHighlighted];
            [yansebtn setBackgroundImage:GETIMG(@"mall_button_colour_sel@2x.png") forState:UIControlStateSelected];
            [yansebtn addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside];
            [yanSeView addSubview:yansebtn];
            [_colorArr addObject:yansebtn];
            if ((i+1)%3==0)
            {
                if (i!=0)
                {
                    x=yanSeL.frame.origin.x+yanSeL.frame.size.width;
                    y = y+35;
                }else
                {
                    x=yansebtn.frame.origin.x+yansebtn.frame.size.width+5;
                }
            }else
            {
                x=yansebtn.frame.origin.x+yansebtn.frame.size.width+5;
            }
        }
        if (_colorArr.count>0)
        {
            //调整底图高度
            UIButton *colorBtn = (UIButton*)_colorArr[_colorArr.count-1];
            y = colorBtn.frame.origin.y+colorBtn.frame.size.height;
            CGRect yanSeFrame = yanSeView.frame;
            yanSeFrame.size.height = y;
            yanSeView.frame = yanSeFrame;
            //当前被选中的颜色的btn置为选中
            UIButton *btn = _colorArr[_curSelectedColorBtnIndex];
            btn.selected = YES;
            self.curSelectedColor = [btn titleForState:UIControlStateNormal];
            //当前被选中的颜色对应的第一张缩略图
            if (_spDetailObject.colorandimgs.count>0)
            {
                NSDictionary *dic = (NSDictionary*)_spDetailObject.colorandimgs[_curSelectedColorBtnIndex];
                NSArray *arr = [dic objectForKey:@"thumbnailimgs"];
                if (arr.count>0)
                {
                    self.curSelectedColorImage = arr[0];
                }
            }
        }
        
#pragma mark-- //商品尺码
        y = yanSeView.frame.origin.y+yanSeView.frame.size.height+10;
        x=10;
        w=300;
        h= 35;
        //商品尺码底视图
        UIView *chiMaView = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        chiMaView.backgroundColor = [UIColor clearColor];
        [view addSubview:chiMaView];
        [chiMaView release];
        UILabel *chiMaL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,45,30)];
        chiMaL.backgroundColor = [UIColor clearColor];
        chiMaL.text = @"尺码:";
        chiMaL.textAlignment = NSTextAlignmentLeft;
        chiMaL.font = [UIFont systemFontOfSize:15];
        chiMaL.textColor = RGBCOLOR(62,62,62);
        chiMaL.numberOfLines = 0;
        [chiMaView addSubview:chiMaL];
        [chiMaL release];
        
        
        x=chiMaL.frame.origin.x+chiMaL.frame.size.width;
        y=0;
        w=117;
        h=32;
        //找到当前颜色所在NSDictionary
        NSDictionary *colorObject=nil;
        if (_spDetailObject.colorandimgs.count>0)
        {
            for (NSDictionary *colorDic in _spDetailObject.colorandimgs)
            {
                NSString *color = [colorDic objectForKey:@"color"];
                if ([color isEqualToString:self.curSelectedColor])
                {
                    colorObject = colorDic;
                    break;
                }
            }
        }
        [_curColorChiCunArr removeAllObjects];
        //找到当前颜色对应的尺码库存数组
        NSArray *sizeAndStoreArr = [colorObject objectForKey:@"sizeandstore"];
        //找到当前颜色对应的所有尺码
        for (NSDictionary *sizeStoreDic in sizeAndStoreArr)
        {
            NSString *size = [sizeStoreDic objectForKey:@"size"];
            if ((![size isKindOfClass:[NSNull class]])||(size!=nil))
            {
                [_curColorChiCunArr addObject:size];
            }
        }
        //商品尺寸btn
        _chiCunArr = [[NSMutableArray arrayWithCapacity:0]retain];
        for (int i=0; i<_curColorChiCunArr.count; i++)
        {
            UIButton *chiMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chiMaBtn.tag = i+chiMaBtnBaseTag;
            chiMaBtn.frame = CGRectMake(x,y,w,h);
            [chiMaBtn setTitle:_curColorChiCunArr[i] forState:UIControlStateNormal];
            [chiMaBtn setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
            chiMaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size@2x.png") forState:UIControlStateNormal];
            [chiMaBtn setBackgroundImage:GetImage(@"mall_button_size_dis@2x.png") forState:UIControlStateDisabled];
            [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size_sel@2x.png") forState:UIControlStateHighlighted];
            [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size_sel@2x.png") forState:UIControlStateSelected];
            [chiMaBtn addTarget:self action:@selector(chiCunSelected:) forControlEvents:UIControlEventTouchUpInside];
            [chiMaView addSubview:chiMaBtn];
            [_chiCunArr addObject:chiMaBtn];
            if ((i+1)%2==0)
            {
                if (i!=0)
                {
                    x=chiMaL.frame.origin.x+chiMaL.frame.size.width;
                    y = y+35;
                }else
                {
                    x=chiMaBtn.frame.origin.x+chiMaBtn.frame.size.width+8;
                }
            }else
            {
                x=chiMaBtn.frame.origin.x+chiMaBtn.frame.size.width+8;
            }
            //如果一种尺码没有库存就把按钮置灰
            if (i<sizeAndStoreArr.count)
            {
                NSDictionary *sizeStoreDic = [sizeAndStoreArr objectAtIndex:i];
                if ([[sizeStoreDic objectForKey:@"store"] integerValue]==0)
                {
                    chiMaBtn.enabled=NO;
                }else
                {
                    chiMaBtn.enabled=YES;
                }
            }
        }
        if (_chiCunArr.count>0)
        {
            //调整尺码底图高度
            UIButton *chiMaBtn = (UIButton*)_chiCunArr[_chiCunArr.count-1];
            y = chiMaBtn.frame.origin.y+chiMaBtn.frame.size.height;
            CGRect chiMaFrame = chiMaView.frame;
            chiMaFrame.size.height = y;
            chiMaView.frame = chiMaFrame;
            
            //当前尺码不确定，默认选中第一个尺码
            int index=0;
            if (_curColorChiCunArr.count>0)
            {
                if (_curSelectedSize !=nil)
                {//当前尺码已经确认，就选中当前尺码
                    index = [_curColorChiCunArr indexOfObject:_curSelectedSize];
                }
            }
            UIButton *btn = _chiCunArr[(index<_chiCunArr.count)?index:0];
            //尺码可选中的前提是有库存
            if (btn.enabled==YES)
            {
                [self chiCunSelected:btn];
            }else
            {
                btn.selected=NO;
                //如果当前尺寸没有库存，就选中下一个有库存的
                for (UIButton *btn2 in _chiCunArr)
                {
                    if (btn2.enabled==YES)
                    {
                        [self chiCunSelected:btn2];
                        break;
                    }
                }
            }
        }
        
#pragma mark-- //立即购买按钮
        y = chiMaView.frame.origin.y+chiMaView.frame.size.height+10;
        
        UIImage *liJIGouMaiI = [UIImage imageNamed:@"mall_button_buy@2x.png"];
        x=10;
        w=liJIGouMaiI.size.width/2;
        h=liJIGouMaiI.size.height/2;
        //加入购物车动画中的商品小图片
        DSImageView *liJIGouMaiview = [[DSImageView alloc]initWithFrame:CGRectMake(x+w-31, y+2,29,29)];
        self.LiJIGouMaiView = liJIGouMaiview;
        [liJIGouMaiview release];
        liJIGouMaiview.image = [UIImage imageNamed:@"列表小图.png"];
        liJIGouMaiview.hidden = YES;
        [view addSubview:self.LiJIGouMaiView];
        //立即购买按钮
        UIButton *LiJiGouMaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LiJiGouMaiBtn.frame = CGRectMake(x,y,w,h);
        [LiJiGouMaiBtn setBackgroundImage:GETIMG(@"mall_button_buy@2x.png") forState:UIControlStateNormal];
        [LiJiGouMaiBtn setBackgroundImage:GETIMG(@"mall_button_buy_press@2x.png") forState:UIControlStateHighlighted];
        [LiJiGouMaiBtn setBackgroundImage:GETIMG(@"mall_button_buy_dis@2x.png") forState:UIControlStateDisabled];
        [LiJiGouMaiBtn addTarget:self action:@selector(liJiGouMaiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:LiJiGouMaiBtn];
        self.liJiGouMaiBtn=LiJiGouMaiBtn;
        //判断当前颜色尺寸对应有木有库存
        if ([self isCurColorChiCunHasStore])
        {
            LiJiGouMaiBtn.enabled = YES;
        }else
        {
            LiJiGouMaiBtn.enabled = NO;
        }
#pragma mark-- //加入购物车按钮
        UIImage *jiaRuGouWuCheI = [UIImage imageNamed:@"mall_button_add@2x.png"];
        x=LiJiGouMaiBtn.frame.origin.x+LiJiGouMaiBtn.frame.size.width+49;
        w=jiaRuGouWuCheI.size.width/2;
        h=jiaRuGouWuCheI.size.height/2;
        //加入购物车动画中的商品小图片
        DSImageView *imageview = [[DSImageView alloc]initWithFrame:CGRectMake(x+2, y+2,29,29)];
        self.shangPinView = imageview;
        [imageview release];
        imageview.image = [UIImage imageNamed:@"列表小图.png"];
        imageview.hidden = YES;
        [view addSubview:self.shangPinView];
        //加入购物车按钮
        UIButton *JiaRuGouWuCheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        JiaRuGouWuCheBtn.frame = CGRectMake(x,y,w,h);
        [JiaRuGouWuCheBtn setBackgroundImage:GETIMG(@"mall_button_add@2x.png") forState:UIControlStateNormal];
        [JiaRuGouWuCheBtn setBackgroundImage:GETIMG(@"mall_button_add_press@2x.png") forState:UIControlStateHighlighted];
        [JiaRuGouWuCheBtn setBackgroundImage:GETIMG(@"mall_button_add_dis@2x.png") forState:UIControlStateDisabled];
        [JiaRuGouWuCheBtn addTarget:self action:@selector(jiaRuGouWuCheBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:JiaRuGouWuCheBtn];
        self.jiaRuGouWuCheBtn = JiaRuGouWuCheBtn;
        //判断当前颜色尺寸对应有木有库存
         if ([self isCurColorChiCunHasStore])
        {
            JiaRuGouWuCheBtn.enabled = YES;
        }else
        {
            JiaRuGouWuCheBtn.enabled = NO;
        }
#pragma mark-- //优惠套装
        UIImage *xuXianImage=[UIImage imageNamed:@"mall_details_devision line@2x.png"];
        if (_spDetailObject.havesuite==1)//1有权限
        {
            x = 0;
            y = JiaRuGouWuCheBtn.frame.origin.y+JiaRuGouWuCheBtn.frame.size.height+10;
            w = xuXianImage.size.width;
            h = xuXianImage.size.height;
            UIImageView *xuxian1=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
            xuxian1.image=xuXianImage;
            [view addSubview:xuxian1];
            [xuxian1 release];

            UIImageView *arrowView1 = [[UIImageView alloc]initWithFrame:CGRectMake(300,14.5, 9, 15)];
            [arrowView1 setImage:[UIImage imageNamed:@"icon_next@2x.png"]];
            
            y = JiaRuGouWuCheBtn.frame.origin.y+JiaRuGouWuCheBtn.frame.size.height+12;
            x=0;
            w=320;
            h=44;
            UIButton *youHuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            youHuiBtn.frame = CGRectMake(x,y,w,h);
            [youHuiBtn setTitle:@"优惠套装" forState:UIControlStateNormal];
            youHuiBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [youHuiBtn addTarget:self action:@selector(youHuiTaoZHuangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            youHuiBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-237, 0, 0);
            [youHuiBtn setTitleColor:RGBACOLOR(62, 62, 62, 1) forState:UIControlStateNormal];
            youHuiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            youHuiBtn.backgroundColor = RGBACOLOR(255,255,255, 0);
            [youHuiBtn addSubview:arrowView1];
            [view addSubview:youHuiBtn];
            [arrowView1 release];
            
            y = youHuiBtn.frame.origin.y+youHuiBtn.frame.size.height;
        }
        
        x = 0;
        if (_spDetailObject.havesuite==0)
        {
            y = JiaRuGouWuCheBtn.frame.origin.y+JiaRuGouWuCheBtn.frame.size.height+10;
        }
        w = xuXianImage.size.width;
        h = xuXianImage.size.height;
        UIImageView *xuxian2=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        xuxian2.image=xuXianImage;
        [view addSubview:xuxian2];
        [xuxian2 release];
        
#pragma mark--//商品推荐
        UIImageView *arrowView2 = [[UIImageView alloc]initWithFrame:CGRectMake(300,14.5, 9, 15)];
        [arrowView2 setImage:[UIImage imageNamed:@"icon_next@2x.png"]];
        y = y+2;
        x=0;
        w=320;
        h=44;
        UIButton *tuiJianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tuiJianBtn.frame = CGRectMake(x,y,w,h);
        tuiJianBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-237, 0, 0);
        [tuiJianBtn setTitleColor:RGBACOLOR(62, 62, 62, 1) forState:UIControlStateNormal];
        [tuiJianBtn setTitle:@"商品推荐" forState:UIControlStateNormal];
        tuiJianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [tuiJianBtn addTarget:self action:@selector(shangPinTuiJianBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tuiJianBtn addSubview:arrowView2];
        tuiJianBtn.backgroundColor=RGBACOLOR(255,255,255,0);
        [view addSubview:tuiJianBtn];
        [arrowView2 release];
        
        x = 0;
        y = tuiJianBtn.frame.origin.y+tuiJianBtn.frame.size.height;
        w = xuXianImage.size.width;
        h = xuXianImage.size.height;
        UIImageView *xuxian3=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        xuxian3.image=xuXianImage;
        [view addSubview:xuxian3];
        [xuxian3 release];
#pragma mark--//售前咨询
        UIImageView *arrowView3 = [[UIImageView alloc]initWithFrame:CGRectMake(300,14.5, 9, 15)];
        [arrowView3 setImage:[UIImage imageNamed:@"icon_next@2x.png"]];
        x=0;
        y=tuiJianBtn.frame.origin.y+tuiJianBtn.frame.size.height+2;
        w=320;
        h=44;
        UIButton *ziXunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ziXunBtn.frame = CGRectMake(x,y,w,h);
        [ziXunBtn setTitle:@"" forState:UIControlStateNormal];
        ziXunBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [ziXunBtn addTarget:self action:@selector(shouQianZiXunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        ziXunBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-237, 0, 0);
        [ziXunBtn setTitleColor:RGBACOLOR(62, 62, 62, 1) forState:UIControlStateNormal];
        ziXunBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [ziXunBtn addSubview:arrowView3];
        ziXunBtn.backgroundColor = RGBACOLOR(255, 255,255, 0);
        [view addSubview:ziXunBtn];
        [arrowView3 release];
        
        x=10;
        y=14.5;
        w=150;
        h=15;
        ziXunCountL = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [ziXunBtn addSubview:ziXunCountL];
        ziXunCountL.text = [NSString stringWithFormat:@"售前咨询(%i)",_spDetailObject.consults];
        ziXunCountL.textAlignment = NSTextAlignmentLeft;
        ziXunCountL.font = [UIFont systemFontOfSize:15];
        ziXunCountL.textColor = RGBACOLOR(62, 62, 62, 1);
        ziXunCountL.backgroundColor = [UIColor clearColor];
        [ziXunCountL release];
        
        x = 0;
        y = ziXunBtn.frame.origin.y+ziXunBtn.frame.size.height;
        w = xuXianImage.size.width;
        h = xuXianImage.size.height;
        UIImageView *xuxian4=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        xuxian4.image=xuXianImage;
        [view addSubview:xuxian4];
        [xuxian4 release];
        
      
        
        return view;
#pragma mark -- //图文详情
    }else if (self.detailType==tuWen)
    {
        if (_webView==nil)
        {
            UITableView *table = (UITableView*)[self.view viewWithTag:tableViewTag];
            CGRect frame = table.bounds;
            _webView = [[UIWebView alloc] initWithFrame:frame];
            _webView.delegate=self;
            _webView.backgroundColor = RGBACOLOR(242, 242, 242, 1);
            [_webView.scrollView setBounces:NO];
            _webView.scalesPageToFit = YES;
        }
        if (_isRequestTuWenDetailSuccess==NO)
        {
            NSURLRequest *request =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_spDetailObject.imgdetail]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
            [_webView loadRequest:request];
            [request release];
        }
        return _webView;
    }else if(tableView==self.pingLunTable&&self.detailType==pingLun)//
    {
#pragma mark -- //用户评论
        CGFloat x=0;
        CGFloat y=0;
        CGFloat w=MainViewWidth;
        CGFloat h=44;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        view.backgroundColor =  self.view.backgroundColor;
        
        x=10;
        w=300;
        UILabel *countL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,h)];
        countL.backgroundColor = [UIColor clearColor];
        countL.textAlignment = NSTextAlignmentLeft;
        countL.font = [UIFont systemFontOfSize:14];
        countL.textColor = RGBCOLOR(60,60,60);
        countL.text = [NSString stringWithFormat:@"购买评论(%i)",self.userCommentsEntity.count];
        countL.numberOfLines = 1;
        self.commentsCountLabel = countL;
        [view addSubview:countL];
        [countL release];
        
        UIImage *lineImage=[UIImage imageNamed:@"division line.png"];
         x = 0;
         y = 44;
         w = 320;
         h = lineImage.size.height/2;
        UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        lingImageView.image=lineImage;
        [view addSubview:lingImageView];
        [lingImageView release];
        
        return [view autorelease];

    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor=[UIColor clearColor];
    return [view autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_detailType==jianJie&&_isRequestSPDetailEntitySuccess==YES)
    {//商品简介
        return [self heightForHeader];
        
    }else if (_detailType==tuWen)
    {//图文详情
        return MainViewHeight-20-[self getTitleBarHeight]-45;
    }else if (_detailType==pingLun)
    {//用户评论
        return 44;
    }
    return 0;
}
//商品简介页面高度
-(CGFloat)heightForHeader
{
    CGFloat height = 0;
    //商品名高度
    CGFloat h1 = [_spDetailObject.goodsname sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(230, MAXFLOAT)].height;
    //颜色行数
    int colorCount = ((_spDetailObject.colorandimgs.count%3)==0)?_spDetailObject.colorandimgs.count/3:(_spDetailObject.colorandimgs.count/3)+1;
    //颜色高度
    CGFloat h2 = colorCount*32+(colorCount-1)*3;
    //尺寸高度
    NSDictionary *colorObject=nil;
    if (_spDetailObject.colorandimgs.count>0)
    {//当前颜色所在字典
        colorObject = _spDetailObject.colorandimgs[_curSelectedColorBtnIndex];
    }
    //当前颜色对应的尺寸库存数组
    NSArray *sizeAndStoreArr = [colorObject objectForKey:@"sizeandstore"];
    NSMutableArray *sizeArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *sizeStoreDic in sizeAndStoreArr)
    {
        NSString *size = [sizeStoreDic objectForKey:@"size"];
        if ((![size isKindOfClass:[NSNull class]])&&(size!=nil))
        {//筛选
            [sizeArr addObject:size];
        }
    }
    int chiCunArrCount = sizeArr.count;
    //尺寸行数
    int chiCunCount = ((chiCunArrCount%2)==0)?chiCunArrCount/2:(chiCunArrCount/2)+1;
    CGFloat h3 = chiCunCount*32+(chiCunCount-1)*3;
    //尺寸高度
    height = ((_colorImageUrlArr.count==0)?kShangPinTuPianH:kShangPinTuPianH)+5+15+MAX(h1, 30)+5+20+h2+h3+10+30+44+44+44;
    return height+50;
}

#pragma mark -- 判断当前选择的颜色和尺码是否有库存
-(BOOL)isCurColorChiCunHasStore
{
    NSDictionary *colorObject=nil;
    if (_spDetailObject.colorandimgs.count>0)
    {
        for (NSDictionary *colorDic in _spDetailObject.colorandimgs)
        {
            NSString *color = [colorDic objectForKey:@"color"];
            if ([color isEqualToString:self.curSelectedColor])
            {
                colorObject = colorDic;
                break;
            }
        }
    }
    NSArray *sizeAndStoreArr = [colorObject objectForKey:@"sizeandstore"];
    for (NSDictionary *sizeStoreDic in sizeAndStoreArr)
    {
        NSString *size = [sizeStoreDic objectForKey:@"size"];
        if ([size isEqualToString:self.curSelectedSize])
        {
            int size = 0;
            size = [[sizeStoreDic objectForKey:@"store"]intValue];
            return ((size==1)?YES:NO);
        }
    }
    return NO;
}

#pragma mark -- buttonClicked
#pragma mark --售前咨询 点击
-(void)shouQianZiXunBtnClicked:(UIButton*)btn
{
    ShouQianZiXunVC *vc = [[ShouQianZiXunVC alloc]init];
    vc.spId = self.spDetailObject.goodsid;
    [self pushViewController:vc];
    [vc release];
}
#pragma mark --商品推荐 点击
-(void)shangPinTuiJianBtnClicked:(UIButton*)btn
{
    CaiNiXiHuanVC *vc = [[CaiNiXiHuanVC alloc]init];
    vc.spId = _spDetailObject.goodsid;
    [self pushViewController:vc];
    [vc release];
}
#pragma mark --优惠套装 点击
-(void)youHuiTaoZHuangBtnClicked:(UIButton*)btn
{
    DaPeiXiaoShouVC *vc = [[DaPeiXiaoShouVC alloc]init];
    vc.spId = _spDetailObject.goodsid;
    vc.mainSpColor = (self.curSelectedColor==nil)?@"":self.curSelectedColor;
    vc.mainSpSize = (self.curSelectedSize==nil)?@"":self.curSelectedSize;
    [self pushViewController:vc];
    [vc release];
}
#pragma mark --加入购物车按钮点击
-(void)jiaRuGouWuCheBtnClicked:(UIButton*)btn
{
    if (self.curSelectedColor.length==0||self.curSelectedSize.length==0)
    {
        if (self.curSelectedColor.length==0)
        {
            [self addFadeLabel:@"请先选择好颜色"];
            return;
        }
        if (self.curSelectedSize.length==0)
        {
            [self addFadeLabel:@"请先选择好尺寸"];
            return;
        }
    }
    NSMutableDictionary *good = [NSMutableDictionary dictionaryWithCapacity:0];
    [good setObject:self.spDetailObject.goodsid forKey:@"goodsid"];
    [good setObject:self.curSelectedColor forKey:@"color"];
    [good setObject:self.curSelectedSize forKey:@"size"];
    NSArray *goodsList = [NSArray arrayWithObject:good];
    [self addHud:@"请稍后..."];
    [self.request requestDataWithInterface:AddToShoppingCar param:[self AddToShoppingCarParam:goodsList issuit:0] tag:4];
    _carType = jiaRuGouWuChe;
}
#pragma mark --购物车按钮点击
-(void)gouWuCheBtnClicked:(UIButton*)btn
{
    [self popToRoot];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSPDetailShopCarClickedNotification object:nil];
}
#pragma mark --尺寸按钮点击
-(void)chiCunSelected:(UIButton*)btn
{
    for (UIButton *btn in _chiCunArr)
    {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.curSelectedSize = [btn titleForState:UIControlStateNormal];
    //有库存可以购买，没库存不能购买
    if ([self isCurColorChiCunHasStore]==YES)
    {
        self.liJiGouMaiBtn.enabled=YES;
        self.jiaRuGouWuCheBtn.enabled=YES;
    }else
    {
        self.liJiGouMaiBtn.enabled=NO;
        self.jiaRuGouWuCheBtn.enabled=NO;

    }
}
#pragma mark --颜色按钮点击
-(void)colorSelected:(UIButton*)btn
{
    //当前选中颜色按钮索引
    int index = [_colorArr indexOfObject:btn];
    if (index==_curSelectedColorBtnIndex)
    {
        return;
    }
    _curSelectedColorBtnIndex = index;
    
    for (UIButton *btn in _colorArr)
    {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.curSelectedColor = [btn titleForState:UIControlStateNormal];

    
    //当前颜色对应的字典
    NSDictionary *colorDic=nil;
    if (_spDetailObject.colorandimgs.count>index)
    {
        colorDic = (NSDictionary*)_spDetailObject.colorandimgs[index];
        //当前颜色对应的商品小图
        NSArray *thumbnailimgsArr = [colorDic objectForKey:@"thumbnailimgs"];
        //商品小图的第一张图片
        if (thumbnailimgsArr.count>0)
        {
            self.curSelectedColorImage = thumbnailimgsArr[0];
        }
        //刷新显示的商品小图对应到当前颜色
        if (_colorImageUrlArr.count>0)
        {
            [_colorImageUrlArr removeAllObjects];
        }
        [_colorImageUrlArr addObjectsFromArray:thumbnailimgsArr];
    }
    //移除原有尺寸
    if (_curColorChiCunArr.count>0)
    {
        [_curColorChiCunArr removeAllObjects];
    }
    
    if (colorDic!=nil)
    {//尺寸库存数组
        NSArray *sizeAndStoreArr = [colorDic objectForKey:@"sizeandstore"];
        for (NSDictionary *sizeStoreDic in sizeAndStoreArr)
        {
            NSString *size = [sizeStoreDic objectForKey:@"size"];
            if ((![size isKindOfClass:[NSNull class]])||(size!=nil))
            {//筛选
                [_curColorChiCunArr addObject:size];
            }
        }
    }
    [self.tableView reloadData];
}
#pragma mark --立即加入购物车按钮点击
-(void)liJiGouMaiBtnClicked:(UIButton*)bt
{
    if (self.curSelectedColor.length==0||self.curSelectedSize.length==0)
    {
        if (self.curSelectedColor.length==0)
        {
            [self addFadeLabel:@"请先选择颜色"];
            return;
        }
        if (self.curSelectedSize.length==0)
        {
            [self addFadeLabel:@"请先选择尺寸"];
            return;
        }
    }
    NSMutableDictionary *good = [NSMutableDictionary dictionaryWithCapacity:0];
    [good setObject:self.spDetailObject.goodsid forKey:@"goodsid"];
    [good setObject:self.curSelectedColor forKey:@"color"];
    [good setObject:self.curSelectedSize forKey:@"size"];
    NSArray *goodsList = [NSArray arrayWithObject:good];
    [self addHud:@"请稍后..."];
    [self.request requestDataWithInterface:AddToShoppingCar param:[self AddToShoppingCarParam:goodsList issuit:0] tag:4];
    _carType = liJiGouMai;
}
#pragma mark -- 购物车上的数量红点
-(UIView*)hongDianPoint:(CGPoint)point number:(int)count
{
    UIButton *btn = nil;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(point.x, point.y,20,14);
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = RGBCOLOR(251, 66, 55);
    btn.layer.cornerRadius = 6;
    CGFloat fontSize = 0;
    if (count<10)
    {
        fontSize = 13;
    }else if(count>=10&&count<=99)
    {
        fontSize = 11;
    }else
    {
        fontSize = 10;
    }
    NSString *countStr = @"";
    if (count<=99)
    {
        countStr = [NSString stringWithFormat:@"%i",count];
    }else{
        countStr = @"99+";
    }
    [btn setTitle:countStr forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    btn.tag = 0x1234;
    return btn ;
}
//购物车商品数量显示
-(void)setGouWuCheCount:(int)count
{
    if (count<=0)
    {
        self.hongDianView.hidden=YES;
    }else
    {
       self.hongDianView.hidden=NO;
    }
    CGFloat fontSize = 0;
    if (count<10)
    {
        fontSize = 13;
    }else if(count>=10&&count<=99)
    {
        fontSize = 11;
    }else
    {
        fontSize = 10;
    }
    NSString *countStr = @"";
    if (count<=99)
    {
        countStr = [NSString stringWithFormat:@"%i",count];
    }else{
        countStr = @"99+";
    }
    
    [((UIButton*)self.hongDianView) setTitle:countStr forState:UIControlStateNormal];
    [((UIButton*)self.hongDianView) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ((UIButton*)self.hongDianView).titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

//BounceAnimation
- (void) addBounceAnimation:(UIView*)view
{

	SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:@"bounds"];
	bounceAnimation.fromValue = [NSValue valueWithCGRect:view.frame];
	bounceAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0,0,14,20)];
	bounceAnimation.duration = 0.8f;
	bounceAnimation.numberOfBounces = 5;
    
	bounceAnimation.removedOnCompletion = NO;
	bounceAnimation.fillMode = kCAFillModeForwards;
    
	[view.layer addAnimation:bounceAnimation forKey:@"someKey"];
}
//加入购物车动画效果 步骤1
-(void)addToShoppingCarAnimation
{
    UIImageView *goodsView = (UIImageView*)[_carousel itemViewAtIndex:0];
    UIImageView *goodV = (UIImageView*)[goodsView viewWithTag:0x2014];
    self.shangPinView.image = goodV.image;
    self.LiJIGouMaiView.image = goodV.image;
    if (goodV.image==nil)
    {
        self.shangPinView.image = [UIImage imageNamed:@"列表小图.png"];
        self.LiJIGouMaiView.image = [UIImage imageNamed:@"列表小图.png"];
    }
    //购物图像
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    if (_carType==jiaRuGouWuChe)
    {
         transitionLayer.contents = (id)(self.shangPinView.layer.contents);
        transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:self.shangPinView.bounds fromView:self.shangPinView];
    }else
    {
       transitionLayer.contents = (id)(self.LiJIGouMaiView.layer.contents);
        transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:self.LiJIGouMaiView.bounds fromView:self.LiJIGouMaiView];
    }
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
    CGPoint toPoint = CGPointMake(self.gouWuCheBtn.center.x, self.gouWuCheBtn.center.y+20);
    
    if (_carType==jiaRuGouWuChe)
    {
        [movePath addCurveToPoint:toPoint controlPoint1:CGPointMake(transitionLayer.frame.origin.x+80,transitionLayer.frame.origin.y-180) controlPoint2:CGPointMake(self.gouWuCheBtn.center.x,transitionLayer.position.y)];
    }else
    {
       [movePath addCurveToPoint:toPoint controlPoint1:CGPointMake(transitionLayer.frame.origin.x+160,transitionLayer.frame.origin.y-180) controlPoint2:CGPointMake(self.gouWuCheBtn.center.x,transitionLayer.position.y)];
    }
    
    //关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.5f;
    group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses = NO;
    
    [transitionLayer addAnimation:group forKey:@"opacity"];
    [self performSelector:@selector(addGouWuCheFinished:) withObject:transitionLayer afterDelay:0.5f];
}
//加入购物车 步骤2
- (void)addGouWuCheFinished:(CALayer*)transitionLayer
{
    transitionLayer.hidden = YES;
    [transitionLayer removeAllAnimations];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.gouWuCheSpCount] forKey:kGouWuCheGoodsCount];
    //购物车商品数量显示
    self.hongDianView.hidden = NO;
    [self setGouWuCheCount:self.gouWuCheSpCount];
    [self addBounceAnimation:self.hongDianView];
    
    if(_carType==liJiGouMai)
    {
        [self popToRoot];
        [[NSNotificationCenter defaultCenter]postNotificationName:kSPDetailShopCarClickedNotification object:self];
    }
}

#pragma mark -- 分享 收藏
/**********************************************
 ****以下部分 胡鹏 写的
 *********************************************/
- (void)buttonClicked:(UIButton*)btn
{
    switch (btn.tag)
    {
        case fenxiangBtnTag://fenxiang
        {
            NSMutableArray *shareAry = [NSMutableArray arrayWithObjects:@"icon_share_sina.png",@"icon_share_tx.png",
                                    @"icon_share_weixin.png",@"图层 30.png",@"icon_share_message.png",nil];
            NSMutableArray *shareTitleAry = [NSMutableArray arrayWithObjects:@"新浪微博",@"腾讯微博",
                                             @"微信好友",@"微信朋友圈",@"短信分享", nil];
            mySheet.actionSheetStyle = UIActionSheetStyleDefault;
            mySheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
      
            for (int i =0; i<shareAry.count; i++)
            {
                UIImage *sinaImg = GETIMG(@"icon_share_message.png");
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.frame = CGRectMake(30+(sinaImg.size.width+40)*(i%3), 10+i/3*(sinaImg.size.height+30), sinaImg.size.width, sinaImg.size.height);
                shareBtn.tag = 20+i;
                [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
                [shareBtn setBackgroundImage:GETIMG([shareAry objectAtIndex:i]) forState:UIControlStateNormal];
                [mySheet addSubview:shareBtn];
                
                UILabel *titleLabel = [[UILabel alloc]init];
                titleLabel.center  = CGPointMake(shareBtn.center.x,  shareBtn.center.y+shareBtn.bounds.size.height/2+10);
                titleLabel.bounds = CGRectMake(0, 0, sinaImg.size.width, 20);
                titleLabel.font = SYSTEMFONT(12);
                if(i==3)
                {
                    titleLabel.font = SYSTEMFONT(11);
                }
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.text = [shareTitleAry objectAtIndex:i];
                [mySheet addSubview:titleLabel];
                [titleLabel release];
            }
            RootVC *rootView = [RootVC shareInstance];
            [mySheet showInView:rootView.view];
            
            NSLog(@"fenxiang");
        }
            break;
        case shouCangbtnTag://shoucang
        {
            if (!isNotLogin)
            {
                if (_spDetailObject.savestatus==0 &&_isShouCangGuo==NO)
                {
                    if (_spId==nil||_spId.length==0)
                    {
                        return;
                    }
                    [self addHud:@""];
                    [_request requestDataWithInterface:GoodsSaving param:[self GoodsSavingParam:_spDetailObject.goodsid] tag:2];
                }else
                {
                    [self addFadeLabel:@"您已收藏过此商品"];
                }
                
            }else
            {
                LoginViewCtrol *vc = [[LoginViewCtrol alloc]init];
                [self pushViewController:vc];
                [vc release];
            }
            
        }
            break;
        default:
            break;
    }
}
-(void)soucang:(NSNotification*)noti
{
    [self requestDatasource:jianJie];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        aRoot.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}
-(void)shareClick:(UIButton *)btn
{
    [mySheet dismissWithClickedButtonIndex:btn.tag animated:YES];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];//避免在ios7上登录界面一闪而过
    switch (btn.tag) {
        case 20:
        {
            [[SinaWeiBoManager sharedInstance]shareMessageToSinaWithText:[NSString stringWithFormat:@"海澜之家购买的“%@“不错哦。%@（来自海澜之家客户端)",self.spDetailObject.goodsname,self.spDetailObject.shareurl] imageUrlStr:self.curSelectedColorImage];
            
//            //新浪微博
//            SinaWeibo *sinaWeibo=[self sinaweibo];
//            sinaWeibo.delegate=self;
//            if (![sinaWeibo isAuthValid])//YES为有效；NO为无效
//            {
//                [sinaWeibo logIn];
//            }
//            else
//            {
//                //新浪微博
//                ShareToSinaVC *shareView = [[ShareToSinaVC alloc]init];
//                shareView.isSina = YES;
//                shareView.urlString = self.curSelectedColorImage;//提供的连接
//                shareView.fenxiangLianjie = self.spDetailObject.shareurl;
//                shareView.goodName = self.spDetailObject.goodsname;//名字
//                [self pushViewController:shareView];
//                [shareView release];
//            }

//            [SinaWeiBoManager sharedInstance] isAccessibilityElement
            
        }
            break;
        case 21:
        {
            WeiboApi *weiboApi=[self tecentweibo];//分享商品标题、链接、客户端信息和第一张图片
            //腾信
            if(![weiboApi isAuthValid])
            {
                [weiboApi loginWithDelegate:self andRootController:self];
                
            }
            else
            {
                ShareToSinaVC *shareView = [[ShareToSinaVC alloc]init];
                shareView.isTecent = YES;
                shareView.urlString = self.curSelectedColorImage;//提供的连接
                shareView.goodName = self.spDetailObject.goodsname;//名字
                shareView.fenxiangLianjie = self.spDetailObject.shareurl;
                [self pushViewController:shareView];
                [shareView release];
            }
  
        }
            break;
        case 22:
        {
            //微信好友
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
            {
                //带图片压缩
//                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.curSelectedColorImage]]];
//                NSData *imageData = UIImagePNGRepresentation(image);
//                int lengthKb = [imageData length];
//                float kScaleNumber=0.0;
//                NSData *thumbImageData= UIImageJPEGRepresentation(image, kScaleNumber);
//                UIImage *shareImage = [UIImage imageWithData:thumbImageData];
//                if(lengthKb>32)
//                {
//                   kScaleNumber=30.0/lengthKb; 
//                }
//                else
//                {
//                    kScaleNumber = 1;
//                }
         
                //[WeiXinShareVC sendTextContentFiend:self.spDetailObject.goodsname];
//                 [WeiXinShareVC sendImageContent:self.curSelectedColorImage thumImg:shareImage];
                 NSString *string = [NSString stringWithFormat:@"%@,%@,%@",self.spDetailObject.goodsname,self.spDetailObject.shareurl,@"（来自海澜之家客户端)"];
//                [WeiXinShareVC sendTextContentFiend:string];
                 [WeiXinShareVC sendTextContentSection:string];
            }
            else
            {
                
                [WCAlertView showAlertWithTitle:@"提示" message:@"你的设备上还没有安装微信,无法使用此功能。" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                    alertView.labelTextColor=[UIColor blackColor];
                    alertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    nil;
                } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            }
        }
            break;
        case 23:
        {
           
            //微信圈
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
            {

                 NSString *string = [NSString stringWithFormat:@"%@,%@,%@",self.spDetailObject.goodsname,self.spDetailObject.shareurl,@"（来自海澜之家客户端)"];
                [WeiXinShareVC sendTextContentFiend:string];
            }
            else
            {
                
                [WCAlertView showAlertWithTitle:@"提示" message:@"你的设备上还没有安装微信,无法使用此功能。" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                    alertView.labelTextColor=[UIColor blackColor];
                    alertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    nil;
                } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            }
 
        }
            break;
        case 24:
        {
//            NSString *string = [NSString stringWithFormat:@"%@,%@,%@",self.spDetailObject.goodsname,self.spDetailObject.shareurl,@"（来自海澜之家客户端)"];
//            [self showSMSPicker:string];
//短信分享imgdetail
            NSString *string = [NSString stringWithFormat:@"%@,%@,%@",self.spDetailObject.goodsname,self.spDetailObject.shareurl,@"（来自海澜之家客户端)"];
            [self showSMSPicker:string];
        }
            break;
        default:
            break;
    }
}

#pragma mark ----腾讯微博

- (void)DidAuthFailWithError:(NSError *)error
{
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
    
}

- (WeiboApi *)tecentweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.wbapi;
}
-(void)DidAuthFinished:(WeiboApi *)wbapi
{
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
    
    ShareToSinaVC *shareView = [[ShareToSinaVC alloc]init];
    shareView.isTecent = YES;
    shareView.urlString = self.curSelectedColorImage;//提供的连接
    shareView.goodName = self.spDetailObject.goodsname;//名字
    shareView.fenxiangLianjie = self.spDetailObject.shareurl;

    [self pushViewController:shareView];
    [shareView release];
  
}
//短信
-(void)showSMSPicker:(NSString *)content
{
    

    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil)
    {
        
        // Check whether the current device is configured for sending SMS messages
        
        if ([messageClass canSendText])
        {
            [self displaySMSComposerSheet:content];
        }
        else
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"您的设备未设置iMessage账户不能发送短信" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];

            
        }
    }
    else
    {
        
        [WCAlertView showAlertWithTitle:@"确认" message:@"系统版本太低，不支持短信发送功能" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            nil;
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        

    }
    
}

-(void)displaySMSComposerSheet:(NSString *)content

{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
    picker.messageComposeDelegate =self;
    
    NSString *smsBody =[NSString stringWithFormat:@"%@",content] ;
    
    picker.body=smsBody;
    
    [self presentModalViewController:picker animated:YES];
    
    picker.view.backgroundColor= [UIColor whiteColor];
	[picker release];
    
}

#pragma mark ---短信分享代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    switch (result)
	{
		case MessageComposeResultCancelled:
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"短信发送取消" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        }
            
			break;
        case MessageComposeResultSent:
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"短信发送成功" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        }
            
			break;
		case MessageComposeResultFailed:
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"短信发送失败，请稍后重试！" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];

        }
            
			break;
		default:
            break;
	}
    controller.delegate=nil;
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
   // [self dismissModalViewControllerAnimated:YES];
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}
/*****************************************
 ***********以上部分 胡鹏 写的
 *****************************************/

#pragma mark -- webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView addHUDActivityView:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _isRequestTuWenDetailSuccess=YES;
    [webView removeHUDActivityView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _isRequestTuWenDetailSuccess=NO;
    [webView removeHUDActivityView];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    return YES;
}
#pragma mark -
#pragma mark -- iCarousel Datasource Delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.colorImageUrlArr.count;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	NSString* url = nil;
    if ([[self.colorImageUrlArr objectAtIndex:index] isKindOfClass:[NSString class]])
    {
        url = [self.colorImageUrlArr objectAtIndex:index];
    }else
    {
        url = @"";
    }
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0,2.5,kShangPinTuPianH,kShangPinTuPianH-5)];
    bg.image = [UIImage imageNamed:@"mall_details_photo@2x.png"];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(2,2,kShangPinTuPianH-4,kShangPinTuPianH-13.5)];
    [imageview setImageWithURL:[NSURL URLWithString:url] placeholderImage:GetImage(@"")];
    imageview.userInteractionEnabled = YES;
    imageview.tag = 0x2014;
    [bg addSubview:imageview];
	[imageview release];
	return [bg autorelease];
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return INCLUDE_PLACEHOLDERS? 2: 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	UILabel*	label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
	return [label autorelease];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    self.countIndexLabel.text = [NSString stringWithFormat:@"%d/%d",carousel.currentItemIndex+1,carousel.numberOfItems];
}
//查看大图
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    SeeBigPhoneVC* bigPhone = [[SeeBigPhoneVC alloc] init];
    bigPhone.selectIndex = index;
    bigPhone.isCommentViewHide=YES;
    NSDictionary *colorObject=nil;
    if (_spDetailObject.colorandimgs.count>0)
    {//当前颜色所在字典
        colorObject = _spDetailObject.colorandimgs[_curSelectedColorBtnIndex];
    }
    bigPhone.imgs = [colorObject objectForKey:@"imgs"];
    [self pushViewController:bigPhone];
    [bigPhone release];
}
#pragma mark -- pullTableviewDelegate
#pragma mark -- pulltableview delegate
-(void)refreshTable
{
    self.pingLunTable.pullLastRefreshDate = [NSDate date];
    self.pingLunTable.pullTableIsRefreshing = NO;
}
//上啦更新数据再这里加载
-(void)loadMoreDataToTable
{
    self.pingLunTable.pullTableIsLoadingMore = NO;
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _currentPage = 1;
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    [self requestDatasource:pingLun];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if (_isNeedAddPage==YES)
    {
        _currentPage++;
    }
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
    [self requestDatasource:pingLun];
}
#pragma mark -- 浏览纪录保存
-(void)saveSpDetailObject:(GoodDetailEntity*)object
{
    
    if (object.goodsid.length==0||object.goodsname.length==0)
    {
        return;
    }
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *file = [docDir stringByAppendingPathComponent:@"SpDetailEntity.plist"];
    NSMutableArray *tempArr=nil;
    if (tempArr ==nil)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:file])
        {
            tempArr = [NSMutableArray arrayWithContentsOfFile:file];
        }else
        {
            tempArr = [NSMutableArray arrayWithCapacity:0];
        }
    }
    if (tempArr.count>0)
    {
        for (int i=0;i<tempArr.count;i++)
        {
            NSDictionary *dic = (NSDictionary*)tempArr[i];
            NSString *spId = [dic objectForKey:@"id"];
            if ([object.goodsid isEqualToString:spId])
            {
                [tempArr removeObject:dic];
            }
        }
    }
   
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tempDic setObject:object.goodsid forKey:@"id"];
    [tempDic setObject:(object.goodsname==nil)?@"":object.goodsname forKey:@"name"];
    [tempDic setObject:(object.goodscode==nil)?@"":object.goodscode forKey:@"code"];
    [tempDic setObject:(object.price==nil)?@"":object.price forKey:@"price"];
    [tempDic setObject:(self.curSelectedColorImage==nil)?@"":self.curSelectedColorImage forKey:@"image"];
    [tempArr insertObject:tempDic atIndex:0];
    [tempArr writeToFile:file atomically:YES];
}
#pragma mark -- reloadCommentsCountLabel 刷新评论条数
-(void)reloadCommentsCountLabel
{
    self.commentsCountLabel.backgroundColor = [UIColor clearColor];
    self.commentsCountLabel.text = [NSString stringWithFormat:@"购买评论(%i)",self.userCommentsEntity.count];
}
#pragma mark -- UserCommentCellDelegate  用户评论中的小图点击查看大图
-(void)cell:(UserCommentCell *)cell scrollView:(SwipeView *)scrollView clickedAtIndex:(NSInteger)index
{
    SeeBigPhoneVC* bigPhone = [[SeeBigPhoneVC alloc] init];
    bigPhone.selectIndex = index;
    bigPhone.imgs = cell.commentObject.imgarray;
    bigPhone.isCommentViewHide = YES;
    [self pushViewController:bigPhone];
    [bigPhone release];
}
@end
