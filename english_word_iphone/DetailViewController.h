//
//  DetailViewController.h
//  english_word_iphone
//
//  Created by Arata Okura on 1/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "word.h"
#import "UpdateController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Word *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *english;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel2;
@property (strong, nonatomic) UpdateController *updateController;

@end
