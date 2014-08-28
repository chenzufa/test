//
//  RegisterLoginEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//注册登录

#import <Foundation/Foundation.h>

@interface RegisterLoginEntity : NSObject

@property (nonatomic,assign) int response;//提交状态 1：提交成功 2：提交失败 3：此用户名已注册（3.7.1 注册）

@property (retain,nonatomic) NSString *failmsg;//failmsg

@property (retain,nonatomic) NSString *userid;//用户id
@property (retain,nonatomic) NSString *token;//服务端返回的token（用于登录用户访问数据接口）

@property (nonatomic,assign) int totalcount;//提交购物车后，购物车中的商品件数（选中、未选中之和；一个套装算一件）

@end
