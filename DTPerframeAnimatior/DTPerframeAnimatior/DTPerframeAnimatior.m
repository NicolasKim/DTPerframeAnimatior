//
//  DTPerframeAnimatior.m
//  DTPerframeAnimatior
//
//  Created by dreamtracer on 2019/4/16.
//  Copyright © 2019 dreamtracer. All rights reserved.
//

#import "DTPerframeAnimatior.h"


@protocol _DTPerframeAnimatiorTargetDelegate <NSObject>

-(void)animationDidFinished;

@end

@interface _DTPerframeAnimatiorTarget : NSObject

@property (nonatomic,assign)NSTimeInterval duration;

@property (nonatomic,assign)CFTimeInterval startTimeInterval;

@property (nonatomic,assign)CGFloat progress;

@property (nonatomic,copy)DTPerframeAnimatiorAnimationHandle animationHandle;


@property (nonatomic,copy)DTPerframeAnimatiorAnimationComplete animationComplete;

@property (nonatomic,assign)NSTimeInterval displayLinkDuration;

@property (nonatomic,weak)id<_DTPerframeAnimatiorTargetDelegate> delegate;

-(void)handleDisplayLink:(CADisplayLink *)displayLink;

@end

@implementation _DTPerframeAnimatiorTarget
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.displayLinkDuration = 1.0/60.0;
    }
    return self;
}
-(void)handleDisplayLink:(CADisplayLink *)displayLink{
    
    CFTimeInterval passedTime 	 = (CACurrentMediaTime() - self.startTimeInterval);
    CFTimeInterval passedPercent = passedTime / self.duration;
    CFTimeInterval percent = passedPercent;//-cos(passedPercent * (M_PI/2))+1;//-0.5*cos(M_PI*passedPercent)+0.5;
    _progress = percent;
    if (percent >= 1.0) {
        percent = 1.0;
        displayLink.paused = YES;
    } else {
        
    }
    
    
    if (self.animationHandle) {
        self.animationHandle(percent);
    }
    
    if (percent == 1.0) {
        if (self.animationComplete) {
            self.animationComplete();
        }
        [self.delegate animationDidFinished];
    }
}

-(void)setProgress:(CGFloat)progress{
    if (progress > 1.0) {
        progress = 1.0;
    }
    _progress = progress;
    
    
    if (self.animationHandle) {
        self.animationHandle(progress);
    }
    
    if (progress == 1.0) {
        if (self.animationComplete) {
            self.animationComplete();
        }
        [self.delegate animationDidFinished];
    }
}

-(void)dealloc{
    NSLog(@"target 销毁");
}

@end

@interface DTPerframeAnimatior ()<_DTPerframeAnimatiorTargetDelegate>
@property (nonatomic,strong)CADisplayLink * displayLink;

@property (nonatomic,weak)_DTPerframeAnimatiorTarget * target;
@end


@implementation DTPerframeAnimatior

-(void)setPaused:(BOOL)paused{
    _paused = paused;
    if (paused) {
        if (_displayLink) {
            _displayLink.paused = YES;
        }
    }
    else{
        self.target.startTimeInterval = CACurrentMediaTime() - self.target.duration * self.target.progress;
        self.displayLink.paused = NO;
    }
}

-(void)setProgress:(CGFloat)progress{
    self.target.progress = progress;
}
-(CGFloat)progress{
    return self.target.progress;
}

-(void)animationDidFinished{
	_displayLink.paused = YES;
}

+ (DTPerframeAnimatior *)animateWithDuration:(NSTimeInterval)duration
                                  animations:(DTPerframeAnimatiorAnimationHandle)animation
                                  completion:(DTPerframeAnimatiorAnimationComplete)completion{
    DTPerframeAnimatior * animator = [[DTPerframeAnimatior alloc] init];
    [animator displayLink];
    animator.target.startTimeInterval = CACurrentMediaTime();
    animator.target.duration = duration;
    animator.target.animationHandle = animation;
    animator.target.animationComplete = completion;
    animator.paused = NO;
    return animator;
}

-(CADisplayLink *)displayLink{
    if (!_displayLink) {
        _DTPerframeAnimatiorTarget * target = [[_DTPerframeAnimatiorTarget alloc] init];
        target.delegate = self;
        self.target = target;
        _displayLink = [CADisplayLink displayLinkWithTarget:target selector:@selector(handleDisplayLink:)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

-(void)dealloc{
    NSLog(@"animator 销毁");
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}


@end
