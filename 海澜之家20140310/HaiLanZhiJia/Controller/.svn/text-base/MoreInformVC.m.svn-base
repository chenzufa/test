//
//  MoreInformVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MoreInformVC.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "SDImageCache.h"
#import "ASIDownloadCache.h"
@interface MoreInformVC ()<UITableViewDataSource,UITableViewDelegate,DSRequestDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray *titleAry;
    UITableView *moreTableView;
    UILabel *chacheLabel;
    UILabel *viserLabel;
    UISwitch *onOffSwitch;
    BOOL OnOffStaint;
}

@property(nonatomic,retain)NSString *deceiveToken;

@property(nonatomic,retain)DSRequest *aRequest;


@end

@implementation MoreInformVC


- (void)dealloc
{
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    [moreTableView release];
    self.wbapi = nil;
    [chacheLabel release];
    [viserLabel release];
    [SinaWeiBoManager sharedInstance].delegate = nil;
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
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    [SinaWeiBoManager sharedInstance].delegate = self;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 320, 20)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    [topView release];
    
    
    //的到推送token
    self.deceiveToken = [[NSUserDefaults standardUserDefaults] objectForKey:kkkDeviceToken];
    //获取push开关状态
     [self initPushSet];
  //  [self addHud:@"请稍后"];
    
    if(self.wbapi == nil)
    {
        self.wbapi = [[[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI] autorelease];
    }
    
    [self setTitleString:@"更多"];
    [self initView];
   
    /*
     需求变更，联系客服目前不要，以后可能添加
     */
    
    titleAry =[ [NSMutableArray alloc]initWithObjects:@"消息推送",@"新浪微博",@"腾讯微博",@"帮助中心",@"意见反馈",@"关于我们",@"去AppStore评分",@"清理缓存",@"检查更新", nil];
    
}

#pragma mark ---初始化ui

-(void)initView
{
    
    moreTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 54, 300, MainViewHeight - TITLEHEIGHT - 20 - 10)];
    [moreTableView setShowsVerticalScrollIndicator:NO];
    moreTableView.tag = 0x1111;
    moreTableView.delegate = self;
    if(isIPhone5)
    {
        moreTableView.scrollEnabled = NO;
    }
    moreTableView.backgroundColor = [UIColor clearColor];
    moreTableView.dataSource = self;
    moreTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:moreTableView];
    if ([moreTableView respondsToSelector:@selector(setSeparatorInset:)]) { //去掉ios7每行分割线前的空白
        [moreTableView setSeparatorInset:UIEdgeInsetsZero];
    }

    
    //缓存大小
    chacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 100, 20)];
    chacheLabel.backgroundColor = [UIColor clearColor];
    chacheLabel.font = SYSTEMFONT(14);
    
    //版本
    viserLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 10, 100, 20)];
    viserLabel.backgroundColor = [UIColor clearColor];
    viserLabel.textColor = [UIColor blueColor];
    viserLabel.font = SYSTEMFONT(14);
    NSDictionary *itsUserDefaults = [[NSBundle mainBundle] infoDictionary];
    NSString *currentversion = [itsUserDefaults objectForKey:@"CFBundleVersion"];
    viserLabel.text = [NSString stringWithFormat:@"V%@",currentversion];
   


}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 15)]autorelease];
    [view setBackgroundColor:VIEW_BACKGROUND_COLOR];
    return view;
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)] autorelease];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
        需求变更，联系客服目前不要，以后可能添加
     */
