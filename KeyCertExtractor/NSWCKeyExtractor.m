//
//  NSWCKeyExtractor.m
//  KeyCertExtractor
//
//  Created by Harrison, Brielle on 6/27/17.
//  Copyright © 2017 Nyteshade Enterprises. All rights reserved.
//

#import "NSWCKeyExtractor.h"

@interface NSWCKeyExtractor ()

@end

@implementation NSWCKeyExtractor

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window registerForDraggedTypes:@[(NSString*)kUTTypeItem]];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
