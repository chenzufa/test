//
//  InterfaceParam.h
//  MeiLiYun
//
//  Created by donson-周响 on 13-10-14.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//
//功能说明：将接口参数拼装成json字串
//-----------------------------------------

#define STRING_FROM_INT(a) [NSString stringWithFormat:@"%d",a]

#import "NSObject+InterfaceParam.h"
#import "JSON.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSObject (InterfaceParam)

- (NSString *)getMD5EncodedString:(NSString *)string
{
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], [data length], result);
	
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

#pragma mark    3.1	首页
#pragma mark    3.1.1推荐商品
-(NSString*) RecommendGoodsParam
{
    return @"";
}
#pragma mark    3.1.2 焦点资讯
-(NSString*) FocusInfoParam
{
    return @"";
}
#pragma mark    3.1.3 获取首页6个专题
-(NSString*) GetSpecialListParam
{
    return @"";
}
#pragma mark    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
//specialid	string	专题id
//page	int	分页（对于goodlist中返回的商品做分页处理）
-(NSString*) GetSpecialActivityListParam:(NSString *)specialid page:(int)page
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:specialid,@"specialid",[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.1.5 获取秒杀、团购专题列表
//specialid	string	专题id
//page	int	对返回的goodslist分页
-(NSString*) GetSpecialBuyListParam:(NSString *)specialid page:(int)page
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:specialid,@"specialid",[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
    
}
#pragma mark    3.1.6获取秒杀、团购详情
//userid	string	用户id,没有登录传空字符””
//token	string	服务端返回的token，没有登录传空字符””
//goodsid	string	商品id
//specialtype	int	专题类型1.宫格 2.瀑布流 3.单图 4.秒杀 5.团购
-(NSString*) GetSpecialBuyDetailParam:(NSString *)goodsid specialtype:(int)specialtype
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticateNot],@"needauthenticate",token,@"token",userid,@"userid",goodsid,@"goodsid",[NSNumber numberWithInt:specialtype],@"specialtype",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.1.7 获取用户对商品的评论
//goodsid	string	商品id
//page	int	分页（对返回的usercomments做分页处理）
-(NSString*) GetUserCommentsParam:(NSString *)goodsid page:(int)page
{
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticateNot],@"needauthenticate",token,@"token",userid,@"userid",goodsid,@"goodsid",[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.1.8 开机启动广告
-(NSString*) StartupADParam
{
    return @"";
}
#pragma mark    3.1.9提交首页热点
//time	string	开始记录热点的日期时间
//hotclick_list	array	热点坐标列表
// {
//     “hotclick_x”:23.516,
//     “hotclick_y”:23.516,
// }
//hotclick_x	float	热点坐标x
//hotclick_y	float	热点坐标y
-(NSString*) UploadHomeHotClickParam:(NSString *)time hotclick_list:(NSArray *)hotclick_list
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:time,@"time",hotclick_list,@"hotclick_list",nil];
    return [tempDic JSONRepresentation];
    
}
#pragma mark    3.1.10广告点击统计接口
//id	string	被点击的广告id
//type	int	类型：1.开机广告 2.焦点广告 3.推荐商品
-(NSString*) ADClickReportParam:(NSString *)adid type:(int)type
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:adid,@"id",[NSNumber numberWithInt:type],@"type",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.1.11用户信息统计接口 (登录后调用)
//userid	string	id
//model	string	手机型号，如三星S3
//pixel	string	分辨率
//chanel	string	安装渠道
//sp	string	网路运营商
//area	string	地域
//sex	string	用户性别
-(NSString*) GetUserCommentsParam:(NSString *)userid model:(NSString *)model pixel:(NSString *)pixel sp:(NSString *)sp area:(NSString *)area
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",model,@"model",pixel,@"pixel",sp,@"sp",area,@"area",nil];
    return [tempDic JSONRepresentation];
}

