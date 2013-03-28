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
    
    // Display a custom background
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"slate.JPG"]];
    self.view.backgroundColor = background;
    
    self.textView.delegate = self;
    self.titleField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Enables the doneButton only when the titleField has text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isFieldEmpty = [newText isEqualToString:@""];
    [self.doneButton setEnabled:!isFieldEmpty];
    return YES;
}

// If the user hits return when typing in the titleField, resign the keyboard
- (BOOL)textFieldShouldReturn:(UITextField*)titleField
{
    [titleField resignFirstResponder];
    return YES;
}

// Hide whichever keyboard can be hidden
-(void)dismissKeyboard {
    if ([self.titleField canResignFirstResponder]) {
        [self.titleField resignFirstResponder];
    }
    else if ([self.textView canResignFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}



@end
