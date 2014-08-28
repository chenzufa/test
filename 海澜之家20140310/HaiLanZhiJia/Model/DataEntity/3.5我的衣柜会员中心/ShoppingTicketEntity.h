//
//  ShoppingTicketEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//购物券信息（现金券、抵用券）

#import <Foundation/Foundation.h>

@interface ShoppingTicketEntity : NSObject

@property (retain,nonatomic) NSString *cardnum;//绑定的卡号
@property (retain,nonatomic) NSString *amount;//金额
@property (retain,nonatomic) NSString *usingdate;//使用日期 (返回已使用购物券时使用)
@property (retain,nonatomic) NSString *ordernumber;//订单号(返回已使用购物券时使用)
@property (retain,nonatomic) NSString *expireddate;//有效时间(返回未使用购物券时使用)
@property (retain,nonatomic) NSString *status;//状态(返回未使用购物券时使用)
@property (nonatomic) BOOL isSelected;

@end

@interface ShoppingTicketInfoEntity : NSObject

@property (retain,nonatomic) NSString *rule;//现金券使用规则

//ShoppingTicketEntity
@property (retain,nonatomic) NSArray *ticketlist;//已使用购物券对象数组

@end
