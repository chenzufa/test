//
//  NSObject+ZXisTest.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "NSObject+ZXisTest.h"
#define getZXtestPlist [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZXtest" ofType:@"plist"]] autorelease]

@implementation NSObject (ZXisTest)

-(void)setResponseJSONString:(NSString **)jsonString withInterface:(enum InterfaceType)type
{
    NSDictionary *jsonDic = getZXtestPlist;
    switch (type)
    {
            //    3.1	首页
            //    3.1.1推荐商品
        case RecommendGoods:
        {
            *jsonString = [jsonDic valueForKey:@"RecommendGoods"];
         }
            break;
            //    3.1.2 焦点资讯
        case FocusInfo:
        {
            *jsonString = [jsonDic valueForKey:@"FocusInfo"];
        }
            break;
            //    3.1.3 获取首页6个专题
        case GetSpecialList:
        {
            *jsonString = [jsonDic valueForKey:@"GetSpecialList"];
        }
            break;
            //    3.1.4 获取普通活动专题列表（除秒杀、团购外的）
        case GetSpecialActivityList:
        {
            *jsonString = [jsonDic valueForKey:@"GetSpecialActivityList"];
        }
            break;
            //    3.1.5 获取秒杀、团购专题列表
        case GetSpecialBuyList:
        {
            *jsonString = [jsonDic valueForKey:@"GetSpecialBuyList"];
        }
            break;
            //    3.1.6获取秒杀、团购详情
        case GetSpecialBuyDetail:
        {
            *jsonString = [jsonDic valueForKey:@"GetSpecialBuyDetail"];
        }
            break;
            //    3.1.7 获取用户对商品的评论
        case GetUserComments:
        {
            *jsonString = [jsonDic valueForKey:@"GetUserComments"];
        }
            break;
            //    3.1.8 开机启动广告
        case StartupAD:
        {
            *jsonString = [jsonDic valueForKey:@"StartupAD"];
        }
            break;
            //    3.1.9提交首页热点
        case UploadHomeHotClick:
        {
            *jsonString = [jsonDic valueForKey:@"UploadHomeHotClick"];
        }
            break;
            
            //    3.2	商城（分类）
            //    3.2.1商城分类列表
        case ShoppingMallCategory:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingMallCategory"];
        }
            break;
            //    3.2.2获取商品列表筛选条件
        case GetGoodsListSpec:
        {
            *jsonString = [jsonDic valueForKey:@"GetGoodsListSpec"];
        }
            break;
            //    3.2.3获取商品列表
        case GetGoodsList:
        {
            *jsonString = [jsonDic valueForKey:@"GetGoodsList"];
        }
            break;
            //    3.2.4获取商品详情
        case GetGoodsDetail:
        {
            *jsonString = [jsonDic valueForKey:@"GetGoodsDetail"];
        }
            break;
            //    3.2.5 获取售前咨询列表
        case GetSaleConsultList:
        {
            *jsonString = [jsonDic valueForKey:@"GetSaleConsultList"];
        }
            break;
            //    3.2.6 提交咨询
        case ConsultCommit:
        {
            *jsonString = [jsonDic valueForKey:@"ConsultCommit"];
        }
            break;
            //    3.2.7 套装详情
        case SuitDetail:
        {
            *jsonString = [jsonDic valueForKey:@"SuitDetail"];
        }
            break;
            //    3.2.8 猜你喜欢
        case YourFavourateIntroduce:
        {
            *jsonString = [jsonDic valueForKey:@"YourFavourateIntroduce"];
        }
            break;
            //    3.2.9 商品收藏
        case GoodsSaving:
        {
            *jsonString = [jsonDic valueForKey:@"GoodsSaving"];
        }
            break;
            
            //    3.3	搜索
            //    3.3.1 获取热门搜索词
        case GetPopularSearchWords:
        {
            *jsonString = [jsonDic valueForKey:@"GetPopularSearchWords"];
        }
            break;
            //    3.3.2获取文本搜索结果
        case GetTextSearchResult:
        {
            *jsonString = [jsonDic valueForKey:@"GetTextSearchResult"];
        }
            break;
            //    3.3.3获取条码搜索结果
        case GetBarcodeSearchResult:
        {
            *jsonString = [jsonDic valueForKey:@"GetBarcodeSearchResult"];
        }
            break;
            //    3.3.4获取颜色购搜索结果
        case GetColorBuySearchResult:
        {
            *jsonString = [jsonDic valueForKey:@"GetColorBuySearchResult"];
        }
            break;
            //    3.3.5获取摇一摇搜索结果
        case GetShakeSearchResult:
        {
            *jsonString = [jsonDic valueForKey:@"GetShakeSearchResult"];
        }
            break;
            //    3.3.6获取摇一摇限制条件
        case GetShakeRestrict:
        {
            *jsonString = [jsonDic valueForKey:@"GetShakeRestrict"];
        }
            break;
            
            //    3.4	设置（更多）
            //    3.4.1设置消息推送
        case PushSetting:
        {
            *jsonString = [jsonDic valueForKey:@"PushSetting"];
        }
            break;
            //    3.4.2获取消息推送开关状态
        case GetPushStatus:
        {
            *jsonString = [jsonDic valueForKey:@"GetPushStatus"];
        }
            break;
            //    3.4.3获取帮助信息
        case GetHelpInfo:
        {
            *jsonString = [jsonDic valueForKey:@"GetHelpInfo"];
        }
            break;
            //    3.4.4意见反馈
        case CustomerFeedback:
        {
            *jsonString = [jsonDic valueForKey:@"CustomerFeedback"];
        }
            break;
            
            //    3.5	我的衣柜（会员中心）
            //    3.5.1修改个人信息
        case ModifyCustomerInfo:
        {
            *jsonString = [jsonDic valueForKey:@"ModifyCustomerInfo"];
        }
            break;
            //    3.5.2 订单提醒列表
        case OrderRemindedList:
        {
            *jsonString = [jsonDic valueForKey:@"OrderRemindedList"];
        }
            break;
            //    3.5.3 获取我的订单列表
        case MyOrderList:
        {
            *jsonString = [jsonDic valueForKey:@"MyOrderList"];
        }
            break;
            //    3.5.4 获取订单详情
        case MyOrderDetail:
        {
            *jsonString = [jsonDic valueForKey:@"MyOrderDetail"];
        }
            break;
            //    3.5.5 取消订单
        case CancelOrder:
        {
            *jsonString = [jsonDic valueForKey:@"CancelOrder"];
        }
            break;
            //    3.5.6 获取我的收藏列表
        case GetMySaveList:
        {
            *jsonString = [jsonDic valueForKey:@"GetMySaveList"];
        }
            break;
            //    3.5.7 删除收藏
        case DeleteSaving:
        {
            *jsonString = [jsonDic valueForKey:@"DeleteSaving"];
        }
            break;
            //    3.5.8 添加送货地址
        case AddingAddress:
        {
            *jsonString = [jsonDic valueForKey:@"AddingAddress"];
        }
            break;
            //    3.5.9获取送货地址
        case GetAddressList:
        {
            *jsonString = [jsonDic valueForKey:@"GetAddressList"];
        }
            break;
            //    3.5.10 修改送货地址
        case ModifyAddress:
        {
            *jsonString = [jsonDic valueForKey:@"ModifyAddress"];
        }
            break;
            //    3.5.11 删除、设定默认送货地址
        case DelAndSetDefaultAddress:
        {
            *jsonString = [jsonDic valueForKey:@"DelAndSetDefaultAddress"];
        }
            break;
            //    3.5.12 购物券信息（现金券、抵用券）
        case ShoppingTicketInfo:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingTicketInfo"];
        }
            break;
            //    3.5.13 绑定购物券（现金券、抵用券）
        case BindShoppingTicket:
        {
            *jsonString = [jsonDic valueForKey:@"BindShoppingTicket"];
        }
            break;
            //    3.5.14 积分信息
        case ScoreInfo:
        {
            *jsonString = [jsonDic valueForKey:@"ScoreInfo"];
        }
            break;
            //    3.5.16 我的评论列表
        case MyCommentList:
        {
            *jsonString = [jsonDic valueForKey:@"MyCommentList"];
        }
            break;
            //    3.5.17 发表评论
        case PublishComment:
        {
            *jsonString = [jsonDic valueForKey:@"PublishComment"];
        }
            break;
            //    3.5.18 晒单列表
        case ShowOrderList:
        {
            *jsonString = [jsonDic valueForKey:@"ShowOrderList"];
        }
            break;
            //    3.5.19 我的晒单
        case MyShowOrder:
        {
            *jsonString = [jsonDic valueForKey:@"MyShowOrder"];
        }
            break;
            //    3.5.20 发表晒单
        case PublishShowOrder:
        {
            *jsonString = [jsonDic valueForKey:@"PublishShowOrder"];
        }
            break;
            //    3.5.21获取个人信息
        case GetCustomerInfo:
        {
            *jsonString = [jsonDic valueForKey:@"GetCustomerInfo"];
        }
            break;
            //    3.5.22获取订单物流详情
        case GetOrderDeliverDetail:
        {
            *jsonString = [jsonDic valueForKey:@"GetOrderDeliverDetail"];
        }
            break;
            //    3.5.23 上传、修改个人图像
        case UploadPersonalPic:
        {
            *jsonString = [jsonDic valueForKey:@"UploadPersonalPic"];
        }
            break;
            
            //    3.6	购物车
            //    3.6.1获取购物车信息
        case GetShoppingCarInfo:
        {
            *jsonString = [jsonDic valueForKey:@"GetShoppingCarInfo"];
        }
            break;
            //    3.6.2 提交订单
        case CommitOrder:
        {
            *jsonString = [jsonDic valueForKey:@"CommitOrder"];
        }
            break;
            //    3.6.3 添加到购物车（不在购物车页面时添加物品）
        case AddToShoppingCar:
        {
            *jsonString = [jsonDic valueForKey:@"AddToShoppingCar"];
        }
            break;
            //    3.6.4 删除购物车物品
        case ShoppingCarDel:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingCarDel"];
        }
            break;
            //    3.6.5 修改购物车物品数量
        case ShoppingCarModify:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingCarModify"];
        }
            break;
            //    3.6.6 购物车物品选中状态设置
        case ShoppingCarGoodsSelection:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingCarGoodsSelection"];
        }
            break;
            //    3.6.7 购物车获取赠品信息列表
        case ShoppingCarPresentationList:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingCarPresentationList"];
        }
            break;
            //    3.6.8 购物车提交选中的赠品信息
        case ShoppingCarCommitPresentation:
        {
            *jsonString = [jsonDic valueForKey:@"ShoppingCarCommitPresentation"];
        }
            break;
            //    3.6.9 商品结算（点击“去结算”时调用）
        case GoodsSettleUp:
        {
            *jsonString = [jsonDic valueForKey:@"GoodsSettleUp"];
        }
            break;
            //    3.6.10 获取商品支付方式
        case GetPayType:
        {
            *jsonString = [jsonDic valueForKey:@"GetPayType"];
        }
            break;
            //    3.6.12 获取可使用（结算）购物券信息
        case GetUseableShoppingTicket:
        {
            *jsonString = [jsonDic valueForKey:@"GetUseableShoppingTicket"];
        }
            break;
            
            //    3.7	注册
            //    3.7.1 注册
        case Register:
        {
            *jsonString = [jsonDic valueForKey:@"Register"];
        }
            break;
            //    3.7.2 登录
        case Login:
        {
            *jsonString = [jsonDic valueForKey:@"Login"];
        }
            break;
            //    3.7.3 找回密码
        case ForgetPasswd:
        {
            *jsonString = [jsonDic valueForKey:@"ForgetPasswd"];
        }
            break;
            //    3.7.4 获取匿名用户id
        case GetAnonymityID:
        {
            *jsonString = [jsonDic valueForKey:@"GetAnonymityID"];
        }
            break;
            //    3.7.5 退出登录接口
        case Logout:
        {
            *jsonString = [jsonDic valueForKey:@"Logout"];
        }
            break;
            //    3.7.6 修改密码
        case ChangePassword:
        {
            *jsonString = [jsonDic valueForKey:@"ChangePassword"];
        }
            break;
            
        default:
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"警告jsonString：" message:@"请求的接口类型出错！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
            break;
    }
}

@end
