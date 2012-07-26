//
//  ContactsListTableViewCell.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"



// contact default photo
#define CONTACT_DEFAULT_PHOTO [UIImage imageNamed:@"unselected.png"]
// contact selected photo
#define CONTACT_SELECTED_PHOTO [UIImage imageNamed:@"selected.png"]
// contact prein meeting photo
//#define CONTACT_PREINMEETING_PHOTO [UIImage imageNamed:@"left_arrow.png"]

@interface ContactsListTableViewCell : UITableViewCell {
    // contact check button
    UIButton *_mCheckButton;
    // contact display name label
    UILabel *_mDisplayNameLabel;
    // contact phone numbers display label
    UILabel *_mPhoneNumbersLabel;
    UIImageView *_mSeparateLine;
}

// contact photo imageView photo image
@property (nonatomic, retain) UIImage *photoImg;
// contact diaplay name label text
@property (nonatomic, retain) NSString *displayName;
// contact phone numbers array
@property (nonatomic, retain) NSArray *phoneNumbersArray;

// add target/action for UIControlEventTouchDown event
- (void)addImgButtonTarget:(id)pTarget andActionSelector:(SEL)pSelector;

// get the height of the contacts list tableViewCell with contactBean object
+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact;

@end
