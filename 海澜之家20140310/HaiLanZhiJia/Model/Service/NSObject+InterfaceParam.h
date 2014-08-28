//
//  InterfaceParam.h
//  MeiLiYun
//
//  Created by donson-周响 on 13-10-14.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//
//功能说明：将接口参数拼装成json字串
//-----------------------------------------

#import <Foundation/Foundation.h>

//@"" //当前用户的id 
#define kCurrUserId     [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]

//@"" //当前用户的token
#define kCurrUserToken  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] 

//@""//当前匿名用户的id
#define kCurrAnonymityID [[NSUserDefaults standardUserDefaults] objectForKey:@"anonymityId"] 

//判断用户没有登录
#define isNotLogin (kCurrUserId == nil || [kCurrUserId length]==0)

//needauthenticate	int	是否需要鉴别用户已经登录，0：不需要 1:需要
#define kneedauthenticate 1
#define kneedauthenticateNot 0

@interface NSObject (InterfaceParam)

#pragma mark    3.1	首页
#pragma mark    3.1.1推荐商品
-(NSString*) RecommendGoodsParam;
#pragma mark    3.1.2 焦点资讯
-(NSString*) FocusInfoParam;
#pragma mark    3.1.3 获取首页6个专题
-(NSString*) GetSpecialListParam;
#pragma mark    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
//specialid	string	专题id
//page	int	分页（对于goodlist中返回的商品做分页处理）
-(NSString*) GetSpecialActivityListParam:(NSString *)specialid page:(int)page;
#pragma mark    3.1.5 获取秒杀、团购专题列表
//specialid	string	专题id
//page	int	对返回的goodslist分页
-(NSString*) GetSpecialBuyListParam:(NSString *)specialid page:(int)page;
#pragma mark    3.1.6获取秒杀、团购详情
//goodsid	string	商品id
//specialtype	int	专题类型1.宫格 2.瀑布流 3.单图 4.秒杀 5.团购
-(NSString*) GetSpecialBuyDetailParam:(NSString *)goodsid specialtype:(int)specialtype;
#pragma mark    3.1.7 获取用户对商品的评论
//goodsid	string	商品id
//page	int	分页（对返回的usercomments做分页处理）
-(NSString*) GetUserCommentsParam:(NSString *)goodsid page:(int)page;
#pragma mark    3.1.8 开机启动广告
-(NSString*) StartupADParam;
#pragma mark    3.1.9提交首页热点 
//time	string	开始记录热点的日期时间
//hotclick_list	array	热点坐标列表
// {
//     “hotclick_x”:23.516,
//     “hotclick_y”:23.516,
// }
//hotclick_x	float	热点坐标x
//hotclick_y	float	热点坐标y
-(NSString*) UploadHomeHotClickParam:(NSString *)time hotclick_list:(NSArray *)hotclick_list;
#pragma mark    3.1.10广告点击统计接口 
//id	string	被点击的广告id
//type	int	类型：1.开机广告 2.焦点广告 3.推荐商品
-(NSString*) ADClickReportParam:(NSString *)adid type:(int)type;
#pragma mark    3.1.11用户信息统计接口 (登录后调用)
//userid	string	id
//model	string	手机型号，如三星S3
//pixel	string	分辨率
//chanel	string	安装渠道
//sp	string	网路运营商
//area	string	地域
//sex	string	用户性别
-(NSString*) GetUserCommentsParam:(NSString *)userid model:(NSString *)model pixel:(NSString *)pixel sp:(NSString *)sp area:(NSString *)area;

