//
//  DetailViewController.h
//  E-Report
//
//  Created by Nur Imelia on 9/6/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import "ChecklistItem.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *reportPhoto;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UITextView *itemNameTextView;


@property (nonatomic, strong) ChecklistItem *checklistItem; //*checklistToEdit;

@end