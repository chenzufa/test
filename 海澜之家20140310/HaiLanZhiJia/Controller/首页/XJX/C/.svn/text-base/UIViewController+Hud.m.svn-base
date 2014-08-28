//
//  UIViewController+Hud.m
//  MeiLiYun
//
//  Created by xiaojiaxi on 13-10-25.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "UIViewController+Hud.h"

@implementation UIViewController (Hud)
#pragma mark -- Hud
-(void)addHud:(NSString*)text
{
    //MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];//模态
    [self hideHud:nil];
    
    CGRect myRect = self.view.frame;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height - TITLEHEIGHT)];
    hud.userInteractionEnabled = YES;
    hud.labelText = text;
    hud.opacity=0.6;
    if (text.length==0||text==nil)
    {
        hud.labelText = HudText;
    }
    [hud show:YES];
    hud.tag = 1;
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud release];
    [self performSelector:@selector(hideHud:) withObject:hud afterDelay:20];
}
-(void)addHudNM:(NSString*)text
{
    [self hideHud:nil];
    
    CGRect myRect = self.view.frame;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT+45, myRect.size.width, myRect.size.height - TITLEHEIGHT-45)];
    hud.userInteractionEnabled = YES;
    hud.labelText = text;
    hud.opacity=0.6;
    if (text.length==0||text==nil)
    {
        hud.labelText = HudText;
    }
    [hud show:YES];
    hud.tag = 1;
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud release];
    [self performSelector:@selector(hideHud:) withObject:hud afterDelay:20];
}
-(void)hideHud:(MBProgressHUD*)hud
{
    [hud hide:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)addFadeLabel:(NSString*)text
{
    //AutoFadeWithLabel *afLabel = [[AutoFadeWithLabel alloc] initWithString:text];
    //[afLabel show];
    //[afLabel release];
    [self.view addHUDLabelWindow:text Image:nil afterDelay:2.0];
}
@end
