//
//  CommitPresentationEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommitPresentationEntity.h"

@implementation CommitPresentationEntity

- (void)dealloc
{
    self.goodsfee = nil;//商品总额（包含选取赠品后）
    self.discount = nil;//优惠金额（包含选取赠品后）
    self.total = nil;//应付总额（包含选取赠品后）
    
    self.presentationinfo = nil;//赠送商品信息（没有赠品信息返回””）
    self.discountinfo = nil;//stringArray	优惠信息列表
    
    [super dealloc];
}
@end
