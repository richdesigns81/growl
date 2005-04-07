//
//  GrowlBubblesWindowView.h
//  Growl
//
//  Created by Nelson Elhage on Wed Jun 09 2004.
//  Name changed from KABubbleWindowView.h by Justin Burns on Fri Nov 05 2004.
//  Copyright (c) 2004 Nelson Elhage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowlBubblesWindowView : NSView {
	BOOL			haveText;
	NSFont			*titleFont;
	NSFont			*textFont;
	NSImage			*icon;
	NSString		*title;
	float			textHeight;
	float			titleHeight;
	float			lineHeight;
	SEL				action;
	id				target;
	NSColor			*bgColor;
	NSColor			*textColor;
	NSColor			*borderColor;
	NSColor			*lightColor;
	NSLayoutManager *layoutManager;
	NSTextStorage	*textStorage;
	NSTextContainer	*textContainer;
}

- (void) setPriority:(int)priority;
- (void) setIcon:(NSImage *)icon;
- (void) setTitle:(NSString *)title;
- (void) setText:(NSString *)text;

- (void) sizeToFit;
- (float) titleHeight;
- (float) descriptionHeight;
- (int) descriptionRowCount;
	
- (id) target;
- (void) setTarget:(id)object;

- (SEL) action;
- (void) setAction:(SEL)selector;
@end