#pragma mark    3.2	商城（分类）
#pragma mark    3.2.1商城分类列表
-(NSString*) ShoppingMallCategoryParam
{
    return @"";
}
#pragma mark    3.2.2获取商品列表筛选条件
//subcategoryid	string	子目录id
-(NSString*) GetGoodsListSpecParam:(NSString *)subcategoryid
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:subcategoryid,@"subcategoryid",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.3获取商品列表
//subcategoryid	string ///////zhuyi	商品子类别id 对于热销商品subcategory为固定值-1
//type	int	请求类型： 1.销量 2.好评 3.价格由低到高 4.价格由高到低 5.新品
//subspec	stringArray	商品筛选限制条件数组（数组为空表明没有限制条件）
//page	int	分页页码，每页20条数据
-(NSString*) GetGoodsListParam:(NSString *)subcategoryid subspec:(NSArray *)subspec type:(int)type page:(int)page
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:subcategoryid,@"subcategoryid",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:page],@"page",subspec,@"subspec",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.4获取商品详情
//userid	string	用户id,没有登录传空字符””
//token	string	服务端返回的token，没有登录传空字符””
//goodsid	string	商品id
-(NSString*) GetGoodsDetailParam:(NSString *)goodsid
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticateNot],@"needauthenticate",goodsid,@"goodsid",token,@"token",userid,@"userid",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.5 获取售前咨询列表
//goodsid	string	商品id
//page	int	分页
-(NSString*) GetSaleConsultListParam:(NSString *)goodsid page:(int)page
{
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticateNot],@"needauthenticate",token,@"token",userid,@"userid",goodsid,@"goodsid",[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.6 提交咨询
//goodsid	string	商品id
//userid	string	用户id
//token	string	服务端返回的token
//question	string	咨询的问题
-(NSString*) ConsultCommitParam:(NSString *)goodsid question:(NSString *)question
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",goodsid,@"goodsid",userid,@"userid",question,@"question",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.7 套装详情
//goodsid	string	商品id
//userid	string	用户id,没有登录传空字符””
//token	string	服务端返回的token,未登录传空字符””
-(NSString*) SuitDetailParam:(NSString *)goodsid
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticateNot],@"needauthenticate",goodsid,@"goodsid",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.8 猜你喜欢
//goodsid	string	商品id
//page	int	分页
-(NSString*) YourFavourateIntroduceParam:(NSString *)goodsid page:(int)page
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:goodsid,@"goodsid",[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.2.9 商品收藏
//goodsid	string	商品id
//userid	string	用户id（不登陆不能收藏）
//token	string	服务端返回的token
-(NSString*) GoodsSavingParam:(NSString *)goodsid
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",goodsid,@"goodsid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}

#pragma mark    3.3	搜索
#pragma mark    3.3.1 获取热门搜索词
-(NSString*) GetPopularSearchWordsParam
{
    return @"";
}
#pragma mark    3.3.2获取文本搜索结果
//searchword	string	搜索关键字
//type	int	请求类型： 1.销量 2.好评 3.价格由低到高 4.价格由高到低
//page	int	分页页码，每页20条数据
-(NSString*) GetTextSearchResultParam:(NSString *)searchword type:(int)type page:(int)page
{
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:searchword,@"searchword",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.3.3获取条码搜索结果
//barcode	string	商品条码/二维码信息字串
-(NSString*) GetBarcodeSearchResultParam:(NSString *)barcode
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:barcode,@"barcode",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.3.4获取颜色购搜索结果
//l	float	颜色l分量
//a	float	颜色a分量
//b	float	颜色b分量
//astrict	stringArray	限制条件，值是商品一级分类id的子集
-(NSString*) GetColorBuySearchResultParam:(NSArray *)astrict colorl:(float)colorl colora:(float)colora colorb:(float)colorb
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:colorl],@"l",[NSNumber numberWithFloat:colora],@"a",[NSNumber numberWithFloat:colorb],@"b",astrict,@"astrict",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.3.5获取摇一摇搜索结果
//astrict	stringArray	限制条件，值是商品一级分类id的子集
//subastrict	stringArray	子限制条件，值是商品价格区间id(接口3.3.6返回)
-(NSString*) GetShakeSearchResultParam:(NSArray *)astrict subastrict:(NSArray *)subastrict
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:astrict,@"astrict",subastrict,@"subastrict",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.3.6获取摇一摇限制条件
-(NSString*) GetShakeRestrictParam
{
    return @"";
}

