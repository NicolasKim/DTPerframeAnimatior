//
//  ViewController.m
//  DTPerframeAnimatior
//
//  Created by dreamtracer on 2019/4/16.
//  Copyright © 2019 dreamtracer. All rights reserved.
//

#import "ViewController.h"
#import "DTPerframeAnimatior.h"
@interface ViewController ()
{
    DTPerframeAnimatior * _animator;
}
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@end

@implementation ViewController
- (IBAction)sliderValueChanged:(UISlider *)sender {
    _animator.progress = sender.value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

-(void)didClickPause{
    _animator.paused = YES;
}
- (IBAction)startClick:(id)sender {
    if (!_animator) {
        _animator = [DTPerframeAnimatior animateWithDuration:10 animations:^(CGFloat progress) {
            
//            NSLog(@"%@  --- %lf",direction == DTPerframeAnimatiorDirectionForward ? @"forward" : @"backward",progress);
            
            
//            if (direction == DTPerframeAnimatiorDirectionForward) {
                self.widthConstraint.constant = 100 + 200 * progress;
                [self.slider setValue:progress];
//            } else {
//                self.widthConstraint.constant = 100 + 200 * progress;
//                [self.slider setValue:progress];
//            }
            
        } completion:^{
            NSLog(@"complete");
        }];
    }
    _animator.paused = NO;
    
}
- (IBAction)pauseClick:(id)sender {
    _animator.paused = YES;
}
- (IBAction)resetClick:(id)sender {
    _animator.progress = 0;
}

- (IBAction)directionChange:(UIButton *)sender {
    _animator.progressDirection = sender.selected ? DTPerframeAnimatiorDirectionForward: DTPerframeAnimatiorDirectionBackward;
    sender.selected = !sender.selected;
}



@end
