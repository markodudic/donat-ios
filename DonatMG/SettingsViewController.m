//
//	SettingsViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguageManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize languageLabel = _languageLabel;

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// hide the title while view controller is visible
	self.title = @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown with the appropriate title
	self.title = NSLocalizedString(@"settingsTitle", nil);
}

@end
