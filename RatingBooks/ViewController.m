//
//  ViewController.m
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <Parse/Parse.h>
#import "ViewController.h"
#import "RatingViewController.h"
#import "ShowAlert.h"

@interface ViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControll;
@property (strong, nonatomic) NSMutableArray *bookList;
@property NSInteger numberOfBooksToSkip;

@end

@implementation ViewController

- (void) refresh:(UIRefreshControl *) refreshControll {
    [self.tableView reloadData];
    [refreshControll endRefreshing];
}

-(void) addRefreshControllerUI {
    self.refreshControll = [[UIRefreshControl alloc] init];
    self.refreshControll.backgroundColor = [UIColor purpleColor];
    self.refreshControll.tintColor = [UIColor whiteColor];
    [self.refreshControll addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControll];
}

- (void) getDataFromParse {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"BookList"];
    query.skip = self.numberOfBooksToSkip;
    self.numberOfBooksToSkip += 10;
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [ShowAlert alertWithMessage:@"Warning!" message:@"Data could not be fetched. May be some network error!"];
        } else {
            for (NSDictionary *item in objects) {
                [self.bookList addObject:item];
            }
            
            [self.tableView reloadData];
        }
        
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }];
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
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = 70;
    self.numberOfBooksToSkip = 0;
    self.bookList = [[NSMutableArray alloc] init];
    
    [self addRefreshControllerUI];
    [self addActivityIndicatorToRootView];
    
    //Get Data from parse backend storage
    [self getDataFromParse];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.bookList.count == 0) {
        /*UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 120, self.view.bounds.size.height/2, 100, 30)];
         label.text = @"Loading...";
         label.numberOfLines = 0;
         label.textAlignment = NSTextAlignmentCenter;
         label.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
         [label sizeToFit];
         
         self.tableView.backgroundView = label;*/
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    NSDictionary *bookItem = self.bookList[indexPath.row];
    cell.textLabel.text = [bookItem objectForKey:@"name"];
    cell.detailTextLabel.text = [bookItem objectForKey:@"author"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.bookList[indexPath.row] objectId]) {
        [self performSegueWithIdentifier:@"showRatingView" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRatingView"]) {
        RatingViewController *controller = (RatingViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.objectId = [self.bookList[indexPath.row] objectId];
        controller.book = self.bookList[indexPath.row];
    }
}

/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (indexPath.row == self.bookList.count - 1) {
 //Load more books
 [self getDataFromParse];
 NSLog(@"No Refreshing..");
 } else {
 NSLog(@"Refreshing..");
 }
 }*/

-(void) scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ((maximumOffset - currentOffset) <= 10.0) {
        //Load more books
        [self getDataFromParse];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
