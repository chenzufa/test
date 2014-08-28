//
//  InterfaceConstant.h
//  MeiLiYun
//
//  Created by donson-周响 on 13-10-14.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#ifndef MeiLiYun_InterfaceConstant_h
#define MeiLiYun_InterfaceConstant_h

#pragma mark -- API数据接口 InterfaceType
enum InterfaceType
{
//    3.1	首页
//    3.1.1推荐商品
    RecommendGoods,
//    3.1.2 焦点资讯
    FocusInfo,
//    3.1.3 获取首页6个专题
    GetSpecialList,
//    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
    GetSpecialActivityList,
//    3.1.5 获取秒杀、团购专题列表
    GetSpecialBuyList,
//    3.1.6获取秒杀、团购详情
    GetSpecialBuyDetail,
//    3.1.7 获取用户对商品的评论
    GetUserComments,
//    3.1.8 开机启动广告
    StartupAD,
//    3.1.9提交首页热点
    UploadHomeHotClick,
//    3.1.10广告点击统计接口
    ADClickReport,
//    3.1.11用户信息统计接口 (登录后调用)
    UserInfoReport,
    
//    3.2	商城（分类）
//    3.2.1商城分类列表
    ShoppingMallCategory,
//    3.2.2获取商品列表筛选条件
    GetGoodsListSpec,
//    3.2.3获取商品列表
    GetGoodsList,
//    3.2.4获取商品详情
    GetGoodsDetail,
//    3.2.5 获取售前咨询列表
    GetSaleConsultList,
//    3.2.6 提交咨询
    ConsultCommit,
//    3.2.7 套装详情
    SuitDetail,
//    3.2.8 猜你喜欢
    YourFavourateIntroduce,
//    3.2.9 商品收藏
    GoodsSaving,
    
//    3.3	搜索
//    3.3.1 获取热门搜索词
    GetPopularSearchWords,
//    3.3.2获取文本搜索结果
    GetTextSearchResult,
//    3.3.3获取条码搜索结果
    GetBarcodeSearchResult,
//    3.3.4获取颜色购搜索结果
    GetColorBuySearchResult,
//    3.3.5获取摇一摇搜索结果
    GetShakeSearchResult,
//    3.3.6获取摇一摇限制条件
    GetShakeRestrict,
    
//    3.4	设置（更多）
//    3.4.1设置消息推送
    PushSetting,
//    3.4.2获取消息推送开关状态
    GetPushStatus,
//    3.4.3获取帮助信息
    GetHelpInfo,
//    3.4.4意见反馈
    CustomerFeedback,
//    3.4.6 推送清零
    CleanPushStatus,
    
//    3.5	我的衣柜（会员中心）
//    3.5.1修改个人信息
    ModifyCustomerInfo,
//    3.5.2 订单提醒列表
    OrderRemindedList,
//    3.5.3 获取我的订单列表
    MyOrderList,
//    3.5.4 获取订单详情
    MyOrderDetail,
//    3.5.5 取消订单
    CancelOrder,
//    3.5.6 获取我的收藏列表
    GetMySaveList,
//    3.5.7 删除收藏
    DeleteSaving,
//    3.5.8 添加送货地址
    AddingAddress,
//    3.5.9获取送货地址
    GetAddressList,
//    3.5.10 修改送货地址
    ModifyAddress,
//    3.5.11 删除、设定默认送货地址
    DelAndSetDefaultAddress,
//    3.5.12 购物券信息（现金券、抵用券）
    ShoppingTicketInfo,
//    3.5.13 绑定购物券（现金券、抵用券）
    BindShoppingTicket,
//    3.5.14 积分信息
    ScoreInfo,
//    3.5.16 我的评论列表
    MyCommentList,
//    3.5.17 发表评论
    PublishComment,
//    3.5.18 晒单列表
    ShowOrderList,
//    3.5.19 我的晒单
    MyShowOrder,
//    3.5.20 发表晒单
    PublishShowOrder,
//    3.5.21获取个人信息
    GetCustomerInfo,
//    3.5.22获取订单物流详情
    GetOrderDeliverDetail,
//    3.5.23 上传、修改个人图像
    UploadPersonalPic,
//    3.5.24 获取（红点）提醒信息接口
    GetReminderInfo,
//    3.5.25 删除订单提醒
    DelRemind,
//    3.5.26 确认收货
    ConfirmOrder,
//    3.5.27 修改订单详情支付方式
    ChangeOrderPaytype,
    
//    3.6	购物车
//    3.6.1获取购物车信息
    GetShoppingCarInfo,
//    3.6.2 提交订单
    CommitOrder,
//    3.6.3 添加到购物车（不在购物车页面时添加物品）
    AddToShoppingCar,
//    3.6.4 删除购物车物品
    ShoppingCarDel,
//    3.6.5 修改购物车物品数量
    ShoppingCarModify,
//    3.6.6 购物车物品选中状态设置
    ShoppingCarGoodsSelection,
//    3.6.7 购物车获取赠品信息列表
    ShoppingCarPresentationList,
//    3.6.8 购物车提交选中的赠品信息
    ShoppingCarCommitPresentation,
//    3.6.9 商品结算（点击“去结算”时调用）
    GoodsSettleUp,
//    3.6.10 获取商品支付方式
    GetPayType,
//    3.6.12 获取可使用（结算）购物券信息
    GetUseableShoppingTicket,
//    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
    SpecialbuySettleup,
//    3.6.14 获取使用规则
    GetRegulation,
//    3.6.15 获取运费金额
    GetDeliverFee,
//    3.6.16 获取银联交易流水号
    GetUPPayTN,
    
//    3.7	注册
//    3.7.1 注册
    Register,
//    3.7.2 登录
    Login,
//    3.7.3 找回密码
    ForgetPasswd,
//    3.7.4 获取匿名用户id
    GetAnonymityID,
//    3.7.5 退出登录接口
    Logout,
//    3.7.6 修改密码
    ChangePassword,
//    3.7.7 自动登录
    AutoLogin,
};

