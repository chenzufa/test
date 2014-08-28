//
//  SpecEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//商品列表筛选条件

#import <Foundation/Foundation.h>

@interface SpecEntity : NSObject

@property (retain,nonatomic) NSString *specname;//一级限制条件名称
@property (retain,nonatomic) NSString *specid;//一级限制条件id

//MallCategoryEntity
@property (retain,nonatomic) NSArray *subspec;//子限制条件对象数组

@end
