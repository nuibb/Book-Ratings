//
//  GetServices.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetServices : NSObject
- (void) apiCallToGet: (NSString *)url callback: (void(^)(NSDictionary *))handler;
@end
