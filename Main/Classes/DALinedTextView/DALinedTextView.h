//
//  DALinedTextView.h
//  DALinedTextView
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DALinedTextView : UITextView

@property (nonatomic, strong) UIColor *horizontalLineColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *verticalLineColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIEdgeInsets margins UI_APPEARANCE_SELECTOR;

@end
