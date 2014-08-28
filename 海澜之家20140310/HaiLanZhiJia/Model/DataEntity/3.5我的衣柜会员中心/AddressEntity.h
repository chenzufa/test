//
//  AddressEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//送货地址

#import <Foundation/Foundation.h>

@interface AddressEntity : NSObject

@property (retain,nonatomic) NSString *addressid;//地址记录id
@property (retain,nonatomic) NSString *name;//收货人姓名
@property (retain,nonatomic) NSString *tel;//收货人电话
@property (retain,nonatomic) NSString *area;//所在地区
@property (retain,nonatomic) NSString *address;//详细地址
@property (retain,nonatomic) NSString *mailcode;
@property (nonatomic) int isdefault;//是否默认收货地址 0：不是 1：是

@end
