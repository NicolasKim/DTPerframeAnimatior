# DTPerframeAnimatior
Simple perframe animation tool that control animation progress.

# Usage

## Creation
```
_animator = [DTPerframeAnimatior animateWithDuration:5 animations:^(CGFloat progress) {
            self.widthConstraint.constant = 100 + 200 * progress;
            [self.slider setValue:progress];
        } completion:^{
            NSLog(@"complete");
        }];        
        
```
## Pause/Continue

```
_animator.paused = YES; or _animator.paused = NO;
```

## Control progress

```
_animator.paused = YES;
_animator.progress = 0.5;
```
## Reverse progress increasing

```
_animator.progressDirection = DTPerframeAnimatiorDirectionBackward;
```
# Example timeline
![timeline](https://github.com/NicolasKim/DTPerframeAnimatior/blob/master/timeline.png)
# Demo
![ScreenRecord](https://github.com/NicolasKim/DTPerframeAnimatior/blob/master/1555462981382.gif)

