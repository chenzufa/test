//
//  MyWardrobeVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyWardrobeVC.h"
#import "OrderManagerVC.h"
#import "MyCollectionVC.h"
#import "AddressManagerVC.h"
#import "MyConponVC.h"
#import "ScoreManagerVC.h"
#import "MyReviewVC.h"
#import "ChangePwdVC.h"
#import "BrowseHistoryVC.h"
#import "ShowClothVC.h"
#import "MoreInformVC.h"
#import "NSString+GetProvinceid.h"
#import "UIView+AddRemind.h"
#define ColorGray [UIColor colorWithRed:0.298 green:0.282 blue:0.282 alpha:1]
#define NickNameLabDown 20      //未登录时，nicknamelab下降的距离
@interface MyWardrobeVC ()

@end

@implementation MyWardrobeVC
{
    UIScrollView *sv ;
    UIButton *headImgView;
    UILabel *nickNameLab;
    UILabel *castLab;
    UILabel *surplusLab;
    UILabel *memberScoreLab;
    UIImageView *memberShipImgView;
    
    
    UIImage *newImage;  //  上传的新头像图片
    BOOL hasNewRemind;
}

enum RequestType{
    RequestTypeGetUserInfo,
    RequestTypeLogOut,
    RequestTypeUploadPersonalPic,
    RequestTypeGetReminderInfo
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
    [sv release];
    [nickNameLab release];
    [castLab release];
    [surplusLab release];
    [memberScoreLab release];
    [memberShipImgView release];
    self.entiCustInfo = nil;
    
    self.requestOjb = nil;
    self.requestOjb.delegate = nil;
    SAFETY_RELEASE(newImage);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CONTENTFRAME];
    [self.leftButton setHidden:YES];
    [self setTitleString:@"我的衣柜"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonImage:@"user_icon_more.png" hightImage:@"user_icon_more.png"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self initUI];
    if (!isNotLogin) {
        [self request:RequestTypeGetUserInfo imgData:nil];
    }
    
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    //  查看提醒后 重新获取红点提示
    [notifiCenter addObserver:self selector:@selector(readOrderRemind) name:OrderRedRemind object:nil];
    //  登录成功后，接受通知刷新数据
    [notifiCenter addObserver:self selector:@selector(resignReloadData) name:LoginSuccess object:nil];
    //  修改密码后，接受通知刷新界面
    [notifiCenter addObserver:self selector:@selector(logoutSuccess) name:LoginOut object:nil];
}

- (void)resignReloadData
{
    [self request:RequestTypeGetUserInfo imgData:nil];
}

//  请求获取红点提示
- (void)readOrderRemind
{
    [self request:RequestTypeGetReminderInfo imgData:nil];
}

- (void)myRightButtonAction:(UIButton *)button
{
    MoreInformVC *moreView = [[MoreInformVC alloc]init];
    [self pushViewController:moreView];
    [moreView release];
}

