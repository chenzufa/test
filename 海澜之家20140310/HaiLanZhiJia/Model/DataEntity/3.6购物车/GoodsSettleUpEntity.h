//
//  GoodsSettleUpEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//商品结算

#import <Foundation/Foundation.h>
#import "AddressEntity.h"
#import "PayTypeEntity.h"
#import "InvoceEntity.h"
#import "DeliverEntity.h"

@interface GoodsSettleUpEntity : NSObject

@property (nonatomic) int response;//商品结算提交状态：1.成功 2.失败
@property (nonatomic) int selectcount;//结算商品件数
@property (retain,nonatomic) NSString *score;//赠送积分总计
@property (retain,nonatomic) NSString *goodsfee;//商品金额总计
@property (retain,nonatomic) NSString *deliverfee;//运费金额
@property (retain,nonatomic) NSString *total;//应付总额
@property (retain,nonatomic) NSString *diYongFee;// 抵用
@property (retain,nonatomic) NSString *xianJinFee;// 现金
@property (retain,nonatomic) NSString *failmsg;//response=2的提示信息

//NSArray GoodEntity
@property (retain,nonatomic) NSArray *goodslist;//购物车中的商品列表
@property (nonatomic,retain) AddressEntity *addressE;
@property (nonatomic,retain) PayTypeEntity *paytypeE;
@property (nonatomic,retain) DeliverEntity *deliverE;
@property (nonatomic,retain) NSString *note;
@property (nonatomic,retain) InvoceEntity *billE;
@property (retain,nonatomic) NSArray *moneyTicketList;//订单的现金券
@property (retain,nonatomic) NSArray *tradeTicketList;//订单的抵用券

@end
