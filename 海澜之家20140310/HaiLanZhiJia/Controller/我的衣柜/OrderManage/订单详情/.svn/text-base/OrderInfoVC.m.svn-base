//
//  OrderInfoVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderInfoVC.h"
#import "OrderInfoCell.h"
@interface OrderInfoVC ()

@end

@implementation OrderInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.entiOrderDetail = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"订单信息"];
    
    UITableView *oiTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT + 10, MainViewWidth - 20, MainViewHeight - TITLEHEIGHT - 20)];
    [oiTableView setShowsVerticalScrollIndicator:NO];
    oiTableView.delegate = self;
    oiTableView.dataSource = self;
    [oiTableView setBackgroundColor:[UIColor clearColor]];
    oiTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [oiTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:oiTableView];
    [oiTableView setScrollEnabled:NO];
    [oiTableView release];
    
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[OrderInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (indexPath.row == 0) {
        [cell setBackgroundViewWithImage:@"bg_list2_up.png"];
    }else if(indexPath.row == 6) {
        [cell setBackgroundViewWithImage:@"bg_list2_down.png"];
    }else {
        [cell setBackgroundViewWithImage:@"bg_list2_middle.png"];
    }
    
    switch (indexPath.row) {
        case 0:
            if ([self.entiOrderDetail.ordernumber isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"订单号" labRight:self.entiOrderDetail.ordernumber];
            }else [cell setlabLeft:@"订单号" labRight:@""];
            
            break;
        case 1:
            if ([self.entiOrderDetail.orderstatus isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"订单状态" labRight:self.entiOrderDetail.orderstatus];
            }else [cell setlabLeft:@"订单状态" labRight:@""];
            break;
        case 2:
            if ([self.entiOrderDetail.deliverby isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"送货方式" labRight:self.entiOrderDetail.deliverby];
            }else [cell setlabLeft:@"送货方式" labRight:@""];
            break;
        case 3:
            if ([self.entiOrderDetail.payby isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"支付方式" labRight:self.entiOrderDetail.payby];
            }else [cell setlabLeft:@"支付方式" labRight:@""];
            break;
        case 4:
            if ([self.entiOrderDetail.orderdate isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"订单生成时间" labRight:self.entiOrderDetail.orderdate];
            }else [cell setlabLeft:@"订单生成时间" labRight:@""];
            break;
        case 5:
            if ([self.entiOrderDetail.deliverstatus isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"发货时间" labRight:self.entiOrderDetail.deliverstatus];
            }else [cell setlabLeft:@"发货时间" labRight:@""];
            break;
        case 6:
            if ([self.entiOrderDetail.needinvoice isKindOfClass:[NSString class]]) {
                [cell setlabLeft:@"是否开发票" labRight:self.entiOrderDetail.needinvoice];
            }else [cell setlabLeft:@"是否开发票" labRight:@""];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
