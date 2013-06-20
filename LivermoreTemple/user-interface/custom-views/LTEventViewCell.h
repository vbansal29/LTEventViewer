//
//  LTEventViewCell.h
//  LivermoreTemple
//
//  Created by Vidya on 5/2/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTEventViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDetails;
@end
