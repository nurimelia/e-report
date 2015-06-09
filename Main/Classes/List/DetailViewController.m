//
//  DetailViewController.m
//  E-Report
//
//  Created by Nur Imelia on 9/6/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "DetailViewController.h"
@interface DetailViewController()
@end
@implementation DetailViewController

@synthesize reportPhoto;
@synthesize notesTextView;
@synthesize itemNameTextView;
@synthesize checklistItem;




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
    
    self.title = checklistItem.item;
    self.itemNameTextView.text = checklistItem.item;
    self.reportPhoto = checklistItem.image;
    
    NSMutableString *notesReport = [NSMutableString string];
    for (NSString* notesReports in checklistItem.notes) {
        [notesReport appendFormat:@"%@\n", notesReports];
    }
    self.notesTextView.text = notesReport;
    
}

- (void)viewDidUnload
{
    [self setReportPhoto:nil];
    [self setNotesTextView:nil];
    [self setItemNameTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end