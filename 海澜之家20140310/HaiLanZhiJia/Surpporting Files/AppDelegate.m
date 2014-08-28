//
//  AppDelegate.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AppDelegate.h"
#import "RootVC.h"
#import "MyWardrobeVC.h"
#import "AnimationsView.h"
//#import "SinaWeibo.h"
#import "WXApi.h"
#import "RemoteNotificationManage.h"
#import "DataVerifier.h"
#import "AlixPay.h"
#import <AdSupport/AdSupport.h>
#import "SinaWeiBoManager.h"
#define PUSHMANGER  [RemoteNotificationManage sharedRemoteNotificationManage]



@implementation AppDelegate
{
    NSString *deceiveToken;
}
- (void)dealloc
{
    [_window release];
//    SAFETY_RELEASE(_actionView);
    self.requestLjy.delegate = nil;
    self.requestLjy = nil;
    deceiveToken = nil;
    [super dealloc];
}

-(void)thisWayIscomming
{
    RootVC *rootVC = [RootVC shareInstance];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
  //  NSDictionary *noteDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [application setApplicationSupportsShakeToEdit:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    //  友盟统计
    [MobClick startWithAppkey:@"5334d60356240b439f07caa3" reportPolicy:SEND_INTERVAL   channelId:nil];
    
    [self getTime];//获得时间
    NSMutableArray *pointAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointAry"];
    NSLog(@"热点坐标集合：%@",pointAry);
//    if(pointAry)
//    {
    if (!self.requestLjy) {
        DSRequest *requestObj = [[DSRequest alloc]init];
        requestObj.delegate = self;
        self.requestLjy = requestObj;
        [requestObj release];
    }
    
        [self.requestLjy requestDataWithInterface:UploadHomeHotClick
                                       param:[self UploadHomeHotClickParam:self.dateStr
                                                             hotclick_list:pointAry] tag:0];
    
//    }

    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Token];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //微信注册
     [WXApi registerApp:weiXinApi];
    //推送注册
    [PUSHMANGER registerNotification];
    
    //新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
//    self.sinaweibo = [[[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:nil]autorelease];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *sinaweiboInfo = [defaults objectForKey:SinaWeiboAuthData];//新浪微博授权信息
//    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
//    {
//        self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
//        self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
//        self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
//    }
    
   //腾讯
    self.wbapi = [[[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI]autorelease];

    NSDictionary *tecentWeiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"TecentWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([tecentWeiboInfo objectForKey:@"AccessTokenKey"] && [tecentWeiboInfo objectForKey:@"TecentAppKey"] && [tecentWeiboInfo objectForKey:@"OpenId"]&&[tecentWeiboInfo objectForKey:@"TecentSecret"])
    {//TecentExp
        self.wbapi.accessToken = [tecentWeiboInfo objectForKey:@"AccessTokenKey"];
        self.wbapi.appKey = [tecentWeiboInfo objectForKey:@"TecentAppKey"];
        self.wbapi.openid = [tecentWeiboInfo objectForKey:@"OpenId"];
        self.wbapi.appSecret = [tecentWeiboInfo objectForKey:@"TecentSecret"];
        self.wbapi.expires = [[tecentWeiboInfo objectForKey:@"TecentExp"] doubleValue];
    }

    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thisWayIscomming) name:@"goRoot" object:nil];
    
//  关闭########
//    RootVC *rootVC = [RootVC shareInstance];
//    self.window.rootViewController = rootVC;
//    [self.window makeKeyAndVisible];

//    self.loginViewController = [[[LoginVC alloc] init]autorelease];
//    self.window.rootViewController = self.loginViewController;
//    //设置消息控制器的管理器主视图
//    ModelManager *tempModelManager = [ModelManager shareManager];
//    [tempModelManager setRootControllerWith:self];
    
    // 如果远程推送进入的页面，则直接设置 RootVC, 否则启动开机广告
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
            RootVC *rootVC = [RootVC shareInstance];
            self.window.rootViewController = rootVC;
            
			[PUSHMANGER receiveRemoteNotification:dictionary];
		}else{
            [self animalAction];
        }
	}else{
        [self animalAction];
    }
    
    
    
     self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    
     //首页坐标统计
    
    // 推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
//    if ([self isSingleTask]) {
//		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
//		
//		if (nil != url) {
//			[self parseURL:url application:application];
//		}
//	}
    //没有登陆,购物车清0
    if (isNotLogin)
    {
        int count=0;
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:count] forKey:kGouWuCheGoodsCount];
    }
    deceiveToken = [[[NSUserDefaults standardUserDefaults] objectForKey:kkkDeviceToken] retain];    //获取推送token
    return YES;
}
//- (BOOL)isSingleTask{
//	struct utsname name;
//	uname(&name);
//	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
//	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
//		return YES;
//	}
//	else {
//		return NO;
//	}
//}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    switch (tag) {
        case 0:     //获取热点
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pointAry"];
        }
            break;
        case 1:
        {
            NSLog(@"推送清零失败");
        }
            break;
            
        default:
            break;
    }
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    switch (tag) {
        case 0:     //获取热点
        {
            StatusEntity* entity = (StatusEntity *)dataObj;
            if(entity.response == 1)
            {
                NSLog(@"获取热点成功");
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pointAry"];
        }
            break;
        case 1:     //推送清零
        {
            StatusEntity* entity = (StatusEntity *)dataObj;
            if(entity.response == 1)
            {
                NSLog(@"推送清零成功");
            }
        }
            break;
            
        default:
            break;
    }
    
}

