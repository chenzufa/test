//
//  CommitPresentationEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//购物车提交选中的赠品信息

#import <Foundation/Foundation.h>

@interface CommitPresentationEntity : NSObject

@property (nonatomic) int selectcount;//选中的商品件数，含赠品（一个套装算一件）

@property (retain,nonatomic) NSString *goodsfee;//商品总额（包含选取赠品后）
@property (retain,nonatomic) NSString *discount;//优惠金额（包含选取赠品后）
@property (retain,nonatomic) NSString *total;//应付总额（包含选取赠品后）

@property (retain,nonatomic) NSString *presentationinfo;//赠送商品信息（没有赠品信息返回””）
@property (retain,nonatomic) NSArray *discountinfo;//stringArray	优惠信息列表

@property (nonatomic) int presentationcount;
@end