#pragma mark    3.4	设置（更多）
#pragma mark    3.4.1设置消息推送
//userid	string	用户id，（登录了提供，没有登录传值””）
//pushtoken	string	设备推送token
//devicetype	int	设备类型：1. Android 2.iphone 3.ipad
//status	int	需要设置的推送状态 0：禁用推送 1：启用推送
//provinceid	int	省id, 没有登录或者没有获取省id传0， 
-(NSString*) PushSettingParam:(NSString *)pushtoken status:(int)status provinceid:(int)provinceid
{
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",pushtoken,@"pushtoken",[NSNumber numberWithInt:status],@"status",[NSNumber numberWithInt:provinceid],@"provinceid",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.4.2获取消息推送开关状态
//userid	string	用户id，（登录了提供，没有登录传值””）
//pushtoken	string	pushtoken
//devicetype	int	设备类型：1. Android 2.iphone 3.ipad
-(NSString*) GetPushStatusParam:(NSString *)pushtoken
{
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",pushtoken,@"pushtoken",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.4.3获取帮助信息
-(NSString*) GetHelpInfoParam
{
    return @"";
}
#pragma mark    3.4.4意见反馈
//userid	string	用户id(可选,用户登录的时候要传，未登录为””)
//token	string	服务端返回的token（可选,用户登录的时候要传，未登录为””）
//content	string	意见反馈内容
-(NSString*) CustomerFeedbackParam:(NSString *)content
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticateNot],@"needauthenticate",userid,@"userid",content,@"content",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.4.6 推送清零
/*
 userid	string	用户id(可选,用户登录的时候要传，未登录为””)
 token	string	服务端返回的token（可选,用户登录的时候要传，未登录为””）
 pushtoken	string	ios设备提供的推送token
 */
-(NSString *)CleanPushStatusParm:(NSString *)pushtoken
{
    NSString* token = kCurrUserToken?kCurrUserToken:@"";
    NSString* userid = kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",token,@"token",pushtoken,@"pushtoken",nil];
    
    return [tempDic JSONRepresentation];
}

#pragma mark    3.5	我的衣柜（会员中心）
#pragma mark    3.5.1修改个人信息
//userid	string	用户id
//token	string	服务端返回的token
//nickname	string	用户昵称
//name	string	用户姓名
//sex	string	性别
//birthday	string	生日
//provinceid	int	省id
//cityid	int	市id
//districtid	int	县（区）id
//mobile	string	手机号码
//tel	string	联系电话
//qq	string	qq号码
//email	string	邮箱地址
-(NSString*) ModifyCustomerInfoParam:(NSString *)nickname name:(NSString *)name sex:(NSString *)sex birthday:(NSString *)birthday provinceid:(int)provinceid cityid:(int)cityid districtid:(int)districtid mobile:(NSString *)mobile tel:(NSString *)tel  qq:(NSString *)qq email:(NSString *)email;
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nickname,@"nickname",name,@"name",sex,@"sex",birthday,@"birthday",[NSNumber numberWithInt:provinceid],@"provinceid",[NSNumber numberWithInt:cityid],@"cityid",[NSNumber numberWithInt:districtid],@"districtid",mobile,@"mobile",tel,@"tel",qq,@"qq",email,@"email",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.2 订单提醒列表
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) OrderRemindedListParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.3 获取我的订单列表
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
//type	int	请求订单类型 1.进行中的 2.已完成的 3.无效的
-(NSString*) MyOrderListParam:(int)type page:(int)page
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:type],@"type",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.4 获取订单详情
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号码
-(NSString*) MyOrderDetailParam:(NSString *)ordernumber
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",ordernumber,@"ordernumber",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.5 取消订单
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号码
-(NSString*) CancelOrderParam:(NSString *)ordernumber
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",ordernumber,@"ordernumber",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.6 获取我的收藏列表
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
-(NSString*) GetMySaveListParam:(int)page
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",[NSNumber numberWithInt:page],@"page",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.7 删除收藏
//userid	string	用户id
//token	string	服务端返回的token
//goodsid	stringArray	需要删除的商品id对象数组
-(NSString*) DeleteSavingParam:(NSArray *)goodsid
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",goodsid,@"goodsid",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.8 添加送货地址
//userid	string	用户id
//token	string	服务端返回的token
//name	string	收货人姓名
//tel	string	收货人电话
//provinceid	int	省id
//cityid	int	市id
//districtid	int	县（区）id
//address	string	详细地址
-(NSString*) AddingAddressParam:(NSString *)name tel:(NSString *)tel provinceid:(int)provinceid cityid:(int)cityid districtid:(int)districtid address:(NSString *)address mailcode:(NSString *)mailcode
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",name,@"name",tel,@"tel",[NSNumber numberWithInt:provinceid],@"provinceid",[NSNumber numberWithInt:cityid],@"cityid",[NSNumber numberWithInt:districtid],@"districtid",address,@"address",token,@"token",mailcode,@"mailcode",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.9获取送货地址
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GetAddressListParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.10 修改送货地址
//userid	string	用户id
//token	string	服务端返回的token
//addressid	string	地址id
//name	string	收货人姓名
//tel	string	收货人电话
//provinceid	int	省id
//cityid	int	市id
//districtid	int	县（区）id
//address	string	详细地址
-(NSString*) ModifyAddressParam:(NSString *)addressid name:(NSString *)name tel:(NSString *)tel provinceid:(int)provinceid cityid:(int)cityid districtid:(int)districtid address:(NSString *)address mailcode:(NSString *)mailcode
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",addressid,@"addressid",name,@"name",tel,@"tel",[NSNumber numberWithInt:provinceid],@"provinceid",[NSNumber numberWithInt:cityid],@"cityid",[NSNumber numberWithInt:districtid],@"districtid",address,@"address",token,@"token",mailcode,@"mailcode",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.11 删除、设定默认送货地址
//userid	string	用户id
//token	string	服务端返回的token
//addressid	string	地址id
//action	int	接口执行的类型 1：删除地址 2：设置为默认地址
-(NSString*) DelAndSetDefaultAddressParam:(NSString *)addressid action:(int)action
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",addressid,@"addressid",[NSNumber numberWithInt:action],@"action",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.12 购物券信息（现金券、抵用券）
//userid	string	用户id
//token	string	服务端返回的token
//type	int	请求类型 1：现金券信息 2：抵用券信息
//subtype	int	请求子分类 1：已经使用 2：未使用
//page	int	分页（对返回的ticketlist做分页处理）
-(NSString*) ShoppingTicketInfoParam:(int)type subtype:(int)subtype page:(int)page
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:subtype],@"subtype",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.13 绑定购物券（现金券、抵用券）
//userid	string	用户id
//token	string	服务端返回的token
//cardnum	string	卡号
//password	string	密码
//type	int	绑定购物券类型 1：现金券 2：抵用券
//haspassword	int	是否使用密码绑定 0：没有密码 1：有密码 （注意：改字段只有type为2时才有效）
//isscan	int	是否扫描 0：不是 1：是的
//isscan	int	是否扫描 0：不是 1：是的
-(NSString*) BindShoppingTicketParam:(NSString *)cardnum password:(NSString *)password type:(int)type haspassword:(int)haspassword isscan:(int)isscan
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",cardnum,@"cardnum",password,@"password",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:haspassword],@"haspassword",[NSNumber numberWithInt:isscan],@"isscan",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.14 积分信息
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) ScoreInfoParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.16 我的评论列表
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
//type	int	请求类型：1.未评论 2.已评论
-(NSString*) MyCommentListParam:(int)type page:(int)page
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:page],@"page",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.17 发表评论
//ordergoodsid	string	订单商品id（用于描述某一个订单下面的商品的id）
//sizeandcolor	string	商品尺寸和颜色描述
//userid	string	用户id
//token	string	服务端返回的token
//goodsid	string	商品id
//ordernumber	string	订单号
//compositescore	int	综合评分
//appearancescore	int	外观评分
//comfortscore	int	舒适度评分
//comment	string	评价内容
-(NSString*) PublishCommentParam:(NSString *)goodsid ordernumber:(NSString *)ordernumber sizeandcolor:(NSString *)sizeandcolor ordergoodsid:(NSString *)ordergoodsid compositescore:(int)compositescore appearancescore:(int)appearancescore comfortscore:(int)comfortscore comment:(NSString *)comment
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",goodsid,@"goodsid",ordernumber,@"ordernumber",sizeandcolor,@"sizeandcolor",ordergoodsid,@"ordergoodsid",comment,@"comment",[NSNumber numberWithInt:compositescore],@"compositescore",[NSNumber numberWithInt:appearancescore],@"appearancescore",[NSNumber numberWithInt:comfortscore],@"comfortscore",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.18 晒单列表
//page	int	请求的数据的页码
-(NSString*) ShowOrderListParam:(int)page
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page],@"page",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.19 我的晒单
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
//type	int	请求类型：1.未晒单 2.已晒单
-(NSString*) MyShowOrderParam:(int)type page:(int)page
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:page],@"page",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.20 发表晒单
//userid	string	用户id
//token	string	服务端返回的token
//goodsid	string	商品id
//title	string	晒单标题
//这里不管：imgarray	objectArray	晒单图片数据数组 （上传图片）
//comment	string	评价内容
//sizeandcolor	string	商品尺寸和颜色描述
//ordergoodsid	string	订单商品id（用于描述某一个订单下面的商品的id）
-(NSString*) PublishShowOrderParam:(NSString *)goodsid sizeandcolor:(NSString *)sizeandcolor  ordergoodsid:(NSString *)ordergoodsid title:(NSString *)title comment:(NSString *)comment
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",goodsid,@"goodsid",title,@"title",ordergoodsid,@"ordergoodsid",sizeandcolor,@"sizeandcolor",comment,@"comment",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.21获取个人信息
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
-(NSString*) GetCustomerInfoParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.22获取订单物流详情
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
//ordernumber	string	订单号码
-(NSString*) GetOrderDeliverDetailParam:(NSString *)ordernumber
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",ordernumber,@"ordernumber",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.23 上传、修改个人图像
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
//pic	data	图片数据
-(NSString*) UploadPersonalPicParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.24 获取（红点）提醒信息接口
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
-(NSString*) GetReminderInfoParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.25 删除订单提醒
//userid	string	用户id
//token	string	服务端返回的token
//remindids	intArray	提交待删除的订单提醒id数组
-(NSString*) DelRemindParam:(NSArray *)remindids
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",remindids,@"remindids",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.26 确认收货
//“userid”:”abc123”,
//“token”:”服务端返回的token”,
//“ordernumber”:”1313434”,
//“needauthenticate”:1
-(NSString*) ConfirmOrderParam:(NSString *)ordernumber
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",ordernumber,@"ordernumber",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.5.27 修改订单详情支付方式
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号
//paytypeid	string	支付方式id
//needauthenticate	int	是否需要鉴别用户已经登录，0：不需要 1:需要
-(NSString*) ChangeOrderPaytypeParam:(NSString *)ordernumber paytypeid:(NSString *)paytypeid
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",ordernumber,@"ordernumber",paytypeid,@"paytypeid",nil];
    return [tempDic JSONRepresentation];
}

