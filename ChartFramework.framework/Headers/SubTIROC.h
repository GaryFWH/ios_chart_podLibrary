//
//  SubTIROC.h
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubTIROCUnit : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) UIColor * rocColor;
@property (nonatomic, strong) UIColor * ravgColor;

- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTIROC : ChartTI

@property (nonatomic, strong) SubTIROCUnit * unit;

@end

NS_ASSUME_NONNULL_END
