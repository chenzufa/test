//
//  StatusEntity.h
//  MeiLiYun
//
//  Created by donson-周响 on 13-10-8.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//  通用返回结果状态

#import <Foundation/Foundation.h>

@interface StatusEntity : NSObject
@property (nonatomic,assign) int response;//1表示成功，2表示失败  3.旧密码错误（3.7.6 修改密码） 

//3.5.13 绑定购物券（现金券、抵用券）
@property (nonatomic,assign) NSString *failmsg;//绑定失败原因

//3.6.2 提交订单CommitOrder
@property (retain,nonatomic) NSString *failreason;//如果订单生成出错，出错信息（response=2有效，为response=1时，返回””）
@property (retain,nonatomic) NSString *ordernumber;//提交成功产生的订单号（response=1有效）
@property (retain,nonatomic) NSString *orderfee;//订单对应费用

//3.6.3 添加到购物车（不在购物车页面时添加物品）AddToShoppingCar
@property (nonatomic) int totalcount;//提交购物车后，购物车中的商品件数（选中、未选中之和；一个套装算一件）


@property (nonatomic,assign) int hasneworder;//是否有新订单：0没有 1有
@property (nonatomic,assign) int hasneworderremind;//是否有新订单提醒：0没有 1有

//接口3.6.15
@property (retain,nonatomic) NSString *deliverfee;

//接口3.6.16
@property (retain,nonatomic) NSString *uppaytn;//银联交易流水号

@end