#pragma mark    3.6	购物车
#pragma mark    3.6.1获取购物车信息
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GetShoppingCarInfoParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.2 提交订单
//userid	string	用户id
//token	string	服务端返回的token
//addressid	string	物品投送地址id
//payas	int	支付方式
//deliver	object	寄送方式
//deliverby	int	寄货方式：1.第三方快递
//delivertime	int	寄货时间：1.只工作日 2.只双休、节假日3.工作日、双休、节假日均可
//note	string	备注
//invoce	object	发票信息
////isneed	int	是否需要发票：0.不需要 1.需要
//title	string	发票抬头
//content	string	发票内容
//moneyticket	objectArray	现金券 NSDictionary
//tradeticket	objectArray	抵用券 NSDictionary（目前项目一个订单只允许使用一次抵用券，为后续扩展，提交参数仍使用数组）
/*NSDictionary
 {
  amount	float	金额
  cardnum	string	现金券、抵用券卡号
 }
 type	int	商品订单提交类型：1.购物车普通商品2.团购 3.秒杀
 */
-(NSString*) CommitOrderParam:(NSString *)addressid payas:(int)payas deliverby:(int)deliverby delivertime:(int)delivertime note:(NSString *)note invoceisneed:(int)invoceisneed invocetitle:(NSString *)invocetitle invocecontent:(NSString *)invocecontent moneyticket:(NSArray *)moneyticket tradeticket:(NSArray *)tradeticket type:(int)type
{
    if (invocetitle.length==0) {
        invocetitle = @"";
    }
    if (invocecontent.length==0) {
        invocecontent = @"";
    }
    NSDictionary *deliverdic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:deliverby],@"deliverby",[NSNumber numberWithInt:delivertime],@"delivertime",nil];
    NSDictionary *invocedic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:invoceisneed],@"isneed",invocetitle,@"title",invocecontent,@"content",nil];
    
    //money, tradeticket
    NSMutableArray *moneyArray = [NSMutableArray array];
    for (ShoppingTicketEntity *aEntity in moneyticket){
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        [aDict setValue:aEntity.cardnum forKey:@"cardnum"];
        [aDict setValue:aEntity.amount forKey:@"amount"];
        [moneyArray addObject:aDict];
    }
    
    NSMutableArray *tradeArray = [NSMutableArray array];
    for (ShoppingTicketEntity *aEntity in moneyticket){
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        [aDict setValue:aEntity.cardnum forKey:@"cardnum"];
        [aDict setValue:aEntity.amount forKey:@"amount"];
        [tradeArray addObject:aDict];
    }
    
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",addressid,@"addressid",[NSNumber numberWithInt:payas],@"payas",deliverdic,@"deliver",note,@"note",invocedic,@"invoce",moneyArray,@"moneyticket",tradeArray,@"tradeticket",[NSNumber numberWithInt:type],@"type",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.3 添加到购物车（不在购物车页面时添加物品）
//userid	string	用户id
//token	string	服务端返回的token
//goodslist	objectArray	商品对象数组（套装多个，单品单个）
/*NSDictionary
 {
 goodsid	string	商品id
 color	string	商品颜色
 size	string	商品尺寸
 }
 */
