//
//  BeizhuVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SubviewInfoDelegate.h"

@interface BeizhuVC : CommonViewController<UITextViewDelegate>

@property (nonatomic,assign) id<SubviewInfoDelegate> delegate;
@property (nonatomic,retain) NSString *strNote;

@end