- (void)request:(enum RequestType)type imgData:(UIImage *)img  //上传图片时用到imgData参数 其他置空
{

    DSRequest *request = [[DSRequest alloc]init];
    self.requestOjb = request;
    request.delegate = self;
    switch (type) {
        case RequestTypeGetUserInfo:        //获取用户信息
            [sv addHUDActivityView:@"获取中..."];  //提示 加载中
            [request requestDataWithInterface:GetCustomerInfo param:[self GetCustomerInfoParam] tag:type];
            break;
        case RequestTypeLogOut:             //注销
            [sv addHUDActivityView:@"正在注销"];  //提示 加载中
            [request requestDataWithInterface:Logout param:[self LogoutParam] tag:type];
            break;
        case RequestTypeUploadPersonalPic:  //上传头像
            
            if (img) {
                [sv addHUDActivityView:@"正在上传"];  //提示 加载中
                [request requestDataWithInterface:UploadPersonalPic param:[self UploadPersonalPicParam] uploadImg:[NSArray arrayWithObject:img] tag:type];
            }else [sv addHUDLabelView:@"照片选取失败，请重新选择" Image:nil afterDelay:2];
            
            break;
        case RequestTypeGetReminderInfo:    //获取订单提醒
            [request requestDataWithInterface:GetReminderInfo param:[self GetReminderInfoParam] tag:type];
            break;
            
        default:
            break;
    }
    

    
    [request release];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    [sv removeHUDActivityView];        //加载成功  停止转圈
    
    switch (tag) {
        case RequestTypeGetUserInfo:
        {
            self.entiCustInfo = (CustomerInfoEntity *)dataObj;
            [self reloadAllViewsData];
            [self request:RequestTypeGetReminderInfo imgData:nil];     //登录成功后获取订单提醒
        }
            break;
        case RequestTypeLogOut:
        {
            StatusEntity *entiSta = (StatusEntity *)dataObj;
            if (entiSta.response == 1) {
                [sv addHUDLabelView:@"注销成功" Image:nil afterDelay:2];
//                NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
//                [userdefalut removeObjectForKey:UserId];
//                [userdefalut removeObjectForKey:Token];
//                [userdefalut removeObjectForKey:@"userLoginData"];
//                self.entiCustInfo = nil;
//                [self reloadAllViewsData];
//                
//                UIButton *btnOd = (UIButton *)[sv viewWithTag:100];
//                [btnOd showRedCircleRemind:NO];
//                [RootVC setNumber:0 ofIndex:3];
//                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:kGouWuCheGoodsCount];
                [self logoutSuccess];
            }else {
                [sv addHUDLabelView:@"注销失败" Image:nil afterDelay:2];
            }
        }
            break;
        case RequestTypeUploadPersonalPic:
        {
            StatusEntity *entiSta = (StatusEntity *)dataObj;
            if (entiSta.response == 1) {
                [sv addHUDLabelView:@"上传成功" Image:nil afterDelay:2];
                NSLog(@"+++++++++++++++++++%f",newImage.size.width);
                [headImgView setImage:newImage forState:UIControlStateNormal];
            }else {
                [sv addHUDLabelView:@"上传失败" Image:nil afterDelay:2];
            }
        }
            break;
        case RequestTypeGetReminderInfo:
        {
            StatusEntity *entiSta = (StatusEntity *)dataObj;
            UIButton *btnOd = (UIButton *)[sv viewWithTag:100];
            if (entiSta.hasneworderremind == 1) {   // 1  有提醒  0  没
                
                [btnOd showRedCircleRemind:YES];
                [RootVC setNumber:-1 ofIndex:4];
                hasNewRemind = YES;
                
            }else {
                [btnOd showRedCircleRemind:NO];
                [RootVC setNumber:0 ofIndex:4];
                hasNewRemind = NO;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
}

- (void)logoutSuccess        //  注销成功后调用
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    [userdefalut removeObjectForKey:UserId];
    [userdefalut removeObjectForKey:Token];
    [userdefalut removeObjectForKey:@"userLoginData"];
    self.entiCustInfo = nil;
    [self reloadAllViewsData];
    
    UIButton *btnOd = (UIButton *)[sv viewWithTag:100];
    [btnOd showRedCircleRemind:NO];
    [RootVC setNumber:0 ofIndex:3];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:kGouWuCheGoodsCount];
}

- (void)initUI
{
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], MainViewWidth, MainViewHeight)];
    [sv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:sv];
    
    UIButton *upBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBackBtn setImage:GetImage(@"user_bg_personal.png") forState:UIControlStateNormal];
    [upBackBtn setImage:upBackBtn.imageView.image forState:UIControlStateHighlighted];
    [upBackBtn setFrame:CGRectMake(0, 0, upBackBtn.imageView.image.size.width, upBackBtn.imageView.image.size.height )];
    [upBackBtn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    upBackBtn.tag = 1;
    [sv addSubview:upBackBtn];
    
    headImgView = [UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(15, 65 - [self getTitleBarHeight], 60, 60)];
    UIImage *imgHeadBackground = GetImage(@"user_photo.png");
    [headImgView setBackgroundImage:imgHeadBackground forState:UIControlStateNormal];
    [headImgView setFrame:CGRectMake(15, 65 - [self getTitleBarHeight], imgHeadBackground.size.width, imgHeadBackground.size.height)];
    [headImgView setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [headImgView setClipsToBounds:YES];
    [headImgView.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [headImgView setUserInteractionEnabled:NO];
    [headImgView setShowsTouchWhenHighlighted:YES];
    [sv addSubview:headImgView];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedHeadImgView:)];
    [headImgView addGestureRecognizer:tap];
    [tap release];
    
    
    nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(headImgView.frame.origin.x + headImgView.frame.size.width + 5, headImgView.frame.origin.y + NickNameLabDown, 200, FontSize15 + 4)];
    [sv addSubview:nickNameLab];
    [nickNameLab setText:@"点击登录"];
    [nickNameLab setFont:SetFontSize(FontSize15)];
    [nickNameLab setTextColor:ColorFontBlack];
    [nickNameLab setBackgroundColor:[UIColor clearColor]];
    
    //  总消费额
    castLab = [[UILabel alloc]initWithFrame:CGRectMake(nickNameLab.frame.origin.x, 87 - [self getTitleBarHeight], 150, FontSize10)];
    [castLab setFrame:CGRectMake(0, castLab.frame.origin.y - 13, 0, 0)];
    [sv addSubview:castLab];
    [castLab setFont:SetFontSize(FontSize10)];
