//
//  PresentationEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//购物车获取赠品信息

#import <Foundation/Foundation.h>

@interface PresentationEntity : NSObject

@property (retain,nonatomic) NSString *goodsid;//商品id
@property (retain,nonatomic) NSString *goodsimg;//商品预览图片下载地址
@property (retain,nonatomic) NSString *goodsname;//商品名称

@property (retain,nonatomic) NSArray *sizearray;//赠品尺码列表
@property (retain,nonatomic) NSArray *colorarray;//stringArray	赠品颜色列表

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

@property (retain,nonatomic) NSString *selectsize;//用户选择的尺码
@property (retain,nonatomic) NSString *selectcolor;//用户选择的颜色

@property (nonatomic) int isselect;//该赠品是否被选择：0.没选中 1.选中

@property (retain,nonatomic) NSString *specialid;//活动对应的id

@end

@interface PresentationListEntity : NSObject

@property (retain,nonatomic) NSString *presentationinfo;//活动信息（活动名称）
@property (retain,nonatomic) NSString *specialid;//活动对应的id

//PresentationEntity
@property (retain,nonatomic) NSArray *goodsinfo;//某一活动下的可选赠品列表

@end
