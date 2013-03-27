//
//  DMRTableViewController.m
//  Notes
//
//  Created by Dan Reife on 3/27/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import "DMRTableViewController.h"
#define kDMRCellIdentifier @"Cell identifier"

@interface DMRTableViewController ()

@end

@implementation DMRTableViewController

NSMutableArray *notesArray;
BOOL deleteMode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DMRAppDelegate *AppDelegate = (DMRAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [AppDelegate managedObjectContext];
    
    NSLog(@"In viewdidload");
    // Set up the fetch request for "Note" entities
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Send the fetch request and save to notesArray or initialize
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        notesArray = [[NSMutableArray alloc] init];
    }
    else {
        // Store and sort the array
        notesArray = mutableFetchResults;
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                 ascending:YES
                                                                  selector:@selector(caseInsensitiveCompare:)];
        [notesArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    }
    
    NSLog(@"didn't crash yet");
    
    // Get the locationManager from DMRAppDelegate, initialize if necessary
    if (AppDelegate.locationManager == nil) {
        AppDelegate.locationManager = [[CLLocationManager alloc] init];
    }
    AppDelegate.locationManager.delegate = self;
    
    // Update location if possible, otherwise request user to allow location updates
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        [AppDelegate.locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                        message:@"If you would like to see the location of new notes, please go to: \nSettings > Privacy > Location and enable Location Services both for your device and this application."
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Initially, don't delete
    deleteMode = FALSE;
    
    // Refresh the table
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If going to the new note view
    if ([segue.identifier isEqualToString:@"ExpandNoteID"]) {
        
        // Get the objects that will be needed (the destinationVC, indexPath of the selected cell, and corresponding note)
        ExpandNoteViewController *destination = (ExpandNoteViewController *) segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath *) sender;
        Note *note = [notesArray objectAtIndex:path.row];
        
        if ([destination view] != nil) {
            // Set the bar title and text of the detail view
            destination.navigationBar.title = note.title;
            destination.textView.text = note.text;
            destination.row = path.row;
            
            // Display the location of the note if available, otherwise hide the map
            if ([note.hasLocation boolValue]) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:[note.latitude doubleValue]
                                                                  longitude:[note.longitude doubleValue]];
                [destination centerViewAtLocation:location :NO];
            }
            else destination.map.hidden = YES;
        }
    }
}

// The action to be performed when the "Done" button is pressed
// in the AddNoteView
- (IBAction)edit:(id)sender {
    
    // Can only switch to deleteMode if there are notes
    // Can switch to editMode always
    if (([notesArray count] > 0) || deleteMode) {
        
        deleteMode = !deleteMode;  // Switch modes
        
        // Let the user know which mode they're in
        UIAlertView *alert;
        if (deleteMode) alert =
            [[UIAlertView alloc] initWithTitle:@"Delete mode active"
                                       message:@"Selecting a note will now delete it."
                                      delegate:nil
                             cancelButtonTitle:@"Okay"
                             otherButtonTitles:nil];
        else alert =
            [[UIAlertView alloc] initWithTitle:@"Viewing mode active"
                                       message:@"Selecting a note will now display its details."
                                      delegate:nil
                             cancelButtonTitle:@"Okay"
                             otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction) addNote:(UIStoryboardSegue *) segue {
    
    AddNoteViewController *anvc = segue.sourceViewController;
    
    // Allocate a new note and copy the title and description
    Note *note = (Note *)[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    note.title = anvc.titleField.text;
    note.text = anvc.textView.text;
    
    // Record the location if there, if not hasLocation is FALSE
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        note.hasLocation = [NSNumber numberWithBool:TRUE];
        
        DMRAppDelegate *AppDelegate = (DMRAppDelegate *)[[UIApplication sharedApplication] delegate];
        CLLocation *location = [AppDelegate.locationManager location];
        
        note.latitude = [NSNumber numberWithDouble:(double)location.coordinate.latitude];
        note.longitude = [NSNumber numberWithDouble:(double) location.coordinate.longitude];
    }
    else {
        note.hasLocation = [NSNumber numberWithBool:FALSE];
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    // Add the note to the array and sort it
    [notesArray addObject:note];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES
                                                              selector:@selector(caseInsensitiveCompare:)];
    [notesArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    [self.tableView reloadData];
}

- (IBAction) cancel:(UIStoryboardSegue *) segue {
    // If cancel is pushed, do nothing other than unwind
}

- (void) replaceObjectAtIndex:(NSInteger) row withNoteWithText:(NSString *) text {
    NSUInteger r = (NSUInteger) row;
    
    // Adjust the text of the note
    Note *note = [notesArray objectAtIndex:r];
    note.text = text;
    
    // Commit the change
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Handle the error.
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new cell, initialize if necessary
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDMRCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDMRCellIdentifier];
    }
    
    // Set the label of the cell to the title of the note
    Note *note = (Note *)[notesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = note.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object at the given index path.
        Note *note = [notesArray objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:note];
        
        // Update the array and table view.
        [notesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        // Commit the change.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (deleteMode) {  // if in deleteMode, delete the note
        
        // Get and remove the note from the array and managedObjectContext
        Note *note = [notesArray objectAtIndex:indexPath.row];
        [notesArray removeObjectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:note];
        
        // Save the change
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error
        }
        
        // Update the table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    else if ([notesArray objectAtIndex:indexPath.row] != nil) {
        [self performSegueWithIdentifier:@"ExpandNoteID" sender:indexPath];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}



@end
