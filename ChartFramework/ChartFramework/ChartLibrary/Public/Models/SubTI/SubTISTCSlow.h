//
//  SubTISTCSlow.h
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubTISTCSlowUnit : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger skDay;
@property (nonatomic, assign) NSInteger sdDay;

@property (nonatomic, strong) UIColor * skColor;
@property (nonatomic, strong) UIColor * sdColor;

- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTISTCSlow : ChartTI

@property (nonatomic, strong) SubTISTCSlowUnit * unit;

@end

NS_ASSUME_NONNULL_END
