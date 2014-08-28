//
//  XianJinQuanVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MySegMentControl.h"
#import "BangdingView.h"
#import "PullTableView.h"
#import "DSRequest.h"
#import "ConponScanBangdingVC.h"

#import "SubviewInfoDelegate.h"

@interface XianJinQuanVC : CommonViewController<UITableViewDelegate,UITableViewDataSource,MYSegMentControlDelegate,BangdingViewDelegate,PullTableViewDelegate,DSRequestDelegate>

@property (nonatomic, retain) DSRequest *requestOjb;

@property (nonatomic,assign) id<SubviewInfoDelegate> delegate;
@property (nonatomic,retain) NSArray *selectedArray;
@property (nonatomic)int orderType; //1.购物车普通商品2.团购 3.秒杀
@end
