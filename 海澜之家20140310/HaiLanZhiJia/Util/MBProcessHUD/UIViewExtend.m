//
//  UIViewExtend.m
//  YuJingWan
//
//  Created by 陈双龙 on 12-11-17.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import "UIViewExtend.h"
//#import "WindowImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@implementation UIView (Extend)

/**
 @功能:在视图上添加菊花
 @参数1:UIActivityIndicatorViewStyle  菊花类型
 @返回值:更改后的图片对象
 */
- (void) addActivityIndicatorView:(UIActivityIndicatorViewStyle) style
{
    UIView *view = [self viewWithTag:ACTIVITYTAG];
    
    if ( nil != view ) {
        [self removeActivityIndicatorView];
    }
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    aiv.frame = CGRectMake( (self.frame.size.width - ACTIVITYWIDTH) / 2.0,
                           (self.frame.size.height - ACTIVITYHRIGHT) / 2.0,
                           ACTIVITYWIDTH, ACTIVITYHRIGHT);
    aiv.tag = ACTIVITYTAG;
    [aiv startAnimating];
    [self addSubview:aiv];
    [aiv release];
}

/**
 @功能:删除视图上的菊花
 @返回值:空
 */
- (void) removeActivityIndicatorView
{
    UIView *subView = [self viewWithTag:ACTIVITYTAG];
    [subView removeFromSuperview];
}

/**
 @功能:在视图上添加HUD菊花
 @参数1:UIActivityIndicatorViewStyle  菊花类型
 @返回值:更改后的图片对象
 */
- (void) addHUDActivityView:(NSString*) labelText
{
    UIView *view = [self viewWithTag:HUDTAG];
    
    if ( nil != view ) {
        [self removeHUDActivityView];
    }
    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    CGRect myRect = self.bounds;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height)];
    HUD.tag = HUDTAG;
    HUD.backgroundColor=[UIColor clearColor];
    HUD.labelText = labelText;
    [self addSubview:HUD];
    [self bringSubviewToFront:HUD];
    HUD.center=CGPointMake(myRect.size.width/2.0, myRect.size.height/2.0);
    [HUD show:YES];
    [HUD release];
}

/**
 @功能:在视图上添加HUD菊花,TITLEHEIGHT 高度以上和 BOTTOMHEIGHT 高度以下能够点击
 @参数1:UIActivityIndicatorViewStyle  菊花类型
 @返回值:更改后的图片对象
 */
- (void) addClickableActivityView:(NSString*) labelText
{
    UIView *view = [self viewWithTag:HUDTAG];
    if ( nil != view ) {
        [self removeHUDActivityView];
    }
    CGRect myRect = self.frame;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height - TITLEHEIGHT - BOTTOMHEIGHT)];
    HUD.userInteractionEnabled = YES;
    HUD.tag = HUDTAG;
    HUD.labelText = labelText;
    [self addSubview:HUD];
    [HUD show:YES];
    [HUD release];
}

/**
  //@功能:在视图上添加HUD菊花,TITLEHEIGHT 高度以上能够点击
 */
- (void) addTitleBarClickableActivityView:(NSString*) labelText
{
    UIView *view = [self viewWithTag:HUDTAG];
    if ( nil != view ) {
        [self removeHUDActivityView];
    }
    CGRect myRect = self.frame;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height - TITLEHEIGHT)];
    HUD.userInteractionEnabled = YES;
    HUD.tag = HUDTAG;
    HUD.labelText = labelText;
    [self addSubview:HUD];
    [HUD show:YES];
    [HUD release];
}

/**
 @功能:删除视图上的HUD菊花
 @返回值:空
 */
- (void) removeHUDActivityView
{
    UIView *subView = [self viewWithTag:HUDTAG];
    [subView removeFromSuperview];
}

/**
 @功能:在视图上添加HUD菊花
 @参数1:UIActivityIndicatorViewStyle  菊花类型
 @返回值:更改后的图片对象
 */
- (void) addHUDLabelView:(NSString*) labelText Image:(UIImage*) image afterDelay:(NSTimeInterval)delay
{
    
    UIView *view = [self viewWithTag:HUDLABELTAG];
    
    if ( nil != view ) {
        [view removeHUDActivityView];
    }
    
    // 提示信息不要打断操作                       jiangsuiming 2014-01-15
    CGRect myRect = self.frame;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.size.height - 150, myRect.size.width, 150)];
    HUD.userInteractionEnabled = NO;
    
    HUD.customView = [[[UIImageView alloc] initWithImage:image] autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = labelText;
    [self addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
    [HUD release];
}

- (void) addMaskImage:(UIImage*) maskImage
{
    CALayer* roundCornerLayer = [[CALayer layer] retain];
    roundCornerLayer.frame = self.bounds;
    roundCornerLayer.contents = (id)[maskImage CGImage];
    [[self layer] setMask:roundCornerLayer];
    [roundCornerLayer release];
}

- (void) addHUDLabelWindow:(NSString*) labelText Image:(UIImage*) image afterDelay:(NSTimeInterval)delay
{
    
    UIView *view = [self viewWithTag:HUDLABELTAG];
    
    if ( nil != view ) {
        [view removeHUDActivityView];
    }
    
    // 提示信息不要打断操作                       jiangsuiming 2014-01-15
    CGRect myRect = self.frame;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(myRect.origin.x, myRect.size.height - 150, myRect.size.width, 150)];
    HUD.userInteractionEnabled = NO;
    HUD.tag = HUDLABELTAG;
    HUD.customView = [[[UIImageView alloc] initWithImage:image] autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = labelText;
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [tempWindow addSubview:HUD];
    
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
    [HUD release];
}

- (void) addImageToWindow:(UIImage*) image
{
//    [UIApplication sharedApplication].statusBarHidden = YES;
//    
//    WindowImageView *windowImageView = [[WindowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    windowImageView.imageView.image = image;
//    
//    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate.window addSubview:windowImageView];
//    
//    [windowImageView release];
    
}

- (void) addImageUrlToWindow:(NSMutableDictionary*) dicTable
{ 
//    UIImageView *imageView = [dicTable objectForKey:@"ImageView"];
//    
//    if ( [imageView isKindOfClass:[UIImageView class]] ) {
//        
//        WindowImageView *windowImageView = [[WindowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        
//        NSString *jsonString = [dicTable objectForKey:@"UserInfo"];
//        
//        NSMutableDictionary *imageTable = [jsonString JSONValue];
//        
//        if ( [imageTable isKindOfClass:[NSMutableDictionary class]] ) {
//            
//            NSString *bigImageURL = [imageTable objectForKey:@"img"];
//            
//            if ( [bigImageURL isKindOfClass:[NSString class]] ) {
//                NSURL *imageURL = [NSURL URLWithString:bigImageURL];
//                [windowImageView.imageView setImageWithURL:imageURL placeholderImage:imageView.image];
//            } else {
//                windowImageView.imageView.image = imageView.image;
//            }
//            
//        } else {
//            windowImageView.imageView.image = imageView.image;
//        }
//        
//        [UIApplication sharedApplication].statusBarHidden = YES;
//        
//        id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
//        [appDelegate.window addSubview:windowImageView];
//        
//        if ([[[UIDevice currentDevice]systemVersion]intValue]<7.0) {
//            [windowImageView release];//ios7
//        }
//    }
//    
    
}


@end
