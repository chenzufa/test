//
//  UITableView+RemindNoData.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-18.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (RemindNoData)
- (void)addRemindWhenNoData:(NSString *)strRemind;
- (void)hiddenReminndWhenNoDatainSupView;
@end
