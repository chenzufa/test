//
//  RootVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define BUTTONADDTAG 500

#import "RootVC.h"
#import "MyWardrobeVC.h"
#import "ShouYeVC.h"
#import "GouWuCheVC.h"
#import "ShangChenVC.h"
#import "SouSuoVC.h"
#import "ShangChengZhanKaiVC.h"
#import <MapKit/MapKit.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>
#import "GetCityID.h"
#import "NSString+GetProvinceid.h"

@interface RootVC ()<CLLocationManagerDelegate>{
    UIImageView *_actionView;
    CLLocationManager *_locationManger;
    
}

@property(nonatomic,retain)NSString *anonymityid;
@property(nonatomic,retain)NSString * deceiveToken;//推送token
@property(nonatomic,retain)DSRequest *aRequest;
@property(nonatomic,retain)NSString *loginType;
@property(nonatomic,retain)NSString * proviceName;
@end

@implementation RootVC
@synthesize currentIndex = _currentIndex;
@synthesize contentView;
@synthesize vcArray;

- (void)dealloc
{
    self.deceiveToken = nil;
    self.anonymityid = nil;
    SAFETY_RELEASE(r_rootInstance);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

+(id)shareInstance
{
    if (nil == r_rootInstance) {
        r_rootInstance = [[RootVC alloc] init];
    }
    return r_rootInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//自动登陆
-(void)autoLogin
{
    //上次登陆用户的信息
   // self.loginType = [[NSUserDefaults standardUserDefaults] objectForKey:@"logintype"];
    NSString *userName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginData"] objectForKey:@"userName"];
    NSString *userPwd = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginData"] objectForKey:@"userPwd"];//普通  新浪 qq :token
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;
    [requestObj requestDataWithInterface:AutoLogin param:[self AutoLoginParam:userName autologinToken:userPwd] tag:0];
    [requestObj release];
    
}


-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败%@",error);
    switch (tag) {
        case 0:
        {
        }
            break;
        case 1:
        {
            
        }
            break;

        case 2:
        {
            
        }
            break;

        case 3:
        {
            NSLog(@"开启推送失败");
        }
            break;

        default:
            break;
    }
   // [self addHud:@"网络连接失败"];
   // [self hideHud:nil];
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    
    if(tag==3)//推送
    {
        StatusEntity* entity = (StatusEntity *)dataObj;
        if(entity.response == 1)
        {
            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~注册，登录，自动登录,匿名用户自动登录 开启或关闭推送成功");
        }
        if(entity.response == 2)
        {
           NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~注册，登录，自动登录,匿名用户自动登录 开启或关闭推送失败"); 
        }
        return;
    }
   
        switch (tag) {
            
            case 0://自动登陆
            {
                
                RegisterLoginEntity *entitry = (RegisterLoginEntity *)dataObj;
                
                //设置个数
                [RootVC setNumber:entitry.totalcount ofIndex:3];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:entitry.totalcount] forKey:kGouWuCheGoodsCount];
                NSLog(@"!!!!%@",entitry);
                NSLog(@"自动登陆成功");
                //是否登录
                [[NSUserDefaults standardUserDefaults] setObject:entitry.userid forKey:UserId];//保存用户id
                [[NSUserDefaults standardUserDefaults] setObject:entitry.token forKey:Token];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //下次自动登录(保证最新)
                NSDictionary *userInforData = [NSDictionary dictionaryWithObjectsAndKeys:
                                               entitry.userid,@"userName",
                                               entitry.token,@"userPwd", nil];
                [[NSUserDefaults standardUserDefaults]setObject:userInforData forKey:@"userLoginData"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                  [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
                NSLog(@"%@",userInforData);
                
                [self getPersonInfo];//自动登录后获取用户信息
                //没登录为0
              
                
            }
                break;
            case 1://g个人信息
            {
                StatusEntity* entity = (StatusEntity *)dataObj;
                if(entity.response == 1)
                {
                    NSLog(@"统计信息成功");
                }
            }
                break;

            case 2://匿名用户登陆(只是获得id)
            {
                self.anonymityid = (NSString *)dataObj;//id
                [[NSUserDefaults standardUserDefaults] setObject:self.anonymityid forKey:AnonymityId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ClosePush"])//非关闭
                 {
                     [self initPushOn:@"0"];
                 }
                else
                {
                    [self initPushOff:@"0"];
                }
            }
                break;
                
            default:
                break;
        }
    
}

-(void)getPersonInfo
{
    if(_locationManger==nil)
    {
        _locationManger=[[CLLocationManager alloc]init];
    }
    _locationManger.delegate=self;
    [_locationManger startUpdatingLocation];
    
}

#pragma mark ---定位方法

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
    [self initPushOn:@"0"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    CLLocationCoordinate2D coordinate=[newLocation coordinate];
    [manager stopUpdatingLocation];
    NSLog(@"%f<-->%f",coordinate.latitude,coordinate.longitude);
    CLGeocoder *gecoder=[[[CLGeocoder alloc]init] autorelease];
      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
      {
          [gecoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
              for (CLPlacemark *place in placemarks)
              {
                  //市
                  NSLog(@"locality,%@",place.locality);//得到"深圳市"
                  NSLog(@"~~~place.name：%@",place.administrativeArea);
                  self.proviceName = place.administrativeArea;//省名
                  [self initData:place.locality];//用户信息
                  //在用户没有关闭的情况下自动登录开通推送
//                  NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpen"]);
//                  if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpen"] intValue] ||[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpen"] == nil)//用户开启了推送 (后者是用户注册时)
//                  {
//                      NSLog(@"正在设置推送");
//                      [self initPushOn:place.administrativeArea];//推送
//                   }
                  if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ClosePush"])//非关闭
                  {
                       [self initPushOn:place.administrativeArea];//推送
                  }
                  else//关闭
                  {
                      [self initPushOff:place.administrativeArea];//关闭
                  }
                  
                  break;
                }
          }];
      }
}

#pragma mark ---个人信息请求
-(void)initData:(NSString *)cityName
{
    UIScreen *MainScreen1 = [UIScreen mainScreen];
    CGSize Size = [MainScreen1 bounds].size;
    CGFloat scale = [MainScreen1 scale];
    CGFloat screenWidth = Size.width * scale;
    CGFloat screenHeight = Size.height * scale;
    NSString *scaleString = [NSString stringWithFormat:@"%f*%f",screenWidth,screenHeight];
    NSLog(@"用户id：%@，网络：%@,设备型号：%@,位置：%@,分辨率：%@",kCurrUserId,[self operator],[self platformString],cityName,scaleString);
    //请求
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;
    [requestObj requestDataWithInterface:UserInfoReport param:[self GetUserCommentsParam:kCurrUserId model:[self platformString] pixel:scaleString sp:[self operator] area:cityName] tag:1];
    [requestObj release];
}

#pragma mark --判断网络运营商
- (NSString *)operator
{
    //设备运营商，如1表示移动，2表示联通，3表示电信，4其他
    NSString *strOperator = @"其他";
    
    CTTelephonyNetworkInfo *tni = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
    NSString *code = [tni.subscriberCellularProvider mobileNetworkCode];
    if (code == nil) {
        return strOperator;
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        strOperator = @"中国移动";
    }else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
        strOperator = @"中国联通";
    }else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"])
    {
        strOperator = @"中国电信";
    }
    
    return strOperator;
    
    
    
    
}