#pragma mark    3.2	商城（分类）
#pragma mark    3.2.1商城分类列表
-(NSString*) ShoppingMallCategoryParam;
#pragma mark    3.2.2获取商品列表筛选条件
//subcategoryid	string	子目录id
-(NSString*) GetGoodsListSpecParam:(NSString *)subcategoryid;
#pragma mark    3.2.3获取商品列表
//subcategoryid	string	商品子类别id
//type	int	请求类型： 1.销量 2.好评 3.价格由低到高 4.价格由高到低 5.新品
//subspec	stringArray	商品筛选限制条件数组（数组为空表明没有限制条件）
//page	int	分页页码，每页20条数据
-(NSString*) GetGoodsListParam:(NSString *)subcategoryid subspec:(NSArray *)subspec type:(int)type page:(int)page;
#pragma mark    3.2.4获取商品详情
//goodsid	string	商品id
-(NSString*) GetGoodsDetailParam:(NSString *)goodsid;
#pragma mark    3.2.5 获取售前咨询列表
//goodsid	string	商品id
//page	int	分页
-(NSString*) GetSaleConsultListParam:(NSString *)goodsid page:(int)page;
#pragma mark    3.2.6 提交咨询
//goodsid	string	商品id
//userid	string	用户id
//token	string	服务端返回的token
//question	string	咨询的问题
-(NSString*) ConsultCommitParam:(NSString *)goodsid question:(NSString *)question;
#pragma mark    3.2.7 套装详情
//goodsid	string	商品id
//userid	string	用户id,没有登录传空字符””
//token	string	服务端返回的token,未登录传空字符””
-(NSString*) SuitDetailParam:(NSString *)goodsid;
#pragma mark    3.2.8 猜你喜欢
//goodsid	string	商品id
//page	int	分页
-(NSString*) YourFavourateIntroduceParam:(NSString *)goodsid page:(int)page;
#pragma mark    3.2.9 商品收藏
//goodsid	string	商品id
//userid	string	用户id（不登陆不能收藏）
//token	string	服务端返回的token
-(NSString*) GoodsSavingParam:(NSString *)goodsid;

#pragma mark    3.3	搜索
#pragma mark    3.3.1 获取热门搜索词
-(NSString*) GetPopularSearchWordsParam;
#pragma mark    3.3.2获取文本搜索结果
//searchword	string	搜索关键字
//type	int	请求类型： 1.销量 2.好评 3.价格由低到高 4.价格由高到低
//page	int	分页页码，每页20条数据
-(NSString*) GetTextSearchResultParam:(NSString *)searchword type:(int)type page:(int)page;
#pragma mark    3.3.3获取条码搜索结果
//barcode	string	商品条码/二维码信息字串
-(NSString*) GetBarcodeSearchResultParam:(NSString *)barcode;
#pragma mark    3.3.4获取颜色购搜索结果
//l	float	颜色l分量
//a	float	颜色a分量
//b	float	颜色b分量
//astrict	stringArray	限制条件，值是商品一级分类id的子集
-(NSString*) GetColorBuySearchResultParam:(NSArray *)astrict colorl:(float)colorl colora:(float)colora colorb:(float)colorb;
#pragma mark    3.3.5获取摇一摇搜索结果
//astrict	stringArray	限制条件，值是商品一级分类id的子集
//subastrict	stringArray	子限制条件，值是商品价格区间id(接口3.3.6返回)
-(NSString*) GetShakeSearchResultParam:(NSArray *)astrict subastrict:(NSArray *)subastrict;
#pragma mark    3.3.6获取摇一摇限制条件
-(NSString*) GetShakeRestrictParam;

#pragma mark    3.4	设置（更多）
#pragma mark    3.4.1设置消息推送
//userid	string	用户id，（登录了提供，没有登录传值””）
//pushtoken	string	设备推送token
//devicetype	int	设备类型：1. Android 2.iphone 3.ipad
//status	int	需要设置的推送状态 0：禁用推送 1：启用推送
//provinceid	int	省id, 没有登录或者没有获取省id传0，
-(NSString*) PushSettingParam:(NSString *)pushtoken status:(int)status provinceid:(int)provinceid;
#pragma mark    3.4.2获取消息推送开关状态
//userid	string	用户id，（登录了提供，没有登录传值””）
//pushtoken	string	pushtoken
//devicetype	int	设备类型：1. Android 2.iphone 3.ipad
-(NSString*) GetPushStatusParam:(NSString *)pushtoken;
#pragma mark    3.4.3获取帮助信息
-(NSString*) GetHelpInfoParam;
#pragma mark    3.4.4意见反馈
//userid	string	用户id(可选,用户登录的时候要传，未登录为””)
//token	string	服务端返回的token（可选,用户登录的时候要传，未登录为””）
//content	string	意见反馈内容
-(NSString*) CustomerFeedbackParam:(NSString *)content;
#pragma mark    3.4.6 推送清零
/*
 userid	string	用户id(可选,用户登录的时候要传，未登录为””)
 token	string	服务端返回的token（可选,用户登录的时候要传，未登录为””）
 pushtoken	string	ios设备提供的推送token
 */
