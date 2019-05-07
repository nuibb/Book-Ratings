//
//  Settings.h
//  RatingBooks
//
//  Created by Nuibb on 8/30/15.
//  Copyright (c) 2015 Nuibb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (strong, nonatomic) NSString *hostName;
-(NSString *) getCoordinates;
- (NSString*) getCoordinatesById:(NSInteger)_id;

@end
