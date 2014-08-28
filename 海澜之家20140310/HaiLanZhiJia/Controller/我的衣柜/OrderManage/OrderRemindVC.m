//
//  OrderRemindVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderRemindVC.h"
#import "OrderRemindCell.h"
#import "UITableView+RemindNoData.h"
@interface OrderRemindVC ()

@end

@implementation OrderRemindVC
{
    UITableView *orTableView;
    int deleIndex;      // 要删除的订单提醒下标
}

enum RequestType
{
    RequestTypeGetRemindedList,
    RequestTypeDeleReminded
};

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
    self.orList = nil;
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    
    [orTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"订单提醒"];
    
//    [self createMyButtonWithTitleAndImage];
//    [self setMyRightButtonTitle:@"tiaotiao"];
//    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
  
    orTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight - TITLEHEIGHT - 20)];
    [orTableView setShowsVerticalScrollIndicator:NO];
    orTableView.delegate = self;
    orTableView.dataSource = self;
    orTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:orTableView];
    
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
//    [self request];
}

//- (void)myRightButtonAction:(UIButton *)button
//{
//    [self popToRoot];
//    [[NSNotificationCenter defaultCenter]postNotificationName:kSPDetailShopCarClickedNotification object:nil];
//}

- (void)afterDelay
{
    [self request:RequestTypeGetRemindedList deleRemindID:nil];
}

- (void)request:(enum RequestType)requestType deleRemindID:(NSArray *)arrRemindId
{
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    switch (requestType) {
        case RequestTypeGetRemindedList:
            [orTableView addHUDActivityView:Loading];  //提示 加载中
            [self.requestOjb requestDataWithInterface:OrderRemindedList param:[self OrderRemindedListParam] tag:RequestTypeGetRemindedList];
            break;
        case RequestTypeDeleReminded:
            [self.view.window addHUDActivityView:@"正在删除"];  //提示
            [self.requestOjb requestDataWithInterface:DelRemind param:[self DelRemindParam:arrRemindId] tag:RequestTypeDeleReminded];
            break;
            
        default:
            break;
    }
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    
    switch (tag) {
        case RequestTypeGetRemindedList:
        {
            [orTableView removeHUDActivityView];        //加载成功  停止转圈
            self.orList = (NSMutableArray *)dataObj;
            if (self.orList.count == 0) {
                [orTableView addRemindWhenNoData:@"您没有订单提醒"];
            }else [orTableView hiddenReminndWhenNoDatainSupView];
            
            [orTableView reloadData];
            
            
            
            // 获取提醒列表成功后发出通知  通知我的衣柜处刷新红点提醒
            [[NSNotificationCenter defaultCenter]postNotificationName:OrderRedRemind object:nil];
        }
            break;
        case RequestTypeDeleReminded:
        {
            [self.view.window removeHUDActivityView];        //加载成功  停止转圈
            StatusEntity *entiStatu = (StatusEntity *)dataObj;
            if (entiStatu.response == 1) {
                [self.orList removeObjectAtIndex:deleIndex];
                [orTableView reloadData];
//                [self request:RequestTypeGetRemindedList deleRemindID:nil];
            }else [orTableView addHUDLabelView:@"删除失败" Image:nil afterDelay:2];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [orTableView removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [orTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    OrderRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[OrderRemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    OrderRemindEntity *entiOrderRemind = [self.orList objectAtIndex:indexPath.row];
    [cell setLabtime:entiOrderRemind.date LabMessage:entiOrderRemind.content];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderRemindEntity *entiOrderRemind = [self.orList objectAtIndex:indexPath.row];
    CGSize labelSize;
    labelSize = [entiOrderRemind.content sizeWithFont:SetFontSize(FontSize15) constrainedToSize:CGSizeMake(300, 450) lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 42;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleIndex = indexPath.row;
    OrderRemindEntity *entiOrderRemind = [self.orList objectAtIndex:indexPath.row];
    [self request:RequestTypeDeleReminded deleRemindID:[NSArray arrayWithObject:entiOrderRemind.remindid]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
