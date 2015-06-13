//
//  ChecklistItem.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ChecklistItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSString *serviceFrequency;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic, copy) NSDate *nextServiceDate;
@property (nonatomic, assign) BOOL shouldRemind;
@property (nonatomic, assign) int itemId;
@property (nonatomic, assign) PFFile  *imageF;



- (void)toggleChecked;

- (void)scheduleNotification;


@end
