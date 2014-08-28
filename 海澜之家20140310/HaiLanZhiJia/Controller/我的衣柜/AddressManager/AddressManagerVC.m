//
//  AddressManagerVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AddressManagerVC.h"
#import "UITableView+RemindNoData.h"
@interface AddressManagerVC ()

@end

@implementation AddressManagerVC
{
    UITableView *amTableView;
    NSArray *arrAddress;
}
@synthesize delegate;

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
//    self.selectIndexPath = nil;
    self.delegate = nil;
    
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    
    [amTableView release];
    arrAddress = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitleString:@"地址管理"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonImage:@"car_icon_address_add.png" hightImage:@"car_icon_address_add.png"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    
    amTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT, MainViewWidth - 20, MainViewHeight - TITLEHEIGHT - 20)];
    [amTableView setShowsVerticalScrollIndicator:NO];
    amTableView.delegate = self;
    amTableView.dataSource = self;
    amTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [amTableView setBackgroundColor:[UIColor clearColor]];
    [amTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:amTableView];
    
//    [self request];
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
    
}

- (void)afterDelay
{
    [self request];
}

- (void)myRightButtonAction:(UIButton *)button
{
    AddAddressVC *addAddVC = [[AddAddressVC alloc]init];
    addAddVC.backDelegate = self;
    addAddVC.title = @"添加地址";
    [self pushViewController:addAddVC];
    [addAddVC release];
}

- (void)request
{
    [amTableView addHUDActivityView:Loading];  //提示 加载中
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    [self.requestOjb requestDataWithInterface:GetAddressList param:[self GetAddressListParam] tag:1];
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    arrAddress = [(NSArray *)dataObj retain];
    if (arrAddress.count == 0) {
        [amTableView addRemindWhenNoData:@"点击右上角加号添加送货地址"];
    }else {
        [amTableView hiddenReminndWhenNoDatainSupView];
        
    }
    [amTableView reloadData];
    [amTableView removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [amTableView removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [amTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrAddress.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[AddressManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.delegate = self;
    }
    
    AddressEntity *one = [arrAddress objectAtIndex:indexPath.section];
    [cell setlabName:one.name labTel:one.tel labAdd:[NSString stringWithFormat:@"%@ %@",one.area,one.address] row:indexPath.section];
    
    if (one.isdefault == 1) {
        [cell setselectAddress:YES];
    }else [cell setselectAddress:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 10)]autorelease];
    return view;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选择地址，并退出本界面
    
    if ([self.delegate respondsToSelector:@selector(sendFormMessage:Object:)]) {
        [self.delegate sendFormMessage:InfoTypeAddress Object:[arrAddress objectAtIndex:indexPath.section]];
        self.delegate = nil;
        [self popViewController];
    }
    
//    NSLog(@"编辑按钮  row = %i",row);
//    AddAddressVC *addAddVC = [[AddAddressVC alloc]init];
//    addAddVC.backDelegate = self;
//    addAddVC.title = @"修改地址";
//    addAddVC.entiAddress = [arrAddress objectAtIndex:indexPath.section];
//    [self pushViewController:addAddVC];
//    [addAddVC release];
}

#pragma mark AddressManagerDelegate
- (void)addressManagerCell:(AddressManagerCell *)cell clickedEditRow:(NSInteger)row 
{
    NSLog(@"编辑按钮  row = %i",row);
    AddAddressVC *addAddVC = [[AddAddressVC alloc]init];
    addAddVC.backDelegate = self;
    addAddVC.title = @"修改地址";
    addAddVC.entiAddress = [arrAddress objectAtIndex:row];
    [self pushViewController:addAddVC];
    [addAddVC release];
}

#pragma mark AddAddressDisMissDelegate
- (void)addAddressVCDisMissedandReloadData  //返回后刷新数据
{
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
