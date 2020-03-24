//
//  AKShowMessage.h
//  AndKit
//
//  Created by Fengziyi on 2020/3/23.
//  Copyright © 2020 Andwho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AKToastShowPosition) {
    AKToastShowPositionDefault,
    AKToastShowPositionCenter
};

@interface AKShowMessage : UIView

/** 显示toast消息，默认3.5秒
 * @param message 要显示的文案
 */
+ (void)showToast:(NSString *)message;
/** 显示toast消息，默认3.5秒
 * @param message 要显示的文案
 * @param view 在view之内显示
 */
+ (void)showToast:(NSString *)message inView:(UIView *)view;
/** 显示toast消息
 * @param message 要显示的文案
 * @param view 在父视图之内显示
 * @param position 显示位置
 * @param duration 持续时间
 */
+ (void)showToast:(NSString *)message inView:(UIView *)view position:(AKToastShowPosition)position duration:(CGFloat)duration;
/** 显示带按钮的弹窗
 * @param message 要显示的文案
 */
+ (void)showPopup:(NSString *)message;
/** 显示带按钮的弹窗
 * @param message 要显示的文案
 * @param title 标题
 * @param cancelButton 取消按钮
 * @param moreButtons 更多按钮
 * @param handler 更多按钮点击回调
 */
+ (void)showPopup:(nullable NSString *)message title:(nullable NSString *)title cancelButton:(nullable NSString *)cancelButton moreButtons:(nullable NSArray<NSString *> *)moreButtons moreButtonsClickedIndex:(void (^) (NSInteger index))handler;

@end

NS_ASSUME_NONNULL_END
