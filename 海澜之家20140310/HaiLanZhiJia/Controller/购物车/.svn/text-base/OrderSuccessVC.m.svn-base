//
//  OrderSuccessVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderSuccessVC.h"
#import "OrderDetailVC.h"
#import "RootVC.h"
#import "WCAlertView.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "DSRequest.h"

@interface OrderSuccessVC ()<UPPayPluginDelegate,DSRequestDelegate>
{
    UIAlertView* mAlert;
    NSMutableData* mData;
}
@end

@implementation OrderSuccessVC
@synthesize statusEntity;

-(void)dealloc
{
    self.statusEntity = nil;
    self.buyEntity = nil;
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
    [self setTitleString:@"下单成功"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"完成"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self createSubViews];
    
    [self createButtons];
	// Do any additional setup after loading the view.
}

-(void)createSubViews
{
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, MainViewWidth, 24.0)];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.numberOfLines = 1;
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor = RGBCOLOR(64, 134, 6);
    myLabel.font = SYSTEMFONT(24);
    [myLabel setText:@"订单提交成功！"];
    
    [self.view addSubview:myLabel];
    [myLabel release];
    
    
    UIImage *aImg = GetImage(@"bg_list2_up.png");
    NSArray *myArray = [NSArray arrayWithObjects:statusEntity.ordernumber,statusEntity.orderfee,@"第三方快递", nil];
    float beginY = 140.0;
    int number = [myArray count];
    for (int i =0; i< number; i++) {
        if (number==0) {
            NSLog(@"数据失败");
        }else if (number ==1){
            
        }else if (number >1)
        {
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [aBtn setFrame:CGRectMake(10,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            aBtn.tag = i;
            aBtn.enabled = NO;
            [aBtn addTarget:self action:@selector(payBy:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *atLable = [[UILabel alloc]initWithFrame:CGRectMake(15,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            NSString *myStr = nil;
            switch (i) {
                case 0:
                {
                    myStr = [NSString stringWithFormat:@"订单号：%@",[myArray objectAtIndex:i]];
                    break;
                }
                case 1:
                {
                    myStr = [NSString stringWithFormat:@"订单金额："];
                    break;
                }
                case 2:
                {
                    myStr = [NSString stringWithFormat:@"配送方式：%@",[myArray objectAtIndex:i]];
                    break;
                }
                    
                default:
                    break;
            }
            
            [atLable setText:myStr];
            atLable.userInteractionEnabled = NO;
            atLable.backgroundColor = [UIColor clearColor];
            atLable.textColor = TEXT_GRAY_COLOR;
            [atLable setFont:SYSTEMFONT(14)];
            
            
            
            if (i==0) {
                if (number ==1) {
                    [aBtn setBackgroundImage:GetImage(@"bg_list.png") forState:UIControlStateNormal];
                    [aBtn setBackgroundImage:GetImage(@"bg_list_press.png") forState:UIControlStateHighlighted];
                }else{
                    [aBtn setBackgroundImage:GetImage(@"bg_list2_up.png") forState:UIControlStateNormal];
                    [aBtn setBackgroundImage:GetImage(@"bg_list2_up_press.png") forState:UIControlStateHighlighted];
                }
            }else if (i==number-1){
                [aBtn setBackgroundImage:GetImage(@"bg_list2_down.png") forState:UIControlStateNormal];
                [aBtn setBackgroundImage:GetImage(@"bg_list2_down_press.png") forState:UIControlStateHighlighted];
            }else{
                [aBtn setBackgroundImage:GetImage(@"bg_list2_middle.png") forState:UIControlStateNormal];
                [aBtn setBackgroundImage:GetImage(@"bg_list2_middle_press.png") forState:UIControlStateHighlighted];
            }
            
            [self.view addSubview:aBtn];
            [self.view addSubview:atLable];
            [atLable release];
            
            if (i==1) {
                UILabel *btLable = [[UILabel alloc]initWithFrame:CGRectMake(95,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
                btLable.userInteractionEnabled = NO;
                btLable.backgroundColor = [UIColor clearColor];
                btLable.textColor = TEXT_RED_COLOR;
                [btLable setText:[NSString stringWithFormat:@"￥%@",[myArray objectAtIndex:1]]];
                [btLable setFont:SYSTEMFONT(14)];
                [self.view addSubview:btLable];
                [btLable release];

            }
            
        }
        
    }
    for (int i = 0; i<number -1; i++) {
        if (i!=number-1) {
            UIImage *lineImg = GetImage(@"segmentation_line.png");
            UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,beginY+(i+1)*aImg.size.height, lineImg.size.width, lineImg.size.height)];
            lineImgView.image = lineImg;
            [self.view addSubview:lineImgView];
            [lineImgView release];
        }
    }
    UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(15,280, 280, 35)];
    infoLable.numberOfLines = 2;
    
    //1.购物车普通商品2.团购 3.秒杀
    if (self.orderType ==1) {
        [infoLable setText:@"订单已提交成功，请尽快完成支付"];
    }else if (self.orderType ==2)
    {
        NSString *myStr = [NSString stringWithFormat:@"团购订单在活动结束%d分钟内有效，过时后订单自动被取消，请尽快完成支付",self.specialBuyEntity.paylimit];
        [infoLable setText:myStr];
    }else if (self.orderType ==3)
    {
        NSString *myStr = [NSString stringWithFormat:@"秒杀订单在下单成功后%d分钟内有效，过时后订单自动被取消，请尽快完成支付",self.specialBuyEntity.paylimit];
        [infoLable setText:myStr];
    }
    
    infoLable.userInteractionEnabled = NO;
    infoLable.backgroundColor = [UIColor clearColor];
    infoLable.textColor = TEXT_GRAY_COLOR;
    [infoLable setFont:SYSTEMFONT(12)];
    [self.view addSubview:infoLable];
    [infoLable release];
    
}

-(void)createButtons
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [aButton setTitleColor:RGBCOLOR(46, 46, 46) forState:UIControlStateNormal];
    [aButton setBackgroundImage:GETIMG(@"button4_press.png") forState:UIControlStateSelected];
    [aButton setBackgroundImage:GETIMG(@"button4.png") forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor clearColor]];
    [aButton setFrame:CGRectMake(10, 330, 140, 44)];
    [aButton addTarget:self action:@selector(lookupOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton setBackgroundImage:GETIMG(@"button3_press.png") forState:UIControlStateSelected];
    [myButton setBackgroundImage:GETIMG(@"button3.png") forState:UIControlStateNormal];
    [myButton setFrame:CGRectMake(170, 330, 140, 44)];
    [myButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
//    if (self.statusEntity.totalcount>=0) {
//        
//    }
}

-(void)lookupOrder:(UIButton *)button
{
    OrderDetailVC *odVC = [[OrderDetailVC alloc]init];
    odVC.orderNum = self.statusEntity.ordernumber;
    [odVC setOdType:OrderTypeGoing];
    [self pushViewController:odVC];
    [odVC release];
}

-(void)payAction:(UIButton *)button
{
    /*paycode	string	付款方式标识，例如：
     unionpay 银联在线支付
     alipay 支付宝
     bank 银行汇款/转帐
     tenpay 财付通
     onlinepay 在线支付
     */
    //默认支付宝
    if (self.payTypeEntity !=nil && [self.payTypeEntity.paycode compare:@"unionpay" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        //银联在线支付
        [self upPay];
        return;
    }
    
    [self alixPay];
}

////////
//-------6226440123456785 111101
- (void)upPay
{
    [self showAlertWait];
    
    //
    DSRequest *dsrequest=[[DSRequest alloc]init];
    dsrequest.delegate = self;
    [dsrequest requestDataWithInterface:GetUPPayTN param:[self GetUPPayTNParam:self.statusEntity.ordernumber] tag:0];
    [dsrequest release];
}
//------
- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
    [aiv release];
    [mAlert release];
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
    [mAlert release];
}
- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}
//--------
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
//    [self.view removeHUDActivityView];        //加载失败  停止转圈
    NSLog(@"失败");
    [self hideAlert];
    [self showAlertMessage:error.domain];
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
//    [self.view removeHUDActivityView];        //加载成功  停止转圈
    [self hideAlert];
    
    StatusEntity *entity = (StatusEntity *)dataObj;
    //1表示成功，2表示失败
    if (entity.response == 1) {
        
        NSString* tn = entity.uppaytn;
        if (tn != nil && tn.length > 0)
        {
            NSLog(@"tn=%@",tn);
            //tn 交易流水号  mode 00正式环境 01测试环境
            [UPPayPlugin startPay:tn mode:kMode viewController:self delegate:self];
        }

    }else
    {
        [self hideAlert];
        [self showAlertMessage:entity.failmsg];
    }
}
//-----------
- (void)UPPayPluginResult:(NSString *)result
{
    //银联手机支付控件有三个支付状态返回值:success、fail、cancel,分别代表:支付成功、支付失败、用户取消支付。这三个返回状态值以字符串的形式作为回调函
    NSString* msg = [NSString stringWithFormat:kResult, result];
    if ([result isEqualToString:@"success"]) {
        msg = [NSString stringWithFormat:kResult,@"支付成功"];
        
        
    }else
    if ([result isEqualToString:@"fail"]) {
        msg = [NSString stringWithFormat:kResult,@"支付失败"];
    }else
    if ([result isEqualToString:@"cancel"]) {
        msg = [NSString stringWithFormat:kResult,@"用户取消支付"];
    }
    [self showAlertMessage:msg];
    
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.frame = CGRectMake(0, 0, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
    }
}
//////////

//alixPay
-(void)alixPay
{
    //将商品信息拼接成字符串
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    
    AlixPayOrder *order = [[[AlixPayOrder alloc] init] autorelease];
    
    // partner seller   关键字段
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = statusEntity.ordernumber;//订单id
    order.productName = self.statusEntity.ordernumber; //商品标题
    order.amount = self.statusEntity.orderfee;//支付金额
//     order.productName = @"ss";
//    order.amount = @"0.01";//支付金额
	order.productDescription = @"海澜之家"; //商品描述(此项不可少，否者签名错误)
  
    // --------
//    order.notifyURL = @"http://113.106.90.141:2046/Api/PayCallBack";//回调URL
    order.notifyURL=[NSString stringWithFormat:@"%@PayCallBack",ZHIFUBAO_ADDRESS];
    NSString *appScheme = @"HaiLanZhiJia";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    // 客户的私钥    关键字段
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle]
                                                 objectForInfoDictionaryKey:@"RSA private key"]);
