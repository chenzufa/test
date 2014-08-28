//
//  MIaoShaTuanGouDetailVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS 5
#define ITEM_SPACING 230.0f
#define INCLUDE_PLACEHOLDERS YES

#import "MIaoShaTuanGouDetailVC.h"
#import "DSSegmentControl.h"
#import "LunBoView.h"
#import "UserCommentCell.h"
#import "iCarousel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "ShouQianZiXunVC.h"
#import "CaiNiXiHuanVC.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "PullTableView.h"
#import "WeiboApi.h"
#import "ShareToSinaVC.h"
#import "SeeBigPhoneVC.h"
#import "AppDelegate.h"
#import "UIViewController+Hud.h"
#import "PXAlertView.h"

#define fenxiangBtnTag   0x1111
#define shouCangbtnTag   0x1112
#define tableViewTag     0x9999
#define yansebtnBaseTag  0x2222
#define chiMaBtnBaseTag  0x3333
#define indicatorTag     0x8888
#define kShangPinTuPianH 180
#define kMiaoShaTuaoGouState @"kMiaoShaTuaoGouState"
typedef enum
{
    jianJie=0,
    tuWen=1,
    pingLun
}DetailType;


@interface MIaoShaTuanGouDetailVC ()<UITableViewDelegate,UITableViewDataSource,DSSegmentControlDelegate,LunBoViewDelegate,UIWebViewDelegate,iCarouselDataSource,iCarouselDelegate,PullTableViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,WeiboRequestDelegate,WeiboAuthDelegate,UserCommentCellDelegate>
{
    UIActionSheet *mySheet;//点击分享按钮时弹出

}
@property(nonatomic,retain)NSMutableArray *colorArr;//创建的颜色按钮数组
@property(nonatomic,retain)NSMutableArray *chiCunArr;//当前颜色对应创建的尺寸按钮数组
@property(nonatomic,retain)NSMutableArray *curColorChiCunArr;//当前颜色对应尺寸数组
@property(nonatomic,assign)DetailType detailType;//区分：简介，图文，评论
@property(nonatomic,retain)UIWebView *webView;//加载图文详情
@property(nonatomic,assign)BOOL isRequestTuWenDetailSuccess;//请求图文详情是否成功
@property(nonatomic,retain)NSMutableArray *commentsArr;//评论实体数组
@property(nonatomic,retain)SpecialBuyDetailEntity *spDetailObject;
@property(nonatomic,retain)UITableView *tableView;//显示商品详情
@property(nonatomic,retain)iCarousel *carousel;//显示商品缩略图
@property(nonatomic,retain)DSRequest *request;
@property(nonatomic,assign)NSUInteger currentPage;//请求评论的当前页码
@property(nonatomic,assign)BOOL isRequestCommentSuccess;
@property(nonatomic,retain)PullTableView *pingLunTable;//显示评论的列表
@property(nonatomic,retain)NSMutableArray *colorImageUrlArr;//当前颜色对应商品缩略图数组
@property(nonatomic,retain)WeiboApi *wbapi;
@property(nonatomic,copy)NSString *curSelectedColor;//当前选择的颜色
@property(nonatomic,copy)NSString *curSelectedSize;//当前选择的尺寸
@property(nonatomic,copy)NSString *curSelectedColorImage;//当前选择颜色对应的第一张商品小图
@property(nonatomic,assign)NSUInteger curSelectedColorBtnIndex;//当前选择颜色的索引
@property(nonatomic,retain)UILabel *commentsCountLabel;//显示评论条数
@property(nonatomic,retain)UserCommentsEntity *userCommentsEntity;//用户评论实体
@property(nonatomic,retain)NSTimer *timer;//倒计时用
@property(nonatomic,retain)UILabel *daoJiShiL;//倒计时显示label
@property(nonatomic,retain)UILabel *tuanGouCountLabel;//显示团购数量
@property(nonatomic,retain)UIView *alertView;
@property(nonatomic,retain)UIView *alertViewBg;
@property(nonatomic,assign)BOOL isShouCangGuo;//是否收藏过商品
@property(nonatomic,retain)UILabel *countIndexLabel;//显示商品小图当前滑到第几张
@property(nonatomic,retain)UIImageView *fenXiangShouCangV;//顶部栏上收藏分享的底图
@property(nonatomic,retain)UIButton *shouCangBtn;//收藏按钮
@property(nonatomic,retain)UILabel *tiShiLabel;//没有评论时用来提示用户
@property(nonatomic,assign)BOOL isNeedAddPage;//请求评论加载更多时currentPage是否要加1
@property(nonatomic,assign)BOOL isRequestSPDetailEntitySuccess;//请求商品详情实体是否成功
@property(nonatomic,retain)UIButton *woYaoMiaoBtn;//我要秒 我要团 按钮
@property(nonatomic,assign)BOOL isStart0To1;
@property(nonatomic,retain)UILabel *juLiJieShuLabl;
@end

@implementation MIaoShaTuanGouDetailVC
@synthesize specialEntity;

