//
//	LegalViewController.h
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegalViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *legalLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *contentHeight;

@end
