//
//  ReXiaoShangPinVC.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MMDrawerController.h"
#import "ShaiXuanVCViewController.h"

typedef enum
{
    PushComeFromFenLei=3,
    PushComeFromSouSuo=4,
    PushComeFromReMai
}PushComeFromType;

@protocol JiXuGuangGuangDelegate <NSObject>
@optional
-(void)JiXuGuangGuang;
@end

@interface ReXiaoShangPinVC : CommonViewController<ShaiXuanVCDelegate>
@property(nonatomic,copy)NSString *title_;
@property(nonatomic,copy)NSString *spId;
@property(nonatomic,assign)MMDrawerController *mmdc;
@property(nonatomic,assign)PushComeFromType comeFromType;
@property(nonatomic,assign)id<JiXuGuangGuangDelegate>delegate;
@end
