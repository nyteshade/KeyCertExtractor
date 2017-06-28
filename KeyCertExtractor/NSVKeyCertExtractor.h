//
//  NSVKeyCertExtractor.h
//  KeyCertExtractor
//
//  Created by Harrison, Brielle on 6/27/17.
//  Copyright © 2017 Nyteshade Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSVKeyCertExtractor : NSView
@property (readwrite) IBOutlet NSTextField *NSTFPathToPFX;
@property (readwrite) IBOutlet NSSecureTextField *NSSTFPassphrase;
@property (readwrite) IBOutlet NSButton *NSBExtract;

@property (readwrite) IBOutlet NSButton *NSBSaveCert;
@property (readwrite) IBOutlet NSButton *NSBSavePKey;

@property (readwrite) IBOutlet NSImageView *NSIVKeyLight;
@property (readwrite) IBOutlet NSImageView *NSIVCertLight;

@property (readwrite) NSImage *success;
@property (readwrite) NSImage *failure;

@end
