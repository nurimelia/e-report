//
//  ChecklistItem.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "DataModel.h"
#import "ChecklistItem.h"

@implementation ChecklistItem


@synthesize text, checked, notes, item;
//numberPlate,
@synthesize serviceFrequency;
@synthesize dueDate, nextServiceDate, shouldRemind, itemId, imageF;



//To load the plist file

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.notes = [aDecoder decodeObjectForKey:@"Notes"];
        self.item = [aDecoder decodeObjectForKey:@"Item"];
       // self.numberPlate = [aDecoder decodeObjectForKey:@"NumberPlate"];
        self.serviceFrequency = [aDecoder decodeObjectForKey:@"ServiceFrequency"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.nextServiceDate = [aDecoder decodeObjectForKey:@"NextServiceDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntForKey:@"ItemID"];
        self.imageF = [aDecoder decodeObjectForKey:@"Image"];

    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeObject:self.notes forKey:@"Notes"];
    [aCoder encodeObject:self.item forKey:@"Item"];
   // [aCoder encodeObject:self.numberPlate forKey:@"NumberPlate"];
    [aCoder encodeObject:self.serviceFrequency forKey:@"ServiceFrequency"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeObject:self.nextServiceDate forKey:@"NextServiceDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInt:self.itemId forKey:@"ItemID"];
    [aCoder encodeObject:self.imageF forKey:@"Image"];

}

- (void)toggleChecked
{
    self.checked = !self.checked;
}

- (id)init
{
    if (self = [super init]) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}



- (UILocalNotification *)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if (number != nil && [number intValue] == self.itemId) {
            return notification;
        }
    }
    return nil;
}


- (void)scheduleNotification
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
      //  NSLog(@"Found an existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:
         existingNotification];
    
    }


    if (self.shouldRemind && [self.nextServiceDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.nextServiceDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
       // NSString *numberPlate2 = [NSString stringWithFormat:@"%@ %@ is due for Maintenance!", item ? item: @"", numberPlate ? numberPlate: @""];
        
      //  localNotification.alertBody = numberPlate2;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.itemId] forKey:@"ItemID"];
                
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
     //   NSLog(@"Scheduled notification %@ for itemId %d", localNotification, self.itemId);
    }
}


- (void)dealloc
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
     //   NSLog(@"Removing existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:
         existingNotification];
    }
}


@end
