//
//  ExpandNoteViewController.h
//  Notes
//
//  Created by Dan Reife on 3/27/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DMRTableViewController.h"
#import "Note.h"



@interface ExpandNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (assign, nonatomic) NSInteger row;

- (void) centerViewAtLocation:(CLLocation *)location :(BOOL)animated;

@end