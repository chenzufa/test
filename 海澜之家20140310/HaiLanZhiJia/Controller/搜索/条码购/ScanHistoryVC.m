//
//  ScanHistoryVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ScanHistoryVC.h"
#import "ScanHistroyCell.h"
#import "UITableView+RemindNoData.h"
#import "ShangPingDetailVC.h"
@interface ScanHistoryVC ()

@end

@implementation ScanHistoryVC
{
    NSMutableArray *arrGoods;
    UITableView *shTableView;
}
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
    arrGoods = nil;
    [shTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitleString:@"扫描历史"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"清空"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:ScanHistory];
    arrGoods = [[NSMutableArray alloc]init];
    [arrGoods addObjectsFromArray:array];
    
    shTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], MainViewWidth, MainViewHeight - [self getTitleBarHeight] - 20)];
    [shTableView setShowsVerticalScrollIndicator:NO];
    shTableView.delegate = self;
    shTableView.dataSource = self;
    shTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:shTableView];
    
    if (arrGoods.count == 0) {
        [shTableView addRemindWhenNoData:@"您的扫描历史为空"];
    }
}

- (void)leftAction
{
    [super leftAction];
    if ([self.backDelegate respondsToSelector:@selector(scanHistroyVCDisMissed:)]) {
        [self.backDelegate scanHistroyVCDisMissed:self];
    }
}

- (void)myRightButtonAction:(UIButton *)button
{
    WCAlertView *alert = [[WCAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要清空所有扫描记录吗？" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"是的", nil];
    [alert setStyle:WCAlertViewStyleWhite];
    [alert show];
    [alert release];
}

#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:ScanHistory];
        [arrGoods removeAllObjects];
        [shTableView reloadData];
        [shTableView addRemindWhenNoData:@"您的扫描历史为空"];
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    ScanHistroyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[ScanHistroyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    NSMutableDictionary *dicOne = [arrGoods objectAtIndex:indexPath.row];
//    NSString *goodsID = [dicOne objectForKey:@"goodsid"];
    NSString *imgdetail = [dicOne objectForKey:@"imgdetail"];
    NSString *time = [dicOne objectForKey:@"strTime"];
    NSString *name = [dicOne objectForKey:@"goodsname"];
    [cell setImgViewHead:imgdetail labTitle:name labTime:time];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dicOne = [arrGoods objectAtIndex:indexPath.row];
    NSString *goodsID = [dicOne objectForKey:@"goodsid"];
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = goodsID;
    [self pushViewController:vc];
    [vc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
