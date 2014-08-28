//版权所有：版权所有(C) 2013，不亦乐乎科技有限公司
//系统名称：HighHand
//文件名称：ModelManager
//作　　者  冯炳发
//完成日期：13-03-25
//功能说明：视图控制器管理类
//----------------------------------------

#import "ModelManager.h"
//#import "NSObject+ToolClass.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATIONDURATION 0.35 // push或pop视图动画时间

@interface ModelManager (private_methods)
- (void)reSetTransitionType;
@end

@implementation ModelManager
@synthesize transitionType;
@synthesize TransitionSubType;


- (void)dealloc{
    [transitionType release];
    [TransitionSubType release];
    [subcontrollers release];
    
    SAFETY_RELEASE(rootviewcontroller);
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        subcontrollers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

/**
 @method    获取视图管理控制器单例
 @result    返回视图管理控制器单例
 */
+ (id)shareManager{
    if (nil == g_modelManager) {
        g_modelManager = [[ModelManager alloc] init];
    }
    return g_modelManager;
}

/**
 @method    释放视图管理控制器单例（程序退出后由主界面调用，慎用）
 */
+ (void)releaseManager{
    if (g_modelManager) {
        [g_modelManager release];
        g_modelManager = nil;
    }
}

/**
 @method    设置主视图管理控制器
 @param     controller 主视图管理控制器
 */
- (void)setRootControllerWith:(UIViewController*)controller{
    if (rootviewcontroller != controller) {
        [subcontrollers removeAllObjects];
        [rootviewcontroller release];
        rootviewcontroller = controller;
        [rootviewcontroller retain];
        if (rootviewcontroller && [rootviewcontroller respondsToSelector:@selector(controllerViewWillAppear)]) {
            [rootviewcontroller performSelector:@selector(controllerViewWillAppear)];
        }
        [subcontrollers addObject:rootviewcontroller];
    }
}

#pragma mark-
#pragma mark ----- 视图控制方法 -----
/**
 @method    推入视图控制器
 @param     controller 推入的视图控制器
 @param     obj 视图控制器管理类代理
 @param     supportAnimation 是否支持动画
 */
- (void)pushController:(UIViewController*)controller WithDelegate:(id<ModelManagerDelegate>)obj supportTransition:(BOOL)supportAnimation{
    // 页面切换前，把最低下的页面设置为不可以交互
    if (subcontrollers && [subcontrollers count]>0) {
        UIViewController *firstVC = [subcontrollers objectAtIndex:0];
        [firstVC.view setUserInteractionEnabled:NO];
    }
    
    // 动画开始前，子视图数组中的最后一个视图将要被覆盖
    if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewWillDisappear)]) {
        [[subcontrollers lastObject] performSelector:@selector(controllerViewWillDisappear)];
    }
    // 动画开始前，推入的视图将要显示
    if (controller && [controller respondsToSelector:@selector(controllerViewWillAppear)]) {
        [controller performSelector:@selector(controllerViewWillAppear)];
    }
    
    [rootviewcontroller.view addSubview:controller.view];

    if (supportAnimation) {
        // 改变将要插入的视图的位置
        CGRect oldFrame = controller.view.frame;
        CGRect newFram = oldFrame;
        newFram.origin.x = oldFrame.size.width;
        [controller.view setFrame:newFram];
        
        // 启动动画
        [UIView animateWithDuration:ANIMATIONDURATION animations:^{
            [controller.view setFrame:oldFrame];
        }completion:^(BOOL finished) {
            // 动画结束后，子视图数组中的最后一个视图已经被覆盖
            if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewDidDisappear)]) {
                [[subcontrollers lastObject] performSelector:@selector(controllerViewDidDisappear)];
            }

            // 动画结束后，推入的视图已经被显示
            if (controller && [controller respondsToSelector:@selector(controllerviewDidAppear)]) {
                [controller performSelector:@selector(controllerviewDidAppear)];
            }
            
            // 页面切换后，把最低下的页面设置为可以交互
            if (subcontrollers && [subcontrollers count]>0) {
                UIViewController *firstVC = [subcontrollers objectAtIndex:0];
                [firstVC.view setUserInteractionEnabled:YES];
            }
            
            // 加入到子视图数组
            [subcontrollers addObject:controller];
        }];
    }else{
        // 不支持动画，子视图数组中的最后一个视图已经被覆盖
        if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewDidDisappear)]) {
            [[subcontrollers lastObject] performSelector:@selector(controllerViewDidDisappear)];
        }

        // 不支持动画，推入的视图已经被显示
        if (controller && [controller respondsToSelector:@selector(controllerviewDidAppear)]) {
            [controller performSelector:@selector(controllerviewDidAppear)];
        }
        
        // 页面切换后，把最低下的页面设置为可以交互
        if (subcontrollers && [subcontrollers count]>0) {
            UIViewController *firstVC = [subcontrollers objectAtIndex:0];
            [firstVC.view setUserInteractionEnabled:YES];
        }
        
        // 加入到子视图数组
        [subcontrollers addObject:controller];
    }
    
    
