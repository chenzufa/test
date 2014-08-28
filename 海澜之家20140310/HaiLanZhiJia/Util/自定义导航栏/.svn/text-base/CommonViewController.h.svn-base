//
//  CommonViewController.m
//  Donson
//
//  Created by donson on 12-7-21.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ModelManager.h"

@interface CommonViewController : UIViewController<ModelManagerDelegate>
{
    UIView* titleBar;//标题栏
    UIImageView *logoView; // 品牌logo
//    UIButton *myRightButton;
}

@property (retain, nonatomic) UIView* titleBar;
@property (retain, nonatomic) UIImageView *logoView;
@property (nonatomic, retain) UIImageView *TopBackgroudImgV;

// 由外部菜单传入的选中根菜单title和子菜单title
@property (nonatomic, retain) NSString *seletedRootTitle;
@property (nonatomic, retain) NSString *seletedSubTitle;
@property (nonatomic) BOOL isShow; // 当前界面是否已经初始化

- (void)setTitleBarHidden:(BOOL)hidden; // 设置titlebar是否隐藏
- (void)setLogoHidden:(BOOL)hidden; // 设置logo是否隐藏
- (void)setButtonsHidden:(BOOL)leftBtnHidden rightBtnHidden:(BOOL)rightBtnHidden; // 设置左右按钮是否隐藏
- (void)setTitleString:(NSString*)string; // 设置vc的标题
- (void)setTitleBarImageStr:(NSString *)imgStr; //设置vc标题背景

- (UIButton*)leftButton; // 左按钮，返回上一层
- (UIButton*)rightButton; // 右按钮，进入主页
- (UILabel*) titleLabel;
-(void)setLeftButtonImage:(NSString *)str;  //设置返回按钮的图标
-(void)setRightButtonImage:(NSString *)str;  //设置返回按钮的图标
- (void)leftAction; // 左按钮响应方法
- (void)rightAction; // 右按钮响应方法

- (void)pushViewController:(UIViewController*)controller; // push一个vc
- (void)pushViewController:(UIViewController*)controller WithAnimation:(BOOL)animal;
- (void)popViewController; // pop一个vc
- (void)popToRoot; // pop到根vc

- (int) getTitleBarHeight; // 获取titlebar高度

// 管理子视图
- (void)resetVC;
- (void)showVC;
- (void)changeBG:(BOOL)isDefault;

/**
 @function:根据title显示对应的视图
 @param:title 是否显示动画 是否调用委托方法
 @return:无
 */
- (void)showInfomationWithTitle:(NSString*)title animation:(BOOL)isAnimation runDelegate:(BOOL)isRun;

/**
 @function:刷新自己的菜单
 @param:无
 @return:无
 */
- (void)refrushOwnMenu;


/*
 创建右边的按钮
 */
@property (nonatomic, retain) UIButton *myRightButton;

- (void)createMyButtonWithTitleAndImage;
- (void)myRightButtonAction:(UIButton *)button;
- (void)setMyRightButtonTitle:(NSString *)title;
- (void)setMyRightButtonImage:(NSString *)imageName hightImage:(NSString *)hightImageName;
- (void)setMyRightButtonBackGroundImageView:(NSString *)imageName hightImage:(NSString *)hightImageName;


@end

//////////////
/*
 使用说明
 1. 添加文件 ModelManager.h/ModelManager.m;
 2. 添加QuartzCore.framework;
 3. 导入微软字体，使用说明见微软字体文件夹ReadMe.rtf中
 */
//////////////