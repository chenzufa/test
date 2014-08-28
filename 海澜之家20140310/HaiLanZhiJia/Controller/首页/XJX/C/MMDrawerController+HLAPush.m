//
//  MMDrawerController+HLAPush.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-12-11.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MMDrawerController+HLAPush.h"
#import "ReXiaoShangPinVC.h"
#import "ShaiXuanVCViewController.h"

@implementation MMDrawerController (HLAPush)
+(id)MMDrawerControllerWithName:(NSString*)name withId:(NSString*)spId
{
    ReXiaoShangPinVC *vc = [[ReXiaoShangPinVC alloc]init];
    if ([spId isEqualToString:@"-2"])
    {
        vc.comeFromType = PushComeFromSouSuo;
    }else
    {
        vc.comeFromType = PushComeFromFenLei;
    }
    vc.title_ = name;
    vc.spId = spId;
    
    ShaiXuanVCViewController *vc2 = [[ShaiXuanVCViewController alloc]init];
    vc2.spId = spId;
    vc2.delegate = vc;
    
    MMDrawerController *rvc = [[MMDrawerController alloc]initWithCenterViewController:vc rightDrawerViewController:vc2];
    rvc.showsShadow = YES;
    vc.mmdc = rvc;
    [rvc setMaximumRightDrawerWidth:240];
    [rvc setMaximumLeftDrawerWidth:240];
    
    [rvc setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [rvc setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [vc release];
    [vc2 release];
    return [rvc autorelease];
}
@end
