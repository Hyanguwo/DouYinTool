// Tweak.xm
#import <UIKit/UIKit.h>
#import "DouToolSettingViewController.h"

%hook UIWindow

- (instancetype)initWithFrame:(CGRect)frame {
    UIWindow *window = %orig(frame);
    if (window) {
        // 使用 UILongPressGestureRecognizer 进行三指长按
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        longPressGesture.minimumPressDuration = 1.0;  // 设置长按时间为1秒
        longPressGesture.numberOfTouchesRequired = 3; // 三指长按
        [window addGestureRecognizer:longPressGesture];
    }
    return window;
}

%new
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIViewController *rootViewController = self.rootViewController;
        if (rootViewController) {
            DouToolSettingViewController *settingVC = [[DouToolSettingViewController alloc] init];
            if (settingVC) {
                // 设置全屏显示
                settingVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [rootViewController presentViewController:settingVC animated:YES completion:nil];
            }
        }
    }
}

%end
