//
//  SpecialListEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SpecialListEntity.h"

@implementation SpecialListEntity

- (void)dealloc
{
    self.title = nil;//
    self.rule = nil;//活动规则描述
    self.portalimg = nil;//活动宣传图片下载地址
    
    //GoodEntity
    self.goodslist = nil;//商品列表对象数组
    
    [super dealloc];
}
@end
