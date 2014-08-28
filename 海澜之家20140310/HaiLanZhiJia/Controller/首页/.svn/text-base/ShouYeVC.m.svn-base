//
//  ShouYeVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#import "MiaoShaVC.h"
#import "ShouYeVC.h"
#import "LoginViewCtrol.h"
#import "UIButton+WebCache.h"
#import "PullTableView.h"
#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>
@interface ShouYeVC ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    UIScrollView *scrollView;
   // NSMutableArray *pointArray;
    BOOL isNet1;
    BOOL isNet2;
    BOOL isNet3;
    BOOL isFirstFresh;
    NSMutableArray *focusUrlAry;
    UITableView *shouYeTable;
    BOOL tableIsRefreshing;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIPageControl *myPageControl;
    
    
    
}
@property(nonatomic,retain)NSMutableArray *recommentAry;
@property(nonatomic,retain)NSMutableArray *focusAry;
@property(nonatomic,retain)NSMutableArray *listAry;
@property(nonatomic,retain)UIView *failView;
@property(nonatomic,retain)NSString *dateStr;
@property(nonatomic,retain)UIScrollView *lunboScroView;
@end

@implementation ShouYeVC


- (void)dealloc
{
    [focusUrlAry release];
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    self.recommentAry = nil;
    if(_failView)
    {
        [_failView release];
    }
    self.focusAry = nil;
    self.failView = nil;
    self.lunBoView = nil;
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //点击事件
    CGPoint aPoint = [touch locationInView:self.view];
    NSLog(@"%f",shouYeTable.contentOffset.y);//偏移量
    CGPoint btnPoint = CGPointMake(aPoint.x*2, (aPoint.y+shouYeTable.contentOffset.y)*2);
    NSNumber *Xnumber = [NSNumber numberWithFloat:btnPoint.x];
    NSNumber *Ynumber = [NSNumber numberWithFloat:btnPoint.y];
    NSDictionary *pointDic = [NSDictionary dictionaryWithObjectsAndKeys:Xnumber,@"hotclick_x",Ynumber,@"hotclick_y", nil];
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointAry"];//获取存放热点坐标的数组
    NSMutableArray *array1 = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
    if(array)
    {
        [array1 addObjectsFromArray:array];
    }
    [array1 addObject:pointDic];
    [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:@"pointAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"handleSingleTap!gesturePoint:%f,y:%f",btnPoint.x,btnPoint.y);
    
    // 过滤按钮事件
    if([touch.view isKindOfClass:[UIButton class]] )
    {
        return NO;
    }
    return YES;
}


#pragma mark ----------table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *titleImageview = (UIImageView *)[self.titleBar viewWithTag:789];
    [titleImageview setImage:GetImage(@"APP店招--首页@2x.jpg")];
    isFirstFresh = YES;
    
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    shouYeTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20-BOTTOMHEIGHT)] autorelease];
    if(isIPhone5)
    {
        shouYeTable.frame = CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT);
    }
    [shouYeTable setBackgroundColor:VIEW_BACKGROUND_COLOR];
    shouYeTable.tableFooterView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    shouYeTable.delegate = self;
    shouYeTable.showsVerticalScrollIndicator = NO;
    shouYeTable.dataSource = self;
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    if(!_refreshHeaderView)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                              CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                         self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [shouYeTable addSubview:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    
   //    [shouYeTable setContentOffset:CGPointMake(0,-75) animated:YES];
//    [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView];
    
    
    [ shouYeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:shouYeTable];
    
//    UIImage *titleImage = GetImage(@"海蓝之家_logo.png");
//    UIImageView *titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GetImageWidth(titleImage), GetImageHeight(titleImage))];
//    titleView.center = CGPointMake(self.titleBar.center.x, self.titleBar.center.y);
//    titleView.image =titleImage;
//    [self.titleBar addSubview:titleView];
//    [titleView release];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self initData];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pointAry"]);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.view addGestureRecognizer:tapGes];
    tapGes.delegate = self;
    [tapGes release];
    [tapGes setNumberOfTapsRequired:1];//点击次数
    
    [self.leftButton setHidden:YES];
    [self.rightButton setHidden:YES];
    
}



