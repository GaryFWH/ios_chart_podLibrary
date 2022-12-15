//
//  CommonUtil.m
//  ChartLibraryDemo
//
//  Created by Gary on 16/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonUtil.h"

static CommonUtil *instance = nil;

@implementation CommonUtil

+ (CommonUtil*)instance {
    if (instance != nil) {
        return instance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[CommonUtil alloc] init];
    });
    
    return instance;
}
//
- (id)init{
    if (self = [super init]) {
        self.timeSelectionArray  = [NSArray arrayWithObjects:@"1 Min", @"5 Min", @"15 Min", @"30 Min", @"60 Min", @"Daily", @"Weekly", @"Monthly", nil];
        self.typeSelectionArray  = [NSArray arrayWithObjects:@"Candlesticks", @"Line", @"Area", @"Bar", nil];
        self.colorSelectionArray = [NSArray arrayWithObjects:@"Light", @"Dark", nil];
        self.sessionSelectionArray = [NSArray arrayWithObjects:@"Core", @"Pre", @"Post", @"Combine", nil];
    }
    return self;
}

- (NSString*)getStrTimeSelection:(ChartMinTypeSelection)minType{
    return self.timeSelectionArray[minType];
}
//- (NSString*)getStrTypeSelection:(ChartDisTypeSelection)disType{
//    return self.typeSelectionArray[disType];
//}
- (NSString*)getStrColorSelection:(ChartColorTypeSelection)colorType{
    return self.colorSelectionArray[colorType];
}
- (NSString*)getStrLineTypeSelection:(ChartLineType)lineType {
    return self.typeSelectionArray[lineType];
}
- (NSString*)getStrSessionSelection:(ChartSessionType)session {
    return self.sessionSelectionArray[session];
}

-(ChartColorConfig*)getColorConfig:(ChartColorTypeSelection)colorType{
    if (colorType == ChartColorTypeSelectionLight){
        return [ChartColorConfig defaultLightConfig];
    } else {
        return [ChartColorConfig defaultDarkConfig];
    }
}

#pragma mark - Safe Area
+(CGFloat)safeAreaInsetTop {
    if (@available(iOS 11, *)){
        return [[UIApplication sharedApplication] keyWindow].safeAreaInsets.top;
    }
    return 0;
}
+(CGFloat)safeAreaInsetBottom{
    if (@available(iOS 11, *)){
        return [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    }
    return 0;
}
+(CGFloat)safeAreaInsetLeft{
    if (@available(iOS 11, *)){
        return [[UIApplication sharedApplication] keyWindow].safeAreaInsets.left;
    }
    return 0;
}
+(CGFloat)safeAreaInsetRight{
    if (@available(iOS 11, *)){
        return [[UIApplication sharedApplication] keyWindow].safeAreaInsets.right;
    }
    return 0;
}
@end
