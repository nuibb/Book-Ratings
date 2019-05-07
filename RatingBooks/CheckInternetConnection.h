//
//  CheckInternetConnection.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface CheckInternetConnection : NSObject
+ (BOOL) connectedToNetwork;
@end
