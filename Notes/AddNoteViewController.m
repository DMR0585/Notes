//
//  AddNoteViewController.m
//  Notes
//
//  Created by Dan Reife on 3/27/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import "AddNoteViewController.h"
#import "DMRTableViewController.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editingChanged {
    if ([self.titleField.text length] > 0) {
        [self.doneButton setEnabled:YES];
    }
    else {
        [self.doneButton setEnabled:NO];
    }
}

@end
