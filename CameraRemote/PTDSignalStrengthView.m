//
//  PTDSignalStrengthView.m
//  CameraRemote
//
//  Created by Gretchen Walker on 9/22/15.
//  Copyright (c) 2015 Punch Through Design. All rights reserved.
//

#import "PTDSignalStrengthView.h"

@interface PTDSignalStrengthView ()

@property (nonatomic, weak) UIImageView *filledBars;
@property (nonatomic, weak) UIImageView *emptyBars;

@end

@implementation PTDSignalStrengthView

- (void)awakeFromNib
{
    UIImageView *filledBars = [[UIImageView alloc] initWithFrame:self.bounds];
    self.filledBars = filledBars;
    self.filledBars.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.filledBars];

    //

    UIImageView *emptyBars = [[UIImageView alloc] initWithFrame:self.bounds];
    self.emptyBars = emptyBars;
    self.emptyBars.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.emptyBars];
}

- (void)setSignalStrength:(CGFloat)signalStrength
{
    if (signalStrength < 0) { signalStrength = 0.0; }
    if (signalStrength > 1) { signalStrength = 1.0; }

    UIImage *filled;
    UIImage *empty;

    if (signalStrength == 0) {
        filled = nil;
        empty = [UIImage imageNamed:@"signal-strength-5"];
    } else if (signalStrength <= 0.2) {
        filled = [UIImage imageNamed:@"signal-strength-1"];
        empty = [UIImage imageNamed:@"signal-strength-1a"];
    } else if (signalStrength <= 0.4) {
        filled = [UIImage imageNamed:@"signal-strength-2"];
        empty = [UIImage imageNamed:@"signal-strength-2a"];
    } else if (signalStrength <= 0.6) {
        filled = [UIImage imageNamed:@"signal-strength-3"];
        empty = [UIImage imageNamed:@"signal-strength-3a"];
    } else if (signalStrength <= 0.8) {
        filled = [UIImage imageNamed:@"signal-strength-4"];
        empty = [UIImage imageNamed:@"signal-strength-4a"];
    } else {
        filled = [UIImage imageNamed:@"signal-strength-5"];
        empty = nil;
    }

    self.filledBars.image = [filled imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.filledBars.tintColor = self.tintColor;

    self.emptyBars.image = [empty imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.emptyBars.tintColor = [UIColor colorWithWhite:0.0 alpha:0.1];

    [self setNeedsDisplay];
}

@end
