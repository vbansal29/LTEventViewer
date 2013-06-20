//
//  UILoadingView.m
//  LivermoreTemple
//
//  Created by Vidya on 5/25/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "Header.h"
#import "UILoadingView.h"

@interface UILoadingView ()

@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation UILoadingView

-(UILabel *)loadingLabel {

    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    return _loadingLabel;
}

-(UIActivityIndicatorView *) spinner {
    
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _spinner;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.loadingLabel.text = @"Loading...";
        self.loadingLabel.textColor = [UIColor blackColor];//self.spinner.color
        
        [self addSubview:self.loadingLabel];
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setNeedsDisplay];
    }
    return self;
}

-(void)layoutSubviews {
    
    //Set loading label's size to correct one
    
    CGSize labelSize = [self.loadingLabel.text sizeWithFont:self.loadingLabel.font];
    CGRect labelFrame;
    
    labelFrame.size = labelSize;
    self.loadingLabel.frame = labelFrame;
    
    //Center label and spinner (need to ommit vertical origin calcultaion)
    
    self.loadingLabel.center = self.center;
    self.spinner.center = self.center;
    
    //Allign label and spinner horizontally
    
    labelFrame = self.loadingLabel.frame;
    
    CGRect spinnerFrame = self.spinner.frame;
    CGFloat totalWidth = spinnerFrame.size.width + SPACE_BETWEEN_SPINNER_AND_LABEL + labelSize.width;
    
    spinnerFrame.origin.x = self.bounds.origin.x + (self.bounds.size.width-totalWidth) / 2;
    labelFrame.origin.x = spinnerFrame.origin.x + spinnerFrame.size.width + SPACE_BETWEEN_SPINNER_AND_LABEL;
    self.loadingLabel.frame = labelFrame;
    self.spinner.frame = spinnerFrame;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