//    [castLab setText:@"总消费额：0"];
    [castLab setTextColor:ColorGray];
    [castLab setBackgroundColor:[UIColor clearColor]];
    [castLab setHidden:YES];
    
    //  账户余额
    surplusLab = [[UILabel alloc]initWithFrame:CGRectMake(nickNameLab.frame.origin.x, castLab.frame.origin.y + 13, 150, FontSize10)];
    [sv addSubview:surplusLab];
    [surplusLab setFont:SetFontSize(FontSize10)];
//    [surplusLab setText:@"账户余额：0"];
    [surplusLab setTextColor:castLab.textColor];
    [surplusLab setBackgroundColor:castLab.backgroundColor];

    //  会员积分
    memberScoreLab = [[UILabel alloc]initWithFrame:CGRectMake(nickNameLab.frame.origin.x, surplusLab.frame.origin.y + 13, 150, FontSize10)];
    [sv addSubview:memberScoreLab];
    [memberScoreLab setFont:SetFontSize(FontSize10)];
//    [memberScoreLab setText:@"会员积分：0"];
    [memberScoreLab setTextColor:castLab.textColor];
    [memberScoreLab setBackgroundColor:castLab.backgroundColor];
    
    
    //  普通会员 水手……
//    int a = 5;
    UIImage *imgMS = GetImage(@"user_icon_vip1.png");
    memberShipImgView = [[UIImageView alloc]init];//WithImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_icon_vip%i.png",1]]];
    [memberShipImgView setFrame:CGRectMake(249, 84 - [self getTitleBarHeight], imgMS.size.width, imgMS.size.height)];
    [sv addSubview:memberShipImgView];
    
    UIImageView *arrowImgView = [[UIImageView alloc]initWithImage:GetImage(@"icon_next.png")];
    [arrowImgView setFrame:CGRectMake(memberShipImgView.frame.origin.x + memberShipImgView.frame.size.width + 6, memberShipImgView.frame.origin.y + 3, arrowImgView.image.size.width, arrowImgView.image.size.height)];
    [sv addSubview:arrowImgView];
    
    [self initButtons];     //  创建九个按钮
    
    UIButton *zhuXiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = GetImage(@"button3.png");
    [zhuXiaoBtn setBackgroundImage:image forState:UIControlStateNormal];
    [zhuXiaoBtn setBackgroundImage:GetImage(@"button3_press.png") forState:UIControlStateHighlighted];
    [zhuXiaoBtn setFrame:CGRectMake(10, 450, image.size.width, image.size.height)];
    
    [zhuXiaoBtn.titleLabel setFont:SetFontSize(18)];
    [zhuXiaoBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [zhuXiaoBtn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    zhuXiaoBtn.tag = 888;
    [sv addSubview:zhuXiaoBtn];
    [sv setContentSize:CGSizeMake(MainViewWidth, 570)];
    [zhuXiaoBtn setTitle:@"注销" forState:UIControlStateNormal];
    [zhuXiaoBtn setHidden:YES];
    
    [arrowImgView release];
}

// 点击设置头像
- (void)clickedHeadImgView:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择照片选取方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"新拍一张", @"相册中选",nil];
//    alert.tag = 2;
//    [alert show];
//    [alert release];
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新拍一张",@"相册中选择", nil];
    sheet.tag = 2;
    [sheet showInView:self.titleBar];
    [sheet release];
}

