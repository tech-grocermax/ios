//
//  Sequencer.h
//  Sequencer
//
//  Created by Deepak Soni on 12/8/14.
//  Copyright (c) 2012 Kellton. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SequencerCompletion)(id result);
typedef void(^SequencerStep)(id result, SequencerCompletion completion);


@interface Sequencer : NSObject {}

- (void)run;
- (void)enqueueStep:(SequencerStep)step;

@end