-(void)initData
{
     [self addHud:Loading];
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:FocusInfo param:[self FocusInfoParam] tag:0];
    [requestObj release];
 
}


-(void)initFailView
{
    if (self.failView==nil)
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
        //btn.layer.borderWidth=1;
        //btn.layer.borderColor=RGBCOLOR(162, 162, 162).CGColor;
        //btn.layer.cornerRadius=5;
        [_failView addSubview:btn];
    
}


-(void)refreshDataWhenFailRequest
{
    [self initData];
}

#pragma mark ---DSRequest delegate
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    if(tag ==0)
    {   isNet1 = NO;
       // [self.aRequest requestDataWithInterface:GetSpecialList param:[self GetSpecialListParam] tag:1];
    }
    if(tag == 1)
    {
        isNet2 = NO;
      //  [self.aRequest requestDataWithInterface:RecommendGoods param:[self RecommendGoodsParam] tag:2];
    }
    if(tag ==2)
    {
        isNet3 = NO;
    }
    if(tag ==4)
    {
        NSLog(@"统计失败");
    }
    if(!isNet3&&!isNet2&&!isNet1&&isFirstFresh)//第一次如果没有网络就添加initFailView，以后刷新的时候没有网络就保持上一次的数据
    {
        if(self.focusAry.count==0&&self.listAry.count==0&&self.recommentAry.count==0)//有缓存
        {
            [self initFailView];
 
        }
       
    }
    [self hideHud:nil];
    [self addFadeLabel:error.domain];
}

#pragma mark --requestDataSuccess
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
   

    switch (tag) {
        case 0:
        {
            self.focusAry = (NSMutableArray *)dataObj;
            focusUrlAry = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i=0 ; i<self.focusAry.count; i++)
            {
                FocusInfoEntity *entity =  [self.focusAry objectAtIndex:i];
                [focusUrlAry addObject:entity.imgurl];
            }
            
            [self initLunboView];//创建轮播视图
          //  [self performSelector:@selector(initLunboView) withObject:nil afterDelay:0.1];
            [self.aRequest requestDataWithInterface:GetSpecialList param:[self GetSpecialListParam] tag:1];
        }
            break;
        case 1:
        {
            self.listAry = (NSMutableArray *)dataObj;//专题数组
         //   [self initSpecView];//创建专题视图
            [self performSelector:@selector(initSpecView) withObject:nil afterDelay:0.1];

            [self.aRequest requestDataWithInterface:RecommendGoods param:[self RecommendGoodsParam] tag:2];
        }
            break;
        case 2:
        {
             self.recommentAry = (NSMutableArray *)dataObj;//推荐数组
            [self performSelector:@selector(initSwipView) withObject:nil afterDelay:0.1];

            // [self initSwipView];//创建推荐视图
        }
            break;
        case 4:
        {
            NSLog(@"统计热点坐标ok");
        }
            break;
            
        default:
            break;
    }
}

-(void)clicked1:(UIButton*)sender
{
    LoginViewCtrol *loginView = [[LoginViewCtrol alloc]init];
    [self pushViewController:loginView];
    [loginView release];

}




#pragma mark ---初始化UI

-(void)initSwipView
{

    int hupeng = 0;//当小于4的时候第二行格子要隐藏位置变化
    if(self.listAry.count<4)
    {
        hupeng = 100;
    }
    
    UIButton *lastBtn = (UIButton *)[scrollView viewWithTag:self.listAry.count - 1 + 20];
    SwipeView *spv = [[SwipeView alloc]initWithFrame: CGRectMake(20, lastBtn.frame.origin.y + lastBtn.frame.size.height + 40, 320-40, 100)];
    spv.wrapEnabled = YES;
//    [spv setBackgroundColor:[UIColor redColor]];
    self.oneScroView = spv;

   // scrollView.contentSize = CGSizeMake(MainViewWidth, spv.frame.origin.y + spv.frame.size.height + 20);
    scrollView.contentSize = CGSizeMake(MainViewWidth, spv.frame.origin.y + spv.frame.size.height +40);
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.contentSize.width, scrollView.contentSize.height);
    scrollView.scrollEnabled = NO;
    
    [spv release];
    self.oneScroView.pagingEnabled=YES;
    self.oneScroView.currentItemIndex=0;
    self.oneScroView.bounces=YES;
    self.oneScroView.dataSource=self;
    self.oneScroView.delegate=self;
    
    [scrollView addSubview:self.oneScroView];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag=10;
    UIImage *leftImage=[UIImage imageNamed:@"home_icon_left.png"];
    leftBtn.frame=CGRectMake(0, 856/2+30-70-hupeng, 20, 40);
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:leftBtn];
    
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag=11;
    
    UIImage *rightImage=[UIImage imageNamed:@"home_icon_right.png"];
    rightBtn.frame=CGRectMake(300, 856/2+30-70-hupeng, 20, 40);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
   // [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(rightImage.size.height, rightImage.size.width, rightImage.size.height, rightImage.size.width)];
    [rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:rightBtn];
    if(self.recommentAry.count<4)
    {
        leftBtn.hidden = YES;
        rightBtn.hidden = YES;
        spv.scrollEnabled = NO;
    }
}

