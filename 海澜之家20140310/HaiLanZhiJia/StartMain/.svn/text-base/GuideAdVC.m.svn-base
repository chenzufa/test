//
//  GuideAdVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GuideAdVC.h"
#import "FocusInfoEntity.h"
#import "UIImageView+WebCache.h"
#import "AdLinkVC.h"
@interface GuideAdVC ()<GuideViewDelegate,DSRequestDelegate>{
    GuideView * guideView;
    UIImageView *adView;
    BOOL haveAd;
    BOOL isClick;//用于判断是否要自动跳转.
}

@property(nonatomic,retain)DSRequest *aRequest;
@property(nonatomic,retain)FocusInfoEntity *detail;//广告详情
@property(nonatomic,assign)int time;

@end

@implementation GuideAdVC



- (void)dealloc
{
    SAFETY_RELEASE(guideView);
    SAFETY_RELEASE(adView);
    self.aRequest = nil;
    self.detail = nil;
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
    
    if (isBigeriOS7version){
        self.view.bounds = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
        self.view.backgroundColor = [UIColor clearColor];
    }
    self.titleBar.hidden = YES;
    [self thisWay];
    
   
}
//引导进入
-(void)thisWay
{
    NSUserDefaults *userfault = [NSUserDefaults standardUserDefaults];//有引导图
    if ([userfault objectForKey:@"First"] == nil)
    {
        //存入本地，
        [[NSUserDefaults standardUserDefaults]setObject:@"autoLogin" forKey:@"auto"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [userfault setObject:@"FirstComing" forKey:@"First"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (guideView == nil)
        {
            guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            guideView.delegate = self;
            [self.view addSubview:guideView];
        }
    }
    else{
         [self initData];//是否有广告
//            if(haveAd)//判断是否有广告(点击)
//            {
//                adView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight-20)];
//                adView.userInteractionEnabled = YES;
//                if(![self.detail.imgurl isKindOfClass:[NSNull class]])
//                {
//                    [adView setImageWithURL:[NSURL URLWithString:self.detail.imgurl]];
//
//                }
//                //广告点击时间
//                [self.view addSubview:adView];
//                UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                UIImage *btImage = GetImage(@"点击查看@2x.png");
//                [goBtn setBackgroundImage:btImage forState:UIControlStateNormal];
//                [goBtn setBackgroundImage:GetImage(@"点击查看_press@2x.png") forState:UIControlStateHighlighted];
//                goBtn.frame = CGRectMake(190, MainViewHeight-80, GetImageWidth(btImage), GetImageHeight(btImage));
//                [goBtn addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
//                [adView addSubview:goBtn];
//                //按钮点击进入首yue
//                UIImage *closeImage = GetImage(@"00-02广告_03.png");
//                UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [closeBtn setFrame:CGRectMake(MainViewWidth-GetImageWidth(closeImage), 0, GetImageWidth(closeImage), GetImageHeight(closeImage))];
//                [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
//                [closeBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
//                [adView addSubview:closeBtn];
//                //5s没有点击自动跳转
//                NSLog(@"~~~~~~~~~~~~~%d",isClick);
//                [self performSelector:@selector(delayTime) withObject:nil afterDelay:self.time];
//              //  [self performSelector:@selector(delayTime) withObject:nil afterDelay:5];
//            }
//            else
//            {
//                //没有广告去首页
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil]; 
//            }
        
    }
   
}


-(void)clickView:(UIButton *)button
{
 
    int type = self.detail.type;//广告类型
    int specialType = self.detail.specialtype;//专题类型
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
    [adView removeFromSuperview];
    if(type == 3)//网址
    {
        AdLinkVC *adViewVC = [[AdLinkVC alloc]init];
        adViewVC.urlString = self.detail.weburl;
        [self pushViewController:adViewVC];
        [adViewVC release];
    }
    if(type == 2)//商品
    {
       
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = self.detail.goodsid;
        [self pushViewController:vc];
        [vc release];
        [self initHot:self.detail.goodsid andType:1];
       
    }
    if(type == 1)//活动专题
    {
    
        NSString * specialid = self.detail.specialid;//专题id
        [self initHot:specialid andType:1];//热点统计
        switch (specialType)//活动专题类型
        {
            case 1:
            {
                //宫格
                GongGeVC *gongGeView = [[GongGeVC alloc]init];
                gongGeView.zhuanTiId = specialid;
                [self pushViewController:gongGeView];
                [gongGeView release];
            }
                break;
            case 2:
            {
                //瀑布流
                
                HuoDongListVC *puBuLiuView = [[HuoDongListVC alloc]init];
                puBuLiuView.zhuantiId = specialid;
                [self pushViewController:puBuLiuView];
                [puBuLiuView release];
            }
                break;
            case 3:
            {
                //单图
                SinglePicVC *singleView = [[SinglePicVC alloc]init];
                singleView.zhuantiId = specialid;
                [self pushViewController:singleView];
                [singleView release];
            }
                break;
            case 4:
            {
                //秒杀
                MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
                miaoShaView.specialId = specialid;
                miaoShaView.isMiaoSha = YES;
                [self pushViewController:miaoShaView];
                [miaoShaView release];
            }
                break;
            case 5:
            {
                //团购
                MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
                miaoShaView.specialId = specialid;
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
       
}
//广告
-(void)initData
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:StartupAD param:[self StartupADParam] tag:0];
    [requestObj release];
    
}

//广告热点
-(void)initHot:(NSString *)adId andType:(int)type
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:ADClickReport param:[self ADClickReportParam:adId type:type] tag:1];
    [requestObj release];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    if(tag == 0)
    {
        [self addFadeLabel:@"广告加载失败"];
    }
    if(tag == 1)
    {
        NSLog(@"统计热点失败");
    }
    [self addFadeLabel:error.domain];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
    
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    StartupADEntity* entity = (StartupADEntity *)dataObj;
    if(tag == 0)
    {
        if(entity.havead)//有广告
        {
            haveAd = YES;
            self.detail = entity.detail;//广告详情
            self.time = entity.detail.duration;//广告时间
            adView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight-20)];
            adView.userInteractionEnabled = YES;
//            [adView setContentMode:UIViewContentModeScaleAspectFit];
            UIImage *animationImg = [UIImage imageNamed:@"bg_ip5.png"];
            if(!isIPhone5)
            {
                animationImg = [UIImage imageNamed:@"bg_ip4.png"];
            }
            if(![self.detail.imgurl isKindOfClass:[NSNull class]])
            {
                [adView setImageWithURL:[NSURL URLWithString:self.detail.imgurl]placeholderImage:animationImg];
            }
            [self.view addSubview:adView];
            UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *btImage = GetImage(@"点击查看@2x.png");
            [goBtn setBackgroundImage:btImage forState:UIControlStateNormal];
            [goBtn setBackgroundImage:GetImage(@"点击查看_press@2x.png") forState:UIControlStateHighlighted];
            goBtn.frame = CGRectMake(190, MainViewHeight-80, GetImageWidth(btImage), GetImageHeight(btImage));
            [goBtn addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
            [adView addSubview:goBtn];
            //按钮点击进入首yue
            UIImage *closeImage = GetImage(@"00-02广告_03.png");
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn setFrame:CGRectMake(MainViewWidth-GetImageWidth(closeImage), 0, GetImageWidth(closeImage), GetImageHeight(closeImage))];
            [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
            [adView addSubview:closeBtn];
            //5s没有点击自动跳转
            NSLog(@"~~~~~~~~~~~~~%d",isClick);
            [self performSelector:@selector(delayTime) withObject:nil afterDelay:self.time + 3];// 后台给的广告时间是5秒，+3是为了抵消3秒的启动页时间，启动页开启的同时广告业也开始生成了，被覆盖在启动页下面
        }
        else
        {
             haveAd = NO;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
        }
  
    }
    if(tag == 1)
    {
        NSLog(@"统计坐标OK");
    }
}

