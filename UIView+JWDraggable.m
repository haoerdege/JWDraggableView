//
//  UIView+JWDraggable.m
//  DraggableView
//
//  Created by JW on 2017/7/26.
//  Copyright © 2017年 JW. All rights reserved.
//

#import "UIView+JWDraggable.h"
#import <objc/runtime.h>

@implementation UIView (Draggable)

- (void)makeDraggable
{
    NSAssert(self.superview, @"Super view is required when make view draggable");
    
    [self makeDraggableInView:self.superview damping:0.4];
}

- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping
{
    if (!view) return;
    [self removeDraggable];
    
    self.jw_playground = view;
    self.jw_damping = damping;
    
    [self jw_creatAnimator];
    [self jw_addPanGesture];
}

- (void)removeDraggable
{
    [self removeGestureRecognizer:self.jw_panGesture];
    self.jw_panGesture = nil;
    self.jw_playground = nil;
    self.jw_animator = nil;
    self.jw_snapBehavior = nil;
    self.jw_attachmentBehavior = nil;
    self.jw_centerPoint = CGPointZero;
}

- (void)updateSnapPoint
{
    self.jw_centerPoint = [self convertPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) toView:self.jw_playground];
    self.jw_snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:self.jw_centerPoint];
    self.jw_snapBehavior.damping = self.jw_damping;
}

- (void)jw_creatAnimator
{
    self.jw_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.jw_playground];
    [self updateSnapPoint];
}

- (void)jw_addPanGesture
{
    self.jw_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(jw_panGesture:)];
    [self addGestureRecognizer:self.jw_panGesture];
}

#pragma mark - Gesture

- (void)jw_panGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint panLocation = [pan locationInView:self.jw_playground];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        [self updateSnapPoint];
        
        UIOffset offset = UIOffsetMake(panLocation.x - self.jw_centerPoint.x, panLocation.y - self.jw_centerPoint.y);
        [self.jw_animator removeAllBehaviors];
        self.jw_attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self
                                                               offsetFromCenter:offset
                                                               attachedToAnchor:panLocation];
        [self.jw_animator addBehavior:self.jw_attachmentBehavior];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        [self.jw_attachmentBehavior setAnchorPoint:panLocation];
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled ||
             pan.state == UIGestureRecognizerStateFailed)
    {
        [self.jw_animator addBehavior:self.jw_snapBehavior];
        [self.jw_animator removeBehavior:self.jw_attachmentBehavior];
    }
}

#pragma mark - Associated Object

- (void)setJw_playground:(id)object {
    objc_setAssociatedObject(self, @selector(jw_playground), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)jw_playground {
    return objc_getAssociatedObject(self, @selector(jw_playground));
}

- (void)setJw_animator:(id)object {
    objc_setAssociatedObject(self, @selector(jw_animator), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIDynamicAnimator *)jw_animator {
    return objc_getAssociatedObject(self, @selector(jw_animator));
}

- (void)setJw_snapBehavior:(id)object {
    objc_setAssociatedObject(self, @selector(jw_snapBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UISnapBehavior *)jw_snapBehavior {
    return objc_getAssociatedObject(self, @selector(jw_snapBehavior));
}

- (void)setJw_attachmentBehavior:(id)object {
    objc_setAssociatedObject(self, @selector(jw_attachmentBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIAttachmentBehavior *)jw_attachmentBehavior {
    return objc_getAssociatedObject(self, @selector(jw_attachmentBehavior));
}

- (void)setJw_panGesture:(id)object {
    objc_setAssociatedObject(self, @selector(jw_panGesture), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIPanGestureRecognizer *)jw_panGesture {
    return objc_getAssociatedObject(self, @selector(jw_panGesture));
}

- (void)setJw_centerPoint:(CGPoint)point {
    objc_setAssociatedObject(self, @selector(jw_centerPoint), [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)jw_centerPoint {
    return [objc_getAssociatedObject(self, @selector(jw_centerPoint)) CGPointValue];
}

- (void)setJw_damping:(CGFloat)damping {
    objc_setAssociatedObject(self, @selector(jw_damping), @(damping), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)jw_damping {
    return [objc_getAssociatedObject(self, @selector(jw_damping)) floatValue];
}

@end
