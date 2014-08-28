//
//  UserCommentEntity.h
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//用户对商品的评论 

#import <Foundation/Foundation.h>

@interface UserCommentsEntity : NSObject

@property (nonatomic) int count;//用户评论数目

//UserCommentEntity
@property (retain,nonatomic) NSArray *usercomments;//用户评论对象数组

@end

@interface UserCommentEntity : NSObject

@property int score; //综合评分
@property (retain,nonatomic) NSString *username;//评论用户姓名
@property (retain,nonatomic) NSString *comment;//评论内容
@property (retain,nonatomic) NSString *date;//评论日期
@property (retain,nonatomic) NSString *csr;//客服人员回复（customer service response）

@property (retain,nonatomic) NSArray *thumbnailimg;//stringArray	（评论中）晒单商品缩率图下载地址-没有图片返回空数组
@property (retain,nonatomic) NSArray *imgarray;//stringArray	评论中）晒单商品大图下载地址-没有图片返回空数组
@end
