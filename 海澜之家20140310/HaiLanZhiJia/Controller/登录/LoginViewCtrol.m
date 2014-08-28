//
//  LoginViewCtrol.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "LoginViewCtrol.h"
#import "ResignViewVC.h"
#import "UIViewController+Hud.h"
#import "ZhiFuBaoView.h"
@interface LoginViewCtrol ()<UITextFieldDelegate,UIWebViewDelegate,loginDelgate>{
    UITextField *_phoneFild;
    UITextField *_pwdFild;
    UIImageView *_logImgView;
    BOOL isAuto;
    BOOL isOther;
    UIView *_otherView;
    
    int loginType;
    BOOL isLoginTimeOut;
    UIWebView *webView;
    
//    SinaWeibo *tempSinaWb;
}

@property(nonatomic,retain)NSString *someId;
@property(nonatomic,retain)NSString *sinaId;
@property(nonatomic,retain)NSString *sinaToken;
@property(nonatomic,retain)NSString *deceiveToken;//推送token
@property(nonatomic,retain)DSRequest *aRequest;
@end

@implementation LoginViewCtrol

- (void)dealloc
{
    [SinaWeiBoManager sharedInstance].delegate = nil;
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    SAFETY_RELEASE(_phoneFild);
    SAFETY_RELEASE(_pwdFild);
    SAFETY_RELEASE(_logImgView);
    SAFETY_RELEASE(_otherView);
    self.sinaId = nil;
    self.sinaToken = nil;
//    [tempSinaWb release];
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

-(void)keyboardWillShow:(NSNotification *)note
{
    _otherView.hidden = YES;
    isOther = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    [userdefalut removeObjectForKey:UserId];
    [userdefalut removeObjectForKey:Token];
    [userdefalut removeObjectForKey:@"userLoginData"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //进入页面将自动登录信息清理
   
    //推送
    self.deceiveToken = [[NSUserDefaults standardUserDefaults] objectForKey:kkkDeviceToken];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"注册"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    self.view.backgroundColor=RGBCOLOR(247, 247, 247);
    [self setTitleString:@"登录"];
    self.rightButton.hidden = NO;
    [self initView];
    //获得匿名用户id
    self.someId = [[NSUserDefaults standardUserDefaults] objectForKey:AnonymityId];
    [SinaWeiBoManager sharedInstance].delegate = self;
}

//QQ登录
-(void)readyToLogin
{
    _permissions = [[NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
//                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                     kOPEN_PERMISSION_ADD_ALBUM,
//                     kOPEN_PERMISSION_ADD_IDOL,
//                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
//                     kOPEN_PERMISSION_ADD_SHARE,
//                     kOPEN_PERMISSION_ADD_TOPIC,
//                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                     kOPEN_PERMISSION_DEL_IDOL,
//                     kOPEN_PERMISSION_DEL_T,
//                     kOPEN_PERMISSION_GET_FANSLIST,
//                     kOPEN_PERMISSION_GET_IDOLLIST,
//                     kOPEN_PERMISSION_GET_INFO,
//                     kOPEN_PERMISSION_GET_OTHER_INFO,
//                     kOPEN_PERMISSION_GET_REPOST_LIST,
//                     kOPEN_PERMISSION_LIST_ALBUM,
//                     kOPEN_PERMISSION_UPLOAD_PIC,
//                     kOPEN_PERMISSION_GET_VIP_INFO,
//                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
//                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil] retain];
    
    
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQApi andDelegate:self];
}

-(void)onClickTencentOAuth
{
    
    NSLog(@"开始获取token");
	[_tencentOAuth authorize:_permissions inSafari:NO];
}

-(void)myRightButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    ResignViewVC *resignView = [[ResignViewVC alloc]init];
    [self pushViewController:resignView];
    [resignView release];
}

-(void)initView
{
    UIImage *image = GETIMG(@"log in_box bg_.png");
    
    _logImgView = [[UIImageView alloc]initWithFrame:CGRectMake(70/2, (226-20)/2,image.size.width, image.size.height)];
    _logImgView.image = image;
    _logImgView.userInteractionEnabled = YES;
    [self.view addSubview:_logImgView];
    
    _phoneFild = [[UITextField alloc]initWithFrame:CGRectMake(55, 8, 200, 20)];
    _phoneFild.returnKeyType= UIReturnKeyDone;
    _phoneFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneFild.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneFild.delegate=self;
    _phoneFild.font=SYSTEMFONT(15);
    _phoneFild.backgroundColor=[UIColor clearColor];
    _phoneFild.placeholder=@"请输入手机号或邮箱";
    [_logImgView addSubview:_phoneFild];
    
    _pwdFild = [[UITextField alloc]initWithFrame:CGRectMake(55, 43, 200, 20)];
    _pwdFild.backgroundColor=[UIColor clearColor];
    _pwdFild.returnKeyType= UIReturnKeyDone;

    _pwdFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdFild.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdFild.delegate=self;
    _pwdFild.secureTextEntry = YES;
    _pwdFild.font=SYSTEMFONT(15);
    _pwdFild.placeholder=@"请输入密码";
    [_logImgView addSubview:_pwdFild];
 
    UIImage *autoImage=GETIMG(@"log in_button_select2.png");
    UIButton *autoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    autoBtn.tag = 1;
    autoBtn.frame=CGRectMake(70/2, (404-20)/2, autoImage.size.width, autoImage.size.height);
    [autoBtn setBackgroundImage:autoImage forState:UIControlStateNormal];
    //上次是否选择了自动按钮的状态
    NSString *autoString = [[NSUserDefaults standardUserDefaults] objectForKey:@"auto"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    autoBtn.selected = NO;
    NSLog(@"%@",autoString);
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"firstComing"])
//    {
//          isAuto = YES;
//        [[NSUserDefaults standardUserDefaults] objectForKey:@"firstComing"];
//    }
    isAuto = NO;
    if(autoString)
    {
        autoBtn.selected = YES;
        isAuto = YES;
    }

    [autoBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [autoBtn setBackgroundImage:GETIMG(@"log in_button_select1.png") forState:UIControlStateSelected];
    [self.view addSubview:autoBtn];
    
    UILabel *autoLabel = [[UILabel alloc]initWithFrame:CGRectMake(118/2, (412-20)/2-6, 100, 20)];
    autoLabel.text = @"自动登录";
    autoLabel.textColor = RGBCOLOR(154, 150, 150);
    autoLabel.backgroundColor = [UIColor clearColor];
    autoLabel.font = SYSTEMFONT(14);
    [self.view addSubview:autoLabel];
    [autoLabel release];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.tag = 2;
    forgetBtn.backgroundColor = [UIColor clearColor];
    forgetBtn.frame = CGRectMake(412/2, (412-20)/2-6, 80, 20);
    [forgetBtn setTitle:@"忘记密码>>" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:RGBCOLOR(11, 59, 154) forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.titleLabel.font = SYSTEMFONT(14);
    [self.view addSubview:forgetBtn];
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.tag = 3;
    UIImage *otherImg = GETIMG(@"log in_button_other.png");
    otherBtn.frame = CGRectMake(70/2, (508-20)/2, otherImg.size.width, otherImg.size.height);
    [otherBtn setBackgroundImage:otherImg forState:UIControlStateNormal];
    [otherBtn setBackgroundImage:GETIMG(@"log in_button_other_press.png") forState:UIControlStateHighlighted];
    [otherBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];//
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.tag = 4;
    UIImage *loginImg = GETIMG(@"log in_button_confirm.png");
    loginBtn.frame = CGRectMake(333/2, (508-20)/2, loginImg.size.width, loginImg.size.height);
    [loginBtn setBackgroundImage:loginImg forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:GETIMG(@"log in_button_confirm_press.png") forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIImage *threeImg = GETIMG(@"log in_other bg.png");
    _otherView = [[UIView alloc]initWithFrame:CGRectMake(70/2, (283-20)/2,threeImg.size.width , threeImg.size.height)];
    _otherView.backgroundColor = [UIColor clearColor];
    UIImageView *threeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, threeImg.size.width, threeImg.size.height)];
    threeView.image = threeImg;
    _otherView.hidden = YES;
    _otherView.userInteractionEnabled = YES;
    [_otherView addSubview:threeView];
    [threeView release];
    [self.view addSubview:_otherView];
    
   //新浪按钮
    UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame = CGRectMake(0, 0, threeImg.size.width, 35);
    sinaBtn.tag = 5;
    [sinaBtn setBackgroundImage:GETIMG(@"log in_other_select_up.png") forState:UIControlStateHighlighted];
    sinaBtn.titleLabel.textAlignment = UITextAlignmentRight;
    [sinaBtn setTitle:@"新浪微博" forState:UIControlStateNormal];
    sinaBtn.titleLabel.font = SYSTEMFONT(14);
     [sinaBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sinaBtn.backgroundColor = [UIColor clearColor];
    [sinaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[sinaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_otherView addSubview:sinaBtn];
    UIImage *sinaImg = GETIMG(@"log in_icon_sina.png");
    UIImageView *sinaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 7, sinaImg.size.width, sinaImg.size.height)];
    sinaImgView.image = sinaImg;
    [sinaBtn addSubview:sinaImgView];
    [sinaImgView release];
    
    
  //QQ登录按钮
     UIImage *qqImg = GETIMG(@"log in_icon_qq.png");
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.tag = 6;
    qqBtn.frame = CGRectMake(0, 35, threeImg.size.width, 35);
    [qqBtn setBackgroundImage:GETIMG(@"log in_other_select_middle.png") forState:UIControlStateHighlighted];
    qqBtn.titleLabel.textAlignment = UITextAlignmentRight;
    [qqBtn setTitle:@"QQ账号" forState:UIControlStateNormal];
    qqBtn.titleLabel.font = SYSTEMFONT(14);
    [qqBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    qqBtn.backgroundColor = [UIColor clearColor];
    [qqBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [qqBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_otherView addSubview:qqBtn];
    UIImageView *qqImgView = [[UIImageView alloc]initWithFrame:
                              CGRectMake(2, 7, qqImg.size.width, qqImg.size.height)];
    qqImgView.image = qqImg;
    [qqBtn addSubview:qqImgView];
    [qqImgView release];
    
    //支付宝
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(0, 70, threeImg.size.width, 40);
    payBtn.tag = 7;
    [payBtn setBackgroundImage:GETIMG(@"log in_other_select_down.png") forState:UIControlStateHighlighted];
    payBtn.titleLabel.textAlignment = UITextAlignmentRight;
    [payBtn setTitle:@"支付宝账号" forState:UIControlStateNormal];
    payBtn.titleLabel.font = SYSTEMFONT(14);
     [payBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.backgroundColor = [UIColor clearColor];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_otherView addSubview:payBtn];
    UIImage *payImg = GETIMG(@"log in_icon_zhifubao.png");
    UIImageView *payImgView = [[UIImageView alloc]initWithFrame:
                               CGRectMake(2, 8, payImg.size.width, payImg.size.height)];
    payImgView.image = payImg;
    [payBtn addSubview:payImgView];
    [payImgView release];
  
    
}
#pragma mark ---按钮点击事件集合

-(void)clickButton:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
            isAuto = !isAuto;
            //有选择自动登录
            if(isAuto)
            {
                //存入本地，
                [[NSUserDefaults standardUserDefaults]setObject:@"autoLogin" forKey:@"auto"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                isAuto = YES;
                btn.selected = YES;
            }
            //没有选择自动登录
            else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"auto"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                btn.selected = NO;
                isAuto = NO;
            }
            
        }
            break;
            
        case 2:
        {
             [self.view endEditing:YES];
            ForgetViewVC *forgetView = [[ForgetViewVC alloc]init];
            [self pushViewController:forgetView];
            [forgetView release];
        }
            break;
        case 3:
        {
            [_phoneFild resignFirstResponder];
            [_pwdFild resignFirstResponder];
            isOther = !isOther;
            if(isOther)
            {
                isOther = YES;
                _otherView.hidden = NO;
            }
            else{
                _otherView.hidden = YES;
            }
        }
            break;
            
        default:
            break;
    }
}
////type	string	登录类型：1.普通登录 2.新浪微博 3.腾讯QQ 4.支付宝
//三方登录
-(void)loginBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 4://普通登录
        {
            NSLog(@"登录");
            loginType = 1;
            if(_phoneFild.text==nil||[_phoneFild.text isEqualToString:@""]||_pwdFild.text==nil||[_pwdFild.text isEqualToString:@""])
            {
                [WCAlertView showAlertWithTitle:@"提示" message:@"账号或密码不能为空" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                    alertView.labelTextColor=[UIColor blackColor];
                    alertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    nil;
                } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                return;
            }
            
            if([self isValidateMobile:_phoneFild.text] || [self isValidateEmail:_phoneFild.text])
            {
                NSLog(@"合法");
                [self goLogin];
            }
            else{
                [WCAlertView showAlertWithTitle:@"提示" message:@"手机号或邮箱格式不正确" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                    alertView.labelTextColor=[UIColor blackColor];
                    alertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            }
        }
            break;

        case 5://新浪登录
        {
            loginType = 2;
            [[SinaWeiBoManager sharedInstance] sinaLogin];
            
            
            
            
//            SinaWeibo *weibo = [self sinaweibo];//bu使用，对绑定微博会有影响
//            [weibo logIn];
//            if (!tempSinaWb) {
//                tempSinaWb = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:nil];
//                tempSinaWb.delegate=self;
//            }
            
//            [tempSinaWb logIn];

        }
            break;
        case 6://qq登录
        {
            loginType = 3;
            [self readyToLogin];
            [self onClickTencentOAuth];
        }
            break;
        case 7://支付宝登录
        {
            loginType = 4;
            ZhiFuBaoView *zhifuloginView = [[ZhiFuBaoView alloc]init];
            zhifuloginView.loginDelegate = self;
            zhifuloginView.isAuto = isAuto;//是否有选择自动登录的状态给支付宝界面
            [self pushViewController:zhifuloginView WithAnimation:YES];
            [zhifuloginView release];

            //将商品信息拼接成字符串
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark SinaWeiBoManagerDelegate
- (void)sinaWeiBoManagerDidLoginGetToken:(NSString *)accessToken userId:(NSString *)userID expirationDate:(NSDate *)expirationDate
{
//    NSLog(@"登录成功了sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", userID, saccessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);


    if (self.aRequest == nil) {
        DSRequest *requestObj = [[DSRequest alloc]init];
        requestObj.delegate = self;
        self.aRequest = requestObj;
        [requestObj release];
    }


    NSString *type = [NSString stringWithFormat:@"%d",loginType];
    //密码普通登陆有效
    [self.aRequest requestDataWithInterface:Login param:[self LoginParam:userID password:@"" type:type thirdtoken:accessToken anonymityid:self.someId token:self.deceiveToken] tag:0];
    [self addHud:@"正在登录"];
}

//普通登录
-(void)goLogin
{
    NSLog(@"登录");
    [_pwdFild resignFirstResponder];
    [_phoneFild resignFirstResponder];
    isLoginTimeOut = YES;
    [self performSelector:@selector(loginFaiOverTime) withObject:nil afterDelay:10];
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;
    NSString *type = [NSString stringWithFormat:@"%d",loginType];
    [requestObj requestDataWithInterface:Login param:[self LoginParam:_phoneFild.text password:_pwdFild.text type:type thirdtoken:@"" anonymityid:self.someId token:self.deceiveToken] tag:0];
    [self addHud:@"正在登录"];
    [requestObj release];
}


-(void)loginFaiOverTime
{
   if(isLoginTimeOut)
   {
       [self hideHud:nil];
       [self addFadeLabel:@"登录超时"];
   }
}
#pragma mark ------------------zhifubaoLogin delegate
-(void)zhifubaoLogin:(id)object andTag:(int)tag
{
    [self requestDataSuccess:object tag:tag];
}
-(void)zhifubaoLoginFail:(int)tag andError:(NSError *)error andEnum:(enum InterfaceType)type
{
    [self requestDataFail:type tag:tag error:error];
}

#pragma mark SinaWeibo delegate

//- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
//{
//    NSLog(@"登录成功了sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
//    self.sinaId = sinaweibo.userID;
//    self.sinaToken = sinaweibo.accessToken;
//    
//    if (self.aRequest == nil) {
//        DSRequest *requestObj = [[DSRequest alloc]init];
//        requestObj.delegate = self;
//        self.aRequest = requestObj;
//        [requestObj release];
//    }
//    
//    
//    NSString *type = [NSString stringWithFormat:@"%d",loginType];
//    //密码普通登陆有效
//    [self.aRequest requestDataWithInterface:Login param:[self LoginParam:sinaweibo.userID password:@"" type:type thirdtoken:sinaweibo.accessToken anonymityid:self.someId token:self.deceiveToken] tag:0];
//    [self addHud:@"正在登录"];
//    
//    
//}

#pragma mark ---QQ delegate
-(void)tencentDidLogin
{
    NSLog(@"%d",loginType);

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"token值：%@",_tencentOAuth.accessToken);
        NSLog(@"appId值：%@",_tencentOAuth.appId);
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
    
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;
    NSString *type = [NSString stringWithFormat:@"%d",loginType];
     [requestObj requestDataWithInterface:Login param:[self LoginParam:_tencentOAuth.openId password:@"" type:type thirdtoken:_tencentOAuth.accessToken anonymityid:self.someId token:self.deceiveToken] tag:0];
    [self addHud:@"正在登录"];
    [requestObj release];
    
}

//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"用户取消登录");
	}
	else
    {
        NSLog(@"登录失败");
	}
}
//网络错误导致登录失败
-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
   
    
}