//  登录、注销时更新视图
- (void)reloadAllViewsData
{
    UIButton *zhuXiaoBtn = (UIButton *)[sv viewWithTag:888];    //注销按钮
    UIButton *psdChangeBtn = (UIButton *)[sv viewWithTag:100 + 8];
    UILabel *psdLab = (UILabel *)[sv viewWithTag:200 + 8];
    
    
    if (isNotLogin ) {       //  未登录时的UI
        [nickNameLab setFrame:CGRectMake(nickNameLab.frame.origin.x, headImgView.frame.origin.y + NickNameLabDown, nickNameLab.frame.size.width, nickNameLab.frame.size.height)];
        [zhuXiaoBtn setHidden:YES];
        [sv setContentSize:CGSizeMake(sv.contentSize.width, 570)];
        [headImgView setUserInteractionEnabled:NO];
        [psdChangeBtn setHidden:YES];
        [psdLab setHidden:YES];
    }else {                 //  登录后的UI
        
        [nickNameLab setFrame:CGRectMake(nickNameLab.frame.origin.x, headImgView.frame.origin.y, nickNameLab.frame.size.width, nickNameLab.frame.size.height)];
        [zhuXiaoBtn setHidden:NO];
        [sv setContentSize:CGSizeMake(sv.contentSize.width, 570 + 44)];
        [headImgView setUserInteractionEnabled:YES];
        
        int loginType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"logintype"]intValue];  //判断是否是第三方登录，非1时  是第三方
        if (loginType == 1) {
            [psdChangeBtn setHidden:NO];
            [psdLab setHidden:NO];
        }else {
            [psdChangeBtn setHidden:YES];
            [psdLab setHidden:YES];
        }
        
    }
    
    if (![self.entiCustInfo.imgurl isKindOfClass:[NSNull class]]) {
        [headImgView setImageWithURL:[NSURL URLWithString:self.entiCustInfo.imgurl] forState:UIControlStateNormal];
    }else [headImgView setImage:nil forState:UIControlStateNormal];
    
    if (!isNotLogin) {
        
        [nickNameLab setText:self.entiCustInfo.nickname];
//        NSString *tempConsume = self.entiCustInfo.totalconsume ?self.entiCustInfo.totalconsume:@"";
        [castLab setText:[NSString stringWithFormat:@"总消费额：%@",self.entiCustInfo.totalconsume?self.entiCustInfo.totalconsume:@""]];
        [surplusLab setText:[NSString stringWithFormat:@"账户余额：%@",self.entiCustInfo.balance?self.entiCustInfo.balance:@""]];
        [memberScoreLab setText:[NSString stringWithFormat:@"会员积分：%@",self.entiCustInfo.score?self.entiCustInfo.score:@""]];
        [memberShipImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_icon_vip%i.png",self.entiCustInfo.acounttype]]];
    }else {
        [nickNameLab setText:@"点击登录"];
        [castLab setText:@""];
        [surplusLab setText:@""];
        [memberScoreLab setText:@""];
        [memberShipImgView setImage:nil];
    }
    
}

