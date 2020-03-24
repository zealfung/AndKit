//
//  AKShowMessage.m
//  AndKit
//
//  Created by Fengziyi on 2020/3/23.
//  Copyright © 2020 Andwho. All rights reserved.
//

#import "AKShowMessage.h"

static UIView *globalToastView = nil;

@implementation AKShowMessage

+ (UIView *)getRootView {
    UIWindow *currentwindow = [[UIApplication sharedApplication] delegate].window;
    return currentwindow;
}

+ (void)showToast:(NSString *)message {
    [AKShowMessage showToast:message inView:[AKShowMessage getRootView]];
}

+ (void)showToast:(NSString *)message inView:(UIView *)view {
    [AKShowMessage showToast:message inView:view position:AKToastShowPositionDefault duration:3.5];
}

+ (void)showToast:(NSString *)message inView:(UIView *)view position:(AKToastShowPosition)position duration:(CGFloat)duration {
    if (nil == view) {
        view = [AKShowMessage getRootView];
    }
    __block UIView *toastView = [[UIView alloc] initWithFrame:CGRectNull];
    toastView.layer.cornerRadius = 5.f;
    toastView.layer.masksToBounds = YES;
    toastView.backgroundColor = [UIColor blackColor];
    toastView.alpha = 0.9;
    toastView.userInteractionEnabled = NO;
    toastView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:toastView];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:16.f];
    messageLabel.numberOfLines = 0;
    messageLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30.f;
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [toastView addSubview:messageLabel];
    
    NSLayoutConstraint *toastViewCenterX = [toastView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor];
    NSLayoutConstraint *toastViewTop = [toastView.topAnchor constraintEqualToAnchor:view.topAnchor constant:120.f];
    if (position == AKToastShowPositionCenter) {
        toastViewTop = [toastView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor];
    }
    NSLayoutConstraint *toastViewLeft =
    [NSLayoutConstraint constraintWithItem:toastView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:messageLabel
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.f
                                  constant:-15.f];
    
    NSLayoutConstraint *toastViewRight =
    [NSLayoutConstraint constraintWithItem:toastView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:messageLabel
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.f
                                  constant:15.f];
    
    NSLayoutConstraint *toastViewBottom =
    [NSLayoutConstraint constraintWithItem:toastView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:messageLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.f
                                  constant:10.f];
    
    [NSLayoutConstraint activateConstraints:@[toastViewCenterX,toastViewTop,toastViewLeft,toastViewRight,toastViewBottom]];
    
    NSLayoutConstraint *labelCenterX = [messageLabel.centerXAnchor constraintEqualToAnchor:toastView.centerXAnchor];
    NSLayoutConstraint *labelTop = [messageLabel.topAnchor constraintEqualToAnchor:toastView.topAnchor constant:10.f];
    [NSLayoutConstraint activateConstraints:@[labelCenterX,labelTop]];
    
    [globalToastView removeFromSuperview];
    globalToastView = toastView;
    
    toastView.alpha = 0;
    toastView.transform = CGAffineTransformMakeTranslation(0, 15);
    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 1;
        toastView.transform = CGAffineTransformIdentity;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            toastView.alpha = 0;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
            toastView = nil;
            if (globalToastView == toastView) {
                globalToastView = nil;
            }
        }];
    });
}

+ (void)showPopup:(NSString *)message {
    [AKShowMessage showPopup:nil title:message cancelButton:nil moreButtons:nil moreButtonsClickedIndex:^(NSInteger index) {
        
    }];
}

+ (void)showPopup:(nullable NSString *)message title:(nullable NSString *)title cancelButton:(nullable NSString *)cancelButton moreButtons:(nullable NSArray<NSString *> *)moreButtons moreButtonsClickedIndex:(nonnull void (^)(NSInteger index))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *cancelTitle = @"OK";
    if (cancelButton.length > 0) {
        cancelTitle = cancelButton;
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:actionCancel];
    
    if (moreButtons.count > 0) {
        for (NSInteger i = 0; i < moreButtons.count; i++) {
            UIAlertAction *actionItem = [UIAlertAction actionWithTitle:moreButtons[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(i);
                }
            }];
            [alertController addAction:actionItem];
        }
    }
    [[AKShowMessage getTopController] presentViewController:alertController animated: YES completion: nil];
}

+ (__kindof UIViewController *)getTopController {
    UIWindow *currentwindow = [[UIApplication sharedApplication] delegate].window;
    return [self topViewControllerWithRootViewController:currentwindow.rootViewController];
}

+ (__kindof UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *nav = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else {
        
        return rootViewController;
    }
}

@end