#pragma mark --判断手机型号
- (NSString *) platformString {
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)"; 
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectCategay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (isBigeriOS7version) {
        self.view.bounds = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
    GetCityID *getid = [[GetCityID alloc]init];     //将地域文件序列化生成文件存入本地  并将省ID生成字典用userdefalute存入本地
//    NSLog(@" ++++++++++++++++++++++++++++++++++++++++++++++++++++%i",[getid getProvinceIDByProvinceName:@"北京"]);
    [getid release];
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonInfo) name:LoginSuccess object:nil];
    //推送token
    self.deceiveToken = [[NSUserDefaults standardUserDefaults] objectForKey:kkkDeviceToken];//推送token
   //点击详情购物车通知
      [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(spDetailShopCarClicked:) name:kSPDetailShopCarClickedNotification object:nil];
   
    //用户选择了自动登陆
    NSLog(@"%@,%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"auto"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginData"]);
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"auto"]&&[[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginData"])
    {
        [self autoLogin];
    }
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:AnonymityId]);//id_52e1dc91905835.55275782
   if(![[NSUserDefaults standardUserDefaults] objectForKey:AnonymityId])//id_52e1dba02d9cb6.73895594
   {
       //匿名用户登陆(只是获得id),并开启匿名推送
       DSRequest *requestObj = [[DSRequest alloc]init];
       requestObj.delegate = self;
       self.aRequest = requestObj;
       [requestObj requestDataWithInterface:GetAnonymityID param:[self GetAnonymityIDParam] tag:2];
       [requestObj release];
       
       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"logintype"];
       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userLoginData"];
       [[NSUserDefaults standardUserDefaults] synchronize];
 
   }
    
    //设置消息控制器的管理器主视图
    ModelManager *tempModelManager = [ModelManager shareManager];
    [tempModelManager setRootControllerWith:self];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.leftButton setHidden:YES];
    
	// Do any additional setup after loading the view.


    // 菜单
    [self creatTabView];
    // 创建容器
    [self createContentView];
    // 创建VC数组
    [self createVCArray];
    // 默认首页
    CommonViewController *vc = [self.vcArray objectAtIndex:0];
    [self.contentView addSubview:vc.view];
    self.currentIndex = 0;
    
    // Do any additional setup after loading the view.
}