- (void)initButtons          //  创建九个按钮
{
    NSArray *arrImage = [NSArray arrayWithObjects:@"user_button_list.png",@"user_button_collect.png",@"user_button_address.png",@"user_button_message.png",@"user_button__share.png",@"user_button_sale.png",@"user_button_card.png",@"user_button_history.png",@"user_button_safe.png", nil];
    
    NSArray *arrImage_press = [NSArray arrayWithObjects:@"user_button_list_press.png",@"user_button_collect_press.png",@"user_button_address_press.png",@"user_button_message_press.png",@"user_button__share_press.png",@"user_button_sale_press.png",@"user_button_card_press.png",@"user_button_history_press.png",@"user_button_safe_press.png", nil];
    
    NSArray *labelText = [NSArray arrayWithObjects:@"订单管理",@"我的收藏",@"地址管理",@"我的评论",@"晒单",@"优惠券",@"积分管理",@"最近浏览",@"密码修改", nil];
    
    for (int i = 0; i < 9; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:GetImage([arrImage objectAtIndex:i]) forState:UIControlStateNormal];
        [button setImage:GetImage([arrImage_press objectAtIndex:i]) forState:UIControlStateHighlighted];
        [button setFrame:CGRectMake(23 + 101 * (i % 3), 157 + 115 * (i / 3) - [self getTitleBarHeight], 74, 74)];
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 100;
        [sv addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height + 6, button.frame.size.width, FontSize15)];
        [sv addSubview:label];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1]];
        [label setText:[labelText objectAtIndex:i]];
        [label setFont:SetFontSize(FontSize15)];
        [label setTag:i + 200];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label release];
        
        if (i == 8) {
            [button setHidden:YES];
            [label setHidden:YES];
        }
//        [button showRedCircleRemind:YES];
    }
}

- (void)clicked:(UIButton *)btn // 九个按钮点击事件
{
    if (isNotLogin && btn.tag !=104 && btn.tag != 107 && btn.tag != 888) {    //未登录时，只有晒单跟最近浏览点击可进入 其他点击进入登录界面
        LoginViewCtrol *loginView = [[LoginViewCtrol alloc]init];
//        loginView.backDelegate = self;
        [self pushViewController:loginView];
        [loginView release];
    }else{
        switch (btn.tag) {
            case 1:
            {
                UserInfomationVC *infoVC = [[UserInfomationVC alloc]init];
                infoVC.backDelegate = self;
                [self pushViewController:infoVC];
                [infoVC release];
            }
                break;
            case 100:
            {
                OrderManagerVC *orderVC = [[OrderManagerVC alloc]init];
                orderVC.hasnewRemind = hasNewRemind;
                [self pushViewController:orderVC];
                [orderVC release];
            }
                break;
            case 101:
            {
                MyCollectionVC *collectVC = [[MyCollectionVC alloc]init];
                [self pushViewController:collectVC];
                [collectVC release];
            }
                break;
            case 102:
            {
                AddressManagerVC *addressVC = [[AddressManagerVC alloc]init];
                [self pushViewController:addressVC];
                [addressVC release];
            }
                break;
            case 103:
            {
                MyReviewVC *reviewVC = [[MyReviewVC alloc]init];
                [self pushViewController:reviewVC];
                [reviewVC release];
            }
                break;
            case 104:{
                ShowClothVC* showCloth = [[ShowClothVC alloc] init];
                [self pushViewController:showCloth];
                [showCloth release];
            }
                break;
            case 105:
            {
                MyConponVC *conponVC = [[MyConponVC alloc]init];
                [self pushViewController:conponVC];
                [conponVC release];
            }
                break;
            case 106:
            {
                ScoreManagerVC *scoreVC = [[ScoreManagerVC alloc]init];
                [self pushViewController:scoreVC];
                [scoreVC release];
            }
                break;
            case 107:
            {
                NSLog(@"最近浏览");
                BrowseHistoryVC* browseVC = [[BrowseHistoryVC alloc] init];
                [self pushViewController:browseVC];
                [browseVC release];
            }
                break;
            case 108:
            {
                NSString *loginType = [[NSUserDefaults standardUserDefaults]objectForKey:@"logintype"];
                if (loginType.intValue==1)
                {
                    ChangePwdVC *changeView = [[ChangePwdVC alloc]init];
                    [self pushViewController:changeView];
                    [changeView release];
                    NSLog(@"密码修改");
                }else
                {
                    [self addFadeLabel:@"您采用第三方登陆，不支持改密"];
                }
            }
                break;
            case 888:       //  注销
            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要注销当前账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.tag = 1;
//                [alert show];
//                [alert release];
                
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销当前账号" otherButtonTitles:nil];
                sheet.tag = 1;
                [sheet showInView:self.titleBar];
                [sheet release];
            }
                //            [self request:RequestTypeLogOut];
                break;
                
            default:
                break;
        }
    }
    
}

