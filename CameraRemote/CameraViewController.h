//
//  SecondaryCameraViewController.h
//  CameraRemote
//
//  Created by Gretchen Walker on 9/22/15.
//  Copyright (c) 2015 Punch Through Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDBean.h"

@interface CameraViewController : UIViewController <PTDBeanDelegate>

@property (nonatomic, strong) PTDBean *bean;

@end
