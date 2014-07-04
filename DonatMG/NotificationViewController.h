//
//  NotificationViewController.h
//  DonatMG
//
//  Created by Goran Blažič on 28/06/14.
//  Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController

@property (nonatomic, retain) NSDictionary *userInfo;

@property (nonatomic, strong) IBOutlet UILabel *testLabel;

@end