//    // 动画开始前，子视图数组中的最后一个视图将要被覆盖
//    if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewWillDisappear)]) {
//        [[subcontrollers lastObject] performSelector:@selector(controllerViewWillDisappear)];
//    }
//    // 动画开始前，推入的视图将要显示
//    if (controller && [controller respondsToSelector:@selector(controllerViewWillAppear)]) {
//        [controller performSelector:@selector(controllerViewWillAppear)];
//    }
//    if (controller) {
//        // 加入视图控制器页面
//        [rootviewcontroller.view addSubview:controller.view];
//        
//        if (supportAnimation) {
//            // 切换动画
//            [UIView animateWithDuration:0.3f animations:^{
//                CATransition *transition = [CATransition animation];
//                transition.delegate = self;
//                transition.duration = 0.3f;
//                transition.type = nil==self.transitionType ? kCATransitionPush : self.transitionType;
//                transition.subtype = nil==self.TransitionSubType ? kCATransitionFromRight : self.TransitionSubType;
//                [rootviewcontroller.view.layer addAnimation:transition forKey:nil];
//            } completion:^(BOOL finished) {
//                // 动画结束后，子视图数组中的最后一个视图已经被覆盖
//                if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewDidDisappear)]) {
//                    [[subcontrollers lastObject] performSelector:@selector(controllerViewDidDisappear)];
//                }
//                
//                // 动画结束后，推入的视图已经被显示
//                if (controller && [controller respondsToSelector:@selector(controllerviewDidAppear)]) {
//                    [controller performSelector:@selector(controllerviewDidAppear)];
//                }
//            }];
//        }else{
//            // 不支持动画，子视图数组中的最后一个视图已经被覆盖
//            if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewDidDisappear)]) {
//                [[subcontrollers lastObject] performSelector:@selector(controllerViewDidDisappear)];
//            }
//            
//            // 不支持动画，推入的视图已经被显示
//            if (controller && [controller respondsToSelector:@selector(controllerviewDidAppear)]) {
//                [controller performSelector:@selector(controllerviewDidAppear)];
//            }
//        }
//        // 加入到子视图数组
//        [subcontrollers addObject:controller];
//        // 恢复动画类型
//        [self reSetTransitionType];
//    }
}

/**
 @method    推出视图控制器
 @param     controller 推出的视图控制器
 @param     obj 视图控制器管理类代理
 @param     supportAnimation 是否支持动画
 */
