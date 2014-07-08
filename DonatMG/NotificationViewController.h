//
//  NotificationViewController.h
//  DonatMG
//
//  Created by Goran Blažič on 28/06/14.
//  Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetLabel.h"

@interface NotificationViewController : UIViewController {
	NSUInteger _indication;
	NSUInteger _timeOfDay;

	InsetLabel *_labelUpLeft;
	InsetLabel *_labelUpRight;
	InsetLabel *_labelDown;
}

@property (nonatomic, retain) UILocalNotification *notification;

@property (nonatomic, strong) IBOutlet UIImageView *indicationIcon;
@property (nonatomic, strong) IBOutlet UILabel *indicationLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeOfDayLabel;
@property (nonatomic, strong) IBOutlet UIImageView *morningIcon;
@property (nonatomic, strong) IBOutlet UILabel *morningLabel;
@property (nonatomic, strong) IBOutlet UIImageView *noonIcon;
@property (nonatomic, strong) IBOutlet UILabel *noonLabel;
@property (nonatomic, strong) IBOutlet UIImageView *eveningIcon;
@property (nonatomic, strong) IBOutlet UILabel *eveningLabel;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) IBOutlet UIView *containerView;

@end