-(void)delayTime
{
    [adView removeFromSuperview];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
//    if(!isClick)//没有点击
//    {
//       // [adView removeFromSuperview];
//        //发送通知，改变window的rootview
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
//        
//    }
 //   [self performSelector:@selector(loadHomePage) withObject:nil afterDelay:2];
//    [UIView beginAnimations:nil context:nil];
//    [UIView  setAnimationDelegate:self];
//    [UIView setAnimationDuration:2];
//    adView.alpha = 0.0;
//    [UIView setAnimationDidStopSelector:@selector(loadHomePage)];
//    [UIView commitAnimations];

}

#pragma mark ---GuideView delegate(点击按钮代理)
- (void)guideView:(GuideView *)guideview clickedAtButtonIndex:(NSInteger)index
{
    //欢迎页
    //发送通知，改变window的rootview
    [self performSelector:@selector(delayGiveNote) withObject:nil afterDelay:1];
   
}
#pragma mark ---延迟发送通知(得到动画效果)
-(void)delayGiveNote
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
}

//-(void)loadHomePage
//{
//    if(!isClick)//没有点击
//    {
//        [adView removeFromSuperview];
//        //发送通知，改变window的rootview
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
//  
//    }
//    
//}

//-(void)goHomePage
//{
//   
//    //发送通知，改变window的rootview
//    [adView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
//   
//  
//}

-(void)clickBtn
{
    isClick = YES;
    adView.hidden = YES;
     [adView removeFromSuperview];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"goRoot" object:nil];
   // [self performSelector:@selector(goHomePage) withObject:nil afterDelay:2];
//    [UIView beginAnimations:nil context:nil];
//    [UIView  setAnimationDelegate:self];
//    [UIView setAnimationDuration:2];
//    adView.alpha = 0.0;
//    [UIView setAnimationDidStopSelector:@selector(goHomePage)];
//    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
