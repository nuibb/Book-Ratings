//
//  RatingViewController.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarRatingView; //define class, so protocol can see that class

@protocol DelegateForSlider <NSObject>   //define delegate protocol

- (void) getValue:(CGFloat)value;  //define delegate method to be implemented within another class

@end

@interface RatingViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) id <DelegateForSlider> delegate; //define DelegateForSlider as delegate

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSDictionary *book;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *QLabel1;
@property (weak, nonatomic) IBOutlet UILabel *QLabel2;
@property (weak, nonatomic) IBOutlet UILabel *QLabel3;
@property (weak, nonatomic) IBOutlet UILabel *QLabel4;
@property (weak, nonatomic) IBOutlet UILabel *AnsLabel2;
@property (weak, nonatomic) IBOutlet UILabel *AnsLabel3;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *radioBoxButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *tickImage;
@property (weak, nonatomic) IBOutlet UITextField *imotIconTextField;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)toggleRadioButtonSelection:(id)sender;
- (IBAction)toggleCheckBoxSelection:(id)sender;
- (IBAction)sliderValueChange:(id)sender;

@end

