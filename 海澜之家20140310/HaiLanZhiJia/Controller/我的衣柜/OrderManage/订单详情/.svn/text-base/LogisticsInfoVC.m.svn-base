//
//  LogisticsInfoVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "LogisticsInfoVC.h"
#import "OrderRemindCell.h"
@interface LogisticsInfoVC ()

@end

@implementation LogisticsInfoVC
{
    NSArray *arrDelivers;
    UITableView *orTableView ;
}

- (void)dealloc
{
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    arrDelivers = nil;
    [orTableView release];
    [super dealloc];
}

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
    
    [self setTitleString:@"物流追踪"];
    
    orTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight - TITLEHEIGHT - 20)];
    [orTableView setShowsVerticalScrollIndicator:NO];
    orTableView.delegate = self;
    orTableView.dataSource = self;
    orTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:orTableView];
    
    
    
    [self request];
}

- (void)request
{
    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    [self.requestOjb requestDataWithInterface:GetOrderDeliverDetail param:[self GetOrderDeliverDetailParam:self.orderNum] tag:1];
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    
    arrDelivers = [(NSArray *)dataObj retain];
    [orTableView reloadData];
    
    [self.view removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDelivers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    OrderRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[OrderRemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    OrderDeliverEntity *one = [arrDelivers objectAtIndex:indexPath.row];
    [cell setLabtime:one.date LabMessage:one.content];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDeliverEntity *one = [arrDelivers objectAtIndex:indexPath.row];
    
    CGSize labelSize;
    
    labelSize = [one.content sizeWithFont:SetFontSize(FontSize15) constrainedToSize:CGSizeMake(300, 450) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return labelSize.height + 42;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
