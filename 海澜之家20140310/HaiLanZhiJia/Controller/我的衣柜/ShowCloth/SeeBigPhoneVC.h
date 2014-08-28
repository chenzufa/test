//
//  SeeBigPhoneVC.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-11.
//  Copyright (c) 2013年 donson. All rights reserved.
//  不适合大量图片浏览 ，没做内存处理（可做视图重复利用，或预加载处理）

#import "CommonViewController.h"

@interface SeeBigPhoneVC : CommonViewController<UIScrollViewDelegate,UIActionSheetDelegate>
{
}
@property(nonatomic , assign)NSInteger selectIndex;
@property(nonatomic , retain)NSArray* imgs;
@property(nonatomic , retain)UIScrollView* scrolview;
@property(nonatomic , retain)UIView* commentView;
@property(nonatomic , retain)NSString* comment;
@property(nonatomic , retain)UILabel* indexLabel;
@property(nonatomic , assign)BOOL isShow;
@property(nonatomic , assign)BOOL isCommentViewHide;
@property(nonatomic , retain)NSString* goodsid;
@end
