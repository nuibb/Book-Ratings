//
//  ShowAlert.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShowAlert : NSObject
+ (void) alertWithMessage:(NSString *) title message:(NSString *)msg;
@end
