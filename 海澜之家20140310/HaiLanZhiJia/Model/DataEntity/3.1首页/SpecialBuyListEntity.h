//
//  SpecialBuyListEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//  秒杀、团购专题列表

#import <Foundation/Foundation.h>

@interface SpecialBuyListEntity : NSObject

@property (retain,nonatomic) NSString *rule;//规则描述

//SpecialBuyEntity
@property (retain,nonatomic) NSArray *goodslist;//商品列表对象数组

@end

@interface SpecialBuyEntity : NSObject

@property (retain,nonatomic) NSString *goodsid;//商品id
@property (retain,nonatomic) NSString *goodsimg;//商品预览图片下载地址

@property (retain,nonatomic) NSString *goodsname;//商品名称
@property (retain,nonatomic) NSString *originprice;//商品原始价格
@property (retain,nonatomic) NSString *currentprice;//商品团购、秒杀价

@property (nonatomic) long timeleft;//团购、秒杀 结束/开始 剩余时间
@property (nonatomic) long timelast;//尚未开始的活动持续时间-单位秒（活动结束时间与活动开始时间的差值，该字段仅对isstart=0有效）
@property (retain,nonatomic) NSDate *timeWhenReceive; //数据返回时的当前时间

@property (nonatomic) int isstart;//是否已经开始 0：没有开始 1：已经开始
@property (nonatomic) int store;//商品是否有库存：0.没有 1.有
@property (nonatomic) int joincount;//参与人数（该字段只对团购有效）

@end