#pragma mark -- API数据接口 url
#if IS_HAILANZHIJIA_ENVIRONMENT
//海澜客户环境
//#define SEARCH_ADDRESS          @"http://222.191.239.88:8087/"
//#define kDSRequestAPIDomain     @"http://222.191.239.88:8086/"

#define SEARCH_ADDRESS          @"http://search.heilanhome.com/"
#define kDSRequestAPIDomain     @"http://apiapp.heilanhome.com/"

#define ZHIFUBAO_ADDRESS @"http://61.177.144.188/"
#else
//东信环境
#define SEARCH_ADDRESS          @"http://113.106.90.141:2046/Search/"
#define kDSRequestAPIDomain     @"http://113.106.90.141:2046/Api/"

#define ZHIFUBAO_ADDRESS @"http://113.106.90.141:2046/Api/"

#endif
//    3.1	首页
//    3.1.1推荐商品
#define RecommendGoodsURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"RecommendGoods"]
//    3.1.2 焦点资讯
#define FocusInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"FocusInfo"]
//    3.1.3 获取首页6个专题
#define GetSpecialListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetSpecialList"]
//    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
#define GetSpecialActivityListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetSpecialActivityList"]
//    3.1.5 获取秒杀、团购专题列表
#define GetSpecialBuyListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetSpecialBuyList"]
//    3.1.6获取秒杀、团购详情
#define GetSpecialBuyDetailURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetSpecialBuyDetail"]
//    3.1.7 获取用户对商品的评论
#define GetUserCommentsURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetUserComments"]
//    3.1.8 开机启动广告
#define StartupADURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"StartupAD"]
//    3.1.9提交首页热点
#define UploadHomeHotClickURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"UploadHomeHotClick"]
//    3.1.10广告点击统计接口
#define ADClickReportURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ADClickReport"]
//    3.1.11用户信息统计接口 (登录后调用)
#define UserInfoReportURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"UserInfoReport"]

//    3.2	商城（分类）
//    3.2.1商城分类列表
#define ShoppingMallCategoryURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingMallCategory"]
//    3.2.2获取商品列表筛选条件
#define GetGoodsListSpecURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetGoodsListSpec"]
//    3.2.3获取商品列表
#define GetGoodsListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetGoodsList"]
//    3.2.4获取商品详情
#define GetGoodsDetailURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetGoodsDetail"]
//    3.2.5 获取售前咨询列表
#define GetSaleConsultListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetSaleConsultList"]
//    3.2.6 提交咨询
#define ConsultCommitURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ConsultCommit"]
//    3.2.7 套装详情
#define SuitDetailURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"SuitDetail"]
//    3.2.8 猜你喜欢
#define YourFavourateIntroduceURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"YourFavourateIntroduce"]
//    3.2.9 商品收藏
#define GoodsSavingURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GoodsSaving"]

//    3.3	搜索
//    3.3.1 获取热门搜索词
#define GetPopularSearchWordsURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetPopularSearchWords"]
//    3.3.2获取文本搜索结果   //改过了 
#define GetTextSearchResultURL              [NSString stringWithFormat:@"%@%@",SEARCH_ADDRESS,@"GetTextSearchResult"]
//    3.3.3获取条码搜索结果12-20-2013 jsm
#define GetBarcodeSearchResultURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetBarcodeSearchResult"]
//    3.3.4获取颜色购搜索结果
#define GetColorBuySearchResultURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetColorBuySearchResult"]
//    3.3.5获取摇一摇搜索结果
#define GetShakeSearchResultURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetShakeSearchResult"]
//    3.3.6获取摇一摇限制条件
#define GetShakeRestrictURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetShakeRestrict"]

//    3.4	设置（更多）
//    3.4.1设置消息推送
#define PushSettingURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"PushSetting"]
//    3.4.2获取消息推送开关状态
#define GetPushStatusURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetPushStatus"]
//    3.4.3获取帮助信息
#define GetHelpInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetHelpInfo"]
//    3.4.4意见反馈
#define CustomerFeedbackURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"CustomerFeedback"]
//    3.4.6 推送清零
#define CleanPushStatusURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"CleanPushStatus"]

