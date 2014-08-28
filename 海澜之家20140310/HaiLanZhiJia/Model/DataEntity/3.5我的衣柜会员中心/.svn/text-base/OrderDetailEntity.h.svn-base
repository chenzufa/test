//
//  OrderDetailEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//订单详情

#import <Foundation/Foundation.h>

@interface OrderDetailEntity : NSObject

//orderdetail
@property (retain,nonatomic) NSString *ordernumber;//订单号码
@property (retain,nonatomic) NSString *orderstatus;//订单状态
@property (retain,nonatomic) NSString *deliverby;//送货方式
@property (retain,nonatomic) NSString *payby;//支付方式
@property (retain,nonatomic) NSString *paycode;        /*paycode	string	付款方式标识，例如：
                                                        unionpay 银联在线支付
                                                        alipay 支付宝
                                                        bank 银行汇款/转帐
                                                        tenpay 财付通
                                                        onlinepay 在线支付*/

@property (retain,nonatomic) NSString *orderdate;//订单生成时间
@property (retain,nonatomic) NSString *deliverstatus;//发货状态
@property (retain,nonatomic) NSString *needinvoice;//是否开发票

//receiver
@property (retain,nonatomic) NSString *name;//收货人姓名
@property (retain,nonatomic) NSString *tel;//收货人电话
@property (retain,nonatomic) NSString *address;//收货人地址
@property (retain,nonatomic) NSString *mailcode;//邮编

@property (retain,nonatomic) NSString *availabledate;//送货时间

@property (retain,nonatomic) NSArray *goodslist;//商品列表对象数组

//description
@property (retain,nonatomic) NSString *count;//商品件数
@property (retain,nonatomic) NSString *score;//赠送积分总计
@property (retain,nonatomic) NSString *goodsfee;//商品金额总计
@property (retain,nonatomic) NSString *deliverfee;//运费金额
@property (retain,nonatomic) NSString *tradeticket;//抵用券
@property (retain,nonatomic) NSString *moneyticket;//现金券
@property (retain,nonatomic) NSString *total;//应付金额

@end
