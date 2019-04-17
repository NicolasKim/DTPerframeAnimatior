# DTPerframeAnimatior
simple perframe animation tool that control animation progress

#Usage

##creation
```
_animator = [DTPerframeAnimatior animateWithDuration:5 animations:^(CGFloat progress) {
            self.widthConstraint.constant = 100 + 200 * progress;
            [self.slider setValue:progress];
        } completion:^{
            NSLog(@"complete");
        }];        
        
```
##pause/start

```
_animator.paused = YES; or _animator.paused = NO;
```

##control progress

```
_animator.paused = YES;
_animator.progress = 0.5;
```


#Demo
[![Watch the video](https://github.com/NicolasKim/DTPerframeAnimatior/blob/master/IMG_4C827E4F2394-1.jpeg)](https://github.com/NicolasKim/DTPerframeAnimatior/blob/master/ScreenRecording_04-17-2019 08-56-55.MP4)
