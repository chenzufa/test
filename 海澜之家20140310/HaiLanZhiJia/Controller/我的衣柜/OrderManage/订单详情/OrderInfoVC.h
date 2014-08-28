//
//  OrderInfoVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"

@interface OrderInfoVC : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) OrderDetailEntity *entiOrderDetail;

@end
