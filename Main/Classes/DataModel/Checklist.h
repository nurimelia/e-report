//
//  Checklist.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Checklist : NSObject <NSCoding>


@property (nonatomic, strong) NSString *LabName;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) PFFile *LabImage; // image of lab

- (int)countUncheckedItems;


@end
