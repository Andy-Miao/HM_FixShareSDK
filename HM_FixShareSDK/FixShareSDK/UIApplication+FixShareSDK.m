//
//  UIApplication+FixShareSDK.m
//  HM_FixShareSDK
//
//  Created by humiao on 2019/8/15.
//  Copyright © 2019 syc. All rights reserved.
//

#import "UIApplication+FixShareSDK.h"
#import <objc/runtime.h>

@implementation UIApplication (FixShareSDK)
+ (void)load {
    swizzleMethod([self class], @selector(statusBarOrientation), @selector(swizzled_statusBarOrientation));
}

- (void)swizzled_statusBarOrientation {
    if (![NSThread currentThread].isMainThread) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self swizzled_statusBarOrientation];
        }];
    } else {
        [self swizzled_statusBarOrientation];
    }
    
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
