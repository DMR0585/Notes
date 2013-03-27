//
//  DMRTableViewController.h
//  Notes
//
//  Created by Dan Reife on 3/27/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "DMRAppDelegate.h"
#import "AddNoteViewController.h"
#import "ExpandNoteViewController.h"
#import "Note.h"


@interface DMRTableViewController : UITableViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


- (IBAction)edit:(id)sender;
- (IBAction)addNote:(UIStoryboardSegue *) segue;
- (void)replaceObjectAtIndex:(NSInteger) row withNoteWithText:(NSString *) text;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
