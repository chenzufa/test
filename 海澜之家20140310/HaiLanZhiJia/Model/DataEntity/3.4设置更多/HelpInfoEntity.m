//
//  HelpInfoEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "HelpInfoEntity.h"

@implementation HelpInfoEntity

- (void)dealloc
{
    self.servicetel = nil;//客服热线
    
    //HelpEntity
    self.helplist = nil;//帮助列表对象数组
    self.jointel = nil;//stringArray	加盟热线对象数组
    
    [super dealloc];
}
@end


@implementation HelpEntity

- (void)dealloc
{
    self.title = nil;//帮助标题
    self.detail = nil;//帮助详情内容
    
    [super dealloc];
}

@end