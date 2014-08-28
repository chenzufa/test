//
//  OrderAddressInfoVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderAddressInfoVC.h"
#import "OrderInfoCell.h"
@interface OrderAddressInfoVC ()

@end

@implementation OrderAddressInfoVC

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
    self.arrInfo = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"收货信息"];
    
    UITableView *oiTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT + 10, MainViewWidth - 20, MainViewHeight - TITLEHEIGHT - 20)];
    [oiTableView setShowsVerticalScrollIndicator:NO];
    oiTableView.delegate = self;
    oiTableView.dataSource = self;
    [oiTableView setBackgroundColor:[UIColor clearColor]];
    oiTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:oiTableView];
    [oiTableView setScrollEnabled:NO];
    [oiTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [oiTableView release];
    
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    }else if(indexPath.row == 3) {
        [cell setBackgroundViewWithImage:@"bg_list2_down.png"];
    }else {
        [cell setBackgroundViewWithImage:@"bg_list2_middle.png"];
    }
    
    
    switch (indexPath.row) {
        case 0:
            [cell setlabLeft:@"收件人" labRight:[self.arrInfo objectAtIndex:indexPath.row]];
            break;
        case 1:
            [cell setlabLeft:@"电话" labRight:[self.arrInfo objectAtIndex:indexPath.row]];
            break;
        case 2:
            [cell setlabLeft:@"地址" labRight:[self.arrInfo objectAtIndex:indexPath.row]];
            break;
        case 3:
            [cell setlabLeft:@"送货时间" labRight:[self.arrInfo objectAtIndex:indexPath.row]];
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