-(NSString *)CleanPushStatusParm:(NSString *)pushtoken;

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
#pragma mark    3.5.2 订单提醒列表
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) OrderRemindedListParam;
#pragma mark    3.5.3 获取我的订单列表
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
//type	int	请求订单类型 1.进行中的 2.已完成的 3.无效的
-(NSString*) MyOrderListParam:(int)type page:(int)page;
#pragma mark    3.5.4 获取订单详情
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号码
-(NSString*) MyOrderDetailParam:(NSString *)ordernumber;
#pragma mark    3.5.5 取消订单
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号码
-(NSString*) CancelOrderParam:(NSString *)ordernumber;
#pragma mark    3.5.6 获取我的收藏列表
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
-(NSString*) GetMySaveListParam:(int)page;
#pragma mark    3.5.7 删除收藏
//userid	string	用户id
//token	string	服务端返回的token
//goodsid	stringArray	需要删除的商品id对象数组
-(NSString*) DeleteSavingParam:(NSArray *)goodsid;
#pragma mark    3.5.8 添加送货地址
//userid	string	用户id
//token	string	服务端返回的token
//name	string	收货人姓名
//tel	string	收货人电话
//provinceid	int	省id
//cityid	int	市id
//districtid	int	县（区）id
//address	string	详细地址
//mailcode	string	邮政编码
-(NSString*) AddingAddressParam:(NSString *)name tel:(NSString *)tel provinceid:(int)provinceid cityid:(int)cityid districtid:(int)districtid address:(NSString *)address mailcode:(NSString *)mailcode;
#pragma mark    3.5.9获取送货地址
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GetAddressListParam;
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
//mailcode	string	邮政编码
-(NSString*) ModifyAddressParam:(NSString *)addressid name:(NSString *)name tel:(NSString *)tel provinceid:(int)provinceid cityid:(int)cityid districtid:(int)districtid address:(NSString *)address mailcode:(NSString *)mailcode;
#pragma mark    3.5.11 删除、设定默认送货地址
//userid	string	用户id
//token	string	服务端返回的token
//addressid	string	地址id
//action	int	接口执行的类型 1：删除地址 2：设置为默认地址
-(NSString*) DelAndSetDefaultAddressParam:(NSString *)addressid action:(int)action;
#pragma mark    3.5.12 购物券信息（现金券、抵用券）
//userid	string	用户id
//token	string	服务端返回的token
//type	int	请求类型 1：现金券信息 2：抵用券信息
//subtype	int	请求子分类 1：已经使用 2：未使用
//page	int	分页（对返回的ticketlist做分页处理）
-(NSString*) ShoppingTicketInfoParam:(int)type subtype:(int)subtype page:(int)page;
#pragma mark    3.5.13 绑定购物券（现金券、抵用券）
//userid	string	用户id
//token	string	服务端返回的token
//cardnum	string	卡号
//password	string	密码
//type	int	绑定购物券类型 1：现金券 2：抵用券
//haspassword	int	是否使用密码绑定 0：没有密码 1：有密码 （注意：改字段只有type为2时才有效）
//isscan	int	是否扫描 0：不是 1：是的
-(NSString*) BindShoppingTicketParam:(NSString *)cardnum password:(NSString *)password type:(int)type haspassword:(int)haspassword isscan:(int)isscan;
#pragma mark    3.5.14 积分信息
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) ScoreInfoParam;
#pragma mark    3.5.16 我的评论列表
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
//type	int	请求类型：1.未评论 2.已评论
-(NSString*) MyCommentListParam:(int)type page:(int)page;
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
-(NSString*) PublishCommentParam:(NSString *)goodsid ordernumber:(NSString *)ordernumber sizeandcolor:(NSString *)sizeandcolor ordergoodsid:(NSString *)ordergoodsid compositescore:(int)compositescore appearancescore:(int)appearancescore comfortscore:(int)comfortscore comment:(NSString *)comment;
#pragma mark    3.5.18 晒单列表
//page	int	请求的数据的页码
-(NSString*) ShowOrderListParam:(int)page;
#pragma mark    3.5.19 我的晒单
//userid	string	用户id
//token	string	服务端返回的token
//page	int	分页
//type	int	请求类型：1.未晒单 2.已晒单
-(NSString*) MyShowOrderParam:(int)type page:(int)page;
#pragma mark    3.5.20 发表晒单
//userid	string	用户id
//token	string	服务端返回的token
//goodsid	string	商品id
//title	string	晒单标题
//这里不管：imgarray	objectArray	晒单图片数据数组 （上传图片）
//comment	string	评价内容
//sizeandcolor	string	商品尺寸和颜色描述
//ordergoodsid	string	订单商品id（用于描述某一个订单下面的商品的id）
-(NSString*) PublishShowOrderParam:(NSString *)goodsid sizeandcolor:(NSString *)sizeandcolor  ordergoodsid:(NSString *)ordergoodsid title:(NSString *)title comment:(NSString *)comment;
#pragma mark    3.5.21获取个人信息
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
-(NSString*) GetCustomerInfoParam;
#pragma mark    3.5.22获取订单物流详情
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
//ordernumber	string	订单号码
-(NSString*) GetOrderDeliverDetailParam:(NSString *)ordernumber;
#pragma mark    3.5.23 上传、修改个人图像
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
//pic	data	图片数据
-(NSString*) UploadPersonalPicParam;
#pragma mark    3.5.24 获取（红点）提醒信息接口
//userid	string	用户id
//token	string	注册/登录时服务端返回的token
-(NSString*) GetReminderInfoParam;
#pragma mark    3.5.25 删除订单提醒
//userid	string	用户id
//token	string	服务端返回的token
//remindids	intArray	提交待删除的订单提醒id数组
-(NSString*) DelRemindParam:(NSArray *)remindids;
#pragma mark    3.5.26 确认收货
//“userid”:”abc123”,
//“token”:”服务端返回的token”,
//“ordernumber”:”1313434”,
//“needauthenticate”:1
-(NSString*) ConfirmOrderParam:(NSString *)ordernumber;
#pragma mark    3.5.27 修改订单详情支付方式
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号
//paytypeid	string	支付方式id
//needauthenticate	int	是否需要鉴别用户已经登录，0：不需要 1:需要
-(NSString*) ChangeOrderPaytypeParam:(NSString *)ordernumber paytypeid:(NSString *)paytypeid;

