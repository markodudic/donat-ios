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
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
