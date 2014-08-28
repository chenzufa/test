//
//  MyConponVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyConponVC.h"
#import "MyConpnCell.h"
#import "CashConponVC.h"
#import "VouchersConponVC.h"
@interface MyConponVC ()

@end

@implementation MyConponVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"我的优惠券"];
    
    UITableView *cpTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT, 300, MainViewHeight - TITLEHEIGHT - 20)];
    [cpTableView setShowsVerticalScrollIndicator:NO];
    cpTableView.delegate = self;
    cpTableView.dataSource = self;
    [cpTableView setBackgroundColor:[UIColor clearColor]];
    [cpTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cpTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:cpTableView];
    [cpTableView release];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    MyConpnCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[MyConpnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    switch (indexPath.section) {
        case 0:
            [cell setLabelText:@"现金券"];
            break;
        case 1:
            [cell setLabelText:@"抵用券"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 10)]autorelease];
    return view;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            CashConponVC *cashVC = [[CashConponVC alloc]init];
            [self pushViewController:cashVC];
            [cashVC release];
        }
            break;
        case 1:
        {
            VouchersConponVC *vouchersVC = [[VouchersConponVC alloc]init];
            [self pushViewController:vouchersVC];
            [vouchersVC release];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