-(void)dealloc
{
    [_colorArr release];_colorArr=nil;
    [_chiCunArr release];_chiCunArr=nil;
    [_webView release];_webView=nil;
    [_commentsArr release];_commentsArr=nil;
    [_spId release];_spId=nil;
    [_tableView release];_tableView=nil;
    [_spDetailObject release];_spDetailObject=nil;
    [_tableView release];_tableView = nil;
    [_carousel release];_carousel=nil;
    [_request release];_request=nil;
    [_pingLunTable release];_pingLunTable=nil;
    [_colorImageUrlArr release];_colorImageUrlArr = nil;
    [_curSelectedColor release];_curSelectedColor=nil;
    [_curSelectedSize release];_curSelectedSize=nil;
    [_curSelectedColorImage release];_curSelectedColorImage=nil;
    [_commentsCountLabel release];_commentsCountLabel=nil;
    [_userCommentsEntity release];_userCommentsEntity=nil;
    [_timer release];_timer=nil;
    [_daoJiShiL release];_daoJiShiL=nil;
    [_tuanGouCountLabel release];_tuanGouCountLabel=nil;
    [_alertView release];_alertView=nil;
    [_alertViewBg release];_alertViewBg=nil;
    [_countIndexLabel release];_countIndexLabel=nil;
    [_fenXiangShouCangV release];_fenXiangShouCangV=nil;
    [_shouCangBtn release];_shouCangBtn = nil;
    [_tiShiLabel release];_tiShiLabel=nil;
    [_curColorChiCunArr release];_curColorChiCunArr=nil;
    self.specialEntity = nil;
    self.woYaoMiaoBtn=nil;
    self.shopCarGoodEntity=nil;
    self.juLiJieShuLabl=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //胡鹏加的，莫删
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 320, 20)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    [topView release];
    
     [self setTitleString:(_isMiaoSha==1)?@"秒杀详情":@"团购详情"];
     self.view.backgroundColor =RGBCOLOR(242, 242, 242);

    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];

}
-(void)doAfterViewDidLoad
{
    //胡鹏
    if(self.wbapi == nil)
    {
        _wbapi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI] ;
    }
    //子视图创建
    [self initSubview];
    
    _detailType = jianJie;//默认显示商品简介
    _isRequestSPDetailEntitySuccess=NO;
    _isRequestTuWenDetailSuccess=NO;
    _isRequestCommentSuccess=NO;
    _curSelectedColorBtnIndex=0;//默认选中第一种颜色
    _isStart0To1 = NO;
    [self initDataSource];
    [self requestDatasource:jianJie];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(soucang:) name:LoginSuccess object:nil];

}
-(void)initSubview
{
    
    UIImage *rightImage=[UIImage imageNamed:@"mall_details_button@2x.png"];
    CGFloat x = 235;
    CGFloat y = [self getTitleBarHeight]/2.0-rightImage.size.height/4.0;
    CGFloat w = rightImage.size.width/2.0;
    CGFloat h = rightImage.size.height/2.0;
    UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    rightImageView.image=rightImage;
    [self.titleBar addSubview:rightImageView];
    self.fenXiangShouCangV = rightImageView;
    [rightImageView release];
    
    UIButton *fenxiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fenxiangBtn.tag = fenxiangBtnTag;
    fenxiangBtn.frame = CGRectMake(x,y,w/2.0,h);
    [fenxiangBtn setBackgroundImage:GETIMG(@"mall_details_button_share_press@2x.png") forState:UIControlStateHighlighted];
    [fenxiangBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:fenxiangBtn];
    
    x = fenxiangBtn.frame.origin.x+fenxiangBtn.frame.size.width;
    UIButton *shouCangbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shouCangbtn.tag = shouCangbtnTag;
    shouCangbtn.frame = CGRectMake(x,y,w/2.0,h);
    [shouCangbtn setBackgroundImage:GETIMG(@"mall_details_button_collect_press@2x.png") forState:UIControlStateHighlighted];
    [shouCangbtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.shouCangBtn = shouCangbtn;
    [self.titleBar addSubview:shouCangbtn];
    
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
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,y+3, 320, MainViewHeight-20-[self getTitleBarHeight]-45)];
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
    
    PullTableView *pingLunTable = [[PullTableView alloc]initWithFrame:CGRectMake(0,y, 320, MainViewHeight-20-[self getTitleBarHeight]-45)];
    [pingLunTable setBackgroundColor:self.view.backgroundColor];
    pingLunTable.delegate = self;
    pingLunTable.dataSource = self;
    pingLunTable.pullDelegate = self;
    pingLunTable.pullLastRefreshDate = nil;
    pingLunTable.pullArrowImage = [UIImage imageNamed:@""];
    pingLunTable.pullBackgroundColor = RGBCOLOR(245, 245, 245);
    pingLunTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    pingLunTable.pullTextColor = RGBCOLOR(62, 62, 62);
    [self.view addSubview:pingLunTable];
    self.pingLunTable=pingLunTable;
    [pingLunTable release];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    pingLunTable.hidden = YES;
    pingLunTable.tableFooterView  = view2;
    [view2 release];
    
}

