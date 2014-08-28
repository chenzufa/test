//
//  BangdingView.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BangdingView;
@protocol BangdingViewDelegate <NSObject>

@optional
- (void)bangdingView:(BangdingView *)bdView clickedAnIndex:(int)index cardNum:(NSString *)strNum passWord:(NSString *)strPsd;

@end
@interface BangdingView : UIView<UITextFieldDelegate>

@property (assign, nonatomic) id<BangdingViewDelegate> delegate;

@property (assign, nonatomic) int ifHasPsd;  //无密码绑定 1   有密码绑定 2
- (void)initUI;
- (void)cleanTextField;
@end
