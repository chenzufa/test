//
//  ShoppingTicketEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//购物券信息（现金券、抵用券）

#import "ShoppingTicketEntity.h"

@implementation ShoppingTicketEntity
- (void)dealloc
{
    self.cardnum = nil;//绑定的卡号
    self.amount = nil;//金额
    self.usingdate = nil;//使用日期 (返回已使用购物券时使用)
    self.ordernumber = nil;//订单号(返回已使用购物券时使用)
    self.expireddate = nil;//有效时间(返回未使用购物券时使用)
    self.status = nil;//状态(返回未使用购物券时使用)
    
    [super dealloc];
}
@end

@implementation ShoppingTicketInfoEntity

- (void)dealloc
{
    self.rule = nil;//现金券使用规则
    
    //ShoppingTicketEntity
    self.ticketlist = nil;//已使用购物券对象数组
    
    [super dealloc];
}
@end