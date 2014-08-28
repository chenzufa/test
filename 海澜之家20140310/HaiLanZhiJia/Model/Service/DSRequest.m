//
//  DSRequest.h
//  MeiLiYun
//
//  Created by donson-周响 on 13-10-14.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//  添加 方法 isLocalCachEnableOfInterface 来判断一个接口是否应该缓存数据，self.strLocation_key 作为 key 值。 jiangsuiming 2014-01-15
//功能说明：数据请求管理类
//-----------------------------------------

#import "DSRequest.h"
#import "JSONKit.h"
#import "JSON.h"
#import "NSDictionary+SafeExtension.h"
#import "DesEncryptor.h"
#import "LoginViewCtrol.h"

#define KREQUESTTIMEOIUT 20.0
#define PHOTO_REQUEST_TIME 40
#define kStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

@implementation DSRequest
@synthesize delegate;

-(void)dealloc
{
    self.strLocation_key = nil;
    self.delegate=nil;
    [super dealloc];
}
#pragma mark ---------testResponseObject
-(void)testResponseObject:(NSArray *)array;
{
    enum InterfaceType type = [[array objectAtIndex:0]intValue];
    int tag = [[array objectAtIndex:1]intValue];
    
    NSString *jsonStr = nil;
    [self setResponseJSONString:&jsonStr withInterface:type];
    if (jsonStr == nil) {
        jsonStr = @"";
    }
    NSData* rawData=[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    ////解析数据
    [self parseJSONData:rawData interface:type tag:tag];
}
#pragma mark ---------2013/12/10	修改	所有接口请求参数加devicetype(1.android 2.iphone 3.ipad)
//是否为ipad
#define isIPad [[[UIDevice currentDevice]model] isEqualToString:@"iPad"]
//devicetype	int	设备类型：1. Android 2.iphone 3.ipad
-(NSString *)addDevicetypeParam:(NSString*)parm
{
//    int devicetype = isIPad? 3:2;
    
    if (parm.length == 0) {
        NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"devicetype",nil];
        return [tempDic JSONRepresentation];
    }
    NSDictionary *dataDic = nil;
    
    //如果是IOS5.0+ 使用原生json解析,否则使用JSONKit的解析
    NSData *data = [parm dataUsingEncoding:NSUTF8StringEncoding];
    NSError *parseError = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.f)
    {
        dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
    }
    else
    {
        dataDic =[data objectFromJSONData];
    }

    NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithDictionary:dataDic];
    [tempDic setValue:[NSNumber numberWithInt:2] forKey:@"devicetype"];
    return [tempDic JSONRepresentation];
}

#pragma mark ---------
-(void)requestDataWithInterface:(enum InterfaceType)type
                          param:(NSString*)parm
                            tag:(int)tag
{
    [self requestDataWithInterface:type param:parm uploadImg:nil tag:tag];
}

