//
//  OrderRemindEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//订单提醒

#import <Foundation/Foundation.h>

@interface OrderRemindEntity : NSObject

@property (retain,nonatomic) NSString *remindid;
@property (retain,nonatomic) NSString *content;//订单提醒内容
@property (retain,nonatomic) NSString *date;//订单产生日期

@end
