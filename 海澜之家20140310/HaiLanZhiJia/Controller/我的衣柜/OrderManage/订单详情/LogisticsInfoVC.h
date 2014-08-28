//
//  LogisticsInfoVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "DSRequest.h"
@interface LogisticsInfoVC : CommonViewController<UITableViewDataSource,UITableViewDelegate,DSRequestDelegate>

@property (nonatomic, retain) DSRequest *requestOjb;
@property (nonatomic, retain) NSString *orderNum;
@end
