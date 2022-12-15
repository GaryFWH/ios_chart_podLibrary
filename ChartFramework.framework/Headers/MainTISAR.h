//
//  MainTISAR.h
//  ChartLibraryDemo
//
//  Created by Gary on 29/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN
@interface MainTISARUnit : NSObject

@property (nonatomic, assign) float minSpeed;
@property (nonatomic, assign) float maxSpeed;
@property (nonatomic, strong) UIColor * sarColor;

- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface MainTISAR : ChartTI

@property (nonatomic, strong) MainTISARUnit * unit;

@end

NS_ASSUME_NONNULL_END
