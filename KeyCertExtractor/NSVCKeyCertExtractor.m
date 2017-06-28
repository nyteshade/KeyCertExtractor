//
//  NSVCKeyCertExtractor.m
//  KeyCertExtractor
//
//  Created by Harrison, Brielle on 6/27/17.
//  Copyright © 2017 Nyteshade Enterprises. All rights reserved.
//

#import "NSVCKeyCertExtractor.h"
#import "NSVKeyCertExtractor.h"

@interface NSVCKeyCertExtractor ()

@end

@implementation NSVCKeyCertExtractor

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    NSVKeyCertExtractor *view = (NSVKeyCertExtractor *)self.view;

    // Hacky way to enforce my own size; should configure auto sizing
    NSWindow *win = view.window;
    CGRect rect = win.contentView.frame;

    rect.size.width = 700;
    rect.size.height = 156;
    [view.window setContentSize:rect.size];
    [view.NSTFPathToPFX becomeFirstResponder];
}

@end
