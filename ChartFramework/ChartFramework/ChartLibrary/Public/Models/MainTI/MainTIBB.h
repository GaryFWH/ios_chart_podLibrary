//
//  MainTIBB.h
//  ChartLibraryDemo
//
//  Created by Gary on 29/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN
@interface MainTIBBUnit : NSObject

@property (nonatomic, assign) NSInteger bollDay;
@property (nonatomic, assign) float noStdDev;
@property (nonatomic, strong) UIColor * upperBBColor;
@property (nonatomic, strong) UIColor * middleBBColor;
@property (nonatomic, strong) UIColor * lowerBBColor;

- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface MainTIBB : ChartTI

@property (nonatomic, strong) MainTIBBUnit * unit;

@end

NS_ASSUME_NONNULL_END