//    if(section == 1)
//    {
//        return 4;
//    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell1 *cell =nil;
    if (!cell) {
        
          cell =  [[[MoreCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease] ;
       
    }
    //背景
    [cell setCellBackGroundView:indexPath.row andSection:indexPath.section];
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                if(onOffSwitch == nil)
                {
                    onOffSwitch =[[UISwitch alloc]init];
                    int height = onOffSwitch.bounds.size.width;
                    onOffSwitch.frame = CGRectMake(MainViewWidth-25-height, 8, 0, 20);
                    onOffSwitch.tag = 99;
                }
                //开关状态
                onOffSwitch.on = OnOffStaint;
                [onOffSwitch addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:onOffSwitch];
               

            }
                break;
            case 1:
            {

//                if (self.sinaButton == nil) {
                if (self.sinaButton != nil) {
                    [self.sinaButton removeFromSuperview];
                }
                
                UIButton *  rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setImage:GETIMG(@"more_button_quxiao@@x.png") forState:UIControlStateNormal];
                [rightBtn setImage:GETIMG(@"more_button_quxiao_press@@x.png") forState:UIControlStateHighlighted];
                rightBtn.tag = 100;
                rightBtn.frame = CGRectMake(220, 8, rightBtn.imageView.image.size.width/2, rightBtn.imageView.image.size.height/2);
                [rightBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:rightBtn];
                
                self.sinaButton = rightBtn;
//                }
                
                if([[NSUserDefaults standardUserDefaults] objectForKey:SinaWeiboAuthData])
                {
                    [rightBtn setImage:GETIMG(@"more_button_quxiao@@x.png") forState:UIControlStateNormal];
                    [rightBtn setImage:GETIMG(@"more_button_quxiao_press@@x.png") forState:UIControlStateHighlighted];
                }else
                {
                    [rightBtn setImage:GETIMG(@"more_button_bangding.png") forState:UIControlStateNormal];
                    [rightBtn setImage:GETIMG(@"more_button_bangding_press.png") forState:UIControlStateHighlighted];
                }
 
            }
                break;
            case 2:
            {
                UIImage *bangImg;
                UIImage *bangImg_press;
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"TecentWeiboAuthData"])
                    // if([weibo isAuthValid])
                {
                    bangImg = GETIMG(@"more_button_quxiao@@x.png");
                    bangImg_press = GETIMG(@"more_button_quxiao_press@@x.png");
                    UIButton *  rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    rightBtn.tag = 101;
                    rightBtn.frame = CGRectMake(220, 8, bangImg.size.width/2, bangImg.size.height/2);
                    [rightBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [rightBtn setBackgroundImage:bangImg forState:UIControlStateNormal];
                    [rightBtn setBackgroundImage:bangImg_press forState:UIControlStateHighlighted];
                    [cell.contentView addSubview:rightBtn];
                }
                
                else
                {
                    bangImg = GETIMG(@"more_button_bangding.png");
                    bangImg_press = GETIMG(@"more_button_bangding_press.png");
                    UIButton *  rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    rightBtn.tag = 101;
                    rightBtn.frame = CGRectMake(220, 8, bangImg.size.width, bangImg.size.height);
                    [rightBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [rightBtn setBackgroundImage:bangImg forState:UIControlStateNormal];
                    [rightBtn setBackgroundImage:bangImg_press forState:UIControlStateHighlighted];
                    [cell.contentView addSubview:rightBtn];
                }
 
            }
                break;
                
            default:
                break;
        }
        [cell setCellTitleString:[titleAry objectAtIndex:indexPath.row]];

    }
    //右边按钮
    if(!(indexPath.section==0))
    {
        [cell initBtn:indexPath.row andSection:indexPath.section];
    }
    //文字
    if(indexPath.section == 1)
    {
      [cell setCellTitleString:[titleAry objectAtIndex:indexPath.row+3]];
    }
    if(indexPath.section == 2)
    {
        if(indexPath.row == 1)//清理
        {
            unsigned long long tempSize = [[SDImageCache sharedImageCache] getSize];
            float sizeCache = (float)tempSize / (1024 * 1024);
            NSString *CecheString;
            if(sizeCache >0.1)
            {
                CecheString = [NSString stringWithFormat:@"(%.2fM)",sizeCache];
            }
            else
            {
                CecheString = [NSString stringWithFormat:@"(%.2fKB)",sizeCache*1024];
                
            }
            chacheLabel.text = CecheString;
            [cell.contentView addSubview:chacheLabel];
        }
        if(indexPath.row == 2)//检查更新
        {
            [cell.contentView addSubview:viserLabel];
        }
        [cell setCellTitleString:[titleAry objectAtIndex:indexPath.row+6]];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return 15;
    }else return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                HelpCrnterVC *helpView = [[HelpCrnterVC alloc]init];
                [self pushViewController:helpView];
                [helpView release];
            }
                break;
                
