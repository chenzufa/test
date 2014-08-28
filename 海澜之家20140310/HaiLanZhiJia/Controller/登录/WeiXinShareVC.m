//
//  WeiXinShareVC.m
//  Ellassay_iphone
//
//  Created by hua on 12-11-30.
//  Copyright (c) 2012年 donson. All rights reserved.
//

#import "WeiXinShareVC.h"

@implementation WeiXinEntity

@synthesize largeimg=_largeimg;
@synthesize sharetitle=_sharetitle;
@synthesize sharecontent=_sharecontent;
@synthesize smallimg=_smallimg;

- (void) dealloc{
    [_largeimg release];
    [_sharetitle release];
    [_sharecontent release];
    [_smallimg release];
    
    [super dealloc];
}

@end

@implementation WeiXinShareVC
//朋友圈
+ (void) sendTextContentFiend:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    //微信朋友
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}


//回话圈
+ (void) sendTextContentSection:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    //微信朋友
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

+ (void) shareImg: (WeiXinEntity *)entity{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title=entity.sharetitle;
    message.description=@"";
    [message setThumbImage: entity.smallimg];
    
    WXWebpageObject *webobject=[WXWebpageObject object];
    webobject.webpageUrl=entity.largeimg;
    
    message.mediaObject=webobject;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

-(void) onResp:(BaseResp*)resp
{
    
}

//图片
+ (void) sendImageContent: (NSString *)imgurl thumImg: (UIImage *)image {
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage: image];
    
    WXImageObject *ext = [WXImageObject object];
    NSData *tempdata=[NSData dataWithContentsOfURL: [NSURL URLWithString: imgurl]];
    ext.imageData=tempdata;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    //文本和多媒体不发送
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    
    
          
}

+ (void) sendVideo: (WeiXinEntity *)entity{
    WXMediaMessage *videomessage = [WXMediaMessage message];
    videomessage.title=@"";
    videomessage.description = entity.sharecontent;
    [videomessage setThumbImage: entity.smallimg];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = entity.largeimg;
    
    videomessage.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = videomessage;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];

}


@end
