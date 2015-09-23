//
//  DeviceSelectionViewController.m
//  CameraRemote
//
//  Created by Gretchen Walker on 9/21/15.
//  Copyright (c) 2015 Punch Through Design. All rights reserved.
//

#import "DeviceSelectionViewController.h"
#import "CameraViewController.h"
#import "LBBeanListTableViewCell.h"
#import "PTDBeanManager.h"
#import "PTDBean.h"
#import <AVFoundation/AVFoundation.h>

static NSString *HCOBeanCellIdentifier = @"HCOBeanCellIdentifier";

@interface DeviceSelectionViewController () <PTDBeanManagerDelegate, PTDBeanDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PTDBeanManager *beanManager;
@property (nonatomic, strong) PTDBean *bean;
@property (nonatomic, strong) NSMutableArray *beans;
@property (nonatomic, strong) UIImagePickerController *camera;

@end

@implementation DeviceSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.beans = [NSMutableArray new];
    self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.beanManager disconnectFromAllBeans:nil];
    [self reloadBeans:nil];
    self.navigationController.navigationBarHidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PTDBean *)sender
{
    CameraViewController *secondaryCameraVC = segue.destinationViewController;
    secondaryCameraVC.bean = sender;
}

- (IBAction)unwindFromCamera:(UIStoryboardSegue *)segue
{
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.beans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBBeanListTableViewCell *cell;
    PTDBean *bean;

    cell = [tableView dequeueReusableCellWithIdentifier:HCOBeanCellIdentifier];
    if ( !cell ) {
        cell = [[LBBeanListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCOBeanCellIdentifier];
    }

    bean = self.beans[indexPath.row];
    cell.bean = bean;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self connectBean:self.beans[indexPath.row]];
    [self.tableView reloadData];
    [self.beanManager stopScanningForBeans_error:nil];
}

#pragma mark - Bean Manager Delegate

- (void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager
{
    if ( self.beanManager.state == BeanManagerState_PoweredOn ) {
        [self startScan];
    }
}

- (void)beanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error
{
    if ( ![self.beans containsObject:bean] ) {
        [self.beans addObject:bean];
        [self.tableView reloadData];
    }
}

- (void)beanManager:(PTDBeanManager *)beanManager didConnectBean:(PTDBean *)bean error:(NSError *)error
{
    [self performSegueWithIdentifier:@"ShowCameraViewController" sender:bean];
}

#pragma mark - Bluetooth

- (void)startScan
{
    NSError *error;

    [self.beanManager startScanningForBeans_error:&error];

    if ( error && error.code == 1 ) {
        [[[UIAlertView alloc] initWithTitle:@"Bluetooth Required" message:@"Enable Bluetooth in iOS Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)connectBean:(PTDBean *)bean
{
    NSError *error;

    [self.beanManager connectToBean:bean error:&error];
    if ( error ) {
        [[[UIAlertView alloc] initWithTitle:@"Could not connect to bean" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else {
        NSLog(@"connected to %@", bean.name);
    }
}

- (void)reloadBeans:(id)sender
{
    self.beans = [NSMutableArray array];
    [self.tableView reloadData];
    if ([self.beanManager state] == BeanManagerState_PoweredOn) {
        [self startScan];
    }
}

@end



