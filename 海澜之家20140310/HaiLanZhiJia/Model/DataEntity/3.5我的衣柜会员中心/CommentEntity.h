//
//  CommentEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//评论

#import <Foundation/Foundation.h>
#import "GoodEntity.h"

@interface CommentEntity : NSObject

//@property (retain,nonatomic) GoodEntity *goodEntity;//商品详情
@property (retain,nonatomic) NSString *ordergoodsid;//订单商品id（用于描述某一个订单下面的商品的id）
@property (retain,nonatomic) NSString *goodsid;//商品id
@property (retain,nonatomic) NSString *goodsimg;//商品预览图片下载地址
@property (retain,nonatomic) NSString *goodsname;//商品名称
@property (retain,nonatomic) NSString *sizeandcolor;//商品尺寸和颜色描述

//
@property (retain,nonatomic) NSString *buydate;//购买时间
@property (nonatomic) int score;//评分（返回的数据是已评论列表有效）

@property (retain,nonatomic) NSString *comment;//评价内容（返回的数据是已评论列表有效）
@property (retain,nonatomic) NSString *ordernumber;//订单号

@end