//issuit	int	是否套装：0.单品 1.套装
-(NSString*) AddToShoppingCarParam:(NSArray *)goodslist issuit:(int)issuit
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",goodslist,@"goodslist",[NSNumber numberWithInt:issuit],@"issuit",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.4 删除购物车物品
//userid	string	用户id
//token	string	服务端返回的token
//goodslist	stringArray	需要删除的商品记录id对象数组
/*
 [
 “123”,
 “124”,
 ……..
 
 ]
 */
//注意已改
-(NSString*) ShoppingCarDelParam:(NSArray *)goodslist ofIndex:(int)index
{
    NSMutableArray *bigArr = [NSMutableArray array];
    
//    NSMutableArray *smallArr = [NSMutableArray array];
    NSArray *goodEntityArray = [goodslist objectAtIndex:index];
    for (int j = 0; j<[goodEntityArray count]; j++) {
        GoodEntity *entity = [goodEntityArray objectAtIndex:j];
//        [smallArr addObject:entity.recordid];
        [bigArr addObject:entity.recordid];
    }
//    [bigArr addObject:smallArr];
    
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",bigArr,@"goodslist",token,@"token",nil];
    NSLog(@"%@",[tempDic JSONRepresentation]);
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.5 修改购物车物品数量
//注意该结构有些复杂，由于商品有套装的缘故
//userid	string	用户id
//token	string	服务端返回的token
//goodslist	objectArray	需要修改的商品id对象数组 此数组元素是数组，数组里面是字典
//recordid	string	商品记录id
//count	int	商品件数（组成套装商品中的每一个商品，count参数是一样的）
/*
 [
 [{
 “recordid”:“1”,
 “count”:2
 },
 ……
 ],
 [{
 “recordid”:“2”,
 “count”:1
 }]
 ……..   //注意该结构有些复杂，由于商品有套装的缘故
 ]
 */
//注意已改
-(NSString*) ShoppingCarModifyParam:(NSArray *)goodslist ofIndex:(int)index
{
    NSMutableArray *bigArr = [NSMutableArray array];
    
    NSMutableArray *smallArr = [NSMutableArray array];
    NSArray *goodEntityArray = [goodslist objectAtIndex:index];
    for (int j = 0; j<[goodEntityArray count]; j++) {
        GoodEntity *entity = [goodEntityArray objectAtIndex:j];
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        [aDict setValue:entity.recordid forKey:@"recordid"];
        [aDict setValue:STRING_FROM_INT(entity.count) forKey:@"count"];
        [smallArr addObject:aDict];
    }
    [bigArr addObject:smallArr];
    
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",bigArr,@"goodslist",token,@"token",nil];
    
    NSLog(@"%@",[tempDic JSONRepresentation]);
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.6 购物车物品选中状态设置
//userid	string	用户id
//token	string	服务端返回的token
//goodslist	objectArray	需要修改的商品id对象数组 此数组元素是数组，数组里面是字典
//recordid	string	商品记录id
//select	int	商品选中状态:0.未选中 1.选中（组成套装商品中的每一个商品，select参数是一样的）
/*
 [
 [{
 “recordid”:“1”,
 “select”:0
 },
 ……
 ],
 [{
 “recordid”:“2”,
 “select”:1
 }]
 ……..   //注意该结构有些复杂，由于商品有套装的缘故
 ]
 */
//注意已改
-(NSString*) ShoppingCarGoodsSelectionParam:(NSArray *)goodslist ofIndex:(int)index
{
    NSMutableArray *bigArr = [NSMutableArray array];
    
    NSMutableArray *smallArr = [NSMutableArray array];
    NSArray *goodEntityArray = [goodslist objectAtIndex:index];
    for (int j = 0; j<[goodEntityArray count]; j++) {
        GoodEntity *entity = [goodEntityArray objectAtIndex:j];
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        [aDict setValue:entity.recordid forKey:@"recordid"];
        NSString *strSelect = @"";
        if (entity.isselect) {
            strSelect = @"1";
        }else{
            strSelect = @"0";
        }
        [aDict setValue:strSelect forKey:@"select"];
        [smallArr addObject:aDict];
    }
    [bigArr addObject:smallArr];
    
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",bigArr,@"goodslist",token,@"token",nil];
    NSLog(@"%@",[tempDic JSONRepresentation]);
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.7 购物车获取赠品信息列表
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) ShoppingCarPresentationListParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.8 购物车提交选中的赠品信息
//userid	string	用户id
//token	string	服务端返回的token
//goodslist	objectArray	选中的赠品对象列表
/*NSDictionary
 {
 specialid	string	活动id(赠品对应的活动id)
 goodsid	string	商品id
 color	string	商品颜色
 size	string	商品尺寸
 }
 */
-(NSString*) ShoppingCarCommitPresentationParam:(NSArray *)goodslist
{
    NSMutableArray *requestArray = [NSMutableArray array];
    
    for (int i = 0 ; i<[goodslist count]; i++) {
        PresentationListEntity *bEntity =  [goodslist objectAtIndex:i];
        NSArray *listEntity = bEntity.goodsinfo;
        for (PresentationEntity *aEntity in listEntity) {
            if (aEntity.isselect) {
                NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
                
                [aDict setValue:bEntity.specialid forKey:@"specialid"]; //活动的id，自己字段没有，从上层拿取
                [aDict setValue:aEntity.goodsid forKey:@"goodsid"];
                [aDict setValue:aEntity.selectcolor forKey:@"color"];
                [aDict setValue:aEntity.selectsize forKey:@"size"];
                
                [requestArray addObject:aDict];
            }
        }
    }
    
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = kneedauthenticate;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
        needauthenticate = kneedauthenticateNot;
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:needauthenticate],@"needauthenticate",userid,@"userid",requestArray,@"goodslist",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.9 商品结算（点击“去结算”时调用）
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GoodsSettleUpParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.10 获取商品支付方式
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GetPayTypeParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.12 获取可使用（结算）购物券信息
//userid	string	用户id
//token	string	服务端返回的token
//type	int	查询可用购物券的类型：1.现金券 2.购物券
//page	int	对返回的ticketlist进行分页处理
//buytype	int	结算类型1.购物车普通商品 2. 团购 3. 秒杀
-(NSString*) GetUseableShoppingTicketParam:(int)type page:(int)page buytype:(int)buytype
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:page],@"page",token,@"token",[NSNumber numberWithInt:buytype],@"buytype",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
//userid	string	用户id
//token	string	服务端返回的token
//goods	object	团购、秒杀的商品对象
//goodsid	string	商品id
//color	string	商品颜色
//size	string	商品尺寸
//count	int	商品件数
//type	int	结算类型：1.团购 2.秒杀
-(NSString*) SpecialbuySettleupParam:(NSString *)goodsid color:(NSString *)color size:(NSString *)size count:(int)count type:(int)type
{
    NSDictionary *gooddic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:count],@"count",size,@"size",color,@"color",goodsid,@"goodsid",nil];
    
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",gooddic,@"goods",[NSNumber numberWithInt:type],@"type",token,@"token",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.14 获取使用规则
//type	Int	请求类型：1.邮箱找回规则 2.手机找回规则 3.配送方式规则
-(NSString*) GetRegulationParam:(int)type
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type],@"type",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.15 获取运费金额
//addressid	string	地址id
//paytypeid	int	支付方式
//type	int	订单类型：1.购物车普通商品 2.秒杀 3.团购
-(NSString*) GetDeliverFeeParam:(NSString *)addressid  paytypeid:(int)paytypeid type:(int)type
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",addressid,@"addressid",[NSNumber numberWithInt:paytypeid],@"paytypeid",[NSNumber numberWithInt:type],@"type",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.6.16 获取银联交易流水号
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号码
-(NSString*) GetUPPayTNParam:(NSString *)ordernumber
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kneedauthenticate],@"needauthenticate",userid,@"userid",token,@"token",ordernumber,@"ordernumber",nil];
    return [tempDic JSONRepresentation];
}

