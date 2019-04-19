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
{
    CGFloat _tmpProgress;
    CFTimeInterval _tmpStartTime;
}
@property (nonatomic,assign)NSTimeInterval duration;

@property (nonatomic,assign)CFTimeInterval startTimeInterval;

@property (nonatomic,assign)CGFloat progress;

@property (nonatomic,copy)DTPerframeAnimatiorAnimationHandle animationHandle;


@property (nonatomic,copy)DTPerframeAnimatiorAnimationComplete animationComplete;

@property (nonatomic,assign)NSTimeInterval displayLinkDuration;

@property (nonatomic,weak)id<_DTPerframeAnimatiorTargetDelegate> delegate;

@property (nonatomic,assign)DTPerframeAnimatiorDirection progressDirection;

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
    if (_tmpStartTime == 0.0) {
        _tmpStartTime = CACurrentMediaTime();
    }

    if (self.progressDirection == DTPerframeAnimatiorDirectionForward) {
        _progress = (_tmpProgress / tan(M_PI_4) * self.duration + (CACurrentMediaTime() - _tmpStartTime))/self.duration * tan(M_PI_4);
    } else {
        _progress = (_tmpProgress / tan(M_PI_4) * self.duration - (CACurrentMediaTime() - _tmpStartTime))/self.duration * tan(M_PI_4);
    }
    
    
    if (_progress < 0) {
        _progress = 0.0;
        displayLink.paused = YES;
        _tmpProgress = _progress;
        _tmpStartTime = 0.0;
    } else if (_progress > 1.0) {
        _progress = 1.0;
        displayLink.paused = YES;
        _tmpProgress = _progress;
        _tmpStartTime = 0.0;
    }
    
    if (self.animationHandle) {
        self.animationHandle(self.progress);
    }
    
    if (self.animationHandle) {
        self.animationHandle(self.progress);
    }
    
    if (self.progress == 0.0 && self.progressDirection == DTPerframeAnimatiorDirectionBackward) {
        if (self.animationComplete) {
            self.animationComplete();
        }
    }
    
    if (self.progress == 1.0 && self.progressDirection == DTPerframeAnimatiorDirectionForward) {
        if (self.animationComplete) {
            self.animationComplete();
        }
    }
}

-(void)setProgressDirection:(DTPerframeAnimatiorDirection)progressDirection{
    if (_progressDirection != progressDirection) {
    	_progressDirection = progressDirection;
        _tmpProgress = self.progress;
        _tmpStartTime = CACurrentMediaTime();
    }
}


-(void)setProgress:(CGFloat)progress{
    if (progress > 1.0) {
        progress = 1.0;
        
    } else if(progress < 0.0) {
        progress = 0.0;
    }
    
    _tmpProgress = progress;
    _tmpStartTime = 0.0;
    
    _progress = progress;

    if (self.animationHandle) {
        self.animationHandle(progress);
    }
    
    if (progress == 0.0 && self.progressDirection == DTPerframeAnimatiorDirectionBackward) {
        if (self.animationComplete) {
            self.animationComplete();
        }
    }
    
    if (progress == 1.0 && self.progressDirection == DTPerframeAnimatiorDirectionForward) {
        if (self.animationComplete) {
            self.animationComplete();
        }
    }
}

-(void)setTempStartTime:(CFTimeInterval)time{
    _tmpStartTime = time;
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
        [self setProgress:self.progress];
        self.displayLink.paused = NO;
    }
}

-(void)setProgressDirection:(DTPerframeAnimatiorDirection)progressDirection{
    _progressDirection = progressDirection;
    self.target.progressDirection = progressDirection;
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