//#pragma mark UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"button = %i",buttonIndex);
//    switch (alertView.tag) {
//        case 1:
//            if (buttonIndex == 1) {                     //确定注销buttonIndex = 1
//                [self request:RequestTypeLogOut imgData:nil];
//            }
//            break;
//        case 2:
//            if (buttonIndex > 0) {
//                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//                picker.delegate = self;
//                if (buttonIndex == 1) {     //拍照
//                    
//                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                        
//                    }else{
//                        NSLog(@"模拟器无法打开相机");
//                    }
//                    
//                }else if (buttonIndex == 2){    //相册
//                    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//                }
//                
//                [picker.view setFrame:CGRectMake(0, 20, picker.view.frame.size.width, picker.view.frame.size.height)];
//                [[RootVC shareInstance] presentModalViewController:picker animated:YES];
//                [picker release];
//            }
//            
//            break;
//            
//        default:
//            break;
//    }
//
//}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button = %i",buttonIndex);
    switch (actionSheet.tag) {
        case 1:
            if (buttonIndex == 0) {                     //确定注销buttonIndex = 0
                [self request:RequestTypeLogOut imgData:nil];
            }
            break;
        case 2:
            if (buttonIndex < 2) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.allowsEditing = YES;
                picker.delegate = self;
                if (buttonIndex == 0) {     //拍照
                    
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                    }else{
                        NSLog(@"模拟器无法打开相机");
                    }
                    
                }else if (buttonIndex == 1){    //相册
                    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                }
                
                [[RootVC shareInstance] presentModalViewController:picker animated:YES];
                [picker release];
            }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
    
    [picker.view addHUDActivityView:@"转换中..."];
    NSData *data;  
        //将图片转换为JPG格式的二进制数据
    data = UIImageJPEGRepresentation(originImage, 0.05);
    //将二进制数据生成UIImage
    newImage = [[UIImage imageWithData:data]retain];
    [self request:RequestTypeUploadPersonalPic imgData:newImage];       //上传
    NSLog(@"+++++++++++++++++++%f",newImage.size.width);
//    [headImgView setImage:newImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker.view removeActivityIndicatorView];
    
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        aRoot.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        aRoot.view.bounds = CGRectMake(0, -20, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

#pragma mark UserInformationDisMissDelegate
- (void)userInformationVCDisMissReloadData      //  保存成功后刷新界面
{
    [self request:RequestTypeGetUserInfo imgData:nil];
}

//#pragma mark LoginViewCtrolDisMissDelegate
//- (void)loginViewCtrolDisMissed
//{
//    [self request:RequestTypeGetUserInfo imgData:nil];      // 登录成功后刷新界面
//}

- (void)showVC
{
    if (!self.entiCustInfo && !isNotLogin) {
        [self request:RequestTypeGetUserInfo imgData:nil];
//        return;
    }
//    if (isNotLogin) {
        [self reloadAllViewsData];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