- (void)popController:(UIViewController*)controller WithDelegate:(id<ModelManagerDelegate>)obj supportTransition:(BOOL)supportAnimation{
    CGRect oldFrame = controller.view.frame;
    CGRect newFram = oldFrame;
    newFram.origin.x = oldFrame.size.width;
    
    // 动画开始前，推出的视图将要被移除
    if (controller && [controller respondsToSelector:@selector(controllerViewWillDisappear)]) {
        [controller performSelector:@selector(controllerViewWillDisappear)];
    }
    
    // 动画开始前，子视图数组中的最后一个视图将要被显示
    if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewWillAppear)]) {
        [[subcontrollers lastObject] performSelector:@selector(controllerViewWillAppear)];
    }
    
    if (supportAnimation) {
        // 启动动画
        [UIView animateWithDuration:ANIMATIONDURATION animations:^{
            [controller.view setFrame:newFram];
        }completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
            [subcontrollers removeObject:controller];
            // 动画开始后，推出的视图已经被移除
            if (controller && [controller respondsToSelector:@selector(controllerViewDidDisappear)]) {
                [controller performSelector:@selector(controllerViewDidDisappear)];
            }
            // 动画结束后，子视图数组中的最后一个视图已经被显示
            if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerviewDidAppear)]) {
                [[subcontrollers lastObject] performSelector:@selector(controllerviewDidAppear)];
            }
        }];
    }else{
        [controller.view removeFromSuperview];
        [subcontrollers removeObject:controller];
        // 动画开始后，推出的视图已经被移除
        if (controller && [controller respondsToSelector:@selector(controllerViewDidDisappear)]) {
            [controller performSelector:@selector(controllerViewDidDisappear)];
        }
        // 动画结束后，子视图数组中的最后一个视图已经被显示
        if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerviewDidAppear)]) {
            [[subcontrollers lastObject] performSelector:@selector(controllerviewDidAppear)];
        }
    }
    
    
//    // 动画开始前，推出的视图将要被移除
//    if (controller && [controller respondsToSelector:@selector(controllerViewWillDisappear)]) {
//        [controller performSelector:@selector(controllerViewWillDisappear)];
//    }
//    if (controller) {
//        // 移除推出的视图界面
//        [controller.view removeFromSuperview];
//        // 移除子视图数组中的视图
//        [subcontrollers removeObject:controller];
//        // 动画开始前，子视图数组中的最后一个视图将要被显示
//        if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerViewWillAppear)]) {
//            [[subcontrollers lastObject] performSelector:@selector(controllerViewWillAppear)];
//        }
//        
//        if (supportAnimation) {
//            // 切换动画
//            [UIView animateWithDuration:0.3f animations:^{
//                CATransition *transition = [CATransition animation];
//                transition.delegate = self;
//                transition.duration = 0.3f;
//                transition.type = nil==self.transitionType ? kCATransitionPush : self.transitionType;
//                transition.subtype = nil==self.TransitionSubType ? kCATransitionFromLeft : self.TransitionSubType;
//                [rootviewcontroller.view.layer addAnimation:transition forKey:nil];
//            } completion:^(BOOL finished) {
//                // 动画开始后，推出的视图已经被移除
//                if (controller && [controller respondsToSelector:@selector(controllerViewDidDisappear)]) {
//                    [controller performSelector:@selector(controllerViewDidDisappear)];
//                }
//                // 动画结束后，子视图数组中的最后一个视图已经被显示
//                if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerviewDidAppear)]) {
//                    [[subcontrollers lastObject] performSelector:@selector(controllerviewDidAppear)];
//                }
//            }];
//        }else{
//            // 不支持动画，调用页面已经显示的方法
//            if ([subcontrollers lastObject] && [[subcontrollers lastObject] respondsToSelector:@selector(controllerviewDidAppear)]) {
//                [[subcontrollers lastObject] performSelector:@selector(controllerviewDidAppear)];
//            }
//            // 不支持动画，推出的视图已经被移除
//            if (controller && [controller respondsToSelector:@selector(controllerViewDidDisappear)]) {
//                [controller performSelector:@selector(controllerViewDidDisappear)];
//            }
//        }
//        // 恢复动画类型
//        [self reSetTransitionType];
//    }
}

/**
 @method    返回到根视图控制器
 @param     obj 视图控制器管理类代理
 @param     supportAnimation 是否支持动画
 */
