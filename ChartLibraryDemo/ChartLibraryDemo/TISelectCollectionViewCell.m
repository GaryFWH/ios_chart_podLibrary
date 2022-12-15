//
//  TISelectCollectionViewCell.m
//  ChartLibraryDemo
//
//  Created by william on 18/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "TISelectCollectionViewCell.h"

@implementation TISelectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]){
        [self initView];
    }
    return self;
}

- (void)initView {
//    UIView *view2=[[UIView alloc]init];
//    view2.backgroundColor = [UIColor whiteColor];
//    view2.layer.cornerRadius = 10.0;
//    view2.layer.masksToBounds = YES;
//
//    self.contentView.layer.cornerRadius=10.0;
//    self.contentView.layer.shadowColor=[[UIColor blackColor] CGColor];
//    self.contentView.layer.shadowOpacity=1.0;
//    self.contentView.layer.shadowRadius=3.0;
//    self.contentView.layer.shadowOffset=CGSizeMake(0.0f,0.0f);
    
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.tiSelectLabel = [[UILabel alloc] init];
    self.tiSelectLabel.numberOfLines = 0;
    self.tiSelectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.tiSelectLabel.textColor = [UIColor blackColor];
    self.tiSelectLabel.font = [UIFont systemFontOfSize:13.0f];
    self.tiSelectLabel.adjustsFontSizeToFitWidth = YES;
    self.tiSelectLabel.layer.cornerRadius = 10.0;
    self.tiSelectLabel.layer.masksToBounds = YES;
    
//    [self.contentView addSubview:view2];
    [self.contentView addSubview:self.tiSelectLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[view]-0-|" options:0 metrics:nil views:@{@"view":self.tiSelectLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.tiSelectLabel}]];
}


@end
