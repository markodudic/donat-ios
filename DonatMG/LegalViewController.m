//
//	LegalViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 03/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "LegalViewController.h"

@interface LegalViewController ()

@end

@implementation LegalViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	// TODO: iterate through all subviews and set the appropriate fonts
	// it's not possible to set a custom font in IB, so this is the only way to do it
	// before, make sure that autolayout is set up the right way, so the labels will be layed out as needed when fonts are set
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
