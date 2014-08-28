//
//  BrowseHistoryVC.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "BrowseHistoryVC.h"
#import "RecentBrowseCell.h"
#import "ShangPingDetailVC.h"
#import "UITableView+RemindNoData.h"
@interface BrowseHistoryVC ()


@end

@implementation BrowseHistoryVC
@synthesize data = _data;
@synthesize tableView = _tableView;

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
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"清空"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self getArrayData];
    
    [self setTitleString:@"最近浏览"];
//    [self creatRightButton];    
    [self initTableView];
}

- (void)getArrayData{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *file = [docDir stringByAppendingPathComponent:@"SpDetailEntity.plist"];
    _data = [[NSMutableArray alloc] initWithContentsOfFile:file];
}

- (void)dealloc{
    [_data release]; _data = nil;
    [_tableView release];_tableView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init UI
////导航栏右边按钮
//- (void)creatRightButton
//{
//    UIButton* myRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [myRightButton setFrame:CGRectMake(269, 7, 44, 30)];
//    [myRightButton.titleLabel setFont:SetFontSize(FontSize15)];
//    [myRightButton setTitle:@"清空" forState:UIControlStateNormal];
//    [myRightButton setTitleColor:RGBCOLOR(236, 224, 224) forState:UIControlStateNormal];
//    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
//    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button1_press.png"] forState:UIControlStateHighlighted];
//    [myRightButton addTarget:self action:@selector(myRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleBar addSubview:myRightButton];
//}
- (void)myRightButtonAction:(UIButton *)button
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清空最近浏览", nil];
    [sheet showInView:self.titleBar];
    [sheet release];
}

#pragma mark sheetDelegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_data removeAllObjects];
        [_tableView reloadData];
        
        if (_data.count == 0) {
            [_tableView addRemindWhenNoData:@"您还没有浏览记录"];
        }else [_tableView hiddenReminndWhenNoDatainSupView];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(
                                                                NSDocumentDirectory,
                                                                NSUserDomainMask, YES) objectAtIndex: 0];
        NSString *file = [docDir stringByAppendingPathComponent:@"SpDetailEntity.plist"];
        
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];

    }
}

//初始化列表
- (void)initTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self getTitleBarHeight], 320,MainViewHeight - TITLEHEIGHT-20) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[[UIView alloc] init]autorelease];
        [self.view addSubview:_tableView];
        if (_data.count == 0) {
            [_tableView addRemindWhenNoData:@"您还没有浏览记录"];
        }else [_tableView hiddenReminndWhenNoDatainSupView];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifield = @"cell";
    RecentBrowseCell* cell = [tableView dequeueReusableCellWithIdentifier:identifield];
    if (cell == nil) {
        cell = [[[RecentBrowseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifield] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.imgView setImageWithURL:[NSURL URLWithString:[[_data objectAtIndex:indexPath.row] objectForKey:@"image"]] forState:UIControlStateNormal placeholderImage:nil];
//    [cell.imgView setImageWithURL:[NSURL URLWithString:[[_data objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"列表小图.png"]];
    if ([[[_data objectAtIndex:indexPath.row] objectForKey:@"name"] isKindOfClass:[NSString class]]) {
        cell.name.text = [[_data objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    if ([[[_data objectAtIndex:indexPath.row] objectForKey:@"price"] isKindOfClass:[NSString class]]) {
        cell.price.text = [NSString stringWithFormat:@"￥%@",[[_data objectAtIndex:indexPath.row] objectForKey:@"price"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodEntity *oneEnti = [arrMyCollects objectAtIndex:indexPath.row];
    
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = [[_data objectAtIndex:indexPath.row]objectForKey:@"id"];
    [self pushViewController:vc];
    [vc release];
}

@end
