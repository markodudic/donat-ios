//
//	SplashViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "SplashViewController.h"
#import "TreatmentManager.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)showMainView {
	[self performSegueWithIdentifier:@"showMainView" sender:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:IS_IPHONE_5 ? @"splash-5.png" : @"splash-4.png"]] atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
	[self performSelector:@selector(showMainView) withObject:nil afterDelay:3.0f];

	[[TreatmentManager sharedManager] checkForUnsetNotifications];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
