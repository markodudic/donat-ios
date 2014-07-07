//
//	NotificationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 28/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "NotificationViewController.h"
#import "SettingsManager.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

@synthesize notification = _notification;
@synthesize indicationType = _indicationType;

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	[self.closeButton setTitle:___(@"close") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)closeClicked:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
