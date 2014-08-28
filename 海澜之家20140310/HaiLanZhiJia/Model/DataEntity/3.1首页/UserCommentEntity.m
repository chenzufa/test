//
//  UserCommentEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "UserCommentEntity.h"

@implementation UserCommentEntity

- (void)dealloc
{
    self.username = nil;//评论用户姓名
    self.comment = nil;//评论内容
    self.date = nil;//评论日期
    self.csr = nil;//客服人员回复（customer service response）
    
    [super dealloc];
}
@end

@implementation UserCommentsEntity

- (void)dealloc
{
    self.usercomments = nil;
    
    [super dealloc];
}

@end
