//
// Created by akuraru on 2014/10/19.
// Copyright (c) 2014 akuraru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AKUSnapshotService.h"

@interface AKUSnapshotService ()
@end

@implementation AKUSnapshotService {

}

+ (UIImage *)snapshotViewOrLayer:(id)viewOrLayer {
    CALayer *layer = nil;

    if ([viewOrLayer isKindOfClass:[UIView class]]) {
        return [self _renderView:viewOrLayer];
    } else if ([viewOrLayer isKindOfClass:[CALayer class]]) {
        layer = (CALayer *) viewOrLayer;
        [layer layoutIfNeeded];
        return [self _renderLayer:layer];
    } else {
        [NSException raise:@"Only UIView and CALayer classes can be snapshotted" format:@"%@", viewOrLayer];
    }
    return nil;
}

+ (UIImage *)_renderLayer:(CALayer *)layer {
    CGRect bounds = layer.bounds;

    NSAssert1(CGRectGetWidth(bounds), @"Zero width for layer %@", layer);
    NSAssert1(CGRectGetHeight(bounds), @"Zero height for layer %@", layer);

    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSAssert1(context, @"Could not generate context for layer %@", layer);

    CGContextSaveGState(context);
    {
        [layer renderInContext:context];
    }
    CGContextRestoreGState(context);

    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapshot;
}

+ (UIImage *)_renderView:(UIView *)view {
#ifdef __IPHONE_7_0
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
#endif
    [view layoutIfNeeded];
    return [self _renderLayer:view.layer];
}
@end
