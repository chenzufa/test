//
//  ViewWithImages.h
//  MeiLiYun
//
//  Created by summer on 13-10-9.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewWithImages;
@protocol ViewWithImagesDelegate <NSObject>

-(void)selectedImg:(ViewWithImages*)view atIndex:(NSInteger)index;

@end

@interface ViewWithImages : UIScrollView
@property(nonatomic , assign)id<ViewWithImagesDelegate>viewWithImagesDelegate;
@property (nonatomic, retain) NSMutableArray *images;
- (void)createImageViews;
@end
