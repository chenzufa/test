//
//  OrderDetailEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderDetailEntity.h"

@implementation OrderDetailEntity

- (void)dealloc
{
    //orderdetail
    self.ordernumber = nil;//订单号码
    self.orderstatus = nil;//订单状态
    self.deliverby = nil;//送货方式
    self.payby = nil;//支付方式
    self.paycode = nil;
    self.orderdate = nil;//订单生成时间
    self.deliverstatus = nil;//发货时间
    self.needinvoice = nil;//是否开发票
    
    //receiver
    self.name = nil;//收货人姓名
    self.tel = nil;//收货人电话
    self.address = nil;//收货人地址
    self.mailcode = nil;//邮编
    
    self.availabledate = nil;//送货时间
    
    self.goodslist = nil;//商品列表对象数组
    
    //description
    self.count = nil;//商品件数
    self.score = nil;//赠送积分总计
    self.goodsfee = nil;//商品金额总计
    self.deliverfee = nil;//运费金额
    self.tradeticket = nil;//抵用券
    self.moneyticket = nil;//现金券
    self.total = nil;//应付金额
    
    [super dealloc];
}
@end
