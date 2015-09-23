//
//  LBBeanListTableViewCell.m
//  CameraRemote
//
//  Created by Gretchen Walker on 9/22/15.
//  Copyright (c) 2015 Punch Through Design. All rights reserved.
//

#import "LBBeanListTableViewCell.h"
#import "PTDSignalStrengthView.h"

@interface LBBeanListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PTDSignalStrengthView *signalStrengthView;

@end

@implementation LBBeanListTableViewCell

- (void)setBean:(PTDBean *)bean
{
    _bean = bean;
    if (bean) {
        [self updateBeanValues];
    }
}

- (void)setAccessoryViewForSelectedState:(BOOL)isSelected
{
    self.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

#pragma mark - Private Methods

- (void)updateBeanValues
{
    if (!self.bean.RSSI) {
        self.signalStrengthView.signalStrength = 0;
    } else if (self.bean.RSSI.integerValue == 127) {
        self.signalStrengthView.signalStrength = 0;
    } else {
        CGFloat value = self.bean.RSSI.floatValue;
        self.signalStrengthView.signalStrength = (value + 90) / 60;
    }
    if (![self.titleLabel.text isEqualToString:self.bean.name]) {
        self.titleLabel.text = self.bean.name;
    }

    if (!self.bean.RSSI || self.bean.RSSI.integerValue == 127) {
        self.titleLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
    }

    [self setNeedsDisplay];
}

@end