-(void)initDataSource
{
    SpecialBuyDetailEntity *object = [[SpecialBuyDetailEntity alloc]init];
    object.goodsid = @"";
    object.goodsname = @"";
    object.goodscode = @"";
    object.originprice = @"";
    object.currentprice = @"";
    object.colorandimgs = [NSArray array];
    object.imgdetail = @"";
    self.spDetailObject = object;
    [object release];
    
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
-(void)requestDatasource:(DetailType)theType
{
    
    if (theType==jianJie)
    {
        [self.tableView addHUDActivityView:@"加载中..."];
        [self.request requestDataWithInterface:GetSpecialBuyDetail param:[self GetSpecialBuyDetailParam:_spId specialtype:(_isMiaoSha==YES)?4:5] tag:1];
    }
    if (theType==pingLun)
    {
        [self.pingLunTable addHUDActivityView:@"加载中..."];

        [self.request requestDataWithInterface:GetUserComments param:[self GetUserCommentsParam:_spId page:_currentPage] tag:3];
    }
}

#pragma mark - 网络请求回调
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
  
    switch (tag)
    {
        case 1://详情实体
        {
            [self hideHud:nil];
            [self.tableView removeHUDActivityView];
            //秒杀团购详情
            SpecialBuyDetailEntity *object = (SpecialBuyDetailEntity*)dataObj;
            self.spDetailObject = object;
            if (_timer==nil)
            {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
            }
            _isRequestSPDetailEntitySuccess=YES;
            [self.tableView reloadData];
            if (_spDetailObject.isstart==1)
            {
                if (_spDetailObject.timeleft>0)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"距离结束" forKey:kMiaoShaTuaoGouState];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }else
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"已结束" forKey:kMiaoShaTuaoGouState];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
            }else
            {
                if (_spDetailObject.timeleft>0&&_spDetailObject.timelast>0)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"距离开始" forKey:kMiaoShaTuaoGouState];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }else
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"已结束" forKey:kMiaoShaTuaoGouState];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
            }
            if(object.timeleft<=0)
            {
              [self addFadeLabel:_isMiaoSha?@"对不起，商品秒杀已结束":@"对不起，商品团购已结束"];
            }
            if (object.savestatus==1)
            {
              self.fenXiangShouCangV.image = [UIImage imageNamed:@"mall_details_button_press@2x.png"];
                [_shouCangBtn setBackgroundImage:GETIMG(@"mall_details_button_collect_@2x.png") forState:UIControlStateHighlighted];
            }
            
        }
            break;
        case 2:// 商品收藏请求
        {
            [self hideHud:nil];

            StatusEntity *object = (StatusEntity*)dataObj;
            if (object.response==1)
            {
                [self addFadeLabel:@"收藏成功"];
                _isShouCangGuo = YES;
                self.fenXiangShouCangV.image = [UIImage imageNamed:@"mall_details_button_press@2x.png"];
                [_shouCangBtn setBackgroundImage:GETIMG(@"mall_details_button_collect_@2x.png") forState:UIControlStateHighlighted];
            }else
            {
                [self addFadeLabel:@"收藏失败,请重试"];
            }
        }
            break;
        case 3:// 用户评论请求
        {
            [self hideHud:nil];
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
                [self.commentsArr addObjectsFromArray:object.usercomments];
            }
            _isNeedAddPage=YES;
            [self.pingLunTable reloadData];
            [self reloadCommentsCountLabel];
            
        }
            break;
        case 4://秒杀购买
        {
            [self hideHud:nil];

            GoodsSettleUpEntity* entity=dataObj;
            if (entity.response==1)
            {
                NSString *myString = [NSString stringWithFormat:@"秒杀订单在下单成功后%i分钟内有效，过时后订单自动被取消，请尽快完成支付",_spDetailObject.paylimit];
                
                [WCAlertView showAlertWithTitle:@"提示" message:myString customizationBlock:^(WCAlertView *alertView)
                 {
                     alertView.style = WCAlertViewStyleDefault;
                     alertView.labelTextColor=[UIColor blackColor];
                     alertView.buttonTextColor=[UIColor blueColor];
                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
                 {
                     NSLog(@"%i",buttonIndex);
                     if (buttonIndex==1)
                     {
                         GoodEntity *object = [[GoodEntity alloc]init];
                         object.goodsid = self.spDetailObject.goodsid;
                         object.goodsimg =self.curSelectedColorImage;
                         object.price = self.spDetailObject.currentprice;
                         object.color = self.curSelectedColor;
                         object.goodsname = self.spDetailObject.goodsname;
                         object.size = self.curSelectedSize;
                         object.isselect =1;
                         object.count = 1;
                         entity.goodslist = [NSArray arrayWithObjects:object, nil];
                         [object release];
                         
                         //秒杀购买
                         OrderFormVC *order = [[OrderFormVC alloc]init];
                         order.orderType = 3;   //1.购物车普通商品2.团购 3.秒杀
                         order.specialBuyEntity = _spDetailObject;
                         order.mySetupEntity = entity;
                         [self pushViewController:order];
                         [order release];

                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"去结算", nil];
            }else if (entity.response==2)
            {
                [self addFadeLabel:entity.failmsg];
            }
            
        }
            break;
        case 5://团购购买
        {
            [self hideHud:nil];

            GoodsSettleUpEntity* entity=(GoodsSettleUpEntity*)dataObj;
            if (entity.response==1)
            {
                GoodEntity *object = [[GoodEntity alloc]init];
                object.goodsid = self.spDetailObject.goodsid;
                object.goodsimg =self.curSelectedColorImage;
                object.price = self.spDetailObject.currentprice;
                object.color = self.curSelectedColor;
                object.goodsname = self.spDetailObject.goodsname;
                object.size = self.curSelectedSize;
                object.isselect =1;
                object.count = [self.tuanGouCountLabel.text intValue];
                entity.goodslist = [NSArray arrayWithObjects:object, nil];
                [object release];
                
                //团购购买
                OrderFormVC *order = [[OrderFormVC alloc]init];
                order.orderType = 2; //1.购物车普通商品2.团购 3.秒杀
                order.specialBuyEntity = _spDetailObject;
                order.mySetupEntity = entity;
                [self pushViewController:order];
                [order release];

            }else if (entity.response==2)
            {
                [self addFadeLabel:entity.failmsg];
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
            [self addFadeLabel:error.domain];
            _isRequestSPDetailEntitySuccess=NO;
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
          [self addFadeLabel:@"秒杀失败，请重试"];
        }
            break;
        case 5:
        {
          [self addFadeLabel:@"团购失败，请重试"];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        case 0://jianjie
        {
            _detailType = jianJie;
            self.pingLunTable.hidden = YES;
            self.tableView.hidden = NO;
            self.tableView.scrollEnabled = YES;
            [self.tableView reloadData];
        }
            break;
        case 1://tuwen
        {
            _detailType = tuWen;
            self.pingLunTable.hidden = YES;
            self.tableView.hidden = NO;
            self.tableView.scrollEnabled = NO;
            [self.tableView reloadData];
            
        }
            break;
        case 2://pinglun
        {
            _detailType = pingLun;
            self.pingLunTable.hidden = NO;
            self.tableView.hidden = YES;
            self.tableView.scrollEnabled = YES;
            if (_isRequestCommentSuccess==YES)
            {
                [self.pingLunTable reloadData];
            }else
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
#pragma mark -- tableviewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
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
            cell.commentObject = _commentsArr[indexPath.row];
        }
        cell.delegate=self;
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
          return [UserCommentCell cellHeight:_commentsArr[indexPath.row]];
        }
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#pragma mark -- //商品简介
    if (self.detailType==jianJie&&tableView==self.tableView&&_isRequestSPDetailEntitySuccess==YES)
    {
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
        
        iCarousel *carouselView = [[iCarousel alloc]initWithFrame:CGRectMake(0,0,MainViewWidth,((_colorImageUrlArr.count==0)?0:kShangPinTuPianH))];
        carouselView.dataSource = self;
        carouselView.delegate = self;
        carouselView.backgroundColor = [UIColor clearColor];
        carouselView.decelerationRate = 0.5;
        carouselView.type = iCarouselTypeCoverFlow2;
        carouselView.scrollEnabled = YES;
        self.carousel = carouselView;
        [view addSubview:self.carousel];
        [carouselView release];
        
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

        
        UIImage *lineImage=[UIImage imageNamed:@"division line.png"];
        CGFloat x = 0;
        CGFloat y = carouselView.frame.origin.y+((_colorImageUrlArr.count==0)?0:kShangPinTuPianH-5);
        CGFloat w = 320;
        CGFloat h = lineImage.size.height/2;
        UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y+5,w,h)];
        lingImageView.image=lineImage;
        lingImageView.hidden=((_colorImageUrlArr.count==0)?YES:NO);
        [view addSubview:lingImageView];
        [lingImageView release];
        
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
        
        x=titleLab.frame.origin.x+titleLab.frame.size.width+10;
        y=titleLab.frame.origin.y;
        w=68;
        h= [_spDetailObject.goodsname sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(230, MAXFLOAT)].height;
        UILabel *xianJiaL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        xianJiaL.backgroundColor = [UIColor clearColor];
        NSString *xPStr = nil;
        if ([_spDetailObject.currentprice  hasPrefix:@"¥"])
        {
            xPStr = _spDetailObject.currentprice;
            if ([_spDetailObject.currentprice  rangeOfString:@"."].location==NSNotFound)
            {
                xPStr = [NSString stringWithFormat:@"%@.00",_spDetailObject.currentprice];
            }
        }else
        {
            xPStr = [NSString stringWithFormat:@"¥%@",_spDetailObject.currentprice];
            if ([_spDetailObject.currentprice  rangeOfString:@"."].location==NSNotFound)
            {
               xPStr = [NSString stringWithFormat:@"¥%@.00",_spDetailObject.currentprice];
            }
        }
        

        xianJiaL.text = xPStr;
        xianJiaL.textAlignment = NSTextAlignmentCenter;
        xianJiaL.font = [UIFont systemFontOfSize:15];
        xianJiaL.textColor = RGBCOLOR(221, 54, 58);
        xianJiaL.numberOfLines = 0;
        [view addSubview:xianJiaL];
        [xianJiaL release];
        
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
        
        x=10;
        y=bianHaoL.frame.origin.y+bianHaoL.frame.size.height+5;
        w=72;
        h= 20;
        UILabel *juLiJieShuL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        juLiJieShuL.backgroundColor = [UIColor clearColor];
        if (_spDetailObject.isstart==1)
        {
            if (_spDetailObject.timeleft>0)
            {
                juLiJieShuL.text = @"距离结束:";
            }else
            {
              juLiJieShuL.text = (_isMiaoSha)?@"秒杀:":@"团购:";
            }
        }else
        {
            if (_spDetailObject.timeleft>0&&_spDetailObject.timelast>0)
            {
              juLiJieShuL.text = @"距离开始:";
            }else
            {
              juLiJieShuL.text = (_isMiaoSha)?@"秒杀:":@"团购:";
            }
        }
        juLiJieShuL.textAlignment = NSTextAlignmentLeft;
        juLiJieShuL.font = [UIFont systemFontOfSize:15];
        juLiJieShuL.textColor = RGBCOLOR(62, 62, 62);
        juLiJieShuL.numberOfLines = 0;
        [view addSubview:juLiJieShuL];
        self.juLiJieShuLabl = juLiJieShuL;
        [juLiJieShuL release];
        //时间
        x=juLiJieShuL.frame.size.width+juLiJieShuL.frame.origin.x+5;
        y=y;
        w=320-x-5;
        h= 20;
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        self.daoJiShiL = timeL;
        timeL.backgroundColor = [UIColor clearColor];
        timeL.text = [self miaoZhuanTime: _spDetailObject.timeleft];
        timeL.textAlignment = NSTextAlignmentLeft;
        timeL.font = [UIFont systemFontOfSize:15];
        timeL.textColor = RGBCOLOR(221,54,58);
        timeL.numberOfLines = 0;
        [view addSubview:timeL];
        [timeL release];
        //原价
        x=10;
        y=timeL.frame.origin.y+timeL.frame.size.height;
        w=300;
        h= 20;
        UILabel *yuanJiaL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        yuanJiaL.backgroundColor = [UIColor clearColor];
        NSString *oPStr = nil;
        if ([_spDetailObject.originprice  hasPrefix:@"¥"])
        {
            oPStr = _spDetailObject.originprice;
        }else
        {
            oPStr = [NSString stringWithFormat:@"¥%@",_spDetailObject.originprice];
        }
        yuanJiaL.text = [NSString stringWithFormat:@"原价:   %@",oPStr];
        yuanJiaL.textAlignment = NSTextAlignmentLeft;
        yuanJiaL.font = [UIFont systemFontOfSize:15];
        yuanJiaL.textColor = RGBCOLOR(150,150,150);
        if ([self.juLiJieShuLabl.text isEqualToString:@"距离结束:"]) {
           yuanJiaL.textColor = RGBCOLOR(62,62,62);
        }
        yuanJiaL.numberOfLines = 0;
        [view addSubview:yuanJiaL];
        [yuanJiaL release];
#pragma mark-- //商品颜色
        x=10;
        y=yuanJiaL.frame.origin.y+yuanJiaL.frame.size.height+15;
        w=300;
        h= 35;
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
          UIButton *colorBtn = (UIButton*)_colorArr[_colorArr.count-1];
          y = colorBtn.frame.origin.y+colorBtn.frame.size.height;
          CGRect yanSeFrame = yanSeView.frame;
          yanSeFrame.size.height = y;
          yanSeView.frame = yanSeFrame;
            //当前被选中的颜色的btn置为选中
            UIButton *btn = _colorArr[_curSelectedColorBtnIndex];
            btn.selected = YES;
            self.curSelectedColor = [btn titleForState:UIControlStateNormal];
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
        _chiCunArr = [[NSMutableArray arrayWithCapacity:0]retain];
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
        NSArray *sizeAndStoreArr = [colorObject objectForKey:@"sizeandstore"];
        for (NSDictionary *sizeStoreDic in sizeAndStoreArr)
        {
            NSString *size = [sizeStoreDic objectForKey:@"size"];
            if ((![size isKindOfClass:[NSNull class]])||(size!=nil))
            {
                [_curColorChiCunArr addObject:size];
            }
        }
        
        for (int i=0; i<_curColorChiCunArr.count; i++)
        {
            UIButton *chiMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chiMaBtn.tag = i+chiMaBtnBaseTag;
            chiMaBtn.frame = CGRectMake(x,y,w,h);
            [chiMaBtn setTitle:_curColorChiCunArr[i] forState:UIControlStateNormal];
            [chiMaBtn setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
            [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size@2x.png") forState:UIControlStateNormal];
            [chiMaBtn setBackgroundImage:GetImage(@"mall_button_size_dis@2x.png") forState:UIControlStateDisabled];
            [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size_sel@2x.png") forState:UIControlStateHighlighted];
            [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size_sel@2x.png") forState:UIControlStateSelected];
            [chiMaBtn addTarget:self action:@selector(chiCunSelected:) forControlEvents:UIControlEventTouchUpInside];
            chiMaBtn.titleLabel.font = [UIFont systemFontOfSize:14];

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
          UIButton *chiMaBtn = (UIButton*)_chiCunArr[_chiCunArr.count-1];
          y = chiMaBtn.frame.origin.y+chiMaBtn.frame.size.height;
          CGRect chiMaFrame = chiMaView.frame;
          chiMaFrame.size.height = y;
          chiMaView.frame = chiMaFrame;
            
            int index=0;
            if (_curColorChiCunArr.count>0)
            {
                if (_curSelectedSize !=nil)
                {
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
#pragma mark-- //我要秒 我要团 按钮
        y = chiMaView.frame.origin.y+chiMaView.frame.size.height+10;
        UIImage *woYaoMiaoImage = [UIImage imageNamed:@"sale_button2_press@2x.png"];
        x=160-woYaoMiaoImage.size.width/4.0;
        w=woYaoMiaoImage.size.width/2;
        h=woYaoMiaoImage.size.height/2;
        UIButton *woYaoMiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        woYaoMiaoBtn.frame = CGRectMake(x,y,w,h);
        if (_isMiaoSha==1)
        {
            [woYaoMiaoBtn setBackgroundImage:[UIImage imageNamed:@"sale_button1@2x.png"] forState:UIControlStateDisabled];
            [woYaoMiaoBtn setBackgroundImage:[UIImage imageNamed:@"sale_button2@2x.png"] forState:UIControlStateNormal];
            [woYaoMiaoBtn setBackgroundImage:[UIImage imageNamed:@"sale_button2_press@2x.png"] forState:UIControlStateHighlighted];
  
        }else
        {
            [woYaoMiaoBtn setBackgroundImage:[UIImage imageNamed:@"sale_button3@2x.png"] forState:UIControlStateDisabled];
            [woYaoMiaoBtn setBackgroundImage:[UIImage imageNamed:@"sale_button4@2x.png"] forState:UIControlStateNormal];
            [woYaoMiaoBtn setBackgroundImage:[UIImage imageNamed:@"sale_button4_press@2x.png"] forState:UIControlStateHighlighted];
        }
        self.woYaoMiaoBtn=woYaoMiaoBtn;
        if (_spDetailObject.isstart==1  && [self isCurColorChiCunHasStore] &&_spDetailObject.timeleft>0)
        {
            woYaoMiaoBtn.enabled = YES;
        }else
        {
            woYaoMiaoBtn.enabled = NO;
        }
        [woYaoMiaoBtn addTarget:self action:@selector(woYaoMiaoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:woYaoMiaoBtn];
        
        UIImage *xuXianImage=[UIImage imageNamed:@"mall_details_devision line@2x.png"];
        x = 0;
        y = woYaoMiaoBtn.frame.origin.y+woYaoMiaoBtn.frame.size.height+10;
        w = xuXianImage.size.width;
        h = xuXianImage.size.height;
        
        UIImageView *xuxian1=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        xuxian1.image=xuXianImage;
        [view addSubview:xuxian1];
        [xuxian1 release];
        
        ////////////////
        UIImageView *arrowView2 = [[UIImageView alloc]initWithFrame:CGRectMake(300,14.5, 9, 15)];
        [arrowView2 setImage:[UIImage imageNamed:@"icon_next@2x.png"]];
        y = woYaoMiaoBtn.frame.origin.y+woYaoMiaoBtn.frame.size.height+10;
        x=0;
        w=320;
        h=44;
        UIButton *tuiJianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tuiJianBtn.frame = CGRectMake(x,y,w,h);
        tuiJianBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-237, 0, 0);
        [tuiJianBtn setTitleColor:RGBACOLOR(62, 62, 62, 1) forState:UIControlStateNormal];
        [tuiJianBtn setTitle:@"商品推荐" forState:UIControlStateNormal];
        tuiJianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [tuiJianBtn addTarget:self action:@selector(tuiJianBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tuiJianBtn addSubview:arrowView2];
        [view addSubview:tuiJianBtn];
        tuiJianBtn.backgroundColor = RGBACOLOR(255,255,255,0);
        [arrowView2 release];
        
        
        x = 0;
        y = tuiJianBtn.frame.origin.y+tuiJianBtn.frame.size.height;
        w = xuXianImage.size.width;
        h = xuXianImage.size.height;
        UIImageView *xuxian3=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        xuxian3.image=xuXianImage;
        [view addSubview:xuxian3];
        [xuxian3 release];
        ///////////////
        
        UIImageView *arrowView1 = [[UIImageView alloc]initWithFrame:CGRectMake(300,14.5, 9, 15)];
        [arrowView1 setImage:[UIImage imageNamed:@"icon_next@2x.png"]];
        
        y = tuiJianBtn.frame.origin.y+tuiJianBtn.frame.size.height;
        x=0;
        w=320;
        h=44;
        UIButton *ziXunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ziXunBtn.frame = CGRectMake(x,y,w,h);
        [ziXunBtn setTitle:@"" forState:UIControlStateNormal];
        [ziXunBtn addTarget:self action:@selector(ziXunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        ziXunBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-237, 0, 0);
        [ziXunBtn setTitleColor:RGBACOLOR(62, 62, 62, 1) forState:UIControlStateNormal];
        ziXunBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        ziXunBtn.backgroundColor = RGBACOLOR(255,255,255,0);
        [ziXunBtn addSubview:arrowView1];
        [view addSubview:ziXunBtn];
        ziXunBtn.userInteractionEnabled = YES;
        [arrowView1 release];
        
        x=10;
        y=14.5;
        w=150;
        h=15;
        UILabel *ziXunCountL = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
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
        UIImageView *xuxian2=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        xuxian2.image=xuXianImage;
        [view addSubview:xuxian2];
        [xuxian2 release];
        //////////////
     
        
        return view;
 
    }else if (self.detailType==tuWen)
    {
#pragma mark -- //图文详情
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
            NSURLRequest *request =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_spDetailObject.imgdetail] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
            [_webView loadRequest:request];
            [request release];
        }
        return _webView;
    }else if(tableView==self.pingLunTable&&self.detailType==pingLun)
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
    {
        return [self heightForHeader];

    }else if (_detailType==tuWen)
    {
        return MainViewHeight-20-[self getTitleBarHeight]-37;
    }else if (_detailType==pingLun)
    {
        return 44;
    }
    return 0;
}
-(CGFloat)heightForHeader
{
    CGFloat height = 0;
    CGFloat h1 = [_spDetailObject.goodsname sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(230, MAXFLOAT)].height;
    int colorCount = ((_spDetailObject.colorandimgs.count%3)==0)?_spDetailObject.colorandimgs.count/3:(_spDetailObject.colorandimgs.count/3)+1;
    CGFloat h2 = colorCount*32+(colorCount-1)*3;
    NSDictionary *colorObject=nil;
    if (_spDetailObject.colorandimgs.count>0)
    {
        colorObject = _spDetailObject.colorandimgs[_curSelectedColorBtnIndex];
    }
    NSArray *sizeAndStoreArr = [colorObject objectForKey:@"sizeandstore"];
    NSMutableArray *sizeArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *sizeStoreDic in sizeAndStoreArr)
    {
        NSString *size = [sizeStoreDic objectForKey:@"size"];
        if ((![size isKindOfClass:[NSNull class]])&&(size!=nil))
        {
            [sizeArr addObject:size];
        }
    }
    int chiCunArrCount = sizeArr.count;
    int chiCunCount = ((chiCunArrCount%2)==0)?chiCunArrCount/2:(chiCunArrCount/2)+1;
    CGFloat h3 = chiCunCount*32+(chiCunCount-1)*3;
    height = ((_colorImageUrlArr.count==0)?kShangPinTuPianH:kShangPinTuPianH)+5+15+MAX(h1, 30)+5+20+20+20+15+h2+h3+10+30+44+44+44;
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
-(void)ziXunBtnClicked:(UIButton*)btn
{
    ShouQianZiXunVC *vc = [[ShouQianZiXunVC alloc]init];
    vc.spId = self.spDetailObject.goodsid;
    [self pushViewController:vc];
    [vc release];
}
#pragma mark --商品推荐 点击
-(void)tuiJianBtnClicked:(UIButton*)btn
{
    CaiNiXiHuanVC *vc = [[CaiNiXiHuanVC alloc]init];
    vc.spId = _spDetailObject.goodsid;
    [self pushViewController:vc];
    [vc release];
}
-(void)chiCunSelected:(UIButton*)btn
{
    for (UIButton *btn in _chiCunArr)
    {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.curSelectedSize = [btn titleForState:UIControlStateNormal];
    if (_spDetailObject.isstart==1  && [self isCurColorChiCunHasStore] &&_spDetailObject.timeleft>0)
    {
        _woYaoMiaoBtn.enabled = YES;
    }else
    {
        _woYaoMiaoBtn.enabled = NO;
    }

}
-(void)colorSelected:(UIButton*)btn
{
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
    NSLog(@"你选择了：%@",[btn titleForState:UIControlStateNormal]);
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
#pragma mark --我要秒 我要团 点击
-(void)woYaoMiaoBtnClicked:(UIButton*)btn
{

    if (isNotLogin)
    {
        LoginViewCtrol *vc = [[LoginViewCtrol alloc]init];
        [self pushViewController:vc];
        [vc release];
    }else
    {
        if (_isMiaoSha==YES)//秒杀
        {
            [self addHud:@"请稍后..."];
            [_request requestDataWithInterface:SpecialbuySettleup param:[self SpecialbuySettleupParam:_spDetailObject.goodsid color:_curSelectedColor size:_curSelectedSize count:1 type:2] tag:4];//2秒杀 1团购
        }
        if (_isMiaoSha==NO)//团购
        {
            if (isBigeriOS7version)
            {
                [PXAlertView showAlertWithTitle:@"请选择数量" message:nil cancelTitle:@"取消" otherTitle:@"去结算" contentView:[self alertSubView:CGPointMake(0,0)] completion:^(BOOL cancelled)
                {
                    if (cancelled==NO)
                    {
                        [self addHud:@"请稍后..."];
                        [_request requestDataWithInterface:SpecialbuySettleup param:[self SpecialbuySettleupParam:_spDetailObject.goodsid color:_curSelectedColor size:_curSelectedSize count:[self.tuanGouCountLabel.text intValue] type:1] tag:5];
                    }
                }];
            
            }else
            {
                [WCAlertView showAlertWithTitle:@"请选择数量" message:@"\n\n" customizationBlock:^(WCAlertView *alertView)
                 {
                     alertView.style = WCAlertViewStyleDefault;
                     alertView.labelTextColor=[UIColor blackColor];
                     alertView.buttonTextColor=[UIColor blueColor];
                     [alertView addSubview:[self alertSubView:CGPointMake(0, 50)]];
                     
                 } completionBlock:^(NSUInteger index,WCAlertView *alertview)
                 {
                     if (index==1)
                     {
                         [self addHud:@"请稍后..."];
                          [_request requestDataWithInterface:SpecialbuySettleup param:[self SpecialbuySettleupParam:_spDetailObject.goodsid color:_curSelectedColor size:_curSelectedSize count:[self.tuanGouCountLabel.text intValue] type:1] tag:5];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"去结算", nil];

            }
        }

    }
}
-(UIView*)alertSubView:(CGPoint)point
{

    UIImage *minusI = GETIMG(@"car_button_reduce_press@2x.png");
    
    UIView *contentV = [[[UIView alloc]initWithFrame:CGRectMake(point.x,point.y, 280, minusI.size.height/2)]autorelease];
    contentV.backgroundColor = [UIColor clearColor];
    
    CGFloat x=(280-(minusI.size.width/2)*3-4*2)/2;
    CGFloat y=0;
    CGFloat w=minusI.size.width/2;
    CGFloat h=minusI.size.height/2;
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusButton setBackgroundImage:GETIMG(@"car_button_reduce_press@2x.png") forState:UIControlStateSelected];
    [minusButton setBackgroundImage:GETIMG(@"car_button_reduce@2x.png") forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    minusButton.frame = CGRectMake(x,y,w,h);
    minusButton.tag = 0x1111;
    [contentV addSubview:minusButton];
    
    x=minusButton.frame.origin.x+minusButton.frame.size.width+4;
    UILabel *countL = [[UILabel alloc]init];
    countL.backgroundColor = RGBCOLOR(235, 235, 235);
    countL.textAlignment = NSTextAlignmentCenter;
    countL.textColor = TEXT_GRAY_COLOR;
    countL.font = SYSTEMFONT(15);
    countL.frame = CGRectMake(x, y,minusI.size.width/2,minusI.size.height/2);
    [countL setText:@"1"];
    countL.layer.cornerRadius = 2;
    [contentV addSubview:countL];
    self.tuanGouCountLabel=countL;
    [countL release];
    
    x=countL.frame.origin.x+countL.frame.size.width+4;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:GETIMG(@"car_button_add_press@2x.png") forState:UIControlStateSelected];
    [addButton setBackgroundImage:GETIMG(@"car_button_add@2x.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(x,y,minusI.size.width/2,minusI.size.height/2);
    addButton.tag = 0x2222;
    [contentV addSubview:addButton];
    
    return contentV;
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
            NSMutableArray *shareAry = [NSMutableArray arrayWithObjects:@"icon_share_sina.png",@"icon_share_tx.png",@"icon_share_weixin.png",@"图层 30.png",@"icon_share_message.png",nil];
            NSMutableArray *shareTitleAry = [NSMutableArray arrayWithObjects:@"新浪微博",@"腾讯微博",@"微信好友",@"微信朋友圈",@"短信分享", nil];
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
        }
            break;
        case shouCangbtnTag://shoucang
        {
            if (!isNotLogin)
            {
                if (_spDetailObject.savestatus==0&&_isShouCangGuo==NO)
                {
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = shouCangbtnTag;
    [self buttonClicked:btn];
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
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    switch (btn.tag) {
        case 20://分享内容可以变价，分享商品标题、链接、客户端信息和第一张图片
        {
            //新浪微博
            [[SinaWeiBoManager sharedInstance]shareMessageToSinaWithText:[NSString stringWithFormat:@"海澜之家购买的“%@“不错哦。%@（来自海澜之家客户端)",self.spDetailObject.goodsname,self.spDetailObject.shareurl] imageUrlStr:self.curSelectedColorImage];
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
                shareView.fenxiangLianjie = self.spDetailObject.shareurl;
                shareView.goodName = self.spDetailObject.goodsname;//名字
                [self pushViewController:shareView];
                [shareView release];
            }
        }
            break;
        case 22://好友
        {
            //微信好友
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
            {
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
        case 23://朋友圈
        {
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
            {
                
                NSString *string = [NSString stringWithFormat:@"%@,%@,%@",self.spDetailObject.goodsname,self.spDetailObject.shareurl,@"（来自海澜之家客户端)"];
                [WeiXinShareVC sendTextContentFiend:string];
//                [WeiXinShareVC sendTextContentSection:string];
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
            //短信分享
            //短信分享imgdetail
            NSString *string = [NSString stringWithFormat:@"%@,%@,%@",self.spDetailObject.goodsname,self.spDetailObject.shareurl,@"（来自海澜之家客户端)"];
            [self showSMSPicker:string];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark--- 腾讯 delegate


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


//#pragma mark - 新浪微博
//- (SinaWeibo *)sinaweibo
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.sinaweibo;
//}

//-(void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
//{
//    ShareToSinaVC *shareView = [[ShareToSinaVC alloc]init];
//    shareView.isSina = YES;
//    
//    shareView.urlString = self.curSelectedColorImage;//提供的连接
//    shareView.goodName = self.spDetailObject.goodsname;//名字
//    shareView.fenxiangLianjie = self.spDetailObject.shareurl;
//
//    [self pushViewController:shareView];
//    [shareView release];
//
//}


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
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];        }
            
			break;
		default:
            break;
	}
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}



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
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0,2.5, kShangPinTuPianH, kShangPinTuPianH-5)];
    bg.image = [UIImage imageNamed:@"mall_details_photo@2x.png"];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(2,2,kShangPinTuPianH-4,kShangPinTuPianH-13.5)];
    [imageview setImageWithURL:[NSURL URLWithString:url] placeholderImage:GetImage(@"")];
    imageview.userInteractionEnabled = YES;
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
#pragma mark -- reloadCommentsCountLabel
-(void)reloadCommentsCountLabel
{
    self.commentsCountLabel.backgroundColor = [UIColor clearColor];
    self.commentsCountLabel.text = [NSString stringWithFormat:@"购买评论(%i)",self.userCommentsEntity.count];
}
#pragma mark -- UserCommentCellDelegate
-(void)cell:(UserCommentCell *)cell scrollView:(SwipeView *)scrollView clickedAtIndex:(NSInteger)index
{
    SeeBigPhoneVC* bigPhone = [[SeeBigPhoneVC alloc] init];
    bigPhone.selectIndex = index;
    bigPhone.imgs = cell.commentObject.imgarray;
    bigPhone.isCommentViewHide = YES;
    [self pushViewController:bigPhone];
    [bigPhone release];
}

#pragma mark -- 秒数转化为shijian
-(NSString*)miaoZhuanTime:(long)miao
{
    if (miao>0)
    {
        int day = miao/(24*60*60);
        int hour = (miao-day*24*60*60)/(60*60);
        int minute = (miao-day*24*60*60-hour*60*60)/60;
        int sencond = (miao-day*24*60*60-hour*60*60-minute*60)%60;
        NSString *time = [NSString stringWithFormat:@"%i天%i时%i分%i秒",day,hour,minute,sencond];
        if (day==0 && hour==0 && minute==0 && sencond==0)
        {
            self.woYaoMiaoBtn.enabled=NO;
            _juLiJieShuLabl.text = (_isMiaoSha)?@"秒杀:":@"团购:";
            CGRect frame = self.daoJiShiL.frame;
            if (frame.origin.x==87) {
                frame.origin.x =57;
            }
            self.daoJiShiL.frame = frame;
            return @"已结束";
        }else
        {
            return time;
        }
    }else
    {
        self.woYaoMiaoBtn.enabled=NO;
        _juLiJieShuLabl.text = (_isMiaoSha)?@"秒杀:":@"团购:";
        CGRect frame = self.daoJiShiL.frame;
        if (frame.origin.x==87) {
            frame.origin.x =57;
        }
        self.daoJiShiL.frame = frame;
        return @"已结束";
    }
}
-(void)daoJiShi
{
    
    self.spDetailObject.timeleft--;
    if (self.spDetailObject.timeleft<=0)
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:kMiaoShaTuaoGouState]isEqualToString:@"距离开始"]&&_isStart0To1==NO)
        {
            _isStart0To1=YES;
            if (self.spDetailObject.timelast>=0)
            {
                self.spDetailObject.timeleft = self.spDetailObject.timelast;
                self.spDetailObject.isstart = 1;
                [self.tableView reloadData];
            }
        }else
        {
            self.spDetailObject.timeleft=0;
            [self.timer invalidate];
        }
    }
    self.daoJiShiL.text = [self miaoZhuanTime:self.spDetailObject.timeleft];
}

-(void)alertHide
{
    [self.alertView removeFromSuperview];
    [self.alertViewBg removeFromSuperview];
}
-(void)alertBtnClicked:(UIButton*)btn
{
    switch (btn.tag)
    {
        case 0x1111://-
        {
            int count = [self.tuanGouCountLabel.text intValue];
            count--;
            if (count<1)
            {
                count=1;
            }
            self.tuanGouCountLabel.text = [NSString stringWithFormat:@"%d",count];
        }
            break;
        case 0x2222://+
        {
            int count = [self.tuanGouCountLabel.text intValue];
            count++;
            self.tuanGouCountLabel.text = [NSString stringWithFormat:@"%d",count];
        }
            break;
        case 0x3333://cancel
        {
            [self alertHide];
        }
            break;
        case 0x4444://jieSuan
        {
            [self alertHide];
            [self requestDatasource:jianJie];
        }
            break;
        default:
            break;
    }
}
@end
