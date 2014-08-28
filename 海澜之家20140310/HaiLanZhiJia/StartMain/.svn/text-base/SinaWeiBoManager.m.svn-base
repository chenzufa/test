//
//  SinaWeiBoManager.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 14-4-14.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import "SinaWeiBoManager.h"

static SinaWeiBoManager *sinaManager = nil;


@implementation SinaWeiBoManager
{
    NSString *sinaToken;
}

- (void)dealloc
{
    sinaToken = nil;
    [super dealloc];
}

+ (SinaWeiBoManager *)sharedInstance
{
    @synchronized(self){
        if (!sinaManager) {
            sinaManager = [[SinaWeiBoManager alloc]init];
        }
    }
    return sinaManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if (!sinaManager) {
            sinaManager = [super allocWithZone:zone];
            return sinaManager;
        }
    }
    return nil;
}

- (void)sinaLogin   //授权登录
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kAppRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)sinalogout
{
    if (!sinaToken) {
        NSDictionary *dicData = [[NSUserDefaults standardUserDefaults]objectForKey:SinaWeiboAuthData];
        sinaToken = [[dicData objectForKey:@"AccessTokenKey"]retain];
    }
    
    [WeiboSDK logOutWithToken:sinaToken delegate:self withTag:@"logout"];
    
}

#pragma mark WBhttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"解绑成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:SinaWeiboAuthData];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

// 微博分享
- (void)shareMessageToSinaWithText:(NSString *)text imageUrlStr:(NSString *)imageurlstr
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:text imageUrlStr:imageurlstr]];

    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare:(NSString *)text imageUrlStr:(NSString *)imageurlstr
{
    WBMessageObject *message = [WBMessageObject message];
    if (text) {
        message.text = text;
    }
    
    if (imageurlstr) {
        WBImageObject *imageobj = [WBImageObject object];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurlstr]]];
        imageobj.imageData = UIImagePNGRepresentation(image);
        message.imageObject = imageobj;
    }
    return message;
}

#pragma mark WeiboDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])        //发送结果
    {
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//        WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//        WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//        WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//        WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//        WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//        WeiboSDKResponseStatusCodeUnknown               = -100,
        NSString *message = nil;
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:
                message = @"微博分享成功";
                break;
            case WeiboSDKResponseStatusCodeUserCancel:
                message = @"分享已取消";
                break;
            case WeiboSDKResponseStatusCodeSentFail:
                message = @"微博分享成功";
                break;
            case WeiboSDKResponseStatusCodeAuthDeny:
                message = @"授权失败";
                break;
            case WeiboSDKResponseStatusCodeUserCancelInstall:
                message = @"用户取消安装微博客户端";
                break;
            case WeiboSDKResponseStatusCodeUnsupport:
                message = @"不支持的请求";
                break;
                
            default:
                message = @"未知错误";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])        // 登录认证
    {

        NSString *token = [(WBAuthorizeResponse *)response accessToken];
        NSString *userid = [(WBAuthorizeResponse *)response userID];
        NSDate *expirationDate = [(WBAuthorizeResponse *)response expirationDate];
        sinaToken = [token retain];     //  保留token
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {     // 认证成功才将数据保存并回调
            NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      token, @"AccessTokenKey",
                                      expirationDate, @"ExpirationDateKey",
                                      userid, @"UserIDKey",nil];
            [[NSUserDefaults standardUserDefaults] setObject:authData forKey:SinaWeiboAuthData];    //新浪第三方登陆把数据保存在本地
            
            if ([self.delegate respondsToSelector:@selector(sinaWeiBoManagerDidLoginGetToken:userId:expirationDate:)]) {
                [self.delegate sinaWeiBoManagerDidLoginGetToken:token userId:userid expirationDate:expirationDate];
            }
        }
        
        
        
        
    }
}

@end