//    NSString *privateKey =  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOWJZHgOI+KbXugA1h4T0XV0DnVhhbGY8/aeqD1IXDqkBewYVop2ycyINsC11apu12nX2ESb65gWJwS4n+IeB1c+aW3kzvsMPqP+snEbKuVIWnPq40EFf3/Ii8nJHNqM8iRaoNv+t4biZ88ojtGYMDYhSFgn6NVT5zjb232pw3YlAgMBAAECgYEAyfAS9NAz3/QjDedWeMWkvDlrUveGQFW5JFo21xtnEKwnDavnzw9swEWCLg6LONMlLtgXS10FaxrqHuwytSMH/p1fMijOBrDKuwo2yd0rnJNMMQaXge/z7Sic3ql/Jw/RtRCvyu/H31BIN7dljXFwp1i1NGy1Dp8FA9i2CSUU600CQQD868ipCH83N1v3VyGFd0Ay3q0g1gTzOujdhdeVHdz7B2N6BZgJGlUaqkgq1NmJKpASS4dm9lWX6RKbEO3kPF8zAkEA6FS7glzIG8vqCHnxQ9RcO2KC3cfqCze9UVJl6wdyQlNf9m82hFBNHe/ndRZOE2iNPvW5XkvLubiYvJAIk3K1RwJBAPtD8zGas2fTo5XyBedmNW1UM4Mvm/NYTwfkc+w8otDw4i7TZ9uDQZEgIloK46KVmlPSnU3448frUQSkqPHZ2GkCQAO50CQADul7NK6cHgVjc3M0WjrqSNOTOkMCmkXRocB0i9Zs5CftDb+MKF8VU302MQWwdR+RAZxh3HkxqiGLNmMCQDdnxkMAfvLuxahvNimUFV4VoKtCcayIC+IJrefCUW3BVptCZxulk88aocw7LW56xHwcm0ChdKMlkGmTYamQAoU=";
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
//    NSString *payPublicStr = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQChhJyjxYniah/98EZPwOhcV6u9LdngWGYFN7tK CMCKTgqu0EP0Ir7wuz3AxJWrOixGaV4i6qD3bnKCy7ifGQtDqUSf+Uxy6uQA7dcrmroonE6lRmJY ndwD2WhlXefkbbTXAPcMHYdWbGQbihg6KpsXBVS6wbTzL+WinxWyxz1bIwIDAQAB";
    
    
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",orderString);
        
        if (ret == kSPErrorAlipayClientNotInstalled)
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"您还没有安装支付宝快捷支付，请先安装。" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if(buttonIndex == 1)
                {
                    //进入下载支付宝
                    NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
                }
               

            } cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];

        }
        else if (ret == kSPErrorSignError)
        {
            NSLog(@"签名错误！");
        }
        
        
    }

 // OrderDetailEntity
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 回退和完成都是回到购物车首页
-(void)leftAction
{
    [self popToRoot];
    [[NSNotificationCenter defaultCenter]postNotificationName:ReloadGouwuche object:nil];
//    [[RootVC shareInstance]showTableIndex:3];   // 调用这个方法来返回并刷新购物车信息
}

-(void)myRightButtonAction:(UIButton *)button
{
    [self popToRoot];
    [[NSNotificationCenter defaultCenter]postNotificationName:ReloadGouwuche object:nil];
//    [[RootVC shareInstance]showTableIndex:3];   // 调用这个方法来返回并刷新购物车信息
}

@end
