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
@synthesize testText = _testText;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.testText.text = [_notification description];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
