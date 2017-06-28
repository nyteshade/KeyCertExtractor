//
//  NSVKeyCertExtractor.m
//  KeyCertExtractor
//
//  Created by Harrison, Brielle on 6/27/17.
//  Copyright © 2017 Nyteshade Enterprises. All rights reserved.
//

#import "NSVKeyCertExtractor.h"

@implementation NSVKeyCertExtractor

- (instancetype)init {
  self = [super init];
  if (self) { [self initImages]; }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) { [self initImages]; }
  return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) { [self initImages]; }
  return self;
}

- (void)initImages {
  [self registerForDraggedTypes:@[(NSString *)kUTTypeItem]];

  _success = [NSImage imageNamed:@"success"];
  _failure = [NSImage imageNamed:@"error"];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)enableIfReady {
  BOOL ready = NO;

  if (
    [[_NSTFPathToPFX stringValue] length] &&
    [[_NSSTFPassphrase stringValue] length]
  ) {
    ready = YES;
  }

  [_NSBSaveCert setEnabled:ready];
  [_NSBSavePKey setEnabled:ready];

  if (!ready) {
    [_NSIVKeyLight setHidden:YES];
    [_NSIVCertLight setHidden:YES];
  }
}

- (void)controlTextDidChange:(NSNotification *)notification {
    [self enableIfReady];
}

- (NSURL *)get {
   NSOpenPanel *panel = [NSOpenPanel openPanel];
   [panel setAllowsMultipleSelection:NO];
   [panel setCanChooseDirectories:YES];
   [panel setCanChooseFiles:NO];
   if ([panel runModal] != NSFileHandlingPanelOKButton) return nil;
   return [[panel URLs] lastObject];
}

- (IBAction)saveCert:(id)sender {
  if (![[_NSTFPathToPFX stringValue] length]) return;

  NSURL *path = [self get];
  NSString *outPath = [NSString pathWithComponents:@[
    [path relativePath],
    [NSString stringWithFormat:
      @"%@.pem",
     [[[[_NSTFPathToPFX stringValue]
        pathComponents]
       lastObject]
      stringByDeletingPathExtension]
    ]
  ]];

  [self extractCert:outPath];
}

- (IBAction)saveKey:(id)sender {
  if (![[_NSTFPathToPFX stringValue] length]) return;

  NSURL *path = [self get];
  NSString *outPath = [NSString pathWithComponents:@[
    [path relativePath],
    [NSString stringWithFormat:
      @"%@.key",
     [[[[_NSTFPathToPFX stringValue]
        pathComponents]
       lastObject]
      stringByDeletingPathExtension]
    ]
  ]];

  [self extractKey:outPath];
}

- (void)showActionableUI {
  // Show elements that were previously hidden

  // Adjust window content size to show hidden elements
  NSWindow *win = [self window];
  NSRect size = win.frame;
  size.size.width = 700;
  size.size.height = 240;

  [win setContentSize:size.size];
}

- (void)setCertState:(NSNumber *)success {
  [_NSBSaveCert setHidden:NO];
  [_NSIVCertLight setHidden:NO];
  [self.NSIVCertLight setImage:[success boolValue] ? self.success : self.failure];
}

- (void)setKeyState:(NSNumber *)success {
  [_NSBSavePKey setHidden:NO];
  [_NSIVKeyLight setHidden:NO];
  [self.NSIVKeyLight setImage:[success boolValue] ? self.success : self.failure];
}

- (void)extractCert:(NSString *)outputPath {
  NSString *password = [self.NSSTFPassphrase stringValue];
  NSString *filePath = [self.NSTFPathToPFX stringValue];
  [self.NSBSaveCert setEnabled:YES];
  
  @try {
    if (![password length] || ![filePath length]) {
      [self setCertState:@NO];
      return;
    }

    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/openssl";
    task.arguments = @[
      @"pkcs12",
      @"-in", filePath,
      @"-nokeys",
      @"-out", outputPath,
      @"-password", [NSString stringWithFormat:@"pass:%@", password]
    ];
    task.standardOutput = pipe;

    [task launch];
    [task waitUntilExit];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    [self setCertState:[task terminationStatus] ? @NO : @YES];

    NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"grep returned:\n%@", grepOutput);
  }
  @catch (NSException *exception) {
    [self setCertState:@NO];
    [self.NSBSaveCert setEnabled:NO];
  }
}

- (void)extractKey:(NSString *)outputPath {
  NSString *password = [self.NSSTFPassphrase stringValue];
  NSString *filePath = [self.NSTFPathToPFX stringValue];
  [self.NSBSavePKey setEnabled:YES];

  @try {
    if (![password length] || ![filePath length]) {
      [self setCertState:@NO];
      return;
    }

    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/openssl";
    task.arguments = @[
      @"pkcs12",
      @"-in", filePath,
      @"-nocerts",
      @"-out", outputPath,
      @"-nodes",
      @"-password", [NSString stringWithFormat:@"pass:%@", password]
    ];
    task.standardOutput = pipe;


    [task launch];
    [task waitUntilExit];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];

    [self setKeyState:[task terminationStatus] ? @NO : @YES];

    NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"grep returned:\n%@", grepOutput);
  }
  @catch (NSException *exception) {
    [self setKeyState:@NO];
    [self.NSBSavePKey setEnabled:NO];
  }
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
  [_NSTFPathToPFX becomeFirstResponder];
  [_NSTFPathToPFX setStringValue:@""];

  NSDragOperation op = [super draggingEntered:sender];
  [self enableIfReady];
  return op;
}

@end
