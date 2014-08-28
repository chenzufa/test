//版权所有：版权所有(C) 2013，不亦乐乎科技有限公司
//系统名称：HighHand
//文件名称：ModelManager
//作　　者  冯炳发
//完成日期：13-03-25
//功能说明：视图控制器管理类
//----------------------------------------

#import <Foundation/Foundation.h>

@class ModelManager;
@protocol ModelManagerDelegate;

ModelManager                    *g_modelManager;                    // 视图控制器单例

@interface ModelManager : NSObject{
    NSMutableArray              *subcontrollers;                    // 子控制器数组
    UIViewController            *rootviewcontroller;                // 父控制器
    NSString                    *transitionType;                    // 动画类型
    NSString                    *TransitionSubType;                 // 动画方向
}

@property (retain, nonatomic) NSString* transitionType;             // 动画类型，动画前设置
@property (retain, nonatomic) NSString* TransitionSubType;          // 动画子类型，动画前设置

/**
 @method    获取视图管理控制器单例
 @result    返回视图管理控制器单例
 */
+ (id)shareManager;

/**
 @method    释放视图管理控制器单例（程序退出后由主界面调用，慎用）
 */
+ (void)releaseManager;

/**
 @method    设置主视图管理控制器
 @param     controller 主视图管理控制器
 */
- (void)setRootControllerWith:(UIViewController*)controller;

/**
 @method    推入视图控制器
 @param     controller 推入的视图控制器
 @param     obj 视图控制器管理类代理
 @param     supportAnimation 是否支持动画
 */
- (void)pushController:(UIViewController*)controller
          WithDelegate:(id<ModelManagerDelegate>)obj
     supportTransition:(BOOL)supportAnimation;

/**
 @method    推出视图控制器
 @param     controller 推出的视图控制器
 @param     obj 视图控制器管理类代理
 @param     supportAnimation 是否支持动画
 */
- (void)popController:(UIViewController*)controller
         WithDelegate:(id<ModelManagerDelegate>)obj
    supportTransition:(BOOL)supportAnimation;

/**
 @method    返回到根视图控制器
 @param     obj 视图控制器管理类代理
 @param     supportAnimation 是否支持动画
 */
- (void)popToRootControllerWithDelegate:(id<ModelManagerDelegate>)obj
                      supportTransition:(BOOL)supportAnimation;

/**
 @method    设置视图控制器的切换动画类型，当次动画有效，动画完毕后将会恢复默认值
 @param     type 切换动画类型
 */
- (void)setTransitionTypeWithType:(NSString*)type;

/**
 @method    设置视图控制器的切换动画子类型（动画的切换方向），当次动画有效，动画完毕后将会恢复默认值
 @param     type 切换动画子类型（动画的切换方向）
 */
- (void)setTransitionSubTypeWithType:(NSString*)type;

@end

// 视图控制器管理类代理
@protocol ModelManagerDelegate <NSObject>
@optional
/**
 @method    视图将要被移除
 */
- (void)controllerViewWillDisappear;

/**
 @method    视图将要出现
 */
- (void)controllerViewWillAppear;

/**
 @method    视图已经出现
 */
- (void)controllerviewDidAppear;

/**
 @method    视图已经被移除
 */
- (void)controllerViewDidDisappear;

@end
