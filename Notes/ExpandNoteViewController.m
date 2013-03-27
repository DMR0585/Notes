//
//  ExpandNoteViewController.m
//  Notes
//
//  Created by Dan Reife on 3/27/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import "ExpandNoteViewController.h"

@interface ExpandNoteViewController ()

@end

@implementation ExpandNoteViewController

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
	
    // Display a custom background
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"slate.jpg"]];
    self.view.backgroundColor = background;
    
    // The user can zoom but not scroll
    self.map.scrollEnabled = false;
    self.map.zoomEnabled = true;
    
    // Add a recognizer to the view to dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    
    // Get the root view controller (the table view) and replace the text of the
    // note whose row was stored in this ViewController
    DMRTableViewController *tvc = [self.navigationController.viewControllers objectAtIndex:0];
    [tvc replaceObjectAtIndex:self.row withNoteWithText:self.textView.text];
}

- (void) centerViewAtLocation:(CLLocation *)location
                             :(BOOL)animated {
    
    // Create a new region centered at the location, adjust it to fit the
    // map, and set the map to display the fitted region
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:region];
    [self.map setRegion:adjustedRegion animated:animated];
}

-(void)dismissKeyboard {
    [self.textView resignFirstResponder];
}

@end