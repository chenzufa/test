//
//  ZhiFuBaoView.h
//  HaiLanZhiJia
//
//  Created by creaver on 14-2-12.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import "CommonViewController.h"


@protocol loginDelgate <NSObject>

-(void)zhifubaoLogin:(id)object andTag:(int)tag;
-(void)zhifubaoLoginFail:(int)tag andError:(NSError *)error andEnum:(enum InterfaceType)type;

@end

@interface ZhiFuBaoView : CommonViewController
@property(nonatomic,assign)BOOL isAuto;
@property(nonatomic,assign)id<loginDelgate>loginDelegate;

@end
