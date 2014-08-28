//
//  HandInputVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "HandInputVC.h"

@interface HandInputVC ()

@end

@implementation HandInputVC
{
    UITextField *textFieldInput;
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
    [self setTitleString:@"手动输入"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"完成"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self initUI];
}

- (void)myRightButtonAction:(UIButton *)button
{
    [textFieldInput resignFirstResponder];
    if (textFieldInput.text.length > 0) {
        
        [self request:[NSString stringWithFormat:@"BAR_%@",textFieldInput.text]];
    }else {
        WCAlertView *alert = [[WCAlertView alloc]initWithTitle:nil message:@"请先输入条码" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert setStyle:WCAlertViewStyleWhite];
        [alert show];
        [alert release];
    }
    
}

- (void)request:(NSString *)strCode
{
    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    DSRequest *request = [[DSRequest alloc]init];
    self.requestOjb = request;
    request.delegate = self;
    [request requestDataWithInterface:GetBarcodeSearchResult param:[self GetBarcodeSearchResultParam:strCode] tag:1];
    [request release];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
//    dataObj = nil;
    if (dataObj == nil) {
        WCAlertView *alert = [[WCAlertView alloc]initWithTitle:@"扫描结果" message:@"没有找到该商品，请确认您输入的条码是否有误" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert setStyle:WCAlertViewStyleWhite];
        [alert show];
        [alert release];
    }else {
        GoodDetailEntity *entiGoodDetail = (GoodDetailEntity *)dataObj;
        
        ShangPingDetailVC *goodsDetailVC = [[ShangPingDetailVC alloc]init];
        goodsDetailVC.spDetailObject = entiGoodDetail;
        [goodsDetailVC setComeFromType:ComeFromTiaoMa];
        [self pushViewController:goodsDetailVC];
        [goodsDetailVC release];
    }
    
    [self.view removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark WCAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [textFieldInput becomeFirstResponder];
}

- (void)initUI
{
    UIImageView *imgViewCode = [[UIImageView alloc]initWithImage:GetImage(@"search_icon_code.png")];
    [imgViewCode setFrame:CGRectMake(88, 78 - 20, imgViewCode.image.size.width, imgViewCode.image.size.height)];
    [self.view addSubview:imgViewCode];
    
    UIImageView *imgViewBackGround = [[UIImageView alloc]initWithImage:GetImage(@"bg_in put.png")];
    [imgViewBackGround setFrame:CGRectMake(10, 165 - 20, imgViewBackGround.image.size.width, imgViewBackGround.image.size.height)];
    [self.view addSubview:imgViewBackGround];
    
    textFieldInput = [[UITextField alloc]initWithFrame:CGRectMake(imgViewBackGround.frame.origin.x + 10, imgViewBackGround.frame.origin.y, imgViewBackGround.frame.size.width - 20, imgViewBackGround.frame.size.height)];
    [textFieldInput setPlaceholder:@"请输入条码"];
    [textFieldInput setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [textFieldInput setKeyboardType:UIKEYBOARDTYPE];
    [textFieldInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textFieldInput setFont:SetFontSize(FontSize15)];
    [self.view addSubview:textFieldInput];
    
    [textFieldInput becomeFirstResponder];
    
    [imgViewCode release];
    [imgViewBackGround release];
    [textFieldInput release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
