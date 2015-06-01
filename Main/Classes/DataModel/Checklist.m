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

@synthesize category;
@synthesize items;
@synthesize iconName;
@synthesize notes;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.category = [aDecoder decodeObjectForKey:@"Category"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.notes = [aDecoder decodeObjectForKey:@"Notes"];
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
        
    [aCoder encodeObject:self.category forKey:@"Category"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.notes forKey:@"Notes"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}



- (id)init
{
    if ((self = [super init])) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
        self.iconName = @"Trips";
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
    return [self.category localizedCaseInsensitiveCompare:otherChecklist.category];
}



@end