#pragma mark    3.6	购物车
#pragma mark    3.6.1获取购物车信息
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GetShoppingCarInfoParam;
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
//isneed	int	是否需要发票：0.不需要 1.需要
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
-(NSString*) CommitOrderParam:(NSString *)addressid payas:(int)payas deliverby:(int)deliverby delivertime:(int)delivertime note:(NSString *)note invoceisneed:(int)invoceisneed invocetitle:(NSString *)invocetitle invocecontent:(NSString *)invocecontent moneyticket:(NSArray *)moneyticket tradeticket:(NSArray *)tradeticket type:(int)type;
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
-(NSString*) AddToShoppingCarParam:(NSArray *)goodslist issuit:(int)issuit;
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
-(NSString*) ShoppingCarDelParam:(NSArray *)goodslist ofIndex:(int)index;
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
-(NSString*) ShoppingCarModifyParam:(NSArray *)goodslist ofIndex:(int)index;
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
-(NSString*) ShoppingCarGoodsSelectionParam:(NSArray *)goodslist ofIndex:(int)index;
#pragma mark    3.6.7 购物车获取赠品信息列表
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) ShoppingCarPresentationListParam;
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
-(NSString*) ShoppingCarCommitPresentationParam:(NSArray *)goodslist;
#pragma mark    3.6.9 商品结算（点击“去结算”时调用）
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) GoodsSettleUpParam;
#pragma mark    3.6.10 获取商品支付方式
-(NSString*) GetPayTypeParam;
#pragma mark    3.6.12 获取可使用（结算）购物券信息
//userid	string	用户id
//token	string	服务端返回的token
//type	int	查询可用购物券的类型：1.现金券 2.购物券
//page	int	对返回的ticketlist进行分页处理
//buytype	int	结算类型1.购物车普通商品 2. 团购 3. 秒杀
-(NSString*) GetUseableShoppingTicketParam:(int)type page:(int)page buytype:(int)buytype;
#pragma mark    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
//userid	string	用户id
//token	string	服务端返回的token
//goods	object	团购、秒杀的商品对象
//goodsid	string	商品id
//color	string	商品颜色
//size	string	商品尺寸
//count	int	商品件数
//type	int	结算类型：1.团购 2.秒杀
-(NSString*) SpecialbuySettleupParam:(NSString *)goodsid color:(NSString *)color size:(NSString *)size count:(int)count type:(int)type;
#pragma mark    3.6.14 获取使用规则
//type	Int	请求类型：1.邮箱找回规则 2.手机找回规则 3.配送方式规则4.用户注册（服务条款）规则
-(NSString*) GetRegulationParam:(int)type;
#pragma mark    3.6.15 获取运费金额
//addressid	string	地址id
//paytypeid	int	支付方式
//type	int	订单类型：1.购物车普通商品 2.秒杀 3.团购
-(NSString*) GetDeliverFeeParam:(NSString *)addressid  paytypeid:(int)paytypeid type:(int)type;
#pragma mark    3.6.16 获取银联交易流水号
//userid	string	用户id
//token	string	服务端返回的token
//ordernumber	string	订单号码
-(NSString*) GetUPPayTNParam:(NSString *)ordernumber;

