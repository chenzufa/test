//
//  StartupADEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//开机启动广告 

#import <Foundation/Foundation.h>
#import "FocusInfoEntity.h"

@interface StartupADEntity : NSObject

@property (nonatomic) int havead;//是否有开机广告：0.没有 1.有

@property (retain,nonatomic) FocusInfoEntity *detail;//开机广告详情

@end