-(void)initLunboView
{
    if(_failView)
    {
        [_failView removeFromSuperview];
    }
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = VIEW_BACKGROUND_COLOR;
        scrollView.frame = CGRectMake(0, 0, 320, MainViewHeight-TITLEHEIGHT-20);
        scrollView.showsVerticalScrollIndicator = NO;
        shouYeTable.tableHeaderView = scrollView;
        
        // [scrollView removeFromSuperview];//子类也会移除
    }
    for (UIView *subView in scrollView.subviews)       //当下拉刷新的时候避免重叠
    {
        [subView removeFromSuperview];
    }
    
    
    self.lunBoView =[[[LunBoView alloc]initWithFrame:CGRectMake(0,0, 320,140)] autorelease];
    self.lunBoView.delegate = self;
    //设置默认图
    [scrollView addSubview:self.lunBoView];
    [self.lunBoView setLunBoImage:focusUrlAry];
    [self.lunBoView start];
}


-(void)initSpecView
{
    for(int i=0;i<2;i++)
    {
        NetImageView *verView = [[NetImageView alloc]initWithFrame:CGRectMake(214/2+(214/2)*i, 409/2-44-15, 1, (838-409)/2)];
        UIImage *verImage=[UIImage imageNamed:@"home_lin1.png"];
        verView.image=verImage;
        [scrollView addSubview:verView];
       
        
        NetImageView *horView=[[NetImageView alloc]initWithFrame:CGRectMake(0, 624/2+(838-624)/2*i-44-15, 320, 1)];
        UIImage *horImage=[UIImage imageNamed:@"home_lin2.png"];//横
        horView.image=horImage;
        [scrollView addSubview:horView];
        [horView release];
        
        if(self.listAry.count<4)//显示一行
        {
            verView.frame = CGRectMake(214/2+(214/2)*i, 409/2-44-15, 1, (838-409)/4);
            if(i==1)
            {
                horView.hidden = YES;
            }
        }
         [verView release];
    }
    
    //6个钻题
    for (int i=0; i<self.listAry.count; i++)
    {
        
        SpecialEntity* entity = [self.listAry objectAtIndex:i];//专题实体
        
        UIButton *iconButton=[UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.frame = CGRectMake(52/2+(110/2+50)*(i%3), 436/2+i/3*(110/2+50)-44-15, 110/2, 110/2);
        iconButton.tag = i+20;
        iconButton.backgroundColor=[UIColor clearColor];
        [iconButton setImageWithURL:[NSURL URLWithString:entity.imgurl]
                           forState:UIControlStateNormal placeholderImage:GetImage(@"列表小图.png")];
      
        iconButton.adjustsImageWhenHighlighted = NO;
        [scrollView addSubview:iconButton];
        [iconButton addTarget:self action:@selector(clickMybtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.font=[UIFont systemFontOfSize:10];
        titleLable.textColor = RGBCOLOR(38, 53, 70);
        titleLable.center = CGPointMake(iconButton.center.x, iconButton.center.y+iconButton.bounds.size.height/2+10);
        
        titleLable.bounds = CGRectMake(0, 0, 214/2-15, 20);

        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.text = entity.title;
        [scrollView addSubview:titleLable];
        [titleLable release];
        
        UILabel *detailLable = [[UILabel alloc]init];
        detailLable.font = [UIFont systemFontOfSize:8];
        detailLable.center = CGPointMake(iconButton.center.x, iconButton.center.y+iconButton.bounds.size.height/2+25);
        detailLable.bounds = CGRectMake(0, 0, 214/2-15, 15);
        detailLable.textAlignment = NSTextAlignmentCenter;
        detailLable.backgroundColor = [UIColor clearColor];
        detailLable.textColor = RGBCOLOR(137, 137, 137);
        if(![entity.subtitle isKindOfClass:[NSNull class]])
        {
            detailLable.text = entity.subtitle;
        }
        
        [scrollView addSubview:detailLable];
        [detailLable release];
        
    }

}

#pragma mark --活动点击按钮
-(void)clickMybtn:(UIButton *)btn
{
    //获得点击坐标
    
    SpecialEntity* entity = [self.listAry objectAtIndex:btn.tag-20];
    int type = entity.specialtype;
    NSString *title = entity.title;
    NSString * idString = entity.specialid;//专题id
    NSLog(@"~~~~~%@",title);
    //专题<=6
    switch (type) {
        case 1:
        {
            //宫格
            GongGeVC *gongGeView = [[GongGeVC alloc]init];
         //   gongGeView.strTitle = title;
            gongGeView.zhuanTiId = idString;
            [self pushViewController:gongGeView];
            [gongGeView release];
        }
            break;
        case 2:
        {
            //瀑布流
            HuoDongListVC *puBuLiuView = [[HuoDongListVC alloc]init];
         //   puBuLiuView.strTitle = title;
            puBuLiuView.zhuantiId = idString;
            [self pushViewController:puBuLiuView];
            [puBuLiuView release];
        }
            break;
        case 3:
        {
            //单图
            SinglePicVC *singleView = [[SinglePicVC alloc]init];
            //singleView.strTitle = title;
            singleView.zhuantiId = idString;
            [self pushViewController:singleView];
            [singleView release];
        }
            break;
        case 4:
        {
            //秒杀
            MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
            miaoShaView.isMiaoSha = YES;
            miaoShaView.specialId = idString;
            [self pushViewController:miaoShaView];
            [miaoShaView release];
        }
            break;
        case 5:
        {
            //团购
            MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
            miaoShaView.specialId = idString;
            miaoShaView.isMiaoSha = NO;
            [self pushViewController:miaoShaView];
            [miaoShaView release];
        }
            
        case 6:
        {
            //未知
           
        }

            break;
            
        default:
            break;
    }

}


#pragma mark ---点击轮播
- (void)clickLunBoImgDelegateAction:(int)img_index
{
    NSLog(@"!!!!!%d",img_index);
    FocusInfoEntity *entity =  [self.focusAry objectAtIndex:img_index];//当前焦点实体
    NSString *typeId = entity.specialid;
    int type = entity.type;
    NSString *adAd = nil;
    if(type == 3)//网址
    {   //无id
        AdLinkVC *adView = [[AdLinkVC alloc]init];
        adView.urlString = entity.weburl;
        [self pushViewController:adView];
        [adView release];
    }
    if(type == 2)//商品
    {
        adAd = entity.goodsid;
        [self initHot:adAd andType:2];
      //  [self.aRequest requestDataWithInterface:ADClickReport param:[self ADClickReportParam:adAd type:2] tag:4];
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = entity.goodsid;
        [self pushViewController:vc];
        [vc release];
    }
    if(type == 1)//活动专题
    {
        //专题id
      //  adAd = entity.specialid;
        [self initHot:typeId andType:2];
   //     [self.aRequest requestDataWithInterface:ADClickReport param:[self ADClickReportParam:typeId type:2] tag:4];
        NSLog(@"%d",entity.specialtype);
        switch (entity.specialtype )//活动专题类型
        {
            case 1:
            {
                //宫格
                GongGeVC *gongGeView = [[GongGeVC alloc]init];
                gongGeView.zhuanTiId = typeId;
                [self pushViewController:gongGeView];
                [gongGeView release];
            }
                break;
            case 2:
            {
                //瀑布流
                HuoDongListVC *puBuLiuView = [[HuoDongListVC alloc]init];
                puBuLiuView.zhuantiId = typeId;
                [self pushViewController:puBuLiuView];
                [puBuLiuView release];
            }
                break;
            case 3:
            {
                //单图
                SinglePicVC *singleView = [[SinglePicVC alloc]init];
                singleView.zhuantiId = typeId;
                [self pushViewController:singleView];
                [singleView release];
            }
                break;
            case 4:
            {
                //秒杀
                MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
                miaoShaView.specialId = typeId;
                miaoShaView.isMiaoSha = YES;
                [self pushViewController:miaoShaView];
                [miaoShaView release];
            }
                break;
            case 5:
            {
                //团购
                MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
                miaoShaView.isMiaoSha = NO;
                miaoShaView.specialId = typeId;
                [self pushViewController:miaoShaView];
                [miaoShaView release];
            }
                break;
                
            default:
                break;
        }
        
    }
   
}

#pragma mark ----点击按钮滑动(类scrollview)
-(void)clickBtn:(UIButton *)btn
{
    int firstIndex=self.oneScroView.currentItemIndex;//当前页的第一个序号
    NSLog(@"current:%d",firstIndex);
        if(btn.tag == 11)
       {
           if(firstIndex==self.recommentAry.count-1)
           {
               [self.oneScroView scrollToItemAtIndex:0 duration:0.5];
 
           }
           else
           {
               [self.oneScroView scrollToItemAtIndex:firstIndex+1 duration:0.5];
 
           }
    }
       if(btn.tag == 10)
       {
           if(firstIndex == 0)
           {
             [self.oneScroView scrollToItemAtIndex:self.recommentAry.count-1 duration:0.5];
           }
           else
           {
             [self.oneScroView scrollToItemAtIndex:firstIndex-1 duration:0.5];
           }
           
       }
 
    
}

#pragma mark ----SwipeView delegate

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.recommentAry.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    GoodEntity *goodEntity = [self.recommentAry objectAtIndex:index];
    view = [[[UIView alloc] initWithFrame:CGRectMake(30.0f, 5.0f,95.0f,80.0f)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(0, 0, 78, 80)];
//    [btn setBackgroundImage:[UIImage imageNamed:@"列表小图.png"] forState:UIControlStateNormal];
//    [btn setImageWithURL:[NSURL URLWithString:goodEntity.goodsimg] forState:UIControlStateNormal placeholderImage:nil];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 5, 2)];
//    [view addSubview:btn];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 88, 88)];//背景图
    bgView.image = [UIImage imageNamed:@"列表小图.png"];
    bgView.userInteractionEnabled = YES;
    [view addSubview:bgView];
     UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2.0f, 2.0f, 84.0f, 80.0f)];
    imageView.tag = 0x1001;
    [bgView addSubview:imageView];
     [imageView setImageWithURL:[NSURL URLWithString:goodEntity.goodsimg] placeholderImage:nil];
     [imageView release];
    [bgView release];
    return view;

}

- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView
{
    NSLog(@"开始");
}
- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束");
}


- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"~index~~~~~~~~~~%d",index);    
    GoodEntity* entity = [self.recommentAry objectAtIndex:index];
 //   [self.aRequest requestDataWithInterface:ADClickReport param:[self ADClickReportParam:entity.goodsid type:3] tag:4];
    [self initHot:entity.goodsid andType:3];
    ShangPingDetailVC *shangpinView = [[ShangPingDetailVC alloc]init];
    shangpinView.spId = entity.goodsid;
    [self pushViewController:shangpinView];
    [shangpinView release];
    
}


-(void)initHot:(NSString *)adId andType:(int)type
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:ADClickReport param:[self ADClickReportParam:adId type:type] tag:4];
    [requestObj release];
}

#pragma mark ------------------------------------EgofreshDelegate
-(void)refreshTableViewData
{
    isFirstFresh = NO;
    [self initData];
    tableIsRefreshing = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:shouYeTable];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView1];
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
//    int page = self.lunboScroView.contentOffset.x/320;
//    //更新页数
//    myPageControl.currentPage = page;
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView1];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    tableIsRefreshing = YES;
    [self performSelector:@selector(refreshTableViewData) withObject:nil afterDelay:2.0];
}


-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return tableIsRefreshing;
}


-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
