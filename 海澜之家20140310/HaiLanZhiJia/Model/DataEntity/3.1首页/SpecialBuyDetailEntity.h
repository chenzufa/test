//
//  SpecialBuyDetailEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//秒杀、团购详情

#import <Foundation/Foundation.h>

@interface SpecialBuyDetailEntity : NSObject

//    paylimit	int	团购或秒杀活动结束的支付时限，单位是分钟
@property (nonatomic) int paylimit;

@property (retain,nonatomic) NSString *shareurl;//商品详情分享地址
@property (retain,nonatomic) NSString *goodsid;//商品id
@property (retain,nonatomic) NSString *goodsname;//商品名称
@property (retain,nonatomic) NSString *goodscode;//商品编码
@property (retain,nonatomic) NSString *originprice;//商品原来价格
@property (retain,nonatomic) NSString *currentprice;//商品团购、秒杀价格

@property (nonatomic) int isstart;//是否已经开始 0：没有开始 1：已经开始
@property (nonatomic) long timeleft;//团购、秒杀活动 开始/结束 剩余时间（取决于活动开始与否）
@property (nonatomic) long timelast;//尚未开始的活动持续时间-单位秒（活动结束时间与活动开始时间的差值，该字段仅对isstart=0有效）
@property (retain,nonatomic) NSArray *size;//商品尺码数组 stringarray

@property (retain,nonatomic) NSArray *sizeandstore;    ///////////尺码库存数组  ljy

//NSDictionary
//(key:value)
//@“color”:	@“商品颜色”
//@"sizeandstore":尺码库存数组
//@“size” :商品尺码数组 stringarray
//@“thumbnailimgs”:	@“与商品颜色对应的缩略图图片数组”stringArray
//@“imgs”:	@“与颜色对应的商品图片”stringArray
@property (retain,nonatomic) NSArray *colorandimgs;//颜色及对应图片对象数组
/*
 {
 “color”:”黑色”,
 “sizeandstore”:[{“size”: “38|165/84A”,
 “store”:1
 }
 {“size”: “38|165/84A”,
 “store”:1
 }
 …..
 ],
 “thumbnailimgs”:[“small1.png”,
 “small2.png”,
 …….
 ],
 “imgs”:[ “1.png”,
 “2.png”,
 ……
 ]
 }
 */

@property (retain,nonatomic) NSString *imgdetail;//商品详情-图文详情展示页面网址
@property (nonatomic) int consults;//售前咨询信息条数
@property (nonatomic) int store;//商品是否有库存：0.没有 1.有

@property (nonatomic) int savestatus;//用户是否收藏：0:没有收藏 1：已经收藏
@end
