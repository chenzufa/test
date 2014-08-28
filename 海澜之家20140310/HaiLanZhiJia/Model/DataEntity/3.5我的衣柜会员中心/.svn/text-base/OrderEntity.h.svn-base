//
//  OrderEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//订单

#import <Foundation/Foundation.h>

@interface OrderEntity : NSObject

@property (retain,nonatomic) NSString *ordernumber;//订单号码 
@property (retain,nonatomic) NSString *amount;//订单金额
@property (retain,nonatomic) NSString *orderdate;//下单时间
//@property (retain,nonatomic) NSString *status;//订单状态如备货中、配送中、已取消
@property (nonatomic) int orderstatus;	//int	订单状态：具体值视后台定义
@property (nonatomic) int deliverstatus;	//int	发货状态：具体值视后台定义
@property (nonatomic) int paystatus;	//int	支付状态：具体值视后台定义


@property (nonatomic) int paytype;//	int	付款方式 1.在线支付 2.货到付款
@property (retain,nonatomic) NSString *paycode;        /*paycode	string	付款方式标识，例如：
                                                        unionpay 银联在线支付
                                                        alipay 支付宝
                                                        bank 银行汇款/转帐
                                                        tenpay 财付通
                                                        onlinepay 在线支付*/
@property (nonatomic) int cancancel;//	int	是否可以取消货到付款订单（该字段对于货到付款才有效），0：不能取消 1.可以取消
@property (nonatomic, assign) int showorderstatus; //该字段对已完成的订单有效 0：表示仍有商品未晒单，客户端需要显示晒单按钮  1：客户端隐藏晒单按钮
@property (nonatomic, assign) int commentstatus;   //该字段对已完成的订单有效 0：表示仍有商品未评论，客户端需要显示评论按钮  1：客户端隐藏评论按钮
@end
