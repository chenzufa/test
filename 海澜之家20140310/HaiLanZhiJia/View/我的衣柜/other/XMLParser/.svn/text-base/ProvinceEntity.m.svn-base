//
//  ProvinceEntity.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-6.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ProvinceEntity.h"

@implementation ProvinceEntity

- (void)dealloc
{
    self.provinceName = nil;
    self.provinceId = nil;
    self.arrCitys = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.provinceName = [aDecoder decodeObjectForKey:@"provinceName"];
        self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
        self.arrCitys = [aDecoder decodeObjectForKey:@"arrCitys"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.provinceName forKey:@"provinceName"];
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
    [aCoder encodeObject:self.arrCitys forKey:@"arrCitys"];
}

@end
