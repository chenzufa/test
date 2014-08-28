//
//  ShowOrderEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShowOrderEntity.h"

@implementation ShowOrderEntity

- (void)dealloc
{
    
    self.goodsid = nil;
    self.username = nil;//用户名称
    self.title = nil;//晒单标题
    self.date = nil;//晒单日期
    self.content = nil;//晒单内容
    self.thumbnailimg = nil;//晒单列表页面缩略图
    
    self.imgarray = nil;//晒单大图片数组
    
    [super dealloc];
}
@end
