//
//  WhiteReviewVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "ScoreImgViews.h"
#import "DSRequest.h"

@protocol WriteReviewVCDisMissDeelgate <NSObject>

@optional
- (void)writeReviewVCDisMissedandReloadData;   //评论成功后  点击返回按钮是实现此协议方法

@end

@interface WriteReviewVC : CommonViewController<UITextViewDelegate,ScoreImgViewsDelegate,DSRequestDelegate>

@property (nonatomic, assign) id<WriteReviewVCDisMissDeelgate> backDelegate;

@property (nonatomic, retain) DSRequest *requestOjb;
@property (nonatomic, retain) CommentEntity *entiComment;
@end