#pragma mark    3.7	注册
#pragma mark    3.7.1 注册
//mobile	string	手机号码（使用邮箱注册的时候传空，例””）
//email	string	邮箱地址
//password	string	密码（使用md5小写加密）
-(NSString*) RegisterParam:(NSString *)mobile email:(NSString *)email password:(NSString *)password token:(NSString *)pushtoken type:(int )devicetype;

#pragma mark    3.7.2 登录
//username	string	用户账号
//password	string	用户密码（普通登录有效-使用md5小写加密）
//type	string	登录类型：1.普通登录 2.新浪微博 3.腾讯QQ 4.支付宝
//thirdtoken	string	第三方授权登录产生的token(type!=1有效)
//anonymityid	string	匿名用户id，（用于未登录时添加到购物车物品转移到登录用户购物车上）
//-(NSString*) LoginParam:(NSString *)username password:(NSString *)password type:(NSString *)type thirdtoken:(NSString *)thirdtoken anonymityid:(NSString *)anonymityid;
//pushtoken	string	手机端提供的用于推送的token
//备注：如果使用支付宝登录，username=获取的real_name
//thirdtoken=获取到的user_id
-(NSString*) LoginParam:(NSString *)username password:(NSString *)password type:(NSString *)type thirdtoken:(NSString *)thirdtoken anonymityid:(NSString *)anonymityid token:(NSString *)pushtoken;
#pragma mark    3.7.3 找回密码
//mobile	string	手机号码（服务端根据手机、邮箱是否有值自行判断是用手机还是邮箱找回密码）
//email	string	邮箱地址
-(NSString*) ForgetPasswdParam:(NSString *)mobile email:(NSString *)email;
#pragma mark    3.7.4 获取匿名用户id
-(NSString*) GetAnonymityIDParam;
#pragma mark    3.7.5 退出登录接口
//userid	string	用户id
//token	string	服务端返回的token(token失效与否应该都不应影响用户退出登录)
-(NSString*) LogoutParam;
#pragma mark    3.7.6 修改密码
//userid	string	用户id
//old	string	旧密码
//new	string	新密码
//token	string	服务端返回的token
-(NSString*) ChangePasswordParam:(NSString *)oldPass newPass:(NSString *)newPass;
#pragma mark    3.7.7 自动登录
//userid	string	用户id
//token	string	服务端返回的token
-(NSString*) AutoLoginParam:(NSString *)autologinUserid autologinToken:(NSString *)autologinToken;

@end
