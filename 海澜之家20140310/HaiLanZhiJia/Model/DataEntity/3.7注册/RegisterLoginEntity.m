//
//  RegisterLoginEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "RegisterLoginEntity.h"

@implementation RegisterLoginEntity

- (void)dealloc
{
    self.failmsg = nil;
    self.userid = nil;//用户id
    self.token = nil;//服务端返回的token（用于登录用户访问数据接口）
    
    [super dealloc];
}

@end
