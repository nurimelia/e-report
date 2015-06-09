//
//  Checklist.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "ChecklistItem.h"
#import "Checklist.h"

@implementation Checklist

@synthesize LabName;
@synthesize items;
@synthesize LabImage;
@synthesize notes;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.LabName = [aDecoder decodeObjectForKey:@"LabName"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.notes = [aDecoder decodeObjectForKey:@"Notes"];
        self.LabImage = [aDecoder decodeObjectForKey:@"LabImage"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
        
    [aCoder encodeObject:self.LabName forKey:@"LabName"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.notes forKey:@"Notes"];
    [aCoder encodeObject:self.LabImage forKey:@"LabImage"];
}



- (id)init
{
    if ((self = [super init])) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
        self.LabImage = @"LabImage";
    }
    return self;
}


- (int)countUncheckedItems
{
    int count = 0;
    for (ChecklistItem *item in self.items) {
        if (!item.checked) {
            count += 1;
        }
    }
    return count;
}

- (NSComparisonResult)compare:(Checklist *)otherChecklist
{
    return [self.LabName localizedCaseInsensitiveCompare:otherChecklist.LabName];
}



@end
