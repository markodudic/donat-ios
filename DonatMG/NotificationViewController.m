//
//	NotificationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 28/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

@synthesize userInfo = _userInfo;
@synthesize testLabel = _testLabel;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.testLabel.text = [_userInfo description];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
