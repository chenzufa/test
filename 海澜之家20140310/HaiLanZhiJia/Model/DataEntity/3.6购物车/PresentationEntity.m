//
//  PresentationEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "PresentationEntity.h"

@implementation PresentationEntity

- (void)dealloc
{
    self.goodsid = nil;//商品id
    self.goodsimg = nil;//商品预览图片下载地址
    self.goodsname = nil;//商品名称
    
    self.sizearray = nil;//赠品尺码列表
    self.colorarray = nil;//stringArray	赠品颜色列表
    
    self.colorandsizes = nil;
    
    self.selectsize = nil;//用户选择的尺码
    self.selectcolor = nil;//用户选择的颜色
    
    self.specialid = nil;   //活动对应的id
    
    [super dealloc];
}

@end


@implementation PresentationListEntity 

- (void)dealloc
{
    self.presentationinfo = nil;//活动信息（活动名称）
    self.specialid = nil;//活动对应的id
    
    //PresentationEntity
    self.goodsinfo = nil;//某一活动下的可选赠品列表
    
    [super dealloc];
}

@end