//开机动画
-(void)animalAction
{
    
    UIImage *animationImg = [UIImage imageNamed:@"bg_ip5.png"];
    if(!isIPhone5)
    {
        animationImg = [UIImage imageNamed:@"bg_ip4.png"];
    }
    
    [self loadHomePage];
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    view.image = animationImg;
    [self.window addSubview:view];
//    [self.window addSubview:_actionView];
    [self.window makeKeyAndVisible];
    [view release];
    
//    [self performSelector:@selector(loadHomePage) withObject:nil afterDelay:3];
    [self performSelector:@selector(removeQidongye:) withObject:view afterDelay:3];
    
    //之前谈入淡出的效果
//    [UIView beginAnimations:Nil context:Nil];
//    [UIView  setAnimationDelegate:self];
//    [UIView setAnimationDuration:4];
//    [UIView setAnimationDidStopSelector:@selector(loadHomePage)];
//    [UIView commitAnimations];
    
//    _actionView = [[AnimationsView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, MainViewHeight)];
//    UIImage *animationImg = [UIImage imageNamed:@"bg_ip5.png"];
//    if(!isIPhone5)
//    {
//        animationImg = [UIImage imageNamed:@"bg_ip4.png"]; 
//    }
//    
//    _actionView.fadeImage = animationImg;
//    _actionView.delegate = self;
//    _actionView.animationsType = eFadeImage;
//    [_actionView startAnimations];
  
    
}

-(void)loadHomePage
{
    GuideAdVC *guidView = [[GuideAdVC alloc]init];
    self.window.rootViewController = guidView;
    [self.window makeKeyAndVisible];
    [guidView release];
//    [view removeFromSuperview];
}

- (void)removeQidongye:(UIView *)senderview
{
    [senderview removeFromSuperview];
}

#pragma mark animationViewDelegate
- (void)animationsStart:(AnimationsView *)animationsView
{
    
}
- (void) animationsFinish:(AnimationsView*) animationsView
{
//    GuideAdVC *guidView = [[GuideAdVC alloc]init];
//    self.window.rootViewController = guidView;
//    [self.window makeKeyAndVisible];
//    [guidView release];
//    [_actionView removeFromSuperview];
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    if ([url.absoluteString hasPrefix:@"wx"]) {
       return  [WXApi handleOpenURL:url delegate:self];
    }
    if([url.absoluteString hasPrefix:@"tencent100413365"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    if([url.absoluteString hasPrefix:@"HaiLanZhiJia"])
    {
//        AlixPay *alixpay = [AlixPay shared];
//        return [alixpay handleOpenURL:url];
        [self parseURL:url application:application];
    }else if([url.absoluteString hasPrefix:@"wb552828054"]){
        return [WeiboSDK handleOpenURL:url delegate:[SinaWeiBoManager sharedInstance]];
    }
    return YES;
    
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application
{
    AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
    if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
                
                NSString *notiStr = result.statusMessage;
                if (!result.statusMessage || [result.statusMessage isEqualToString:@""]) {
                    notiStr = @"支付成功";
                    [[NSNotificationCenter defaultCenter]postNotificationName:ZhifubaoSuccess object:nil];      //支付成功发送通知
                }
                [WCAlertView showAlertWithTitle:@"提示" message:notiStr customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                    alertView.labelTextColor=[UIColor blackColor];
                    alertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                    
                } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];

                
        }//验签错误
			else {
                
                [WCAlertView showAlertWithTitle:@"提示" message:@"签名错误" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                    alertView.labelTextColor=[UIColor blackColor];
                    alertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            }
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
            
            [WCAlertView showAlertWithTitle:@"提示" message:result.statusMessage customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
            } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
		}
		
	}

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    if([url.absoluteString hasPrefix:@"tencent100413365"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    if([url.absoluteString hasPrefix:@"HaiLanZhiJia"])
    {
        AlixPay *alixpay = [AlixPay shared];
        return [alixpay handleOpenURL:url];
    }else if([url.absoluteString hasPrefix:@"wb552828054"]){
        return [WeiboSDK handleOpenURL:url delegate:[SinaWeiBoManager sharedInstance]];
    }

    return YES;
}

//#pragma mark WeiBoDelegate
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class])        // 登录认证
//    {
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//        NSLog(@" ==========  message = %@",message);
//        NSString *sinaToken = [(WBAuthorizeResponse *)response accessToken];
//        NSString *sinaUserid = [(WBAuthorizeResponse *)response userID];
//        [[NSUserDefaults standardUserDefaults]setObject:sinaToken forKey:SinaToken];
//        [[NSUserDefaults standardUserDefaults]setObject:sinaUserid forKey:SinaUserId];
//        
////        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        
//    }
//}

#pragma mark - mark
#pragma mark - 处理远程推送事件
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    // 转发获取deviceToken失败消息
    //失败存空
    //add by caijunbo on 2014-02-25
    //如果获取push token 失败，就用广告id代替push token
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:adId forKey:kkkDeviceToken];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kkkDeviceToken];
    //end adding
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PUSHMANGER failToRegisterForRemoteNotificationsWithError:error];
}

#pragma mark 推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSLog(@"token:\n%@",deviceToken);
    
    [PUSHMANGER registerForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PUSHMANGER receiveRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [self.requestLjy requestDataWithInterface:CleanPushStatus
                                        param:[self CleanPushStatusParm:deceiveToken] tag:1];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;   // 提醒数字清零
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)getTime
{
    
    NSDate *date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    
    // 年月日获得
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSLog(@"year:%d month: %d, day: %d", year, month, day);
    
    //当前的时分秒获得
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    NSLog(@"hour:%d minute: %d second: %d", hour, minute, second);
     self.dateStr= [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",year,month,day,hour,minute,second];
    
    
    

    
}


@end
