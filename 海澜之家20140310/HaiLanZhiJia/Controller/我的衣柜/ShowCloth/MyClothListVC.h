//
//  MyClothListVC.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "DSRequest.h"
#import "PullTableView.h"
#import "MySegMentControl.h"

@interface MyClothListVC : CommonViewController<DSRequestDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,MYSegMentControlDelegate>

@property(nonatomic , retain) PullTableView* tableView1; //未晒单
@property(nonatomic , retain) PullTableView* tableView2; //已晒单
@property(nonatomic , retain) NSMutableArray* data1;   //未晒单数据
@property(nonatomic , retain) NSMutableArray* data2;   //已晒单数据

@property(nonatomic , retain) DSRequest* request;

@end
