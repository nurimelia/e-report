//
//  DatePickerViewController.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController {
    UILabel *dateLabel;
}

@synthesize tableView;
@synthesize datePicker;
@synthesize delegate;
@synthesize date;


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
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"backgroundfordatepicker.png"]];
    
    self.title = @"Choose Date"; // title of view controller

    

}




- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.datePicker = nil;
    dateLabel = nil;
    
    
}

///we dismiss the view if the user cancel the date picker
- (IBAction)cancel
{
    [self.delegate datePickerDidCancel:self];
}


//once the user picked the date we pass the new date to item detail view controller
- (IBAction)done
{
    [self.delegate datePicker:self didPickDate:self.date];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datePicker setDate:self.date animated:YES];
}


///method to format the date label
- (void)updateDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    dateLabel.text = [formatter stringFromDate:date];
}


//once the date change, we update the label
- (IBAction)dateChanged
{
    self.date = [self.datePicker date];
    [self updateDateLabel];
}



//number of rows in section

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"DateCell"];
                             dateLabel = (UILabel *)[cell viewWithTag:1000];
                             [self updateDateLabel];
                             return cell;
                             }
                             - (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath
                                                                           :(NSIndexPath *)indexPath
    {
        return nil;
    }


//height for header in section.

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(
                                                                        NSInteger)section
{
    return 77;
}
                             
@end
