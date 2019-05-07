//
//  RatingViewController.m
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import "RatingViewController.h"
#import "StarRatingView.h"
#import <Parse/Parse.h>
#import "ShowAlert.h"

#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f

@interface RatingViewController ()

- (IBAction)postToParseAndSave:(id)sender;
@property (strong, nonatomic) UITextView *activeTextView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation RatingViewController

-(void) configureUI {
    //Customise text view
    self.slider.value = [_book valueForKey:@"rating"] ? [[_book valueForKey:@"rating"] floatValue]/100.0f : 0.00f;
    self.textView.layer.borderWidth = 2;
    self.textView.layer.borderColor = [[UIColor purpleColor] CGColor];
    self.textView.text = [_book valueForKey:@"perception"] ? [_book valueForKey:@"perception"] : @"Write your perception here about this book...";
    
    //Check box button controll setup
    self.checkBoxButton.layer.borderWidth = 2;
    self.checkBoxButton.layer.borderColor = [[UIColor purpleColor] CGColor];
    [self.checkBoxButton setImage:nil forState:UIControlStateNormal];
    [self.checkBoxButton setImage:[UIImage imageNamed:@"Tick Image"] forState:UIControlStateSelected];
    
    // set up the tap gesture recognizer for check box button
    UITapGestureRecognizer *tapGestureForCheckBox = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(toggleCheckBoxSelection:)];
    [self.checkBoxButton addGestureRecognizer:tapGestureForCheckBox];
    
    //Radio button controll setup
    [self.radioBoxButton setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [self.radioBoxButton setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateSelected];
    
    // set up the tap gesture recognizer for check box button
    UITapGestureRecognizer *tapGestureForRadioButton = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(toggleRadioButtonSelection:)];
    [self.radioBoxButton addGestureRecognizer:tapGestureForRadioButton];
}

-(void) addRatingViewConfiguration {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *rating = [formatter numberFromString:[_book valueForKey:@"rating"] ? [_book valueForKey:@"rating"] : 0];
    StarRatingView* starView = [[StarRatingView alloc]initWithFrame:CGRectMake(5, 8, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating: rating.intValue];
    [self.ratingView addSubview:starView];
    self.delegate = starView;
}

-(void) addActivityIndicatorToRootView {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.color = [UIColor purpleColor];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.hidden = YES;
    [self.view addSubview:self.activityIndicator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUI];
    [self addActivityIndicatorToRootView];
    
    //Add rating view to the controller
    [self addRatingViewConfiguration];
    
    //Moving Content That Is Located Under the Keyboard
    [self registerForKeyboardNotifications];
}

- (IBAction)toggleCheckBoxSelection:(id)sender {
    self.checkBoxButton.selected = !self.checkBoxButton.selected;
    if (self.checkBoxButton.selected) {
        self.AnsLabel2.text = @"Yes";
    } else {
        self.AnsLabel2.text = @"No";
    }
}

- (IBAction)toggleRadioButtonSelection:(id)sender {
    self.radioBoxButton.selected = !self.radioBoxButton.selected;
    if (self.radioBoxButton.selected) {
        self.AnsLabel3.text = @"Yes";
    } else {
        self.AnsLabel3.text = @"No";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![self.imotIconTextField.text isEqualToString:@""]) {
        [self.tickImage setImage:[UIImage imageNamed:@"Tick Image.png"]];
    } else {
        self.tickImage.image = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.imotIconTextField resignFirstResponder];
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    self.activeTextView = textView;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeTextView = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([textView.text isEqualToString:@""]) {
            self.textView.text = @"Write your perception here about this book...";
        }
        return NO;
    }
    return YES;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 10.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextView.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)sliderValueChange:(id)sender {
    [self.delegate getValue:self.slider.value * 100];
}

- (IBAction)postToParseAndSave:(id)sender {
    if (_objectId) {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
        PFQuery *query = [PFQuery queryWithClassName:@"BookList"];
        [query getObjectInBackgroundWithId:_objectId block:^(PFObject *book, NSError *error){
            
            if (error) {
                [ShowAlert alertWithMessage:@"Error!" message:error.description];
            }
            
            book[@"feelings"] = self.imotIconTextField.text;
            book[@"rating"] = [NSString stringWithFormat:@"%d", (int)(self.slider.value * 100)];
            book[@"perception"] = [self.textView.text isEqualToString:@"Write your perception here about this book..."] ? @"" : self.textView.text;
            book[@"isThrilled"] = self.checkBoxButton.selected ? @"Yes" : @"No";
            book[@"isReader"] = self.checkBoxButton.selected ? @"Yes" : @"No";
            
            [book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.textView.text = @"Write your perception here about this book...";
                    self.slider.value = 0.00f;
                    [ShowAlert alertWithMessage:@"Message!" message:@"Successfully posted to the cloud server."];
                } else {
                    [ShowAlert alertWithMessage:@"Error!" message:error.description];
                }
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }];
        }];
    }
}
@end
