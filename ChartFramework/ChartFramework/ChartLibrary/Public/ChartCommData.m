//
//  ChartCommData.m
//  ChartLibraryDemo
//
//  Created by Gary on 19/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartCommData.h"

static ChartCommData *instance = nil;
@implementation ChartCommData

+(ChartCommData*)instance {
    if (instance != nil) {
        return instance;
    }
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[ChartCommData alloc] init];
    });

    return instance;
}
- (id)init {
    if (self == [super init]) {
        [self initData];
    }
    return self;
}

// Public
-(void)setTimeZone:(NSTimeZone*)timeZone {
    _timeZone = timeZone;
}
-(void)setTimeZoneWithName:(NSString*)timeZoneName {
    if (!timeZoneName || [timeZoneName isEqualToString:@""]) {
        self.timeZone = [NSTimeZone systemTimeZone];
    } else {
        self.timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    }
}

// Private
-(void)initData {
    self.timeZone = [NSTimeZone systemTimeZone];
}

@end

