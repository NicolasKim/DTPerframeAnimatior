# DTPerframeAnimatior
simple perframe animation tool that control animation progress

# Usage

## creation
```
_animator = [DTPerframeAnimatior animateWithDuration:5 animations:^(CGFloat progress) {
            self.widthConstraint.constant = 100 + 200 * progress;
            [self.slider setValue:progress];
        } completion:^{
            NSLog(@"complete");
        }];        
        
```
## pause/start

```
_animator.paused = YES; or _animator.paused = NO;
```

## control progress

```
_animator.paused = YES;
_animator.progress = 0.5;
```


# Demo
![ScreenRecord](https://github.com/NicolasKim/DTPerframeAnimatior/blob/master/1555462981382.gif)