#pragma mark    3.7	注册
#pragma mark    3.7.1 注册
//mobile	string	手机号码（使用邮箱注册的时候传空，例””）
//email	string	邮箱地址
//password	string	密码（使用md5小写加密）
//pushtoken	string	手机端提供的用于推送的token
-(NSString*) RegisterParam:(NSString *)mobile email:(NSString *)email password:(NSString *)password token:(NSString *)pushtoken type:(int)devicetype
{
    NSString *md5string = [[self getMD5EncodedString:password]lowercaseString];
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",email,@"email",md5string,@"password",pushtoken,@"pushtoken",[NSString stringWithFormat:@"%d",devicetype],@"devicetype",nil];
    NSLog(@"");
    return [tempDic JSONRepresentation];
  //  postman
}
#pragma mark    3.7.2 登录
//username	string	用户账号
//password	string	用户密码（普通登录有效-使用md5小写加密）
//type	string	登录类型：1.普通登录 2.新浪微博 3.腾讯QQ 4.支付宝
//thirdtoken	string	第三方授权登录产生的token(type!=1有效)
//anonymityid	string	匿名用户id，（用于未登录时添加到购物车物品转移到登录用户购物车上）
//pushtoken	string	手机端提供的用于推送的token
-(NSString*) LoginParam:(NSString *)username password:(NSString *)password type:(NSString *)type thirdtoken:(NSString *)thirdtoken anonymityid:(NSString *)anonymityid token:(NSString *)pushtoken
{
    NSString *md5string = [[self getMD5EncodedString:password]lowercaseString];
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:username,@"username",md5string,@"password",type,@"type",thirdtoken,@"thirdtoken",pushtoken,@"pushtoken",anonymityid,@"anonymityid",nil];
    return [tempDic JSONRepresentation];
}



