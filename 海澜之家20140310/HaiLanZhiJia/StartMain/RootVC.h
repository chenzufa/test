//
//  RootVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "ShouYeVC.h"
#import "GouWuCheVC.h"
#import "ShangChenVC.h"
#import "SouSuoVC.h"
#import "MyWardrobeVC.h"
#import "LoginViewCtrol.h"
#import "DSRequest.h"

@class RootVC;
RootVC                    *r_rootInstance;                    // 视图控制器单例
static UIImageView *tabBagView;
static int  numbersOfGoods;
@interface RootVC : CommonViewController<DSRequestDelegate>
{
    int _currentIndex;
    
}

@property (nonatomic) int                       currentIndex;
@property (nonatomic,retain)UIView              *contentView;
@property (nonatomic,retain)NSMutableArray      *vcArray;

+ (id)shareInstance;
+ (int)getNumberOfGoods;
+ (void)setNumber:(int)number ofIndex:(int)index;

-(void)showTableIndex:(int)index;
//-(void)clickTabButton:(UIButton *)button;
@property(nonatomic,retain)NSMutableArray *buttons;
@end
