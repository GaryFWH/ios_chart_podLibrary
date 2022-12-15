//
//  SubTIOBV.h
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubTIOBVUnit : NSObject

@property (nonatomic, assign) BOOL bWc;
@property (nonatomic, strong) UIColor * obvColor;
- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTIOBV : ChartTI

@property (nonatomic, strong) SubTIOBVUnit * unit;

@end

NS_ASSUME_NONNULL_END