//            case 1:
//            {
//                ContractVC *contractView = [[ContractVC alloc]init];
//                [self pushViewController:contractView];
//                [contractView release];
//            }
//                break;
            case 1:
            {
                GetInforVC *inforView = [[GetInforVC alloc]init];
                [self pushViewController:inforView];
                [inforView release];
            }
                break;
            case 2:
            {
                AboutUsVC *aboutView = [[AboutUsVC alloc]init];
                NSDictionary *itsUserDefaults = [[NSBundle mainBundle] infoDictionary];
                NSString *currentversion = [itsUserDefaults objectForKey:@"CFBundleVersion"];
                NSString *viserString = [NSString stringWithFormat:@"V%@",currentversion];
                aboutView.viserStr = viserString;
                [self pushViewController:aboutView];
                [aboutView release];
 
            }
                break;
                
            default:
                break;
        }
    }
    if(indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                /*
                 id有待更新、、844939127
                 */
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id844939127"]];
               
            }
                break;
                
            case 1:
            {
               //清理缓存
                [self cacheMate];
            }
                break;
            case 2:
            {
                //检查更新
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                hud.labelText = @"正在检测新版本...";
                [hud show:YES];
                [self.view addSubview:hud];
                [hud release];
                NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=844939127"];
                NSURL *url = [NSURL URLWithString:urlString];
                ASIFormDataRequest *versionR = [ASIFormDataRequest requestWithURL:url];
                [versionR setDelegate:self];
                [versionR setRequestMethod:@"GET"];
                [versionR addRequestHeader:@"Content-Type" value:@"application/json"];
                [versionR setTimeOutSeconds:30];
                [versionR startAsynchronous];
            }
                break;
                            
            default:
                break;
        }

    }
    
}

#define mark --requestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *version = @"";
    NSString* jsonString = [request responseString];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *AuthDic = [jsonData objectFromJSONData];
    NSArray *configArr = [AuthDic valueForKey:@"results"];
    
    for (id config in configArr)
    {
        version = [config valueForKey:@"version"];
    }
    NSDictionary *userDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentV = [userDic objectForKey:@"CFBundleVersion"];
    double dVersion = [version doubleValue];
    double dCurVersion = [currentV doubleValue];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (dVersion > dCurVersion)
    {
        [WCAlertView showAlertWithTitle:@"提示" message:@"应用程序有新版本" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if(buttonIndex == 1)
         {
             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id844939127"]];
         }
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        

    }
    else
    {
       
        [self addFadeLabel:@"当前版本已是最新版本"];
    }
 
}

//#pragma mark -- UIAlertViewDelegate methods
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==1)
//    {
//        NSString*requestString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/mei-li-yun/id734257201?ls=1&mt=8"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestString]];
//    }
//}


//清理缓存
- (void)cacheMate
{
    [WCAlertView showAlertWithTitle:@"提示" message:@"确定清空缓存吗？" customizationBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleWhite;
        alertView.labelTextColor=[UIColor blackColor];
        alertView.buttonTextColor=[UIColor blueColor];
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == 0) {
            NSLog(@"Cancel");
        } else {
            NSLog(@"Ok");
             [self cacheConfirm];//清空
        }
        
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];

}