#pragma mark ---开启推送
-(void)initPushOn:(NSString *)proStr
{
    //没登录或没定位到id用0
    int cityId = 0;
    if(![proStr isEqualToString:@"0"])
    {
        cityId = [proStr getProvinceid];
    }
    //"更多"里面用到
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cityId] forKey:KeyCurrentProvinceID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    NSLog(@"省：%@,%d",proStr,cityId);
 //   BOOL isOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isOpen"];
   [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:self.deceiveToken status:1 provinceid:cityId] tag:3];
    [requestObj release];
}

-(void)initPushOff:(NSString *)proStr
{
    //没登录或没定位到id用0
    int cityId = 0;
    if(![proStr isEqualToString:@"0"])
    {
        cityId = [proStr getProvinceid];
    }
    //"更多"里面用到
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cityId] forKey:KeyCurrentProvinceID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;
    NSLog(@"省：%@,%d",proStr,cityId);
    //   BOOL isOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isOpen"];
    [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:self.deceiveToken status:0 provinceid:cityId] tag:3];
    [requestObj release];
}

// 创建view来装载VC array中的视图
-(void)createContentView
{
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, MainViewWidth, MainViewHeight-BOTTOMHEIGHT-20)];
    view.clipsToBounds = YES;
    self.contentView = view;
    [self.view addSubview:view];
    [view release];
}
// 创建视图
-(void)createVCArray
{
    NSMutableArray *myArr = [[NSMutableArray alloc]init];
    self.vcArray = myArr;
    [myArr release];
    
    //添加vc到arr中
    ShouYeVC *souYe = [[ShouYeVC alloc]init];
//    souYe.delegate = self;
    [self.vcArray addObject:souYe];
    [souYe release];
    
//    ShangChenVC *shangChen = [[ShangChenVC alloc]init];
////    shangChen.delegate = self;
//    [self.vcArray addObject:shangChen];
//    [shangChen release];
    ShangChengZhanKaiVC *vc = [[ShangChengZhanKaiVC alloc]init];
    [self.vcArray addObject:vc];
    [vc release];
    

    SouSuoVC *souSuo = [[SouSuoVC alloc]init];
//    souSuo.delegate = self;
    [self.vcArray addObject:souSuo];
    [souSuo release];
    
    GouWuCheVC *gouwuChe = [[GouWuCheVC alloc]init];
//    gouwuChe.delegate = self;
    [self.vcArray addObject:gouwuChe];
    [gouwuChe release];
    
    MyWardrobeVC *myWardrobe = [[MyWardrobeVC alloc]init];
    //    myWardrobe.delegate = self;
    [self.vcArray addObject:myWardrobe];
    [myWardrobe release];
    
    //默认显示第一页
//    [self clickTabButton:0];
}


