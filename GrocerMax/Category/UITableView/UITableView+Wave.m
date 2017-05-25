//
//  UITableView+Wave.m
//  TableViewWaveDemo
//
//  Created by jason on 14-4-23.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "UITableView+Wave.h"
#import <QuartzCore/QuartzCore.h>

static int count = 0;
static WaveHanlder globalHanlder;

@implementation UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation completionHanlder:(WaveHanlder)handler
{
    globalHanlder = handler;
    
    [self setContentOffset:self.contentOffset animated:NO];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    [self reloadData];
    [self visibleRowsBeginAnimation:animation];
    
    count = 0;
}


- (void)visibleRowsBeginAnimation:(WaveAnimation)animation
{
    NSArray *array = [self indexPathsForVisibleRows];
    
    for (int i=0 ; i < [array count]; i++) {
        
        NSIndexPath *path = [array objectAtIndex:i];
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        
        cell.frame = [self rectForRowAtIndexPath:path];
        cell.hidden = YES;
        
        [cell.layer removeAllAnimations];
        
        NSArray *array = @[path,[NSNumber numberWithInt:animation]];
        [self performSelector:@selector(animationStart:) withObject:array afterDelay:.1*(i+1)];
    }
}

- (void)animationStart:(NSArray *)array
{
    NSIndexPath *path = [array objectAtIndex:0];
    
    float i = [((NSNumber*)[array objectAtIndex:1]) floatValue];
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:path];
    
    CGPoint originPoint = cell.center;
    
    CGPoint beginPoint = CGPointMake((cell.frame.size.width-100)*i, originPoint.y);
    CGPoint endBounce1Point = CGPointMake(originPoint.x-i*2*kBOUNCE_DISTANCE, originPoint.y);
    CGPoint endBounce2Point  = CGPointMake(originPoint.x+i*kBOUNCE_DISTANCE, originPoint.y);
    
    cell.hidden = NO;
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    move.keyTimes=@[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:1.0]];
    
    move.values=@[[NSValue valueWithCGPoint:beginPoint],[NSValue valueWithCGPoint:endBounce1Point],[NSValue valueWithCGPoint:endBounce2Point],[NSValue valueWithCGPoint:originPoint]];
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CAKeyframeAnimation *opacityLabel = [CAKeyframeAnimation animationWithKeyPath: @"opacity"];
    opacityLabel.values   = @[@0,@0,@0,@0,@1];
    opacityLabel.keyTimes = @[@0,@.2,@.4,@.5,@1];
    opacityLabel.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    
    CABasicAnimation *opaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opaAnimation.fromValue = @(0.f);
    opaAnimation.toValue = @(1.f);
    opaAnimation.duration = 1.0f;
    opaAnimation.autoreverses = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacityLabel,move];
    group.duration = kWAVE_DURATION;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    [cell.layer addAnimation:group forKey:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    count++;
    
    if (count == [[self visibleCells] count]) {
        if (globalHanlder!=nil) {
            globalHanlder(true);
        }
    }
}

@end