//清理缓存
-(void)cacheConfirm
{
//    [self addHud:@"正在清理..."];
//    [self performSelector:@selector(hideHud1) withObject:nil afterDelay:3];
    
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = @"正在清理...";
    [hud show:YES];
    hud.tag = 1;
    [self.view addSubview:hud];
    [hud release];
    [self performSelector:@selector(hideHud1:) withObject:hud afterDelay:2];

    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
}
-(void)hideHud1:(MBProgressHUD*)hud
{
    [hud hide:YES];
    if (hud.tag == 1)
    {
        [self addFadeLabel:@"清理完成！"];
        UITableView *tableView = (UITableView*)[self.view viewWithTag:0x1111];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationMiddle];
    }

}




/////推送
//-(void)initPushOn:(NSString *)proStr
//{
//    //没登录或没定位到id用0
//    int cityId = 0;
//    if(![proStr isEqualToString:@"0"])
//    {
//        cityId = [proStr getProvinceid];
//    }
//    //"更多"里面用到
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cityId] forKey:KeyCurrentProvinceID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    DSRequest *requestObj = [[DSRequest alloc]init];
//    requestObj.delegate = self;
//    NSLog(@"省：%@,%d",proStr,cityId);
//    [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:self.deceiveToken status:1 provinceid:cityId] tag:3];
//    [requestObj release];
//}
//

//开通
-(void)initPushOn
{
    //pushtoken	string	设备推送token
    //devicetype	int	设备类型：1.ios 2.android
    //status	int	需要设置的推送状态 0：禁用推送 1：启用推送
    ////    3.4.2获取消息推送开关状态 GetPushStatus,
    [self addHud:Loading];
    int cityId = 0;
    if(!isNotLogin)//用户登录了额(定位成功)
    {
        cityId = [[[NSUserDefaults standardUserDefaults] objectForKey:KeyCurrentProvinceID] intValue];
    }
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:self.deceiveToken status:1 provinceid:cityId] tag:0];
    [requestObj release];
}
//禁止
-(void)initPushOff
{
    [self addHud:Loading];
    int cityId = 0;
    if(!isNotLogin)//用户登录了额
    {
        cityId = [[[NSUserDefaults standardUserDefaults] objectForKey:KeyCurrentProvinceID] intValue];
    }

    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:self.deceiveToken status:0 provinceid:cityId] tag:1];
   // 消息推送开关状态
    [requestObj release];
  
}
//开关
-(void)initPushSet
{
     [self addHud:Loading];
   // [self.view addActivityIndicatorView:Loading]
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    // 消息推送开关状态
    [requestObj requestDataWithInterface:GetPushStatus param:[self GetPushStatusParam:self.deceiveToken] tag:2];
    [requestObj release];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    switch (tag) {
        case 0:
        {
            onOffSwitch.on = NO;
            NSLog(@"开通失败");
        }
            break;
        case 1:
        {   onOffSwitch.on = YES;
            NSLog(@"关闭失败");
        }
            break;
            
        default:
            break;
    }
    [self hideHud:nil];
    [self addFadeLabel:error.domain];
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    StatusEntity* entity = (StatusEntity *)dataObj;
    switch (tag) {
        case 0://开通
        {
            if(entity.response == 1)//ok
            {
                NSLog(@"11");
                [self addFadeLabel:@"开启推送成功"];
                OnOffStaint = YES;
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpen"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ClosePush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
            else//FAIL
            {
               
                [self addFadeLabel:@"开启推送失败"];
            }
        }
            break;
        case 1://禁止
        {
            if(entity.response == 1)
            {
//                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                OnOffStaint = NO;
                [[NSUserDefaults standardUserDefaults] setObject:@"closePush" forKey:@"ClosePush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self addFadeLabel:@"关闭推送成功"];
               
            }
            else //2
            {
                [self addFadeLabel:@"关闭推送失败"];
              
            }
 
        }
            break;
        case 2://状态
        {
            if(entity.response == 1)//开启
            {
                OnOffStaint = YES;
            }
            if(entity.response == 0)//关闭
            {
                OnOffStaint = NO;

            }
             [moreTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            // [userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationMiddle];
            
        }
            break;
            
        default:
            break;
    }

  //  [moreTableView reloadData];
}

-(void)pressBtn:(UIButton *)btn
{
   

    if(btn.tag == 99)//消息推送开关
    {
        UISwitch *mySwitsh = (UISwitch *)btn;
        
        if(mySwitsh.on)
        {
            NSLog(@"1");
            [self initPushOn];//开启
        }
        else
        {
           NSLog(@"0");
            [self initPushOff];//关闭
        }
    }
    if(btn.tag == 100)
    {
         if([[NSUserDefaults standardUserDefaults] objectForKey:SinaWeiboAuthData])//表示是解绑,要清除数据.
        {
            [[SinaWeiBoManager sharedInstance]sinalogout];
            [self.sinaButton setImage:GETIMG(@"more_button_bangding.png") forState:UIControlStateNormal];
            [self.sinaButton setImage:GETIMG(@"more_button_bangding_press.png") forState:UIControlStateHighlighted];
            
//            [self addFadeLabel:@"已解绑"];
            return;
        }else//绑定
        {
            [[SinaWeiBoManager sharedInstance]sinaLogin];
        }
        
        NSLog(@"绑定微博");
    }
    if(btn.tag == 101)
    {

        WeiboApi *weibo = [self tecentweibo];
        weibo.authDelegate = self;
   
        NSLog(@"%d",[weibo isAuthed]);
        ///////////////////////////
        if([weibo isAuthorizeExpired])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TecentWeiboAuthData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //if([weibo isAuthed])
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"TecentWeiboAuthData"])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TecentWeiboAuthData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
             [weibo cancelAuth];
            //找不到微博登出的回调方法
            [self addFadeLabel:@"已解绑"];
            [btn setBackgroundImage:GETIMG(@"more_button_bangding.png") forState:UIControlStateNormal];
            [btn setBackgroundImage:GETIMG(@"more_button_bangding_press.png") forState:UIControlStateHighlighted];
        }
        else
        {
            [weibo cancelAuth];
            [weibo loginWithDelegate:self andRootController:self];
        }
        
        NSLog(@"绑定腾信微博");
    }
    NSLog(@"%d",btn.tag);
}

