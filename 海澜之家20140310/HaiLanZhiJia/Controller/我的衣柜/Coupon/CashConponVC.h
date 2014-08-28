//
//  CashConponVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MySegMentControl.h"
#import "BangdingView.h"
#import "DSRequest.h"
#import "PullTableView.h"
@interface CashConponVC : CommonViewController<UITableViewDelegate,UITableViewDataSource,MYSegMentControlDelegate,BangdingViewDelegate,DSRequestDelegate,PullTableViewDelegate>

@property (nonatomic, retain) DSRequest *requestOjb;

@end