-(void)creatTabView
{
    // 不显示底部黑边
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- 200, 320, 200)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    [aView release];
    
    UIImage *tabImage=[UIImage imageNamed:@"bg_tab bar@2x.png"];
    tabBagView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-tabImage.size.height+30, 320, tabImage.size.height/2)];
    tabBagView.userInteractionEnabled=YES;
    tabBagView.image=tabImage;
    [self.view addSubview:tabBagView];
    if(self.buttons == nil)
    {
        self.buttons = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        
    }

    NSArray *titleArray=[NSArray arrayWithObjects:@"首页",@"商城",@"搜索",@"购物车",@"我的衣柜", nil];
    NSArray *normalArray=[NSArray arrayWithObjects:@"icon_home.png",@"icon_list.png",@"icon_search.png",@"icon_car.png",@"icon_user.png", nil];
    NSArray *hightArray=[NSArray arrayWithObjects:@"icon_home_press.png",@"icon_list_press.png",@"icon_search_press.png",@"icon_car_press.png",@"icon_user_press.png", nil];
    for (int i=0; i<5; i++)
    {
        
        UIImage *image=[UIImage imageNamed:[normalArray objectAtIndex:i]];
        int weight=image.size.width;
        int height=image.size.height;
        UIButton *iconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setBackgroundImage:[UIImage imageNamed:[hightArray objectAtIndex:i]] forState:UIControlStateSelected];
        [iconBtn setBackgroundImage:image forState:UIControlStateNormal];
        iconBtn.tag=BUTTONADDTAG+i;
        [self.buttons addObject:iconBtn];
        if(i==0)
        {
            iconBtn.selected=YES;
        }
        iconBtn.frame=CGRectMake((320/5)*i, 0, weight, height);
        iconBtn.backgroundColor=[UIColor clearColor];
        [iconBtn addTarget:self action:@selector(clickTabButton:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [tabBagView addSubview:iconBtn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 15)];
        label.center=CGPointMake(33, iconBtn.center.y+16);
        label.text = [titleArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGBCOLOR(103, 116, 129);
        label.textAlignment = NSTextAlignmentCenter;
       // label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [iconBtn addSubview:label];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 0x600+i;
        btn.hidden = YES;
        if (i < 4) {
            btn.frame = CGRectMake((320/5)*i+35, 8,20,14);
            btn.backgroundColor = RGBCOLOR(251, 66, 55);
            btn.layer.cornerRadius = 6;
        }else {
            btn.frame = CGRectMake((320/5)*i+45, 8,7,7);
            [btn setBackgroundImage:GetImage(@"user_icon_remind.png") forState:UIControlStateNormal];
        }
        
        btn.userInteractionEnabled = NO;
        
        CGFloat fontSize = 10;
        NSString *countStr = @"";

        [btn setTitle:countStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
        //[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [tabBagView addSubview:btn];
        
    }
}

+ (void)setNumber:(int)number ofIndex:(int)index
{
    if (index ==3) {
        numbersOfGoods = number;
    }
    UIButton *button=(UIButton *)[tabBagView viewWithTag:0x600+index];
        if (number ==0) {
        button.hidden = YES;
        }else if (number ==-1){
            button.hidden = NO;
        }
        else{
        button.hidden = NO;
        int fontSize=0;
        if (number<10){
            fontSize = 13;
        }else if(number>=10&&number<=99){
            fontSize = 11;
        }else{
            fontSize = 10;
        }
        NSString *countStr = @"";
        if (number<=99)
        {
            countStr = [NSString stringWithFormat:@"%i",number];
        }else{
            countStr = @"99+";
        }

        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
        [button setTitle:countStr forState:UIControlStateNormal];
    }
    
    
}
+ (int)getNumberOfGoods
{
    return numbersOfGoods;
}

-(void)clickTabButton:(UIButton *)button withEvent:(UIEvent*)event
{
    //统计坐标
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSNumber *Xnumber = [NSNumber numberWithFloat:point.x*2];
    NSNumber *Ynumber = [NSNumber numberWithFloat:point.y*2];
    NSDictionary *pointDic = [NSDictionary dictionaryWithObjectsAndKeys:Xnumber,@"hotclick_x",Ynumber,@"hotclick_y", nil];
    NSLog(@"%@",pointDic);
    
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointAry"];//获取存放热点坐标的数组
    NSMutableArray *array1 = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
    if(array)
    {
        [array1 addObjectsFromArray:array];
    }
    [array1 addObject:pointDic];
    [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:@"pointAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    int clickTag = button.tag - BUTTONADDTAG;
    
    [self showTableIndex:clickTag];
    
}

-(void)showTableIndex:(int)index
{
    switch (_currentIndex) {
        case 0:
        {
            [MobClick endLogPageView:@"首页"];
            break;
        }
        case 1:
        {
            [MobClick endLogPageView:@"商城"];
            break;
        }
        case 2:
        {
            [MobClick endLogPageView:@"搜索"];
            break;
        }
        case 3:
        {
            [MobClick endLogPageView:@"购物车"];
            break;
        }
        case 4:
        {
            [MobClick endLogPageView:@"我的衣柜"];
            break;
        }
        default:
            break;
    }

    
    CommonViewController *vc = [self.vcArray objectAtIndex:index];
    //CommonViewController *vc = [self.vcArray objectAtIndex:0];
//    for (UIView *view in [self.contentView subviews]) {
////        [view retain];
//        [view removeFromSuperview];
//    }
//    CommonViewController *oldvc  = [self.vcArray objectAtIndex:self.currentIndex];
//    [oldvc.view removeFromSuperview];
    if (vc.view.superview == nil) {
        [self.contentView addSubview:vc.view];
    }else
    {
        [self.contentView bringSubviewToFront:vc.view];
    }
    
    //根据index，把vcarr中的视图影藏掉，把对应的index显示
//    [vc showVC];//// 调用这个方法来刷新购物车信息
    [vc performSelector:@selector(showVC) withObject:nil afterDelay:0.1]; // 调用这个方法来刷新购物车信息
    
    for (int i=0; i<5; i++) {
        UIButton *button=(UIButton *)[tabBagView viewWithTag:BUTTONADDTAG+i];
        button.selected=NO;
    }
    UIButton *button=(UIButton *)[tabBagView viewWithTag:BUTTONADDTAG+index];
    button.selected=YES;
    
    self.currentIndex = index;
    
    switch (_currentIndex) {
        case 0:
            NSLog(@"   +++++++++++  首页");
            //统计页面访问时间
            [MobClick beginLogPageView:@"首页"];
            break;
        case 1:
            //统计页面访问时间
            [MobClick beginLogPageView:@"商城"];
            break;
        case 2:

            //统计页面访问时间
            [MobClick beginLogPageView:@"搜索"];
            break;
        case 3:

            //统计页面访问时间
            [MobClick beginLogPageView:@"购物车"];
            break;
        case 4:

            //统计页面访问时间
            [MobClick beginLogPageView:@"我的衣柜"];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-- spDetailShopCarClicked
-(void)spDetailShopCarClicked:(NSNotification*)noti
{
//    [self performSelector:@selector(showTableIndex3) withObject:nil afterDelay:0.1];
    [self showTableIndex:3];
}

-(void)showTableIndex3
{
    [self showTableIndex:3];
}
@end
