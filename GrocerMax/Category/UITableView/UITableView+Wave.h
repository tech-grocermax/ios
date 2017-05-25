
#define kBOUNCE_DISTANCE  4.f
#define kWAVE_DURATION   2.0f

#import <UIKit/UIKit.h>

typedef void (^WaveHanlder)(BOOL finished);

typedef NS_ENUM(NSInteger,WaveAnimation) {
    LeftToRightWaveAnimation = -1,
    RightToLeftWaveAnimation = 1
};

@interface UITableView (Wave)

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation completionHanlder:(WaveHanlder)handler;

@end
