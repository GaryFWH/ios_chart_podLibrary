//
//  TIValueView.m
//  ChartLibraryDemo
//
//  Created by william on 21/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "CustomDrawView.h"
#import "ChartDrawCommon.h"

@implementation CustomDrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithDelegate:(id<CustomDrawViewDelegate>)delegate {
    if (self = [self init]){
        self.delegate = delegate;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.delegate customDrawView:self drawRect:rect context:UIGraphicsGetCurrentContext()];
}

@end
