//
//  GrowlOnSwitch.m
//  GrowlSlider
//
//  Created by Daniel Siemer on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrowlOnSwitch.h"
#import "GrowlOnSwitchKnob.h"

@implementation GrowlOnSwitch

@synthesize knob;
@synthesize onLabel;
@synthesize offLabel;

@synthesize state;
@synthesize mouseLoc;

+(void)initialize
{
   if (self != [GrowlOnSwitch class])
		return;

   [NSObject exposeBinding:@"state"];
}

-(id)initWithFrame:(NSRect)frameRect
{
   if((self = [super initWithFrame:frameRect])){      
      CGRect box = [self bounds];
      CGRect knobFrame = CGRectMake(0.0f, 0.0f, (box.size.width / 1.8f) - knobDoubleInset, box.size.height);
      GrowlOnSwitchKnob *knobView = [[GrowlOnSwitchKnob alloc] initWithFrame:knobFrame];
      self.knob = knobView;
      [self addSubview:knob];
      [knobView release];
      
      CGFloat vertical = box.size.height / 2.0f - 10.0f;
      NSShadow *shadow = [[NSShadow alloc] init];
      [shadow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.5]];
      [shadow setShadowOffset:CGSizeMake(0.0, -1.0)];
      NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue Bold" size:17], NSFontAttributeName,
                                                                          [NSColor colorWithSRGBRed:.255 green:.250 blue:.250 alpha:1.0], NSForegroundColorAttributeName,
                                                                          shadow, NSShadowAttributeName, nil];
      [shadow release];
      
      NSString *offString = NSLocalizedString(@"OFF", @"If the string is too long, use O");
      NSMutableAttributedString *attrOffTitle = [[NSMutableAttributedString alloc] initWithString:offString
                                                                                       attributes:attrDict];
      [attrOffTitle setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [attrOffTitle length])];
      NSTextField *offView = [[NSTextField alloc] initWithFrame:CGRectMake(box.size.width - 50.0f, vertical, 50.0f, 25.0f)];
      [offView setEditable:NO];
      [offView setDrawsBackground:NO];
      [offView setBackgroundColor:[NSColor clearColor]];
      [offView setBezeled:NO];
      [[offView cell] setAttributedStringValue:attrOffTitle];
      self.offLabel = offView;
      [self addSubview:offView positioned:NSWindowBelow relativeTo:knob];
      [offView setToolTip:@"Are you happy now Gemmel?"];
      [offView release];
      [attrOffTitle release];
      
      NSString *onString = NSLocalizedString(@"ON", @"If the string is too long, use I");
      NSMutableAttributedString *attrOnTitle = [[NSMutableAttributedString alloc] initWithString:onString
                                                                                      attributes:attrDict];
      [attrOnTitle setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [attrOnTitle length])];
      NSTextField *onView = [[NSTextField alloc] initWithFrame:CGRectMake(0.0f, vertical, 50.0f, 25.0f)];
      [onView setEditable:NO];
      [onView setDrawsBackground:NO];
      [onView setBackgroundColor:[NSColor clearColor]];
      [onView setBezeled:NO];
      [[onView cell] setAttributedStringValue:attrOnTitle];
      self.onLabel = onView;
      [self addSubview:onView positioned:NSWindowBelow relativeTo:knob];
      [onView release];
      [attrOnTitle release];
      
      [self addObserver:self 
             forKeyPath:@"state" 
                options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                context:nil];
   }
   return self;
}

-(void)dealloc
{
   [self removeObserver:self forKeyPath:@"state"];
   [knob release];
   [onLabel release];
   [offLabel release];
   [super dealloc];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   if([keyPath isEqualToString:@"state"]){
      [self updatePosition];
   }
}

- (void)setNilValueForKey:(NSString *)key
{
	if ([key isEqualToString:@"state"])
		[self setState:NO];
	else
		return [super setNilValueForKey:key];
}

-(void)setState:(BOOL)newState
{
   state = newState;
}

-(void)silentSetState:(BOOL)newState
{
   state = newState;
   [self updatePosition];
}

- (void)mouseDown:(NSEvent *)theEvent
{
   CGPoint viewPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	mouseLoc = [knob convertPoint:viewPoint fromView:nil];
   knob.pressed = YES;
   [knob setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent*)inEvent
{
	BOOL newState = NO;
   
	CGPoint viewPoint = [self convertPoint:[inEvent locationInWindow] fromView:nil];

	CGPoint currentKnobPoint = [knob convertPoint:viewPoint fromView:nil];

	if (CGPointEqualToPoint(mouseLoc, currentKnobPoint))
		newState = ![self state];
	else if(viewPoint.x >= ([self frame].size.width / 2.2f))
		newState = YES;
   else if(viewPoint.x <= ([self frame].size.width / 2.2f))
      newState = NO;
   
	[self setState:newState];
	mouseLoc = CGPointZero;
   knob.pressed = NO;
   [knob setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent*)inEvent
{	
	CGPoint newMouseLoc = [self convertPoint:[inEvent locationInWindow] fromView:nil];
	if (newMouseLoc.x >= self.frame.size.width - [knob frame].size.width - knobDoubleInset)
		newMouseLoc.x = self.frame.size.width - [knob frame].size.width - knobDoubleInset;
	if (newMouseLoc.x <= knobInset)
		newMouseLoc.x = knobInset;
   mouseLoc = newMouseLoc;
   
   [knob setFrameOrigin:CGPointMake(newMouseLoc.x, 0.0f)];
}

-(void)drawRect:(NSRect)dirtyRect
{
   CGRect inset = CGRectInset([self bounds], knobInset, knobInset);
   NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:inset xRadius:onSwitchRadius yRadius:onSwitchRadius];
   NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor grayColor] endingColor:[NSColor lightGrayColor]];
   [[NSColor colorWithDeviceWhite:.2f alpha:1.0f] setStroke];
   [path setLineWidth:.75f];

   [gradient drawInBezierPath:path angle:-90.0f];
   [path stroke];
   [gradient release];
}

-(NSRect)focusRingMaskBounds
{
   return [self bounds];
}

-(void)drawFocusRingMask
{
   CGRect inset = CGRectInset([self bounds], knobInset, knobInset);
   NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:inset xRadius:onSwitchRadius - 1.0f yRadius:onSwitchRadius - 1.0f];
   [path fill];
}

-(BOOL)canBecomeKeyView
{
   return YES;
}

-(BOOL)acceptsFirstResponder
{
   return YES;
}

-(void)moveLeft:(id)sender {
   [self setState:NO];
}

-(void)moveRight:(id)sender {
   [self setState:YES];
}

-(void)performClick:(id)sender {
   [self setState:!state];
   [super performClick:sender];
}

-(void)updatePosition
{
   CGPoint desired;
   if([self state]){
      desired = CGPointMake([self bounds].size.width - [knob bounds].size.width, 0.0f);
   }else{
      desired = CGPointZero;
   }
   [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
      [[knob animator] setFrameOrigin:desired];
   } completionHandler:^{
   }];
}

@end