#pragma mark    3.7.3 找回密码
//mobile	string	手机号码（服务端根据手机、邮箱是否有值自行判断是用手机还是邮箱找回密码）
//email	string	邮箱地址
-(NSString*) ForgetPasswdParam:(NSString *)mobile email:(NSString *)email
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",email,@"email",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.7.4 获取匿名用户id
-(NSString*) GetAnonymityIDParam
{
    return @"";
}
#pragma mark    3.7.5 退出登录接口
//userid	string	用户id
//token	string	服务端返回的token(token失效与否应该都不应影响用户退出登录)
-(NSString*) LogoutParam
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = 1;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",token,@"token",[NSNumber numberWithInt:needauthenticate],@"needauthenticate",nil];
    return [tempDic JSONRepresentation];
}
#pragma mark    3.7.6 修改密码
//userid	string	用户id
//old	string	旧密码
//new	string	新密码
//token	string	服务端返回的token
-(NSString*) ChangePasswordParam:(NSString *)oldPass newPass:(NSString *)newPass
{
    //需要使用登陆后获得的Token来填充token
    NSString* token=kCurrUserToken? kCurrUserToken:@"";
    NSString* userid=kCurrUserId? kCurrUserId:@"";
    int needauthenticate = 1;
    if (isNotLogin) {
        userid = kCurrAnonymityID?kCurrAnonymityID:@"";
    }
    
    NSString *md5stringoldPass = [[self getMD5EncodedString:oldPass]lowercaseString];
    NSString *md5stringnewPass = [[self getMD5EncodedString:newPass]lowercaseString];
    
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",token,@"token",md5stringoldPass,@"old",md5stringnewPass,@"new",[NSNumber numberWithInt:needauthenticate],@"needauthenticate",nil];
    return [tempDic JSONRepresentation];
    
}
#pragma mark    3.7.7 自动登录
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) AutoLoginParam:(NSString *)autologinUserid autologinToken:(NSString *)autologinToken
{
    NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:autologinUserid,@"userid",autologinToken,@"token",nil];
    return [tempDic JSONRepresentation];
}

@end
