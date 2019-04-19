//
//  DTPerframeAnimatior.h
//  DTPerframeAnimatior
//  perframe animator
//  Created by dreamtracer on 2019/4/16.
//  Copyright © 2019 dreamtracer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DTPerframeAnimatiorDirectionForward,
    DTPerframeAnimatiorDirectionBackward,
} DTPerframeAnimatiorDirection;

typedef void(^DTPerframeAnimatiorAnimationHandle)(CGFloat);

typedef void(^DTPerframeAnimatiorAnimationComplete)(void);



@interface DTPerframeAnimatior : NSObject

/**
 pause animation
 */
@property (nonatomic,assign)BOOL paused;


/**
 control animation progress  value[0.0~1.0]
 */
@property (nonatomic,assign)CGFloat progress;

/**
 progress direction
 */
@property (nonatomic,assign)DTPerframeAnimatiorDirection progressDirection;


/**
 create an animation and start

 @param duration animation duration
 @param animation animation handler
 @param completion completion handler
 @return animator object
 */
+ (DTPerframeAnimatior *)animateWithDuration:(NSTimeInterval)duration
                                  animations:(DTPerframeAnimatiorAnimationHandle)animation
                                  completion:(DTPerframeAnimatiorAnimationComplete)completion;

@end

NS_ASSUME_NONNULL_END