- (void)popToRootControllerWithDelegate:(id<ModelManagerDelegate>)obj supportTransition:(BOOL)supportAnimation{
    if ([subcontrollers count] <= 1) {
        // 没有视图或者是只有一个视图不需要做返回
        return;
    }
    if ([subcontrollers count] == 2) {
        // 只有两个视图，调用哪个popController的方法
        [self popController:[subcontrollers lastObject] WithDelegate:obj supportTransition:supportAnimation];
        return;
    }
    
    // 因为已经把主的VC也加入到subcontrollers中了，所以推到底层时需要保留最后一个vc和最后一个vc
	for (int i=[subcontrollers count]-2; i>=1; i--) {
		UIViewController*controller = [subcontrollers objectAtIndex:i];
        [controller.view removeFromSuperview];
        [subcontrollers removeObject:controller];
    }
    
    // 只有两个视图，调用哪个popController的方法
    [self popController:[subcontrollers lastObject] WithDelegate:obj supportTransition:supportAnimation];
    
//    // 因为已经把主的VC也加入到subcontrollers中了，所以推到底层时需要保留最后一个vc
//	for (int i=[subcontrollers count]-1; i>=1; i--) {
//		UIViewController*controller = [subcontrollers objectAtIndex:i];
//        [controller.view removeFromSuperview];
//        [subcontrollers removeObject:controller];
//    }
//    
//    // 动画开始前，调用页面将要显示的方法
//    if (subcontrollers && [subcontrollers count] > 0) {
//        if ([subcontrollers objectAtIndex:0] && [[subcontrollers objectAtIndex:0] respondsToSelector:@selector(controllerViewWillAppear)]) {
//            [[subcontrollers objectAtIndex:0] performSelector:@selector(controllerViewWillAppear)];
//        }
//    }
//    
//    // 调用动画效果
//    if (supportAnimation && [subcontrollers count] != 0) {
//        // 页面切换动画
//        [UIView animateWithDuration:0.3f animations:^{
//            CATransition *transition = [CATransition animation];
//            transition.delegate = self;
//            transition.duration = 0.3f;
//            transition.timingFunction = UIViewAnimationCurveEaseInOut;
//            transition.type = nil==self.transitionType ? kCATransitionPush : self.transitionType;
//            transition.subtype = nil==self.TransitionSubType ? kCATransitionFromLeft : self.TransitionSubType;
//            [rootviewcontroller.view.layer addAnimation:transition forKey:nil];
//        } completion:^(BOOL finished) {
//            // 动画结束后，调用页面已经显示的方法
//            if (subcontrollers && [subcontrollers count] > 0) {
//                if ([subcontrollers objectAtIndex:0] && [[subcontrollers objectAtIndex:0] respondsToSelector:@selector(controllerviewDidAppear)]) {
//                    [[subcontrollers objectAtIndex:0] performSelector:@selector(controllerviewDidAppear)];
//                }
//            }
//        }];
//    }else{
//        // 不支持动画，调用页面已经显示的方法
//        if (subcontrollers && [subcontrollers count] > 0) {
//            if ([subcontrollers objectAtIndex:0] && [[subcontrollers objectAtIndex:0] respondsToSelector:@selector(controllerviewDidAppear)]) {
//                [[subcontrollers objectAtIndex:0] performSelector:@selector(controllerviewDidAppear)];
//            }
//        }
//    }
//    // 恢复动画类型
//    [self reSetTransitionType];
}

#pragma mark-
#pragma mark ----- 动画类型设置 -----
/**
 @method    恢复视图控制器的切换动画默认值
 */
- (void)reSetTransitionType{
    self.transitionType = nil;
    self.TransitionSubType = nil;
}

/**
 @method    设置视图控制器的切换动画类型，当次动画有效，动画完毕后将会恢复默认值
 @param     type 切换动画类型
 */
- (void)setTransitionTypeWithType:(NSString*)type{
    self.transitionType = type;
}

/**
 @method    设置视图控制器的切换动画子类型（动画的切换方向），当次动画有效，动画完毕后将会恢复默认值
 @param     type 切换动画子类型（动画的切换方向）
 */
- (void)setTransitionSubTypeWithType:(NSString*)type{
    self.TransitionSubType = type;
}

@end
