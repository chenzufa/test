//
//  CityEntity.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-6.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityEntity : NSObject<NSCoding>

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSMutableArray *arrDistricts;

@end
