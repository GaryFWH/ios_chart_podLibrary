//
//  ChartCommData.h
//  ChartLibraryDemo
//
//  Created by Gary on 19/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChartCommData : NSObject

@property (nonatomic, strong) NSTimeZone *timeZone;

+ (ChartCommData*)instance;

- (void)setTimeZone:(NSTimeZone*)timeZone;
- (void)setTimeZoneWithName:(NSString*)timeZoneName;


@end
