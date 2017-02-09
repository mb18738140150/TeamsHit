//
//  ActivityView.m
//  TeamsHit
//
//  Created by 仙林 on 16/11/16.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ActivityView.h"

#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define kWMActivityViewRefreshOffset 59.0
#define kWMActivityMaxOffestY (15.0 + 28.0)
#define kWMActivityImageViewSize 24.0

static NSString *const kRefreshControlIdle = @"kRefreshControlIdle";
static NSString *const kRefreshControlPulling = @"kRefreshControlPulling";
static NSString *const kRefreshControlRefreshing = @"kRefreshControlRefreshing";
static NSString *const kRefreshControlRefreshDone = @"kRefreshControlRefreshDone";

@interface ActivityView ()

@property (nonatomic) CGFloat prevProgress;
@property (nonatomic) CGFloat progress;

@property (nonatomic) CGFloat idleOriginY;

@property (nonatomic) CGSize activityViewSize;
@property (nonatomic) CGPoint activityViewOrigin;

@end


@implementation ActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _activityViewSize = frame.size;
        _activityViewOrigin = frame.origin;
        
        self.backgroundColor = [UIColor clearColor];
        _activityView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, kWMActivityImageViewSize, kWMActivityImageViewSize)];
        _activityView.image = [UIImage imageNamed:@"WMIcon@2x.png"];
        [self addSubview:_activityView];
        
        _state = kRefreshControlIdle;
        // _scrollView.panGestureRecognizer
    }
    return self;
}

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    CGRect frame = self.frame;
    frame.origin.y = _scrollView.frame.origin.y - self.activityViewSize.height;
    self.frame = frame;
    
    self.idleOriginY = self.frame.origin.y;
}

-(void)setOffsetY:(CGFloat)offsetY
{
    [self.activityView.layer removeAnimationForKey:@"animation"];
    CGFloat progress = fabs(offsetY) / kWMActivityViewRefreshOffset;
    CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180-180*self.prevProgress)];
    animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180-180*progress)];
    animationImage.duration = 0.1f;
    animationImage.removedOnCompletion = NO;
    animationImage.fillMode = kCAFillModeForwards;
    [self.activityView.layer addAnimation:animationImage forKey:@"animation"];
    self.prevProgress = progress;
    
    CGRect frame = self.frame;
    frame.origin.y = MIN(kWMActivityMaxOffestY , -offsetY) + self.idleOriginY;
    self.frame = frame;
}

-(void)startRefreshingAnimation
{
    [self.activityView.layer removeAnimationForKey:@"Rotation"];
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.7f;
    animation.cumulative = YES;
    animation.repeatCount = 100000;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.0 * M_PI],
                        [NSNumber numberWithFloat:0.75 * M_PI],
                        [NSNumber numberWithFloat:1.5 * M_PI], nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:.5],
                          [NSNumber numberWithFloat:1.0], nil];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.activityView.layer addAnimation:animation forKey:@"Rotation"];
    
    CGRect frame = self.frame;
    frame.origin.y = kWMActivityMaxOffestY + self.idleOriginY;
    self.frame = frame;
}

-(void) stopAnimation
{
    self.prevProgress = 0.0;
    [self.activityView.layer removeAnimationForKey:@"animation"];
    [self.activityView.layer removeAnimationForKey:@"Rotation"];
}

-(void) startDoneAnimation
{
    if(_scrollView.contentOffset.y < 0)
    {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.25];
    [UIView animateWithDuration:0.15 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = weakself.frame;
        frame.origin.y = _scrollView.frame.origin.y - self.activityViewSize.height;
        weakself.frame = frame;
    } completion:^(BOOL finished) {
        [weakself changeStateEx:kRefreshControlIdle andValue:nil];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    //添加到superview时，调整自身的frame
    self.frame = CGRectMake(self.activityViewOrigin.x, -self.activityViewSize.height , self.activityViewSize.height, self.activityViewSize.height);
}

- (void)didMoveToSuperview
{
    //添加到superview时，添加观察上层UITableView的contentOffset
    [self.superTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview
{
    if(self.superTableView)
    {
        //移除时，取消观察contentOffset
        [self.superTableView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
    
    [super removeFromSuperview];
}

- (void)changeStateEx:(NSString *)newState andValue:(NSValue *)value
{
    BOOL hasChanged = !(_state==newState);
    
    if(newState)
    {
        _state = newState;
        
        if([_state isEqualToString:kRefreshControlIdle] && hasChanged)
        {
            [self stopAnimation];
        }
        else if([_state isEqualToString:kRefreshControlPulling])
        {
            [self setOffsetY:[value CGPointValue].y];
        }
        else if([_state isEqualToString:kRefreshControlRefreshing] && hasChanged)
        {
            [self startRefreshingAnimation];
        }
        else if([_state isEqualToString:kRefreshControlRefreshDone] && hasChanged)
        {
            [self startDoneAnimation];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        
        if ([self refresh]) {
            return;
        }
        
        NSValue *offsetValue = [NSValue valueWithCGPoint:self.superTableView.contentOffset];
        
        if (_state == kRefreshControlIdle && self.superTableView.dragging && offsetValue.CGPointValue.y < 0)
        {
            [self changeStateEx:kRefreshControlPulling andValue:offsetValue];
        }else if (_state == kRefreshControlPulling)
        {
            if (offsetValue.CGPointValue.y > 0 && self.frame.origin.y > _scrollView.frame.origin.y - self.activityViewSize.height && self.superTableView.dragging == NO)
            {
                return;
            }
            
            [self changeStateEx:_state andValue:offsetValue];
            if (self.superTableView.decelerating ){
                if ( -offsetValue.CGPointValue.y >= kWMActivityViewRefreshOffset) {
                    
                    [self changeStateEx:kRefreshControlRefreshing andValue:nil];
                    
                    __weak typeof(self) weakself = self;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_refreshRequest) {
                            _refreshRequest(weakself);
                        }
                    });
                }else if(offsetValue.CGPointValue.y == 0)
                {
                    [self changeStateEx:kRefreshControlIdle andValue:nil];
                }
            }
        }
        else if (_state == kRefreshControlRefreshing)
        {
            CGRect frame = self.frame;
            frame.origin.y = MIN(kWMActivityMaxOffestY + self.idleOriginY , kWMActivityMaxOffestY + self.idleOriginY - offsetValue.CGPointValue.y);
            self.frame = frame;
        }
        else if (_state == kRefreshControlRefreshDone)
        {
            [self startDoneAnimation];
        }
    }
}

- (BOOL)refresh
{
    return [_state isEqualToString:kRefreshControlRefreshing];
}

- (UIScrollView *)superTableView
{
    return self.scrollView;
}

- (void)beginRefreshing
{
    if ([self refresh]) {
        return;
    }
    [self changeStateEx:kRefreshControlRefreshing andValue:nil];
}

- (void)endRefreshing
{
    [self changeStateEx:kRefreshControlRefreshDone andValue:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
