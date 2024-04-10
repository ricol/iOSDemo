//
//  AnimationViewController.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/27.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

@property (strong) CALayer *testLayer;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.testLayer = [[CALayer alloc] init];
    self.testLayer.backgroundColor = [UIColor redColor].CGColor;
    self.testLayer.frame = CGRectInset(self.view.layer.bounds, 100, 100);
    [self.view.layer addSublayer:self.testLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:self.testLayer.presentationLayer.position];
        animation.toValue = [NSValue valueWithCGPoint:point];
        animation.duration = 1.f;//动画时长
        animation.removedOnCompletion = NO;//是否在完成时移除
        animation.fillMode = kCAFillModeForwards;//动画结束后是否保持状态
        [self.testLayer addAnimation:animation forKey:@"positionAnimation"];
    }
    
    {
        CATransition *animation = [CATransition animation];
        animation.startProgress = 0;//开始进度
        animation.endProgress = 1;//结束进度
        animation.type = kCATransitionReveal;//过渡类型
        animation.subtype = kCATransitionFromLeft;//过渡方向
        animation.duration = 1.f;
        UIColor *color = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.f];
        self.testLayer.backgroundColor = color.CGColor;
        [self.testLayer addAnimation:animation forKey:@"transition"];
    }
}

@end