#pragma mark - 腾讯微博
- (WeiboApi *)tecentweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.wbapi;
}
//
#pragma mark - 新浪微博
- (void)sinaWeiBoManagerDidLoginGetToken:(NSString *)accessToken userId:(NSString *)userID expirationDate:(NSDate *)expirationDate
{

    [moreTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ---腾讯代理

//- (void)DidAuthCanceled:(WeiboApi *)wbapi
//{
//    NSLog(@"111");
//}
//- (void)DidAuthRefreshFail:(NSError *)error
//{
//    NSLog(@"111");
//}
//
//- (void)DidAuthRefreshed:(WeiboApi *)wbapi
//{
//    NSLog(@"111");
//}

- (void)DidAuthFailWithError:(NSError *)error
{
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }

}

//tecent登录成功
- (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
     WeiboApi *weibo = [self tecentweibo];
//    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r,time=%f\r", weibo.accessToken, weibo.openid, weibo.appKey, weibo.appSecret,weibo.expires];
//    NSLog(@"result = %@",str);
   
    NSDictionary *TecentauthData = [NSDictionary dictionaryWithObjectsAndKeys:
                              weibo.accessToken, @"AccessTokenKey",
                              weibo.openid, @"OpenId",
                              weibo.appSecret, @"TecentSecret",
                            weibo.appKey, @"TecentAppKey",
                           [NSString stringWithFormat:@"%f",weibo.expires], @"TecentExp",nil];

    [[NSUserDefaults standardUserDefaults] setObject:TecentauthData forKey:@"TecentWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [moreTableView reloadData];
    
//    UIButton *btn = (UIButton *)[moreTableView viewWithTag:101];
//    [btn setBackgroundImage:GETIMG(@"more_button_quxiao@@x.png") forState:UIControlStateNormal];
//    [btn setBackgroundImage:GETIMG(@"more_button_quxiao_press@@x.png") forState:UIControlStateHighlighted];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
