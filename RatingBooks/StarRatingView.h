//
//  StarRatingView.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RatingViewController.h"

@interface StarRatingView : UIView <DelegateForSlider>

- (id)initWithFrame:(CGRect)frame andRating:(int)rating;

@end
