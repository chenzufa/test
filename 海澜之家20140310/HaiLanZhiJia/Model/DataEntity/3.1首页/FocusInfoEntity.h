//
//  FocusInfoEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//  焦点资讯

#import <Foundation/Foundation.h>

@interface FocusInfoEntity : NSObject

@property (retain,nonatomic) NSString *adid;//广告id,用于接口3.1.10广告点击统计接口传参

@property (retain,nonatomic) NSString *imgurl;//焦点图图片url地址
@property (retain,nonatomic) NSString *goodsid;//商品id(type为2时有值，其他类型时，值为空)
@property (retain,nonatomic) NSString *weburl;//网址（type为3时有值，其他类型时，值为空）
@property (retain,nonatomic) NSString *specialid;//专题id(type为1时有值，其他类型时，值为空)

@property (nonatomic) int type;//焦点图类型：1.活动专题 2.商品 3.网址
@property (nonatomic) int specialtype;//专题类型1.宫格 2.瀑布流 3.单图 4.秒杀 5.团购(type为1时有值，其他类型时，值为空)

@property (nonatomic) int duration;//广告持续的时间,单位秒
@end
