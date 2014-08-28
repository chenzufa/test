//
//  AddressEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AddressEntity.h"

@implementation AddressEntity

- (void)dealloc
{
    self.addressid = nil;//地址记录id
    self.name = nil;//收货人姓名
    self.tel = nil;//收货人电话
    self.area = nil;//所在地区
    self.address = nil;//详细地址
    self.mailcode = nil;
    
    [super dealloc];
}
@end
