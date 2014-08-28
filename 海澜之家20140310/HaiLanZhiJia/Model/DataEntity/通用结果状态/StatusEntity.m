//
//  StatusEntity.m
//  MeiLiYun
//
//  Created by donson-周响 on 13-10-8.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "StatusEntity.h"

@implementation StatusEntity
- (void)dealloc
{
    //3.6.2 提交订单CommitOrder
    self.failreason = nil;//如果订单生成出错，出错信息（response=2有效，为response=1时，返回””）
    self.ordernumber = nil;//提交成功产生的订单号（response=1有效）
    self.orderfee = nil;//订单对应费用
    
    self.deliverfee = nil;
    self.uppaytn = nil;
    
    [super dealloc];
}
@end