-(void)requestDataWithInterface:(enum InterfaceType)type
                          param:(NSString*)parm
                      uploadImg:(NSArray*)imgArray
                            tag:(int)tag
{
    self.strLocation_key=[NSString stringWithFormat:@"key_%d_%@",type,parm];
    NSLog(@"key = %@",self.strLocation_key);
    NSString* urlString=nil;
    NSString* httpMethod=nil;
    BOOL isNeedLocalData=NO;
    
    //设置请求服务的URL
    [self setUrlString:&urlString HTTPMethod:&httpMethod isNeedLocalData:&isNeedLocalData withInterface:type];
    //所有接口请求参数加devicetype(1.android 2.iphone 3.ipad)
    parm = [self addDevicetypeParam:parm];
    
    NSLog(@"---request参数----------\n1,urlString:%@ \n2,parm:%@",urlString,parm);//
    
    //将参数加密
    if ([self isDesEncryptorInterface:type])//加密接口
    {
        parm=[DesEncryptor desEncryption:parm Key:@"donsonapp"];
        NSLog(@"parm DesEncryptor:%@",parm);//
    }
    
    // 获取数据
    
    
    //在加载了本地数据以后，如果网络不可达，则直接返回；如果网络可达，请求网络
    //1.从本地读取数据
    
    
    if ([self isLocalCachEnableOfInterface:type]) {
        if ([self checkNetWork] == YES && [self OnlyLocalOrNetOfInterface:type])  //有网络;仅取一次数据，网络或缓存,不要加载缓存数据
        {
            if (type==GetGoodsDetail||type==GetUserComments)
            {
                id rawData=[[NSUserDefaults standardUserDefaults] objectForKey:self.strLocation_key];
                if (rawData!=nil)
                {
                    ////解析数据
                    id dateDict  = [NSKeyedUnarchiver unarchiveObjectWithData:rawData] ;
                    [self handleResponseDataDic:dateDict interface:type tag:tag];
                }
            }
        }else{
            id rawData=[[NSUserDefaults standardUserDefaults] objectForKey:self.strLocation_key];
            if (rawData!=nil)
            {
                ////解析数据
                id dateDict  = [NSKeyedUnarchiver unarchiveObjectWithData:rawData] ;
                [self handleResponseDataDic:dateDict interface:type tag:tag];
            }
        }
        
        
    }
    
    //2.从服务端获取数据
    if ([self checkNetWork] == NO) {
        //是否有网络
        if ([self.delegate respondsToSelector:@selector(requestDataFail:tag:error:)]) {
            [self.delegate requestDataFail:type tag:tag error:[NSError errorWithDomain:@"无法连接网络" code:1 userInfo:nil]];
        }
        return;
    }
    
    DSASIFormDataRequest *asiRequest = [DSASIFormDataRequest requestWithURL:[NSURL URLWithString:[urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    if (type == PublishShowOrder || type == PublishShowOrder ) {
        [asiRequest setTimeOutSeconds:PHOTO_REQUEST_TIME];
    }else{
        [asiRequest setTimeOutSeconds:KREQUESTTIMEOIUT];
    }
    
    [asiRequest setDelegate:self];
    [asiRequest setRequestMethod:@"POST"];
    
    //有图片数据
    if (imgArray!=nil&&[imgArray count]!=0)
    {
        [asiRequest setPostFormat:ASIMultipartFormDataPostFormat];
        
        [asiRequest addPostValue:parm forKey:@"p"];
        //添加图片数据
        for (int i=0; i<[imgArray count]; i++)
        {
            NSData* imageData = UIImagePNGRepresentation((UIImage *)[imgArray objectAtIndex:i]);
            [asiRequest addData:imageData withFileName:[NSString stringWithFormat:@"file%d.png",i] andContentType:@"image/png" forKey:[NSString stringWithFormat:@"pic%d",i]];
        }
        
    }else
    {
        [asiRequest setPostFormat:ASIURLEncodedPostFormat];
        
        NSString* strbody=[NSString stringWithFormat:@"%@",parm];
        [asiRequest setPostBody:(NSMutableData *)[strbody dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    //////////////////////////
    [asiRequest retain];
    [self retain];
    
    //////////////////////////
    [asiRequest setRequestType:type];
    [asiRequest setRequestTag:tag];

    [asiRequest startAsynchronous];
    
    return;
    
}

#pragma mark - ASIHTTPRequestDelegate
// 请求响应完成返回数据
- (void)requestFinished:(ASIHTTPRequest *)request
{
    DSASIFormDataRequest* dsrequest=(DSASIFormDataRequest *)request;
    
    ////解析数据
    [self parseJSONData:dsrequest.responseData interface:dsrequest.requestType tag:dsrequest.requestTag];
    
    
    [request clearDelegatesAndCancel];
    [request release];
    request = nil;
    
    [self release];
    self = nil;
}
// 请求超时
- (void)requestFailed:(ASIHTTPRequest *)request
{
    DSASIFormDataRequest* dsrequest=(DSASIFormDataRequest *)request;
    //是否存储数据到本地
    if (dsrequest.strRequestKey == nil) {
        if ([self.delegate respondsToSelector:@selector(requestDataFail:tag:error:)]) {
            [self.delegate requestDataFail:dsrequest.requestType tag:dsrequest.requestTag error:[NSError errorWithDomain:@"请求超时" code:1 userInfo:nil]];
        }
    }
    
    [request clearDelegatesAndCancel];
    [request release];
    request = nil;
    
    [self release];
    self = nil;
}

#pragma mark --
-(BOOL)checkNetWork
{
    return [[WatchDog luckDog]haveNetWork];
    
    
}

-(BOOL)checkServer
{
    // 以下方法会阻塞线程  jiangsuiming 2014-01-16
    
    BOOL bIsNetworkOkay=NO;
    NSString* strURLToCheck=kDSRequestAPIDomain;
    NSURL *url1 = [NSURL URLWithString:strURLToCheck];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSHTTPURLResponse *responseFromServer=nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &responseFromServer error: nil];
    if (responseFromServer == nil) {
        bIsNetworkOkay=NO;
    }
    else{
        bIsNetworkOkay=YES;
    }
    return bIsNetworkOkay;

}

- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark --
#pragma mark 数据解析方法
-(void)parseJSONData:(NSData*)data interface:(enum InterfaceType)type tag:(int)tag
{
    id dataDic = nil;
    //先解密
    NSString* strEncry=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    if ([self isDesEncryptorInterface:type]&&strEncry!=nil&&(![strEncry hasPrefix:@"{"])) {

        NSString* strDes=[DesEncryptor desDecryption:strEncry Key:@"donsonapp"];
        dataDic=[strDes objectFromJSONString];
    }else
    {
        //如果是IOS5.0+ 使用原生json解析,否则使用JSONKit的解析
        NSError *parseError = nil;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.f)
        {
            dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
        }//dsrequest.responseData
        else
        {
            dataDic =[data objectFromJSONData];
        }
    }
    
    NSLog(@"---response原json串结果----------\n%@",[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease]);//
    NSLog(@"---response解析后结果----------\n%@",dataDic);//
    
    //判断数据格式是否合法
    if (dataDic==nil||![dataDic isKindOfClass:[NSDictionary class]]) {
        if ([self.delegate respondsToSelector:@selector(requestDataFail:tag:error:)]) {
            [self.delegate requestDataFail:type tag:tag error:[NSError errorWithDomain:@"无法连接服务器" code:1 userInfo:nil]];
        }
        return;
    }
    
    //判断数据是否正常返回
    int iErrorCode=[[[dataDic valueForKey:@"result"] safeValueForKey:@"error_code"] intValue];
    if (iErrorCode!=200)
    {
        if (iErrorCode == 304)
        {//无数据返回
            if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
            {
                [self.delegate requestDataSuccess:nil tag:tag];
            }
            return;
        }
        if (iErrorCode == 201) {//登录用户过期
            if (isNotLogin) {
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录时效已过，请重新登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil , nil];
                [alert show];
                [alert release];
                [self logout];
            }
            
            if ([self.delegate respondsToSelector:@selector(requestDataFail:tag:error:)]) {
                [self.delegate requestDataFail:type tag:tag error:[NSError errorWithDomain:@"登录时效已过，请重新登录" code:iErrorCode userInfo:nil]];
            }
            return;
        }
        if ([self.delegate respondsToSelector:@selector(requestDataFail:tag:error:)])
        {
            [self.delegate requestDataFail:type tag:tag error:[NSError errorWithDomain:[NSString stringWithFormat:@"%@:code: %i",[[dataDic valueForKey:@"result"] safeValueForKey:@"error_msg"],iErrorCode] code:iErrorCode userInfo:nil]];
            //[self.delegate requestDataFail:type tag:tag error:[NSError errorWithDomain:@"无法连接服务器" code:1 userInfo:nil]];
        }
        return;
    }
    
    //开始解析 iErrorCode==200
    
    //是否存储数据到本地
    if ([self isLocalCachEnableOfInterface:type])
    {
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
        [[NSUserDefaults standardUserDefaults] setObject:udObject forKey:self.strLocation_key];
    }
    [self handleResponseDataDic:dataDic interface:type tag:tag];
}

//临时加在这里
- (void)logout
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    [userdefalut removeObjectForKey:UserId];
    [userdefalut removeObjectForKey:Token];
//    [userdefalut removeObjectForKey:@"auto"];
    [userdefalut removeObjectForKey:@"userLoginData"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:kGouWuCheGoodsCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    LoginViewCtrol *loginView = [[LoginViewCtrol alloc]init];
    //        loginView.backDelegate = self;
    [loginView pushViewController:loginView];
    [loginView release];
}
#pragma mark  ------接口是否缓存------
- (BOOL) isLocalCachEnableOfInterface:(enum InterfaceType)type
{
    //把需要缓存的接口返回 yes
    //首页的推荐商品、焦点轮播图、特殊活动列表、开机广告
    if (type == RecommendGoods || type == FocusInfo || type == GetSpecialList  || type ==  StartupAD) {
        return YES;
    }
    //商城列表
    else if (type == ShoppingMallCategory ) {
        return YES;
    }
    //购物车
    else if (type == GetShoppingCarInfo){
        return YES;
    }
    // 热门关键词
    else if (type == GetPopularSearchWords ) {
        return YES;
    }
    else if (type == GetGoodsDetail ) {
        return YES;
    }else if (type == GetUserComments){
        return YES;
    }
    //
    else
    {
        return NO;
    }
}
#pragma mark  ------缓存数据或网络数据------
- (BOOL) OnlyLocalOrNetOfInterface:(enum InterfaceType)type
{
    //缓存和网络仅返回一次
    // 热门关键词
    return YES;
    if (type == GetPopularSearchWords ) {
        return YES;
    }
    //
    else
    {
        return NO;
    }
}
#pragma mark  ------涉及到敏感信息的接口需要做加密处理（DES加密）------
//大家看看，为方便测试调试项目交付前先明文处理，交付的时候开启加密处理。
-(BOOL)isDesEncryptorInterface:(enum InterfaceType)type
{
    if (!DES_CODE) {
        return NO;
    }
    switch (type)
    {
            //    3.5	我的衣柜（会员中心）
            //    3.5.1修改个人信息
        case ModifyCustomerInfo:
        {
            return YES;
        }
            break;
            //    3.5.2 订单提醒列表
        case OrderRemindedList:
        {
            return YES;
        }
            break;
            //    3.5.3 获取我的订单列表
        case MyOrderList:
        {
            return YES;
        }
            break;
            //    3.5.4 获取订单详情
        case MyOrderDetail:
        {
            return YES;
        }
            break;
            //    3.5.5 取消订单
        case CancelOrder:
        {
            return YES;
        }
            break;
            //    3.5.21获取个人信息
        case GetCustomerInfo:
        {
            return YES;;
        }
            break;
            //    3.5.22获取订单物流详情
        case GetOrderDeliverDetail:
        {
            return YES;;
        }
            break;
            
            //    3.6	购物车
            //    3.6.1获取购物车信息
        case GetShoppingCarInfo:
        {
            return YES;;
        }
            break;
            //    3.6.2 提交订单
        case CommitOrder:
        {
            return YES;;
        }
            break;
            //    3.6.3 添加到购物车（不在购物车页面时添加物品）
        case AddToShoppingCar:
        {
            return YES;;
        }
            break;
            //    3.6.4 删除购物车物品
        case ShoppingCarDel:
        {
            return YES;;
        }
            break;
            //    3.6.5 修改购物车物品数量
        case ShoppingCarModify:
        {
            return YES;;
        }
            break;
            //    3.6.6 购物车物品选中状态设置
        case ShoppingCarGoodsSelection:
        {
            return YES;;
        }
            break;
            //    3.6.9 商品结算（点击“去结算”时调用）
        case GoodsSettleUp:
        {
            return YES;;
        }
            break;
            //    3.6.12 获取可使用（结算）购物券信息
        case GetUseableShoppingTicket:
        {
            return YES;;
        }
            break;
            //    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
        case SpecialbuySettleup:
        {
            return YES;;
        }
            break;
            //    3.6.16 获取银联交易流水号
        case GetUPPayTN:
        {
            return YES;;
        }
            break;
            
            //    3.7	注册
            //    3.7.1 注册
        case Register:
        {
            return YES;;
        }
            break;
            //    3.7.2 登录
        case Login:
        {
            return YES;;
        }
            break;
            //    3.7.3 找回密码
        case ForgetPasswd:
        {
            return YES;;
        }
            break;
            //    3.7.6 修改密码
        case ChangePassword:
        {
            return YES;;
        }
            break;
            
            
        default:
        {
            return NO;
        }
            break;
    }
}

/////////-------------/////////////////////////---------------///////////////////////////
#pragma mark ------------重写部分
-(void)setUrlString:(NSString **)urlString HTTPMethod:(NSString **)httpMethod isNeedLocalData:(BOOL *)isNeedLocalData withInterface:(enum InterfaceType)type
{
    *httpMethod = @"POST";
    *isNeedLocalData = NO;
    
    switch (type)
    {
            //    3.1	首页
            //    3.1.1推荐商品
        case RecommendGoods:
        {
            *urlString = RecommendGoodsURL;
        }
            break;
            //    3.1.2 焦点资讯
        case FocusInfo:
        {
            *urlString = FocusInfoURL;
        }
            break;
            //    3.1.3 获取首页6个专题
        case GetSpecialList:
        {
            *urlString = GetSpecialListURL;
        }
            break;
            //    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
        case GetSpecialActivityList:
        {
            *urlString = GetSpecialActivityListURL;
        }
            break;
            //    3.1.5 获取秒杀、团购专题列表
        case GetSpecialBuyList:
        {
            *urlString = GetSpecialBuyListURL;
        }
            break;
            //    3.1.6获取秒杀、团购详情
        case GetSpecialBuyDetail:
        {
            *urlString = GetSpecialBuyDetailURL;
        }
            break;
            //    3.1.7 获取用户对商品的评论
        case GetUserComments:
        {
            *urlString = GetUserCommentsURL;
        }
            break;
            //    3.1.8 开机启动广告
        case StartupAD:
        {
            *urlString = StartupADURL;
        }
            break;
            //    3.1.9提交首页热点 
        case UploadHomeHotClick:
        {
            *urlString = UploadHomeHotClickURL;
        }
            break;
            //    3.1.10广告点击统计接口 
        case ADClickReport:
        {
            *urlString = ADClickReportURL;
        }
            break;
            //    3.1.11用户信息统计接口 (登录后调用)
        case UserInfoReport:
        {
            *urlString = UserInfoReportURL;
        }
            break;
            
            //    3.2	商城（分类）
            //    3.2.1商城分类列表
        case ShoppingMallCategory:
        {
            *urlString = ShoppingMallCategoryURL;
        }
            break;
            //    3.2.2获取商品列表筛选条件
        case GetGoodsListSpec:
        {
            *urlString = GetGoodsListSpecURL;
        }
            break;
            //    3.2.3获取商品列表
        case GetGoodsList:
        {
            *urlString = GetGoodsListURL;
        }
            break;
            //    3.2.4获取商品详情
        case GetGoodsDetail:
        {
            *urlString = GetGoodsDetailURL;
        }
            break;
            //    3.2.5 获取售前咨询列表
        case GetSaleConsultList:
        {
            *urlString = GetSaleConsultListURL;
        }
            break;
            //    3.2.6 提交咨询
        case ConsultCommit:
        {
            *urlString = ConsultCommitURL;
        }
            break;
            //    3.2.7 套装详情
        case SuitDetail:
        {
            *urlString = SuitDetailURL;
        }
            break;
            //    3.2.8 猜你喜欢
        case YourFavourateIntroduce:
        {
            *urlString = YourFavourateIntroduceURL;
        }
            break;
            //    3.2.9 商品收藏
        case GoodsSaving:
        {
            *urlString = GoodsSavingURL;
        }
            break;
            
            //    3.3	搜索
            //    3.3.1 获取热门搜索词
        case GetPopularSearchWords:
        {
            *urlString = GetPopularSearchWordsURL;
        }
            break;
            //    3.3.2获取文本搜索结果
        case GetTextSearchResult:
        {
            *urlString = GetTextSearchResultURL;
        }
            break;
            //    3.3.3获取条码搜索结果
        case GetBarcodeSearchResult:
        {
            *urlString = GetBarcodeSearchResultURL;
        }
            break;
            //    3.3.4获取颜色购搜索结果
        case GetColorBuySearchResult:
        {
            *urlString = GetColorBuySearchResultURL;
        }
            break;
            //    3.3.5获取摇一摇搜索结果
        case GetShakeSearchResult:
        {
            *urlString = GetShakeSearchResultURL;
        }
            break;
            //    3.3.6获取摇一摇限制条件
        case GetShakeRestrict:
        {
            *urlString = GetShakeRestrictURL;
        }
            break;
            
            //    3.4	设置（更多）
            //    3.4.1设置消息推送
        case PushSetting:
        {
            *urlString = PushSettingURL;
        }
            break;
            //    3.4.2获取消息推送开关状态
        case GetPushStatus:
        {
            *urlString = GetPushStatusURL;
        }
            break;
            //    3.4.3获取帮助信息
        case GetHelpInfo:
        {
            *urlString = GetHelpInfoURL;
        }
            break;
            //    3.4.4意见反馈
        case CustomerFeedback:
        {
            *urlString = CustomerFeedbackURL;
        }
            break;
            //    3.4.4意见反馈
        case CleanPushStatus:
        {
            *urlString = CleanPushStatusURL;
        }
            break;
            
            //    3.5	我的衣柜（会员中心）
            //    3.5.1修改个人信息
        case ModifyCustomerInfo:
        {
            *urlString = ModifyCustomerInfoURL;
        }
            break;
            //    3.5.2 订单提醒列表
        case OrderRemindedList:
        {
            *urlString = OrderRemindedListURL;
        }
            break;
            //    3.5.3 获取我的订单列表
        case MyOrderList:
        {
            *urlString = MyOrderListURL;
        }
            break;
            //    3.5.4 获取订单详情
        case MyOrderDetail:
        {
            *urlString = MyOrderDetailURL;
        }
            break;
            //    3.5.5 取消订单
        case CancelOrder:
        {
            *urlString = CancelOrderURL;
        }
            break;
            //    3.5.6 获取我的收藏列表
        case GetMySaveList:
        {
            *urlString = GetMySaveListURL;
        }
            break;
            //    3.5.7 删除收藏
        case DeleteSaving:
        {
            *urlString = DeleteSavingURL;
        }
            break;
            //    3.5.8 添加送货地址
        case AddingAddress:
        {
            *urlString = AddingAddressURL;
        }
            break;
            //    3.5.9获取送货地址
        case GetAddressList:
        {
            *urlString = GetAddressListURL;
        }
            break;
            //    3.5.10 修改送货地址
        case ModifyAddress:
        {
            *urlString = ModifyAddressURL;
        }
            break;
            //    3.5.11 删除、设定默认送货地址
        case DelAndSetDefaultAddress:
        {
            *urlString = DelAndSetDefaultAddressURL;
        }
            break;
            //    3.5.12 购物券信息（现金券、抵用券）
        case ShoppingTicketInfo:
        {
            *urlString = ShoppingTicketInfoURL;
        }
            break;
            //    3.5.13 绑定购物券（现金券、抵用券）
        case BindShoppingTicket:
        {
            *urlString = BindShoppingTicketURL;
        }
            break;
            //    3.5.14 积分信息
        case ScoreInfo:
        {
            *urlString = ScoreInfoURL;
        }
            break;
            //    3.5.16 我的评论列表
        case MyCommentList:
        {
            *urlString = MyCommentListURL;
        }
            break;
            //    3.5.17 发表评论
        case PublishComment:
        {
            *urlString = PublishCommentURL;
        }
            break;
            //    3.5.18 晒单列表
        case ShowOrderList:
        {
            *urlString = ShowOrderListURL;
        }
            break;
            //    3.5.19 我的晒单
        case MyShowOrder:
        {
            *urlString = MyShowOrderURL;
        }
            break;
            //    3.5.20 发表晒单
        case PublishShowOrder:
        {
            *urlString = PublishShowOrderURL;
        }
            break;
            //    3.5.21获取个人信息
        case GetCustomerInfo:
        {
            *urlString = GetCustomerInfoURL;
        }
            break;
            //    3.5.22获取订单物流详情
        case GetOrderDeliverDetail:
        {
            *urlString = GetOrderDeliverDetailURL;
        }
            break;
            //    3.5.23 上传、修改个人图像
        case UploadPersonalPic:
        {
            *urlString = UploadPersonalPicURL;
        }
            break;
            //    3.5.24 获取（红点）提醒信息接口
        case GetReminderInfo:
        {
            *urlString = GetReminderInfoURL;
        }
            break;
            //    3.5.25 删除订单提醒
        case DelRemind:
        {
            *urlString = DelRemindURL;
        }
            break;
            //    3.5.25 确认收货
        case ConfirmOrder:
        {
            *urlString = ConfirmOrderURL;
        }
            break;
            //    3.5.27 修改订单详情支付方式
        case ChangeOrderPaytype:
        {
            *urlString = ChangeOrderPaytypeURL;
        }
            break;
            
            //    3.6	购物车
            //    3.6.1获取购物车信息
        case GetShoppingCarInfo:
        {
            *urlString = GetShoppingCarInfoURL;
        }
            break;
            //    3.6.2 提交订单
        case CommitOrder:
        {
            *urlString = CommitOrderURL;
        }
            break;
            //    3.6.3 添加到购物车（不在购物车页面时添加物品）
        case AddToShoppingCar:
        {
            *urlString = AddToShoppingCarURL;
        }
            break;
            //    3.6.4 删除购物车物品
        case ShoppingCarDel:
        {
            *urlString = ShoppingCarDelURL;
        }
            break;
            //    3.6.5 修改购物车物品数量
        case ShoppingCarModify:
        {
            *urlString = ShoppingCarModifyURL;
        }
            break;
            //    3.6.6 购物车物品选中状态设置
        case ShoppingCarGoodsSelection:
        {
            *urlString = ShoppingCarGoodsSelectionURL;
        }
            break;
            //    3.6.7 购物车获取赠品信息列表
        case ShoppingCarPresentationList:
        {
            *urlString = ShoppingCarPresentationListURL;
        }
            break;
            //    3.6.8 购物车提交选中的赠品信息
        case ShoppingCarCommitPresentation:
        {
            *urlString = ShoppingCarCommitPresentationURL;
        }
            break;
            //    3.6.9 商品结算（点击“去结算”时调用）
        case GoodsSettleUp:
        {
            *urlString = GoodsSettleUpURL;
        }
            break;
            //    3.6.10 获取商品支付方式
        case GetPayType:
        {
            *urlString = GetPayTypeURL;
        }
            break;
            //    3.6.12 获取可使用（结算）购物券信息
        case GetUseableShoppingTicket:
        {
            *urlString = GetUseableShoppingTicketURL;
        }
            break;
            //    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
        case SpecialbuySettleup:
        {
            *urlString = SpecialbuySettleupURL;
        }
            break;
            //    3.6.14 获取使用规则
        case GetRegulation:
        {
            *urlString = GetRegulationURL;
        }
            break;
            //    3.6.15 获取运费金额
        case GetDeliverFee:
        {
            *urlString = GetDeliverFeeURL;
        }
            break;
            //    3.6.16 获取银联交易流水号
        case GetUPPayTN:
        {
            *urlString = GetUPPayTNURL;
        }
            break;
            
            //    3.7	注册
            //    3.7.1 注册
        case Register:
        {
            *urlString = RegisterURL;
        }
            break;
            //    3.7.2 登录
        case Login:
        {
            *urlString = LoginURL;
        }
            break;
            //    3.7.3 找回密码
        case ForgetPasswd:
        {
            *urlString = ForgetPasswdURL;
        }
            break;
            //    3.7.4 获取匿名用户id
        case GetAnonymityID:
        {
            *urlString = GetAnonymityIDURL;
        }
            break;
            //    3.7.5 退出登录接口
        case Logout:
        {
            *urlString = LogoutURL;
        }
            break;
            //    3.7.6 修改密码
        case ChangePassword:
        {
            *urlString = ChangePasswordURL;
        }
            break;
            //    3.7.7 自动登录
        case AutoLogin:
        {
            *urlString = AutoLoginURL;
        }
            break;
            
        default:
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"警告URL：" message:@"请求的接口类型出错！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
            break;
    }
}
- (void)handleResponseDataDic:(NSDictionary *)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    switch (type)
    {
            //    3.1	首页
            //    3.1.1推荐商品
        case RecommendGoods:
        {
            [self RecommendGoodsResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.2 焦点资讯
        case FocusInfo:
        {
            [self FocusInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.3 获取首页6个专题
        case GetSpecialList:
        {
            [self GetSpecialListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
        case GetSpecialActivityList:
        {
            [self GetSpecialActivityListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.5 获取秒杀、团购专题列表
        case GetSpecialBuyList:
        {
            [self GetSpecialBuyListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.6获取秒杀、团购详情
        case GetSpecialBuyDetail:
        {
            [self GetSpecialBuyDetailResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.7 获取用户对商品的评论
        case GetUserComments:
        {
            [self GetUserCommentsResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.8 开机启动广告
        case StartupAD:
        {
            [self StartupADResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.9提交首页热点
        case UploadHomeHotClick:
        {
            [self UploadHomeHotClickResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.10广告点击统计接口
        case ADClickReport:
        {
            [self ADClickReportResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.1.11用户信息统计接口 (登录后调用)
        case UserInfoReport:
        {
            [self UserInfoReportResponse:dataDic interface:type tag:tag];
        }
            break;
            
            //    3.2	商城（分类）
            //    3.2.1商城分类列表
        case ShoppingMallCategory:
        {
            [self ShoppingMallCategoryResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.2获取商品列表筛选条件
        case GetGoodsListSpec:
        {
            [self GetGoodsListSpecResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.3获取商品列表
        case GetGoodsList:
        {
            [self GetGoodsListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.4获取商品详情
        case GetGoodsDetail:
        {
            [self GetGoodsDetailResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.5 获取售前咨询列表
        case GetSaleConsultList:
        {
            [self GetSaleConsultListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.6 提交咨询
        case ConsultCommit:
        {
            [self ConsultCommitResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.7 套装详情
        case SuitDetail:
        {
            [self SuitDetailResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.8 猜你喜欢
        case YourFavourateIntroduce:
        {
            [self YourFavourateIntroduceResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.2.9 商品收藏
        case GoodsSaving:
        {
            [self GoodsSavingResponse:dataDic interface:type tag:tag];
        }
            break;
            
            //    3.3	搜索
            //    3.3.1 获取热门搜索词
        case GetPopularSearchWords:
        {
            [self GetPopularSearchWordsResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.3.2获取文本搜索结果
        case GetTextSearchResult:
        {
            [self GetTextSearchResultResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.3.3获取条码搜索结果
        case GetBarcodeSearchResult:
        {
            [self GetBarcodeSearchResultResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.3.4获取颜色购搜索结果
        case GetColorBuySearchResult:
        {
            [self GetColorBuySearchResultResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.3.5获取摇一摇搜索结果
        case GetShakeSearchResult:
        {
            [self GetShakeSearchResultResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.3.6获取摇一摇限制条件
        case GetShakeRestrict:
        {
            [self GetShakeRestrictResponse:dataDic interface:type tag:tag];
        }
            break;
            
            //    3.4	设置（更多）
            //    3.4.1设置消息推送
        case PushSetting:
        {
            [self PushSettingResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.4.2获取消息推送开关状态
        case GetPushStatus:
        {
            [self GetPushStatusResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.4.3获取帮助信息
        case GetHelpInfo:
        {
            [self GetHelpInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.4.4意见反馈
        case CustomerFeedback:
        {
            [self CustomerFeedbackResponse:dataDic interface:type tag:tag];
        }
            break;
        case CleanPushStatus:
        {
            [self CleanPushStatusResponse:dataDic interface:type tag:tag];
        }
            break;
            
            //    3.5	我的衣柜（会员中心）
            //    3.5.1修改个人信息
        case ModifyCustomerInfo:
        {
            [self ModifyCustomerInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.2 订单提醒列表
        case OrderRemindedList:
        {
            [self OrderRemindedListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.3 获取我的订单列表
        case MyOrderList:
        {
            [self MyOrderListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.4 获取订单详情
        case MyOrderDetail:
        {
            [self MyOrderDetailResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.5 取消订单
        case CancelOrder:
        {
            [self CancelOrderResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.6 获取我的收藏列表
        case GetMySaveList:
        {
            [self GetMySaveListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.7 删除收藏
        case DeleteSaving:
        {
            [self DeleteSavingResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.8 添加送货地址
        case AddingAddress:
        {
            [self AddingAddressResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.9获取送货地址
        case GetAddressList:
        {
            [self GetAddressListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.10 修改送货地址
        case ModifyAddress:
        {
            [self ModifyAddressResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.11 删除、设定默认送货地址
        case DelAndSetDefaultAddress:
        {
            [self DelAndSetDefaultAddressResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.12 购物券信息（现金券、抵用券）
        case ShoppingTicketInfo:
        {
            [self ShoppingTicketInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.13 绑定购物券（现金券、抵用券）
        case BindShoppingTicket:
        {
            [self BindShoppingTicketResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.14 积分信息
        case ScoreInfo:
        {
            [self ScoreInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.16 我的评论列表
        case MyCommentList:
        {
            [self MyCommentListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.17 发表评论
        case PublishComment:
        {
            [self PublishCommentResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.18 晒单列表
        case ShowOrderList:
        {
            [self ShowOrderListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.19 我的晒单
        case MyShowOrder:
        {
            [self MyShowOrderResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.20 发表晒单
        case PublishShowOrder:
        {
            [self PublishShowOrderResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.21获取个人信息
        case GetCustomerInfo:
        {
            [self GetCustomerInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.22获取订单物流详情
        case GetOrderDeliverDetail:
        {
            [self GetOrderDeliverDetailResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.23 上传、修改个人图像
        case UploadPersonalPic:
        {
            [self UploadPersonalPicResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.24 获取（红点）提醒信息接口
        case GetReminderInfo:
        {
            [self GetReminderInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.25 删除订单提醒
        case DelRemind:
        {
            [self DelRemindResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.25 确认收货
        case ConfirmOrder:
        {
            [self ConfirmOrderResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.5.27 修改订单详情支付方式
        case ChangeOrderPaytype:
        {
            [self ChangeOrderPaytypeResponse:dataDic interface:type tag:tag];
        }
            break;
            
            //    3.6	购物车
            //    3.6.1获取购物车信息
        case GetShoppingCarInfo:
        {
            [self GetShoppingCarInfoResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.2 提交订单
        case CommitOrder:
        {
            [self CommitOrderResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.3 添加到购物车（不在购物车页面时添加物品）
        case AddToShoppingCar:
        {
            [self AddToShoppingCarResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.4 删除购物车物品
        case ShoppingCarDel:
        {
            [self ShoppingCarDelResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.5 修改购物车物品数量
        case ShoppingCarModify:
        {
            [self ShoppingCarModifyResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.6 购物车物品选中状态设置
        case ShoppingCarGoodsSelection:
        {
            [self ShoppingCarGoodsSelectionResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.7 购物车获取赠品信息列表
        case ShoppingCarPresentationList:
        {
            [self ShoppingCarPresentationListResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.8 购物车提交选中的赠品信息
        case ShoppingCarCommitPresentation:
        {
            [self ShoppingCarCommitPresentationResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.9 商品结算（点击“去结算”时调用）
        case GoodsSettleUp:
        {
            [self GoodsSettleUpResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.10 获取商品支付方式
        case GetPayType:
        {
            [self GetPayTypeResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.12 获取可使用（结算）购物券信息
        case GetUseableShoppingTicket:
        {
            [self GetUseableShoppingTicketResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
        case SpecialbuySettleup:
        {
            [self SpecialbuySettleupResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.14 获取使用规则
        case GetRegulation:
        {
            [self GetRegulationResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.15 获取运费金额
        case GetDeliverFee:
        {
            [self GetDeliverFeeResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.6.16 获取银联交易流水号
        case GetUPPayTN:
        {
            [self GetUPPayTNResponse:dataDic interface:type tag:tag];
        }
            break;
            
            //    3.7	注册
            //    3.7.1 注册
        case Register:
        {
            [self RegisterResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.7.2 登录
        case Login:
        {
            [self LoginResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.7.3 找回密码
        case ForgetPasswd:
        {
            [self ForgetPasswdResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.7.4 获取匿名用户id
        case GetAnonymityID:
        {
            [self GetAnonymityIDResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.7.5 退出登录接口
        case Logout:
        {
            [self LogoutResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.7.6 修改密码
        case ChangePassword:
        {
            [self ChangePasswordResponse:dataDic interface:type tag:tag];
        }
            break;
            //    3.7.7 自动登录
        case AutoLogin:
        {
            [self AutoLoginResponse:dataDic interface:type tag:tag];
        }
            break;
       
        default:
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"警告解析：" message:@"请求的接口类型出错！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
            break;
    }
}

#pragma mark -------- 数据响应处理
#pragma mark    3.1	首页
#pragma mark    3.1.1推荐商品
-(void) RecommendGoodsResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"recommend"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];

}
#pragma mark    3.1.2 焦点资讯
-(void) FocusInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"focus"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        FocusInfoEntity* entity=[[FocusInfoEntity alloc] init];
        entity.adid=[dicTemp valueForKey:@"adid"];
        entity.type=[[dicTemp safeValueForKey:@"type"] intValue];
        entity.imgurl=[dicTemp safeValueForKey:@"imgurl"];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.weburl=[dicTemp safeValueForKey:@"weburl"];
        entity.specialid=[dicTemp safeValueForKey:@"specialid"];
        entity.specialtype=[[dicTemp safeValueForKey:@"specialtype"]intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.1.3 获取首页6个专题
-(void) GetSpecialListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"special"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        SpecialEntity* entity=[[SpecialEntity alloc] init];
        entity.imgurl=[dicTemp safeValueForKey:@"imgurl"];
        entity.title=[dicTemp safeValueForKey:@"title"];
        entity.subtitle=[dicTemp safeValueForKey:@"subtitle"];
        entity.specialid=[dicTemp safeValueForKey:@"specialid"];
        entity.specialtype=[[dicTemp safeValueForKey:@"specialtype"]intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
-(void) GetSpecialActivityListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    SpecialListEntity* sentity=[[SpecialListEntity alloc] init];
    sentity.specialtype=[[dataDic safeValueForKey:@"specialtype"]intValue];
    sentity.title=[dataDic safeValueForKey:@"title"];
    sentity.rule=[dataDic safeValueForKey:@"rule"];
    sentity.portalimg=[dataDic safeValueForKey:@"portalimg"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.goodslist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.1.5 获取秒杀、团购专题列表
-(void) GetSpecialBuyListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    SpecialBuyListEntity* sentity=[[SpecialBuyListEntity alloc] init];
    sentity.rule=[dataDic safeValueForKey:@"rule"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        SpecialBuyEntity* entity=[[SpecialBuyEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        entity.originprice=[dicTemp safeValueForKey:@"originprice"];
        entity.currentprice=[dicTemp safeValueForKey:@"currentprice"];
        
        entity.timeleft=[[dicTemp safeValueForKey:@"timeleft"]longLongValue];
        entity.timelast=[[dicTemp safeValueForKey:@"timelast"]longLongValue];
        entity.timeWhenReceive = [NSDate date];
        entity.isstart=[[dicTemp safeValueForKey:@"isstart"]intValue];
        entity.store=[[dicTemp safeValueForKey:@"store"]intValue];
        entity.joincount=[[dicTemp safeValueForKey:@"joincount"]intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.goodslist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.1.6获取秒杀、团购详情
-(void) GetSpecialBuyDetailResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    SpecialBuyDetailEntity* entity=[[SpecialBuyDetailEntity alloc] init];

    NSDictionary* dicTemp=[dataDic valueForKey:@"specialgoodsdetail"];
    entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
    entity.shareurl=[dicTemp safeValueForKey:@"shareurl"];
    entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
    entity.goodscode=[dicTemp safeValueForKey:@"goodscode"];
    entity.originprice=[dicTemp safeValueForKey:@"originprice"];
    entity.currentprice=[dicTemp safeValueForKey:@"currentprice"];
    entity.isstart=[[dicTemp safeValueForKey:@"isstart"]intValue];
    entity.timeleft=(long)[[dicTemp safeValueForKey:@"timeleft"] longLongValue];
    entity.timelast=[[dicTemp safeValueForKey:@"timelast"]longLongValue];
//    entity.size=[dicTemp valueForKey:@"size"];
    entity.colorandimgs=[dicTemp valueForKey:@"colorandimgs"];
//    paylimit	int	团购或秒杀活动结束的支付时限，单位是分钟
    entity.paylimit=[[dicTemp safeValueForKey:@"paylimit"] intValue];
    entity.imgdetail=[dicTemp safeValueForKey:@"imgdetail"];
    entity.consults=[[dicTemp safeValueForKey:@"consults"]intValue];
//    entity.store=[[dicTemp safeValueForKey:@"store"]intValue];
    
    entity.savestatus=[[dicTemp safeValueForKey:@"savestatus"] intValue];
    
    
//    entity.sizeandstore=[dicTemp valueForKey:@"sizeandstore"];////////////////////////ljy
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    
    [entity release];
}
#pragma mark    3.1.7 获取用户对商品的评论
-(void) GetUserCommentsResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    UserCommentsEntity* sentity=[[UserCommentsEntity alloc] init];
    sentity.count=[[dataDic safeValueForKey:@"count"]intValue];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"usercomments"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        UserCommentEntity* entity=[[UserCommentEntity alloc] init];
        entity.score=[[dicTemp safeValueForKey:@"score"]intValue];
        entity.username=[dicTemp safeValueForKey:@"username"];
        entity.comment=[dicTemp safeValueForKey:@"comment"];
        entity.date=[dicTemp safeValueForKey:@"date"];
        entity.csr=[dicTemp safeValueForKey:@"csr"];
        entity.thumbnailimg=[dicTemp valueForKey:@"thumbnailimg"];
        entity.imgarray=[dicTemp valueForKey:@"imgarray"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.usercomments=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.1.8 开机启动广告
-(void) StartupADResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StartupADEntity* sentity=[[StartupADEntity alloc] init];
    sentity.havead=[[dataDic safeValueForKey:@"havead"]intValue];
    
    NSDictionary* dicTemp=[dataDic valueForKey:@"detail"];
    FocusInfoEntity* entity=[[FocusInfoEntity alloc] init];
    entity.adid=[dicTemp safeValueForKey:@"adid"];
    entity.type=[[dicTemp safeValueForKey:@"type"] intValue];
    entity.imgurl=[dicTemp safeValueForKey:@"imgurl"];
    entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
    entity.weburl=[dicTemp safeValueForKey:@"weburl"];
    entity.specialid=[dicTemp safeValueForKey:@"specialid"];
    entity.specialtype=[[dicTemp safeValueForKey:@"specialtype"]intValue];
    entity.duration=[[dicTemp safeValueForKey:@"duration"]intValue];
    
    sentity.detail=entity;
    [entity release];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [sentity release];
}
#pragma mark    3.1.9提交首页热点 
-(void) UploadHomeHotClickResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.1.10广告点击统计接口 
-(void) ADClickReportResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.1.11用户信息统计接口 (登录后调用)
-(void) UserInfoReportResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}

#pragma mark    3.2	商城（分类）
#pragma mark    3.2.1商城分类列表
-(void) ShoppingMallCategoryResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"category"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        MallCategoryEntity* entity=[[MallCategoryEntity alloc] init];
        entity.categoryid=[dicTemp safeValueForKey:@"categoryid"];
        entity.categoryimg=[dicTemp safeValueForKey:@"categoryimg"];
        entity.categoryname=[dicTemp safeValueForKey:@"categoryname"];
        entity.description=[dicTemp safeValueForKey:@"description"];

        {
            NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
            NSArray* arrayTemp1=[dicTemp valueForKey:@"subcategory"];
            int iCount1=[arrayTemp1 count];
            for (int i1=0; i1<iCount1; i1++)
            {
                NSDictionary* dicTemp1=[arrayTemp1 objectAtIndex:i1];
                MallCategoryEntity* entity1=[[MallCategoryEntity alloc] init];
                entity1.categoryid=[dicTemp1 safeValueForKey:@"subcategoryid"];
                entity1.categoryimg=[dicTemp1 safeValueForKey:@"subcategoryimg"];
                entity1.categoryname=[dicTemp1 safeValueForKey:@"subcatergoryname"];
                
                [arrayEntity1 addObject:entity1];
                [entity1 release];
            }
            
            entity.subcategory=arrayEntity1;
            [arrayEntity1 release];
        }
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.2.2获取商品列表筛选条件
-(void) GetGoodsListSpecResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"spec"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        SpecEntity* entity=[[SpecEntity alloc] init];
        entity.specname=[dicTemp safeValueForKey:@"specname"];
        entity.specid=[dicTemp safeValueForKey:@"specid"];
        
        {
            NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
            NSArray* arrayTemp1=[dicTemp valueForKey:@"subspec"];
            int iCount1=[arrayTemp1 count];
            for (int i1=0; i1<iCount1; i1++)
            {
                NSDictionary* dicTemp1=[arrayTemp1 objectAtIndex:i1];
                SpecEntity* entity1=[[SpecEntity alloc] init];
                entity1.specname=[dicTemp1 safeValueForKey:@"subspecname"];
                entity1.specid=[dicTemp1 safeValueForKey:@"subspecid"];
                
                [arrayEntity1 addObject:entity1];
                [entity1 release];
            }
            
            entity.subspec=arrayEntity1;
            [arrayEntity1 release];
        }
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.2.3获取商品列表
-(void) GetGoodsListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.2.4获取商品详情
-(void) GetGoodsDetailResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSDictionary* dicTemp=[dataDic valueForKey:@"goodsintroduce"];
    
    GoodDetailEntity* entity=[[GoodDetailEntity alloc] init];
//    entity.store=[[dicTemp safeValueForKey:@"store"] intValue];
    entity.imgdetail=[dicTemp safeValueForKey:@"imgdetail"];
    entity.consults=[[dicTemp safeValueForKey:@"consults"] intValue];
    entity.shareurl=[dicTemp safeValueForKey:@"shareurl"];
    entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
    entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
//    entity.goodscode=[dicTemp safeValueForKey:@"goodscode"];
    entity.price=[dicTemp safeValueForKey:@"price"];
//    entity.size=[dicTemp valueForKey:@"size"];
    entity.colorandimgs=[dicTemp valueForKey:@"colorandimgs"];
    
    entity.savestatus=[[dicTemp safeValueForKey:@"savestatus"] intValue];
    
    entity.havesuite=[[dicTemp safeValueForKey:@"havesuite"]intValue];
    
    
    
//    entity.sizeandstore = [dicTemp valueForKey:@"sizeandstore"];        //////////////////ljy
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.2.5 获取售前咨询列表
-(void) GetSaleConsultListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"consults"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        SaleConsultEntity* entity=[[SaleConsultEntity alloc] init];
        entity.question=[dicTemp safeValueForKey:@"question"];
        entity.username=[dicTemp safeValueForKey:@"username"];
        entity.answer=[dicTemp safeValueForKey:@"answer"];
        entity.date=[dicTemp safeValueForKey:@"date"];
        
        entity.approved=[[dicTemp safeValueForKey:@"approved"] intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.2.6 提交咨询
-(void) ConsultCommitResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.2.7 套装详情
-(void) SuitDetailResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    SuitDetailEntity* sentity=[[SuitDetailEntity alloc] init];
    sentity.originalprice=[dataDic safeValueForKey:@"originalprice"];
    sentity.discount=[dataDic safeValueForKey:@"discount"];
    sentity.suitprice=[dataDic safeValueForKey:@"suitprice"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"suitdetail"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        SuitEntity* entity=[[SuitEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"]; 
        entity.img=[dicTemp safeValueForKey:@"img"];
        entity.name=[dicTemp safeValueForKey:@"name"];
        entity.price=[dicTemp safeValueForKey:@"price"];
//        entity.size=[dicTemp valueForKey:@"size"];
//        entity.color=[dicTemp valueForKey:@"color"];
        entity.colorandsizes=[dicTemp valueForKey:@"colorandsizes"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.suits=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.2.8 猜你喜欢
-(void) YourFavourateIntroduceResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"img"];//??
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"name"];//??
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.2.9 商品收藏
-(void) GoodsSavingResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}

#pragma mark    3.3	搜索
#pragma mark    3.3.1 获取热门搜索词
-(void) GetPopularSearchWordsResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSArray *searchwords = [dataDic valueForKey:@"searchwords"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:searchwords tag:tag];
    }
}
#pragma mark    3.3.2获取文本搜索结果
-(void) GetTextSearchResultResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    SearchResultEntity* sentity=[[SearchResultEntity alloc] init];
    sentity.totalsearchnumber=[[dataDic safeValueForKey:@"totalsearchnumber"]intValue];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.goodslist=arrayEntity;
    sentity.failkeywords=[dataDic valueForKey:@"failkeywords"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.3.3获取条码搜索结果
-(void) GetBarcodeSearchResultResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSDictionary* dicTemp=[dataDic valueForKey:@"goodsintroduce"];
    GoodDetailEntity* entity=[[GoodDetailEntity alloc] init];
    entity.store=[[dicTemp safeValueForKey:@"store"] intValue];
    entity.imgdetail=[dicTemp safeValueForKey:@"imgdetail"];
    entity.consults=[[dicTemp safeValueForKey:@"consults"] intValue];

    entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
    entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
    entity.goodscode=[dicTemp safeValueForKey:@"goodscode"];
    entity.price=[dicTemp safeValueForKey:@"price"];
//    entity.size=[dicTemp valueForKey:@"size"];
    entity.colorandimgs=[dicTemp valueForKey:@"colorandimgs"];
    
    
//    entity.sizeandstore=[dicTemp valueForKey:@"sizeandstore"];////////////////////////////ljy
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.3.4获取颜色购搜索结果
-(void) GetColorBuySearchResultResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.3.5获取摇一摇搜索结果
-(void) GetShakeSearchResultResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.3.6获取摇一摇限制条件
-(void) GetShakeRestrictResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ShakeRestrictEntity* entity=[[ShakeRestrictEntity alloc] init];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"category"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        MallCategoryEntity* entity=[[MallCategoryEntity alloc] init];
        entity.categoryid=[dicTemp safeValueForKey:@"categoryid"];
        entity.categoryname=[dicTemp safeValueForKey:@"categoryname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    entity.category=arrayEntity;
    [arrayEntity release];
    
    {
        NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
        NSArray* arrayTemp=[dataDic valueForKey:@"price"];
        int iCount=[arrayTemp count];
        for (int i=0; i<iCount; i++)
        {
            NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
            SpecEntity* entity=[[SpecEntity alloc] init];
            entity.specid=[dicTemp safeValueForKey:@"subspecid"];
            entity.specname=[dicTemp safeValueForKey:@"subspecname"];
            
            [arrayEntity addObject:entity];
            [entity release];
        }
        entity.price=arrayEntity;
        [arrayEntity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}

#pragma mark    3.4	设置（更多）
#pragma mark    3.4.1设置消息推送
-(void) PushSettingResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.4.2获取消息推送开关状态
-(void) GetPushStatusResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    if(![[dataDic safeValueForKey:@"status"] isKindOfClass:[NSNull class]])
    {
        entity.response=[[dataDic safeValueForKey:@"status"] intValue];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.4.3获取帮助信息
-(void) GetHelpInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    HelpInfoEntity* entity=[[HelpInfoEntity alloc] init];
    entity.servicetel=[dataDic safeValueForKey:@"servicetel"];
    entity.jointel=[dataDic valueForKey:@"jointel"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"helplist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        HelpEntity* entity=[[HelpEntity alloc] init];
        entity.title=[dicTemp safeValueForKey:@"title"];
        entity.detail=[dicTemp safeValueForKey:@"detail"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    entity.helplist=arrayEntity;
    [arrayEntity release];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.4.4意见反馈
-(void) CustomerFeedbackResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.4.6 推送清零
- (void)CleanPushStatusResponse:(NSDictionary *)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}

#pragma mark    3.5	我的衣柜（会员中心）
#pragma mark    3.5.1修改个人信息
-(void) ModifyCustomerInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg=[dataDic safeValueForKey:@"failmsg"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.2 订单提醒列表
-(void) OrderRemindedListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"reminded"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        OrderRemindEntity* entity=[[OrderRemindEntity alloc] init];
        entity.remindid=[dicTemp safeValueForKey:@"remindid"];
        entity.date=[dicTemp safeValueForKey:@"date"];
        entity.content=[dicTemp safeValueForKey:@"content"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.5.3 获取我的订单列表
-(void) MyOrderListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"orderlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        OrderEntity* entity=[[OrderEntity alloc] init];
        entity.ordernumber=[dicTemp safeValueForKey:@"ordernumber"];
        entity.amount=[dicTemp safeValueForKey:@"amount"];
        entity.orderdate=[dicTemp safeValueForKey:@"orderdate"];
//        entity.status=[dicTemp safeValueForKey:@"status"];
        entity.orderstatus=[[dicTemp safeValueForKey:@"orderstatus"]intValue];
        entity.deliverstatus=[[dicTemp safeValueForKey:@"deliverstatus"]intValue];
        entity.paystatus=[[dicTemp safeValueForKey:@"paystatus"]intValue];
        
        entity.paytype=[[dicTemp safeValueForKey:@"paytype"]intValue];
        entity.paycode=[dicTemp safeValueForKey:@"paycode"];
        /*paycode	string	付款方式标识，例如：
        unionpay 银联在线支付
        alipay 支付宝
        bank 银行汇款/转帐
        tenpay 财付通
        onlinepay 在线支付*/
        entity.cancancel=[[dicTemp safeValueForKey:@"cancancel"]intValue];
        entity.showorderstatus = [[dicTemp safeValueForKey:@"showorderstatus"]intValue];
        entity.commentstatus = [[dicTemp safeValueForKey:@"commentstatus"]intValue];
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.5.4 获取订单详情
-(void) MyOrderDetailResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    OrderDetailEntity* entity=[[OrderDetailEntity alloc] init];
    {
        NSDictionary* dicTemp=[dataDic valueForKey:@"orderdetail"];
        entity.ordernumber=[dicTemp safeValueForKey:@"ordernumber"];
        entity.orderstatus=[dicTemp safeValueForKey:@"orderstatus"];
        entity.deliverby=[dicTemp safeValueForKey:@"deliverby"];
        entity.payby=[dicTemp safeValueForKey:@"payby"];
        entity.paycode=[dicTemp safeValueForKey:@"paycode"];
        /*paycode	string	付款方式标识，例如：
         unionpay 银联在线支付
         alipay 支付宝
         bank 银行汇款/转帐
         tenpay 财付通
         onlinepay 在线支付*/
        entity.orderdate=[dicTemp safeValueForKey:@"orderdate"];
        entity.deliverstatus=[dicTemp safeValueForKey:@"deliverstatus"];
        entity.needinvoice=[dicTemp safeValueForKey:@"needinvoice"];
    }
    {
        NSDictionary* dicTemp=[dataDic valueForKey:@"receiver"];
        entity.name=[dicTemp safeValueForKey:@"name"];
        entity.tel=[dicTemp safeValueForKey:@"tel"];
        entity.address=[dicTemp safeValueForKey:@"address"];
        entity.mailcode=[dicTemp safeValueForKey:@"mailcode"];
    }
    
    entity.availabledate=[dataDic safeValueForKey:@"availabledate"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.sizeandcolor=[dicTemp safeValueForKey:@"sizeandcolor"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        entity.count=[[dicTemp safeValueForKey:@"count"]intValue];
        entity.ispresentation=[[dicTemp safeValueForKey:@"ispresentation"]intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    entity.goodslist=arrayEntity;
    [arrayEntity release];
    
    {
        NSDictionary* dicTemp=[dataDic valueForKey:@"description"];
        entity.count=[dicTemp safeValueForKey:@"count"];
        entity.score=[dicTemp safeValueForKey:@"score"];
        entity.goodsfee=[dicTemp safeValueForKey:@"goodsfee"];
        entity.deliverfee=[dicTemp safeValueForKey:@"deliverfee"];
        entity.tradeticket=[dicTemp safeValueForKey:@"tradeticket"];
        entity.moneyticket=[dicTemp safeValueForKey:@"moneyticket"];
        entity.total=[dicTemp safeValueForKey:@"total"];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.5 取消订单
-(void) CancelOrderResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.6 获取我的收藏列表
-(void) GetMySaveListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.color=[dicTemp safeValueForKey:@"color"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.5.7 删除收藏
-(void) DeleteSavingResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.8 添加送货地址
-(void) AddingAddressResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.9获取送货地址
-(void) GetAddressListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"addrssslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        AddressEntity* entity=[[AddressEntity alloc] init];
        entity.addressid=[dicTemp safeValueForKey:@"addressid"];
        entity.name=[dicTemp safeValueForKey:@"name"];
        entity.tel=[dicTemp safeValueForKey:@"tel"];
        entity.area=[dicTemp safeValueForKey:@"area"];
        entity.address=[dicTemp safeValueForKey:@"address"];
        entity.mailcode=[dicTemp safeValueForKey:@"mailcode"];
        entity.isdefault=[[dicTemp safeValueForKey:@"isdefault"]intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.5.10 修改送货地址
-(void) ModifyAddressResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.11 删除、设定默认送货地址
-(void) DelAndSetDefaultAddressResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.12 购物券信息（现金券、抵用券）
-(void) ShoppingTicketInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ShoppingTicketInfoEntity* sentity=[[ShoppingTicketInfoEntity alloc] init];
    sentity.rule=[dataDic safeValueForKey:@"rule"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"ticketlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        ShoppingTicketEntity* entity=[[ShoppingTicketEntity alloc] init];
        entity.cardnum=[dicTemp safeValueForKey:@"cardnum"];
        entity.amount=[dicTemp safeValueForKey:@"amount"];
        entity.usingdate=[dicTemp safeValueForKey:@"usingdate"];
        entity.ordernumber=[dicTemp safeValueForKey:@"ordernumber"];
        entity.expireddate=[dicTemp safeValueForKey:@"expireddate"];
        entity.status=[dicTemp safeValueForKey:@"status"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.ticketlist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.5.13 绑定购物券（现金券、抵用券）
-(void) BindShoppingTicketResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg = [dataDic safeValueForKey:@"failmsg"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.14 积分信息
-(void) ScoreInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ScoreInfoEntity* sentity=[[ScoreInfoEntity alloc] init];
    sentity.rule=[dataDic safeValueForKey:@"rule"];
    sentity.totalscore=[dataDic safeValueForKey:@"totalscore"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"recored"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        ScoreEntity* entity=[[ScoreEntity alloc] init];
        entity.date=[dicTemp safeValueForKey:@"date"];
        entity.detail=[dicTemp safeValueForKey:@"detail"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.recored=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.5.16 我的评论列表
-(void) MyCommentListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"list"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        CommentEntity* entity=[[CommentEntity alloc] init];
        
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.sizeandcolor=[dicTemp safeValueForKey:@"sizeandcolor"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        entity.ordergoodsid=[dicTemp safeValueForKey:@"ordergoodsid"];

        entity.buydate=[dicTemp safeValueForKey:@"buydate"];
        entity.score=[[dicTemp safeValueForKey:@"score"]intValue];
        entity.comment=[dicTemp safeValueForKey:@"comment"];
        entity.ordernumber=[dicTemp safeValueForKey:@"ordernumber"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.5.17 发表评论
-(void) PublishCommentResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.18 晒单列表
-(void) ShowOrderListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"showorderlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        ShowOrderEntity* entity=[[ShowOrderEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.username=[dicTemp safeValueForKey:@"username"];
        entity.title=[dicTemp safeValueForKey:@"title"];
        entity.date=[dicTemp safeValueForKey:@"date"];
        entity.content=[dicTemp safeValueForKey:@"content"];
        entity.thumbnailimg=[dicTemp valueForKey:@"thumbnailimg"];
        entity.imgarray=[dicTemp valueForKey:@"imgarray"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.5.19 我的晒单
-(void) MyShowOrderResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"orderlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        MyShowOrderEntity* entity=[[MyShowOrderEntity alloc] init];
        entity.ordergoodsid=[dicTemp safeValueForKey:@"ordergoodsid"];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.sizeandcolor=[dicTemp safeValueForKey:@"sizeandcolor"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        
        entity.buydate=[dicTemp safeValueForKey:@"buydate"];
        entity.thumbnailimg=[dicTemp valueForKey:@"thumbnailimg"];
        entity.imgarray=[dicTemp valueForKey:@"imgarray"];
        entity.comment=[dicTemp safeValueForKey:@"comment"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.5.20 发表晒单
-(void) PublishShowOrderResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.21获取个人信息
-(void) GetCustomerInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    CustomerInfoEntity* entity=[[CustomerInfoEntity alloc] init];
    NSDictionary* dicTemp=[dataDic valueForKey:@"personinfo"];
    
    entity.imgurl=[dicTemp safeValueForKey:@"imgurl"];
    entity.name=[dicTemp safeValueForKey:@"name"];
    entity.nickname=[dicTemp safeValueForKey:@"nickname"];
    
    entity.sex=[dicTemp safeValueForKey:@"sex"];
    entity.birthday=[dicTemp safeValueForKey:@"birthday"];
    entity.city=[dicTemp safeValueForKey:@"city"];
    entity.mobile=[dicTemp safeValueForKey:@"mobile"];
    entity.tel=[dicTemp safeValueForKey:@"tel"];
    entity.qq=[dicTemp safeValueForKey:@"qq"];
    entity.email=[dicTemp safeValueForKey:@"email"];
    entity.acounttype=[[dicTemp safeValueForKey:@"acounttype"]intValue];
    entity.totalconsume=[dicTemp safeValueForKey:@"totalconsume"];
    entity.balance=[dicTemp safeValueForKey:@"balance"];
    entity.score=[dicTemp safeValueForKey:@"score"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.22获取订单物流详情
-(void) GetOrderDeliverDetailResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"deliverlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        OrderDeliverEntity* entity=[[OrderDeliverEntity alloc] init];
        entity.date=[dicTemp safeValueForKey:@"date"];
        entity.content=[dicTemp safeValueForKey:@"content"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.5.23 上传、修改个人图像
-(void) UploadPersonalPicResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.24 获取（红点）提醒信息接口
-(void) GetReminderInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.hasneworder =[[dataDic safeValueForKey:@"hasneworder"] intValue];
    entity.hasneworderremind =[[dataDic safeValueForKey:@"hasneworderremind"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.25 删除订单提醒
-(void) DelRemindResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg = [dataDic safeValueForKey:@"failmsg"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.26 ConfirmOrder
-(void) ConfirmOrderResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg = [dataDic safeValueForKey:@"failmsg"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.5.27 修改订单详情支付方式
-(void) ChangeOrderPaytypeResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg = [dataDic safeValueForKey:@"failmsg"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}

#pragma mark    3.6	购物车
#pragma mark    3.6.1获取购物车信息
-(void) GetShoppingCarInfoResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ShoppingCarEntity* sentity=[[ShoppingCarEntity alloc] init];
    sentity.selectcount=[[dataDic safeValueForKey:@"selectcount"]intValue];
    sentity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    sentity.discount=[dataDic safeValueForKey:@"discount"];
    sentity.total=[dataDic safeValueForKey:@"total"];
    sentity.discountinfo=[dataDic valueForKey:@"discountinfo"];
    sentity.presentationcount=[[dataDic safeValueForKey:@"presentationcount"]intValue];
    sentity.presentationinfo=[dataDic safeValueForKey:@"presentationinfo"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
        NSArray* arrTemp=[arrayTemp objectAtIndex:i];
        int iiCount=[arrTemp count];
        for (int ii=0; ii<iiCount; ii++)
        {
            NSDictionary* dicTemp=[arrTemp objectAtIndex:ii];
            GoodEntity* entity=[[GoodEntity alloc] init];
            entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
            entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
            entity.price=[dicTemp safeValueForKey:@"price"];
            entity.color=[dicTemp safeValueForKey:@"color"];
            entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
            entity.size=[dicTemp safeValueForKey:@"size"];
            entity.isselect=[[dicTemp safeValueForKey:@"isselect"]intValue];
            entity.count=[[dicTemp safeValueForKey:@"count"]intValue];
            entity.recordid=[dicTemp safeValueForKey:@"recordid"];
            
            entity.discountprice=[dicTemp safeValueForKey:@"discountprice"];
            
            [arrayEntity1 addObject:entity];
            [entity release];
        }
        
        [arrayEntity addObject:arrayEntity1];
        [arrayEntity1 release];
    }
    
    sentity.goodslist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.6.2 提交订单
-(void) CommitOrderResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failreason=[dataDic safeValueForKey:@"failreason"];
    entity.ordernumber=[dataDic safeValueForKey:@"ordernumber"];
    id feeee = [dataDic safeValueForKey:@"orderfee"];
    if (![feeee isKindOfClass:[NSNull class]]) {
        float fee =[[dataDic safeValueForKey:@"orderfee"]floatValue];
        entity.orderfee = [NSString stringWithFormat:@"%.2f",fee];
    }else{
        entity.orderfee = @"0.00";
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.6.3 添加到购物车（不在购物车页面时添加物品）
-(void) AddToShoppingCarResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.totalcount=[[dataDic safeValueForKey:@"totalcount"]intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.6.4 删除购物车物品
-(void) ShoppingCarDelResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ShoppingCarEntity* sentity=[[ShoppingCarEntity alloc] init];
    sentity.selectcount=[[dataDic safeValueForKey:@"selectcount"]intValue];
    sentity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    sentity.discount=[dataDic safeValueForKey:@"discount"];
    sentity.total=[dataDic safeValueForKey:@"total"];
    sentity.discountinfo=[dataDic valueForKey:@"discountinfo"];
    sentity.presentationcount=[[dataDic safeValueForKey:@"presentationcount"]intValue];
    sentity.presentationinfo=[dataDic safeValueForKey:@"presentationinfo"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
        NSArray* arrTemp=[arrayTemp objectAtIndex:i];
        int iiCount=[arrTemp count];
        for (int ii=0; ii<iiCount; ii++)
        {
            NSDictionary* dicTemp=[arrTemp objectAtIndex:ii];
            GoodEntity* entity=[[GoodEntity alloc] init];
            entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
            entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
            entity.price=[dicTemp safeValueForKey:@"price"];
            entity.color=[dicTemp safeValueForKey:@"color"];
            entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
            entity.size=[dicTemp safeValueForKey:@"size"];
            entity.isselect=[[dicTemp safeValueForKey:@"isselect"]intValue];
            entity.count=[[dicTemp safeValueForKey:@"count"]intValue];
            entity.recordid=[dicTemp safeValueForKey:@"recordid"];
            
            entity.discountprice=[dicTemp safeValueForKey:@"discountprice"];
            
            [arrayEntity1 addObject:entity];
            [entity release];
        }
        
        [arrayEntity addObject:arrayEntity1];
        [arrayEntity1 release];
    }
    
    sentity.goodslist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.6.5 修改购物车物品数量
-(void) ShoppingCarModifyResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ShoppingCarEntity* sentity=[[ShoppingCarEntity alloc] init];
    sentity.selectcount=[[dataDic safeValueForKey:@"selectcount"]intValue];
    sentity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    sentity.discount=[dataDic safeValueForKey:@"discount"];
    sentity.total=[dataDic safeValueForKey:@"total"];
    sentity.discountinfo=[dataDic valueForKey:@"discountinfo"];
    sentity.presentationcount=[[dataDic safeValueForKey:@"presentationcount"]intValue];
    sentity.presentationinfo=[dataDic safeValueForKey:@"presentationinfo"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
        NSArray* arrTemp=[arrayTemp objectAtIndex:i];
        int iiCount=[arrTemp count];
        for (int ii=0; ii<iiCount; ii++)
        {
            NSDictionary* dicTemp=[arrTemp objectAtIndex:ii];
            GoodEntity* entity=[[GoodEntity alloc] init];
            entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
            entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
            entity.price=[dicTemp safeValueForKey:@"price"];
            entity.color=[dicTemp safeValueForKey:@"color"];
            entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
            entity.size=[dicTemp safeValueForKey:@"size"];
            entity.isselect=[[dicTemp safeValueForKey:@"isselect"]intValue];
            entity.count=[[dicTemp safeValueForKey:@"count"]intValue];
            entity.recordid=[dicTemp safeValueForKey:@"recordid"];
            
            entity.discountprice=[dicTemp safeValueForKey:@"discountprice"];
            
            [arrayEntity1 addObject:entity];
            [entity release];
        }
        
        [arrayEntity addObject:arrayEntity1];
        [arrayEntity1 release];
    }
    
    sentity.goodslist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.6.6 购物车物品选中状态设置
-(void) ShoppingCarGoodsSelectionResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    ShoppingCarEntity* sentity=[[ShoppingCarEntity alloc] init];
    sentity.selectcount=[[dataDic safeValueForKey:@"selectcount"]intValue];
    sentity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    sentity.discount=[dataDic safeValueForKey:@"discount"];
    sentity.total=[dataDic safeValueForKey:@"total"];
    sentity.discountinfo=[dataDic valueForKey:@"discountinfo"];
    sentity.presentationcount=[[dataDic safeValueForKey:@"presentationcount"]intValue];
    sentity.presentationinfo=[dataDic safeValueForKey:@"presentationinfo"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
        NSArray* arrTemp=[arrayTemp objectAtIndex:i];
        int iiCount=[arrTemp count];
        for (int ii=0; ii<iiCount; ii++)
        {
            NSDictionary* dicTemp=[arrTemp objectAtIndex:ii];
            GoodEntity* entity=[[GoodEntity alloc] init];
            entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
            entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
            entity.price=[dicTemp safeValueForKey:@"price"];
            entity.color=[dicTemp safeValueForKey:@"color"];
            entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
            entity.size=[dicTemp safeValueForKey:@"size"];
            entity.isselect=[[dicTemp safeValueForKey:@"isselect"]intValue];
            entity.count=[[dicTemp safeValueForKey:@"count"]intValue];
            entity.recordid=[dicTemp safeValueForKey:@"recordid"];
            
            entity.discountprice=[dicTemp safeValueForKey:@"discountprice"];
            
            [arrayEntity1 addObject:entity];
            [entity release];
        }
        
        [arrayEntity addObject:arrayEntity1];
        [arrayEntity1 release];
    }
    
    sentity.goodslist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.6.7 购物车获取赠品信息列表
-(void) ShoppingCarPresentationListResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"presentationlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        PresentationListEntity* entity=[[PresentationListEntity alloc] init];
        entity.presentationinfo=[dicTemp safeValueForKey:@"presentationinfo"];
        entity.specialid=[dicTemp safeValueForKey:@"specialid"];
        
        NSMutableArray* arrayEntity1=[[NSMutableArray alloc] init];
        NSArray* arrTemp=[dicTemp valueForKey:@"goodsinfo"];
        int iiCount=[arrTemp count];
        for (int ii=0; ii<iiCount; ii++)
        {
            NSDictionary* dicTemp1=[arrTemp objectAtIndex:ii];
            PresentationEntity* entity=[[PresentationEntity alloc] init];
            entity.goodsid=[dicTemp1 safeValueForKey:@"goodsid"];
            entity.goodsimg=[dicTemp1 safeValueForKey:@"goodsimg"];
//            entity.sizearray=[dicTemp1 valueForKey:@"sizearray"];
//            entity.colorarray=[dicTemp1 valueForKey:@"colorarray"];
            entity.colorandsizes=[dicTemp1 valueForKey:@"colorandimgs"];
            NSMutableArray *colors = [NSMutableArray array];
            for (NSDictionary *colorSizeDic in entity.colorandsizes)
            {
                [colors addObject:[colorSizeDic objectForKey:@"color"]];
            }
            entity.colorarray = colors;

            entity.goodsname=[dicTemp1 safeValueForKey:@"goodsname"];
            entity.selectsize=[dicTemp1 safeValueForKey:@"selectsize"];
            entity.isselect=[[dicTemp1 safeValueForKey:@"isselect"]intValue];
            entity.selectcolor=[dicTemp1 safeValueForKey:@"selectcolor"];
            
            [arrayEntity1 addObject:entity];
            [entity release];
        }
        entity.goodsinfo = arrayEntity1;
        [arrayEntity1 release];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    [arrayEntity release];
}
#pragma mark    3.6.8 购物车提交选中的赠品信息
-(void) ShoppingCarCommitPresentationResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    CommitPresentationEntity* entity=[[CommitPresentationEntity alloc] init];
    entity.selectcount=[[dataDic safeValueForKey:@"selectcount"] intValue];
    entity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    entity.discount=[dataDic safeValueForKey:@"discount"];
    entity.total=[dataDic safeValueForKey:@"total"];
    entity.discountinfo=[dataDic valueForKey:@"discountinfo"];
    entity.presentationcount=[[dataDic safeValueForKey:@"presentationcount"]intValue];
    entity.presentationinfo=[dataDic safeValueForKey:@"presentationinfo"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.6.9 商品结算（点击“去结算”时调用）
-(void) GoodsSettleUpResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    GoodsSettleUpEntity* entity=[[GoodsSettleUpEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.selectcount=[[dataDic safeValueForKey:@"selectcount"] intValue];
    entity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    entity.deliverfee=[dataDic safeValueForKey:@"deliverfee"];
    entity.total=[dataDic safeValueForKey:@"total"];
    entity.score=[dataDic safeValueForKey:@"score"];
    
    entity.failmsg=[dataDic safeValueForKey:@"failmsg"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"goodslist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        GoodEntity* entity=[[GoodEntity alloc] init];
        entity.goodsid=[dicTemp safeValueForKey:@"goodsid"];
        entity.goodsimg=[dicTemp safeValueForKey:@"goodsimg"];
        entity.price=[dicTemp safeValueForKey:@"price"];
        entity.sizeandcolor=[dicTemp safeValueForKey:@"sizeandcolor"];
        entity.goodsname=[dicTemp safeValueForKey:@"goodsname"];
        entity.count=[[dicTemp safeValueForKey:@"count"]intValue];
        entity.ispresentation=[[dicTemp safeValueForKey:@"ispresentation"]intValue];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    entity.goodslist=arrayEntity;
    [arrayEntity release];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.6.10 获取商品支付方式
-(void) GetPayTypeResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"paytype"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        PayTypeEntity* entity=[[PayTypeEntity alloc] init];
        entity.name=[dicTemp safeValueForKey:@"name"];
        entity.paycode=[dicTemp safeValueForKey:@"paycode"];
        entity.typeId=[[dicTemp safeValueForKey:@"typeid"]intValue];

        [arrayEntity addObject:entity];
        [entity release];
    }
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:arrayEntity tag:tag];
    }
    
    [arrayEntity release];
}
#pragma mark    3.6.12 获取可使用（结算）购物券信息
-(void) GetUseableShoppingTicketResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{

    ShoppingTicketInfoEntity* sentity=[[ShoppingTicketInfoEntity alloc] init];
    sentity.rule=[dataDic safeValueForKey:@"rule"];
    
    NSMutableArray* arrayEntity=[[NSMutableArray alloc] init];
    NSArray* arrayTemp=[dataDic valueForKey:@"ticketlist"];
    int iCount=[arrayTemp count];
    for (int i=0; i<iCount; i++)
    {
        NSDictionary* dicTemp=[arrayTemp objectAtIndex:i];
        ShoppingTicketEntity* entity=[[ShoppingTicketEntity alloc] init];
        entity.cardnum=[dicTemp safeValueForKey:@"cardnum"];
        entity.amount=[dicTemp safeValueForKey:@"amount"];
        entity.usingdate=[dicTemp safeValueForKey:@"usingdate"];
        entity.status=[dicTemp safeValueForKey:@"status"];
        
        [arrayEntity addObject:entity];
        [entity release];
    }
    
    sentity.ticketlist=arrayEntity;
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)])
    {
        [self.delegate requestDataSuccess:sentity tag:tag];
    }
    
    [arrayEntity release];
    [sentity release];
}
#pragma mark    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
-(void) SpecialbuySettleupResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    GoodsSettleUpEntity* entity=[[GoodsSettleUpEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.selectcount=[[dataDic safeValueForKey:@"selectcount"] intValue];
    entity.goodsfee=[dataDic safeValueForKey:@"goodsfee"];
    entity.deliverfee=[dataDic safeValueForKey:@"deliverfee"];
    entity.total=[dataDic safeValueForKey:@"total"];
    entity.score=[dataDic safeValueForKey:@"score"];
    
    entity.failmsg = [dataDic safeValueForKey:@"failmsg"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.6.14 获取使用规则
-(void) GetRegulationResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSString *rule = [dataDic safeValueForKey:@"rule"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:rule tag:tag];
    }
}
#pragma mark    3.6.15 获取运费金额
-(void) GetDeliverFeeResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg=[dataDic safeValueForKey:@"failmsg"];
    entity.deliverfee = [dataDic safeValueForKey:@"deliverfee"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.6.16 获取银联交易流水号
-(void) GetUPPayTNResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg=[dataDic safeValueForKey:@"failmsg"];
    entity.uppaytn = [dataDic safeValueForKey:@"uppaytn"];//银联交易流水号
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}

#pragma mark    3.7	注册
#pragma mark    3.7.1 注册
-(void) RegisterResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    RegisterLoginEntity* entity=[[RegisterLoginEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg=[dataDic safeValueForKey:@"failmsg"];

    NSDictionary* dicTemp=[dataDic valueForKey:@"personinfo"];
    entity.userid=[dicTemp safeValueForKey:@"userid"];
    entity.token=[dicTemp safeValueForKey:@"token"];//token
    
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.7.2 登录
-(void) LoginResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    RegisterLoginEntity* entity=[[RegisterLoginEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    NSDictionary* dicTemp=[dataDic valueForKey:@"personinfo"];
    entity.userid=[dicTemp safeValueForKey:@"userid"];
    entity.token=[dicTemp safeValueForKey:@"token"];
    id count  = [dicTemp safeValueForKey:@"totalcount"];
    if (![count isKindOfClass:[NSNull class]]) {
        entity.totalcount=[[dicTemp safeValueForKey:@"totalcount"]intValue];
    }else{
        entity.totalcount = 0;
    }
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.7.3 找回密码
-(void) ForgetPasswdResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    entity.failmsg=[dataDic safeValueForKey:@"failmsg"];
                     
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.7.4 获取匿名用户id
-(void) GetAnonymityIDResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    NSString *anonymityid=[dataDic safeValueForKey:@"anonymityid"];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:anonymityid tag:tag];
    }
}
#pragma mark    3.7.5 退出登录接口
-(void) LogoutResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.7.6 修改密码
-(void) ChangePasswordResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    StatusEntity* entity=[[StatusEntity alloc] init];
    entity.response=[[dataDic safeValueForKey:@"response"] intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}
#pragma mark    3.7.7 自动登录
-(void) AutoLoginResponse:(NSDictionary*)dataDic interface:(enum InterfaceType)type tag:(int)tag
{
    RegisterLoginEntity* entity=[[RegisterLoginEntity alloc] init];
//    entity.response=[[dataDic safeValueForKey:@"response"] intValue];成功走requestDataSuccess；失败走requestDataFail:tag:error:，errorcode为201
    
    NSDictionary* dicTemp=[dataDic valueForKey:@"personinfo"];
    entity.userid=[dicTemp safeValueForKey:@"userid"];
    entity.token=[dicTemp safeValueForKey:@"token"];
    entity.totalcount=[[dicTemp safeValueForKey:@"totalcount"]intValue];
    
    //返回数据给调用者
    if ([self.delegate respondsToSelector:@selector(requestDataSuccess:tag:)]) {
        [self.delegate requestDataSuccess:entity tag:tag];
    }
    [entity release];
}


@end

