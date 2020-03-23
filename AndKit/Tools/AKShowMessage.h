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

///显示toast消息，默认3.5秒
///@param message 要显示的文案
+ (void)showToast:(NSString *)message;
///显示toast消息，默认3.5秒
///@param message 要显示的文案
///@param view 在view之内显示
+ (void)showToast:(NSString *)message inView:(UIView *)view;
///显示toast消息
///@param message 要显示的文案
///@param view 在view之内显示
///@param position 显示位置
///@param duration 持续时间
+ (void)showToast:(NSString *)message inView:(UIView *)view position:(AKToastShowPosition)position duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END