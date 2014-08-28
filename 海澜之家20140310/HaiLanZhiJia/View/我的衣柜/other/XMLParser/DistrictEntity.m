//
//  DistrictEntity.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-6.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "DistrictEntity.h"

@implementation DistrictEntity
- (void)dealloc
{
    self.districtId = nil;
    self.districtName = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.districtId = [aDecoder decodeObjectForKey:@"districtId"];
        self.districtName = [aDecoder decodeObjectForKey:@"districtName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.districtId forKey:@"districtId"];
    [aCoder encodeObject:self.districtName forKey:@"districtName"];
}


@end
