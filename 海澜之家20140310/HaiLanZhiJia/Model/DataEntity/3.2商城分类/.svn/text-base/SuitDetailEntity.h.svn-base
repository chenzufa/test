//
//  SuitDetailEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//套装详情

#import <Foundation/Foundation.h>

@interface SuitDetailEntity : NSObject

@property (retain,nonatomic) NSString *originalprice;//原始价格
@property (retain,nonatomic) NSString *discount;//折扣
@property (retain,nonatomic) NSString *suitprice;//套餐价格

@property (retain,nonatomic) NSArray *suits;//套装商品对象数组

@end


@interface SuitEntity : NSObject

@property (retain,nonatomic) NSString *goodsid;//套装商品id
@property (retain,nonatomic) NSString *img;//套装商品图片下载地址
@property (retain,nonatomic) NSString *name;//套装商品名称
@property (retain,nonatomic) NSString *price;//套装商品价格

@property (retain,nonatomic) NSArray *size;//套装商品尺寸数组stringArray
@property (retain,nonatomic) NSArray *color;//套装商品颜色数组stringArray


//NSDictionary
//(key:value)
//colorandsizes	objectArray	颜色尺码数组
//sizeandstore	objectArray	尺码库存数组
//store	int	是否有库存：0.没有 1.有
//size	string	商品尺码
//color	string	商品颜色
@property (retain,nonatomic) NSArray *colorandsizes;//颜色及对应图片对象数组
/*
 {
 “color”:”黑色”,
 “sizeandstore”:[{“size”: “38|165/84A”,
                “store”:1
                }，
                {“size”: “38|165/84A”,
                “store”:1
                }，
                …..
                ],
 },
 */
@end
