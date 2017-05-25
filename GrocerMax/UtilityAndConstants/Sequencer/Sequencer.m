//
//  Sequencer.m
//  Sequencer
//
//  Created by Deepak Soni on 12/8/14.
//  Copyright (c) 2012 Tal Kellton. All rights reserved.
//

#import "Sequencer.h"
@interface Sequencer()
@property (nonatomic, strong) NSMutableArray *steps;
@end

@implementation Sequencer

- (NSMutableArray *)steps {
    if (!_steps) {
        _steps = [NSMutableArray new];
    }
    return _steps;
}

- (void)run
{
    [self runNextStepWithResult:nil];
}

- (void)enqueueStep:(SequencerStep)step
{
    [self.steps addObject:[step copy]];
}

- (SequencerStep)dequeueNextStep
{
    SequencerStep step = [self.steps objectAtIndex:0];
    [self.steps removeObjectAtIndex:0];
    return step;
}

- (void)runNextStepWithResult:(id)result
{
    if ([self.steps count] <= 0) {
        return;
    }
    
    SequencerStep step = [self dequeueNextStep];
    
    step(result, ^(id nextRresult){
        [self runNextStepWithResult:nextRresult];
    });
}

@end
