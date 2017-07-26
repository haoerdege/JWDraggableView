//
//  UIView+JWDraggable.h
//  DraggableView
//
//  Created by JW on 2017/7/26.
//  Copyright © 2017年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draggable)

/**
 *  Make view draggable.
 *
 *  @param view    Animator reference view, usually is super view.
 *  @param damping Value from 0.0 to 1.0. 0.0 is the least oscillation. default is 0.4.
 */
- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping;
- (void)makeDraggable;

/**
 *  Disable view draggable.
 */
- (void)removeDraggable;

@end
