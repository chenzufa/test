//
//  CityEntity.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-6.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CityEntity.h"

@implementation CityEntity

- (void)dealloc
{
    self.cityName = nil;
    self.cityId = nil;
    self.arrDistricts = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.arrDistricts = [aDecoder decodeObjectForKey:@"arrDistricts"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.arrDistricts forKey:@"arrDistricts"];
}

@end