//int response;//提交状态 1：提交成功 2：提交失败
#pragma mark ---DSRequest delegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    isLoginTimeOut = NO;
    [self hideHud:nil];
    NSLog(@"%@",dataObj);
    RegisterLoginEntity *entitry = (RegisterLoginEntity *)dataObj;
    if(tag == 0)
    {
        if(entitry.response == 1)//返回登陆状态
        {
//             if(isAuto)//有选择自动登录
//             {
//                 [[NSUserDefaults standardUserDefaults]setObject:@"autoLogin" forKey:@"auto"];
//                 [[NSUserDefaults standardUserDefaults] synchronize];
// 
//             }
            //是否登录
            [[NSUserDefaults standardUserDefaults] setObject:entitry.userid forKey:UserId];//保存用户id
            [[NSUserDefaults standardUserDefaults] setObject:entitry.token forKey:Token];//token
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"%@",entitry.token);
            
            //设置购物车物品个数
            [RootVC shareInstance];
            [RootVC setNumber:entitry.totalcount ofIndex:3];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:entitry.totalcount] forKey:kGouWuCheGoodsCount];

            //密码不能保存在本地(自动登录)
            NSDictionary *userInforData = [NSDictionary dictionaryWithObjectsAndKeys:
                                           entitry.userid,@"userName",
                                           entitry.token,@"userPwd", nil];
            [[NSUserDefaults standardUserDefaults]setObject:userInforData forKey:@"userLoginData"];
            NSLog(@"%@",userInforData);
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"登录类型:%d",loginType);
            //保存类型
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",loginType] forKey:@"logintype"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
            
         //   [self initPushOn];//开启推送(发送通知后在root里面开启推送)
            
            if ([self.backDelegate respondsToSelector:@selector(loginViewCtrolDisMissed)]) {
                [self.backDelegate loginViewCtrolDisMissed];
            }
            [self popViewController];
        }
        else
        {
            [self addFadeLabel:@"用户名或密码错误"];
//            [self addFadeLabel:entitry.failmsg];
        }
    }
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    isLoginTimeOut = NO;
    [self performSelector:@selector(hidHud) withObject:nil afterDelay:0.1];
    [self addFadeLabel:error.domain];
   
}

-(void)hidHud
{
    [self hideHud:nil];
}


-(void)initPushOn
{
  
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;
    NSString *pushToken = self.deceiveToken?self.deceiveToken:@"";
    [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:pushToken status:2 provinceid:@"0"] tag:3];
    [requestObj release];
}

#pragma mark ---判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark ---邮箱验证 
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//- (SinaWeibo *)sinaweibo
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.sinaweibo;
//}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    if(oneTouch.tapCount==1)
    {
        _otherView.hidden = YES;
        isOther = NO;
        [_phoneFild resignFirstResponder];
        [_pwdFild resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _otherView.hidden = YES;
}

@end
