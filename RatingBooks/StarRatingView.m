//
//  StarRatingView.m
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//


#import "StarRatingView.h"
#define kLeftPadding 5.0f

@interface StarRatingView()

@property (nonatomic) int maxrating;
@property (nonatomic) int rating;
@property (nonatomic) float kLabelAllowance;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) CALayer* tintLayer;

@end

@implementation StarRatingView

- (id)initWithFrame:(CGRect)frame andRating:(int)rating {
    self = [super initWithFrame:frame];
    if (self) {
        //Get gps locations from data manager
        _rating = 0;
        _maxrating = rating;
        self.opaque = NO;
        self.kLabelAllowance = 50.0f;
        
        //Add label after star view to show rating as percentage
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - self.kLabelAllowance , 0,self.kLabelAllowance, frame.size.height)];
        self.label.font = [UIFont systemFontOfSize:18.0f];
        self.label.text = [NSString stringWithFormat:@"%d%%",rating];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        
        CGRect newrect = CGRectMake(0, 0, self.bounds.size.width - self.kLabelAllowance, self.bounds.size.height);
        CALayer* starBackground = [CALayer layer];
        starBackground.contents = (__bridge id)([UIImage imageNamed:@"5starsgray"].CGImage);
        starBackground.frame = newrect;
        [self.layer addSublayer:starBackground];
        
        self.tintLayer = [CALayer layer];
        self.tintLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        [self.tintLayer setBackgroundColor:[UIColor yellowColor].CGColor];
        
        [self.layer addSublayer:self.tintLayer];
        CALayer* starMask = [CALayer layer];
        starMask.contents = (__bridge id)([UIImage imageNamed:@"5starsgray"].CGImage);
        starMask.frame = newrect;
        [self.layer addSublayer:starMask];
        self.tintLayer.mask = starMask;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
    }
    
    return self;
}


- (void)increaseRating {
    if (_rating<_maxrating) {
        _rating = _rating + 1;
        if (self.label) {
            self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
        }
        
        if (_rating >= 50) {
            [self.tintLayer setBackgroundColor:[UIColor greenColor].CGColor];
            float barWitdhPercentage = (_rating/100.0f) *  (self.bounds.size.width - self.kLabelAllowance);
            self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
        } else {
            [self.tintLayer setBackgroundColor:[UIColor yellowColor].CGColor];
            float barWitdhPercentage = (_rating/100.0f) *  (self.bounds.size.width - self.kLabelAllowance);
            self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
        }
    } else {
        [self.timer invalidate];
    }
}

-(void) getValue:(CGFloat)value {
    _rating = 0;
    _maxrating = (int)value;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
}

@end
