//
//  SpecEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SpecEntity.h"

@implementation SpecEntity

- (void)dealloc
{
    self.specname = nil;//一级限制条件名称
    self.specid = nil;//一级限制条件id
    
    //MallCategoryEntity
    self.subspec = nil;//子限制条件对象数组
    
    [super dealloc];
}

@end
