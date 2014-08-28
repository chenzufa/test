//
//  UITableView+RemindNoData.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-18.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "UITableView+RemindNoData.h"

@implementation UITableView (RemindNoData)

- (void)addRemindWhenNoData:(NSString *)strRemind      ////////////////用于提示没有数据的时候
{
    
    UILabel *labRemindNoData = (UILabel *)[self viewWithTag:999];
    if (!labRemindNoData) {
        labRemindNoData= [[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.frame.size.width - 40, 30)];
        [labRemindNoData setNumberOfLines:2];
        [labRemindNoData setFont:SetFontSize(FontSize12)];
        [labRemindNoData setTextColor:ColorFontgray];
        [labRemindNoData setTextAlignment:NSTextAlignmentCenter];
        [labRemindNoData setBackgroundColor:[UIColor clearColor]];
        labRemindNoData.tag = 999;
        [self addSubview:labRemindNoData];
        [labRemindNoData setText:strRemind];
        [labRemindNoData release];
    }
}
- (void)hiddenReminndWhenNoDatainSupView         //隐藏 提示没有数据的时候
{
    [[self viewWithTag:999] removeFromSuperview];
}

@end
