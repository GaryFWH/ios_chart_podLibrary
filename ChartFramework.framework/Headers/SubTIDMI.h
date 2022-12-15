//
//  SubTIDMI.h
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubTIDMIUnit : NSObject

@property (nonatomic, assign) NSInteger iDMIDay;
@property (nonatomic, assign) BOOL bShowADXR;
@property (nonatomic, strong) UIColor * dmiADIColor;
@property (nonatomic, strong) UIColor * dmiBDIColor;
@property (nonatomic, strong) UIColor * dmiADXColor;
@property (nonatomic, strong) UIColor * dmiADXRColor;

- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTIDMI : ChartTI

@property (nonatomic, strong) SubTIDMIUnit * unit;

@end

NS_ASSUME_NONNULL_END
