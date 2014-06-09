//
//	IndicationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "IndicationViewController.h"
#import "SettingsManager.h"

@interface IndicationViewController ()

@end

@implementation IndicationViewController

@synthesize indicationType = _indicationType;

- (void)updateViewActivation {
	_amActive = [[SettingsManager sharedManager] activeIndication] == _indicationType;
//	[self.bigButton setTitle:_amActive ? ___(@"button_indication_stop") : ___(@"button_indication_start") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	[self updateViewActivation];
}

//- (IBAction)activationPressed:(id)sender {
//	if (_amActive) {
//		[[SettingsManager sharedManager] setActiveIndication:kUnknown];
//	} else {
//		[[SettingsManager sharedManager] setActiveIndication:self.indicationType];
//	}
//	[self updateViewActivation];
//}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
