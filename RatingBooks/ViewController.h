//
//  ViewController.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

