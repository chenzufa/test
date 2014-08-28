//
//  ShowOrderEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//晒单

#import <Foundation/Foundation.h>

@interface ShowOrderEntity : NSObject

@property (retain,nonatomic) NSString *goodsid;//商品id

@property (retain,nonatomic) NSString *username;//用户名称
@property (retain,nonatomic) NSString *title;//晒单标题
@property (retain,nonatomic) NSString *date;//晒单日期
@property (retain,nonatomic) NSString *content;//晒单内容

@property (retain,nonatomic) NSArray *thumbnailimg;//晒单列表页面缩略图数组

@property (retain,nonatomic) NSArray *imgarray;//晒单大图片数组

@end