//    3.5	我的衣柜（会员中心）
//    3.5.1修改个人信息
#define ModifyCustomerInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ModifyCustomerInfo"]
//    3.5.2 订单提醒列表
#define OrderRemindedListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"OrderRemindedList"]
//    3.5.3 获取我的订单列表
#define MyOrderListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"MyOrderList"]
//    3.5.4 获取订单详情
#define MyOrderDetailURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"MyOrderDetail"]
//    3.5.5 取消订单
#define CancelOrderURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"CancelOrder"]
//    3.5.6 获取我的收藏列表
#define GetMySaveListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetMySaveList"]
//    3.5.7 删除收藏
#define DeleteSavingURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"DeleteSaving"]
//    3.5.8 添加送货地址
#define AddingAddressURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"AddingAddress"]
//    3.5.9获取送货地址
#define GetAddressListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetAddressList"]
//    3.5.10 修改送货地址
#define ModifyAddressURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ModifyAddress"]
//    3.5.11 删除、设定默认送货地址
#define DelAndSetDefaultAddressURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"DelAndSetDefaultAddress"]
//    3.5.12 购物券信息（现金券、抵用券）
#define ShoppingTicketInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingTicketInfo"]
//    3.5.13 绑定购物券（现金券、抵用券）
#define BindShoppingTicketURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"BindShoppingTicket"]
//    3.5.14 积分信息
#define ScoreInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ScoreInfo"]
//    3.5.16 我的评论列表
#define MyCommentListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"MyCommentList"]
//    3.5.17 发表评论
#define PublishCommentURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"PublishComment"]
//    3.5.18 晒单列表
#define ShowOrderListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShowOrderList"]
//    3.5.19 我的晒单
#define MyShowOrderURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"MyShowOrder"]
//    3.5.20 发表晒单
#define PublishShowOrderURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"PublishShowOrder"]
//    3.5.21获取个人信息
#define GetCustomerInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetCustomerInfo"]
//    3.5.22获取订单物流详情
#define GetOrderDeliverDetailURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetOrderDeliverDetail"]
//    3.5.23 上传、修改个人图像
#define UploadPersonalPicURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"UploadPersonalPic"]
//    3.5.24 获取（红点）提醒信息接口
#define GetReminderInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetReminderInfo"]
//    3.5.25 删除订单提醒
#define DelRemindURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"DelRemind"]
//    3.5.26 确认收货
#define ConfirmOrderURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ConfirmOrder"]
//    3.5.27 修改订单详情支付方式
#define ChangeOrderPaytypeURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ChangeOrderPaytype"]

//    3.6	购物车
//    3.6.1获取购物车信息
#define GetShoppingCarInfoURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetShoppingCarInfo"]
//    3.6.2 提交订单
#define CommitOrderURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"CommitOrder"]
//    3.6.3 添加到购物车（不在购物车页面时添加物品）
#define AddToShoppingCarURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"AddToShoppingCar"]
//    3.6.4 删除购物车物品
#define ShoppingCarDelURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingCarDel"]
//    3.6.5 修改购物车物品数量
#define ShoppingCarModifyURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingCarModify"]
//    3.6.6 购物车物品选中状态设置
#define ShoppingCarGoodsSelectionURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingCarGoodsSelection"]
//    3.6.7 购物车获取赠品信息列表
#define ShoppingCarPresentationListURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingCarPresentationList"]
//    3.6.8 购物车提交选中的赠品信息
#define ShoppingCarCommitPresentationURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ShoppingCarCommitPresentation"]
//    3.6.9 商品结算（点击“去结算”时调用）
#define GoodsSettleUpURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GoodsSettleUp"]
//    3.6.10 获取商品支付方式
#define GetPayTypeURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetPayType"]
//    3.6.12 获取可使用（结算）购物券信息
#define GetUseableShoppingTicketURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetUseableShoppingTicket"]
//    3.6.13 团购秒杀结算（不走购物车，区别于普通商品结算）
#define SpecialbuySettleupURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"SpecialbuySettleup"]
//    3.6.14 获取使用规则
#define GetRegulationURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetRegulation"]
//    3.6.15 获取运费金额
#define GetDeliverFeeURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetDeliverFee"]
//    3.6.16 获取银联交易流水号
#define GetUPPayTNURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetUPPayTN"]

//    3.7	注册
//    3.7.1 注册
#define RegisterURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"Register"]
//    3.7.2 登录
#define LoginURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"Login"]
//    3.7.3 找回密码
#define ForgetPasswdURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ForgetPasswd"]
//    3.7.4 获取匿名用户id
#define GetAnonymityIDURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"GetAnonymityID"]
//    3.7.5 退出登录接口
#define LogoutURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"Logout"]
//    3.7.6 修改密码
#define ChangePasswordURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"ChangePassword"]
//    3.7.7 自动登录
#define AutoLoginURL              [NSString stringWithFormat:@"%@%@",kDSRequestAPIDomain,@"AutoLogin"]

#endif