//
//  BrowseHistoryVC.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"

@interface BrowseHistoryVC : CommonViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic , retain)UITableView* tableView;
@property (nonatomic , retain)NSMutableArray* data;


@end
