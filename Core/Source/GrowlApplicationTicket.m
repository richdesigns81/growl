//
//  GrowlApplicationTicket.m
//  Growl
//
//  Created by Karl Adam on Tue Apr 27 2004.
//  Copyright 2004 The Growl Project. All rights reserved.
//
// This file is under the BSD License, refer to License.txt for details


#import "GrowlApplicationTicket.h"
#import "GrowlApplicationNotification.h"
#import "GrowlDefines.h"
#import "GrowlDisplayProtocol.h"
#import "NSGrowlAdditions.h"

#define UseDefaultsKey			@"useDefaults"
#define TicketEnabledKey		@"ticketEnabled"
#define UsesCustomDisplayKey	@"usesCustomDisplay"

#pragma mark -

@implementation GrowlApplicationTicket

+ (NSDictionary *) allSavedTickets {
	NSDate *start, *end; //TEMP
	start = [NSDate date]; //TEMP

	NSArray *libraryDirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, /*expandTilde*/ YES);
	NSEnumerator *libraryDirEnum = [libraryDirs objectEnumerator];
	NSString *libraryPath, *growlSupportPath;
	NSMutableDictionary *result = [NSMutableDictionary dictionary];

	while ((libraryPath = [libraryDirEnum nextObject])) {
		growlSupportPath = [libraryPath      stringByAppendingPathComponent:@"Application Support"];
		growlSupportPath = [growlSupportPath stringByAppendingPathComponent:@"Growl"];
		growlSupportPath = [growlSupportPath stringByAppendingPathComponent:@"Tickets"];
		//The search paths are returned in the order we should search in, so earlier results should take priority
		//Thus, clobbering:NO
		[GrowlApplicationTicket loadTicketsFromDirectory:growlSupportPath intoDictionary:result clobbering:NO];
	}

	end = [NSDate date]; //TEMP
	NSLog(@"Got all saved tickets in %f seconds", [end timeIntervalSinceDate:start]); //TEMP

	return result;
}

+ (void) loadTicketsFromDirectory:(NSString *)srcDir intoDictionary:(NSMutableDictionary *)dict clobbering:(BOOL)clobber {
	NSFileManager *mgr = [NSFileManager defaultManager];
	BOOL isDir;
	NSDirectoryEnumerator *growlSupportEnum = [mgr enumeratorAtPath:srcDir];
	NSString *filename;

	while ((filename = [growlSupportEnum nextObject])) {
		filename = [srcDir stringByAppendingPathComponent:filename];
		[mgr fileExistsAtPath:filename isDirectory:&isDir];

		if ((!isDir) && [[filename pathExtension] isEqualToString:@"growlTicket"]) {
			GrowlApplicationTicket *newTicket = [[GrowlApplicationTicket alloc] initTicketFromPath:filename];
			if (newTicket) {
				NSString *applicationName = [newTicket applicationName];

				if (clobber || ![dict objectForKey:applicationName]) {
					[dict setObject:newTicket forKey:applicationName];
				}
				[newTicket release];
			}
		}
	}
}

//these are specifically for auto-discovery tickets, hence the requirement of GROWL_TICKET_VERSION.
+ (BOOL)isValidTicketDictionary:(NSDictionary *)dict {
	NSNumber *versionNum = [dict objectForKey:GROWL_TICKET_VERSION];
	if ([versionNum intValue] == 1) {
		return [dict objectForKey:GROWL_NOTIFICATIONS_ALL]
			&& [dict objectForKey:GROWL_NOTIFICATIONS_DEFAULT]
			&& [dict objectForKey:GROWL_APP_NAME];
	} else {
		return NO;
	}
}

+ (BOOL)isKnownTicketVersion:(NSDictionary *)dict {
	return ([[dict objectForKey:GROWL_TICKET_VERSION] intValue] == 1);
}

#pragma mark -

+ (id)ticketWithDictionary:(NSDictionary *)ticketDict {
	return [[[GrowlApplicationTicket alloc] initWithDictionary:ticketDict] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)ticketDict {
	if (!ticketDict) {
		[self release];
		NSParameterAssert(ticketDict != nil);
		return nil;
	}
	if ((self = [super init])) {
		NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
		appName = [[ticketDict objectForKey:GROWL_APP_NAME] retain];

		//Get all the notification names and the data about them
		allNotificationNames = [[ticketDict objectForKey:GROWL_NOTIFICATIONS_ALL] retain];
		NSAssert1(allNotificationNames, @"Ticket dictionaries must contain a list of all their notifications (application name: %@)", appName);
		defaultNotifications = [ticketDict objectForKey:GROWL_NOTIFICATIONS_DEFAULT];
		if (!defaultNotifications) defaultNotifications = allNotificationNames;
		[defaultNotifications retain];

		NSEnumerator *notificationsEnum = [allNotificationNames objectEnumerator];
		NSMutableDictionary *allNotificationsTemp = [NSMutableDictionary dictionary];
		id obj;
		while ((obj = [notificationsEnum nextObject])) {
			if ([obj isKindOfClass:[NSString class]]) {
				[allNotificationsTemp setObject:[GrowlApplicationNotification notificationWithName:obj] forKey:obj];
				[self setAllowedNotifications:[ticketDict objectForKey:GROWL_NOTIFICATIONS_USER_SET]];
			} else {
				[allNotificationsTemp setObject:[GrowlApplicationNotification notificationFromDict:obj] forKey:[obj objectForKey:@"Name"]];
			}
		}
		allNotifications = [[NSDictionary alloc] initWithDictionary:allNotificationsTemp];

		NSString *fullPath = nil;
		id location = [ticketDict objectForKey:GROWL_APP_LOCATION];
		if (location) {
			if ([location isKindOfClass:[NSDictionary class]]) {
				NSDictionary *file_data = [location objectForKey:@"file-data"];
				NSURL *URL = [NSURL fileURLWithDockDescription:file_data];
				fullPath = [URL path];
			} else if ([location isKindOfClass:[NSString class]]) {
				fullPath = location;
				if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
					fullPath = nil;
				}
			}
		}
		if (!fullPath) {
			fullPath = [workspace fullPathForApplication:appName];
		}
		appPath = [fullPath retain];
		NSLog(@"got appPath: %@", appPath);

		NSData *iconData = [ticketDict objectForKey:GROWL_APP_ICON];
		if (iconData) {
			icon = [[NSImage alloc] initWithData:iconData];
		} else if (fullPath) {
			icon = [[workspace iconForFile:fullPath] retain];
		}

		id value = [ticketDict objectForKey:UseDefaultsKey];
		if (value) {
			useDefaults = [value boolValue];
		} else {
			useDefaults = YES;
		}

		value = [ticketDict objectForKey:TicketEnabledKey];
		if (value) {
			ticketEnabled = [value boolValue];
		} else {
			ticketEnabled = YES;
		}

		value = [ticketDict objectForKey:UsesCustomDisplayKey];
		if (value) {
			usesCustomDisplay = [value boolValue];
		} else {
			usesCustomDisplay = NO;
		}

		value = [ticketDict objectForKey:GrowlDisplayPluginKey];
		if (value) {
			[self setDisplayPluginNamed:value];
		} else {
			displayPlugin = nil;
		}
		[self saveTicket];
	}

	return self;
}

- (void) dealloc {
	[appName release];
	[appPath release];
	[icon release];
	[allNotifications release];
	[defaultNotifications release];
	
	[super dealloc];
}

#pragma mark -

- (id) initTicketFromPath:(NSString *) ticketPath {
	NSDictionary *ticketDict = [NSDictionary dictionaryWithContentsOfFile:ticketPath];
	if (!ticketDict) {
		NSLog(@"Tried to init a ticket from this file, but it isn't a ticket file: %@", ticketPath);
		[self release];
		return nil;
	}
	return [self initWithDictionary:ticketDict];
}

- (id) initTicketForApplication: (NSString *) inApp {
	return [self initTicketFromPath:[[[[[GrowlPreferences preferences] growlSupportDir] 
												stringByAppendingPathComponent:@"Tickets"]
												stringByAppendingPathComponent:inApp]
												stringByAppendingPathExtension:@"growlTicket"]];
}

- (NSString *) path {
	NSString *destDir;
	destDir = [[GrowlPreferences preferences] growlSupportDir];
	destDir = [destDir stringByAppendingPathComponent:@"Tickets"];
	destDir = [destDir stringByAppendingPathComponent:[appName stringByAppendingPathExtension:@"growlTicket"]];
	return destDir;
}

- (void) saveTicket {
	NSString *destDir;

	destDir = [[GrowlPreferences preferences] growlSupportDir];
	destDir = [destDir stringByAppendingPathComponent:@"Tickets"];

	[self saveTicketToPath:destDir];
}

- (void) saveTicketToPath:(NSString *)destDir {
	// Save a Plist file of this object to configure the prefs of apps that aren't running
	// construct a dictionary of our state data then save that dictionary to a file.
	NSString *savePath = [destDir stringByAppendingPathComponent:[appName stringByAppendingPathExtension:@"growlTicket"]];
	NSMutableArray *saveNotifications = [NSMutableArray array];
	NSEnumerator *notificationEnum = [allNotifications objectEnumerator];
	id obj;
	while ( (obj = [notificationEnum nextObject] ) ) {
		[saveNotifications addObject:[obj notificationAsDict]];
	}

	NSDictionary *file_data = nil;
	if (appPath) {
		file_data = [[NSURL fileURLWithPath:appPath] dockDescription];
	}

	id location = file_data ? [NSDictionary dictionaryWithObject:file_data forKey:@"file-data"] : appPath;

	NSMutableDictionary *saveDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		appName, GROWL_APP_NAME,
		saveNotifications, GROWL_NOTIFICATIONS_ALL,
		defaultNotifications, GROWL_NOTIFICATIONS_DEFAULT,
		icon ? [icon TIFFRepresentation] : [NSData data], GROWL_APP_ICON,
		location, GROWL_APP_LOCATION,
		[NSNumber numberWithBool:useDefaults], UseDefaultsKey,
		[NSNumber numberWithBool:ticketEnabled], TicketEnabledKey,
		[NSNumber numberWithBool:usesCustomDisplay], UsesCustomDisplayKey,
		nil];
	NSString *displayPluginName = [displayPlugin name];
	if (displayPluginName) {
		[saveDict setObject:displayPluginName forKey:GrowlDisplayPluginKey];
	}

	NSData *plistData;
	NSString *error;
	plistData = [NSPropertyListSerialization dataFromPropertyList:saveDict
														   format:NSPropertyListBinaryFormat_v1_0
												 errorDescription:&error];
	if (plistData) {
		[plistData writeToFile:savePath atomically:YES];
	} else {
		NSLog(@"Error writing ticket for application %@: %@", appName, error);
		[error release];
	}
}

#pragma mark -

- (NSImage *) icon {
	if (icon) {
		return icon;
	}
	NSImage *genericIcon = [[NSWorkspace sharedWorkspace] iconForFileType: NSFileTypeForHFSTypeCode(kGenericApplicationIcon)];
	[genericIcon setSize:NSMakeSize(128.0f, 128.0f)];
	return genericIcon;
}

- (void) setIcon:(NSImage *) inIcon {
	if ( icon != inIcon ) {
		[icon release];
		icon = [inIcon retain];
	}
}

- (NSString *) applicationName {
	return appName;
}

- (BOOL) ticketEnabled {
	return ticketEnabled;
}

- (void) setEnabled:(BOOL)inEnabled {
	ticketEnabled = inEnabled;
}

- (BOOL)usesCustomDisplay {
	return usesCustomDisplay;
}

- (void)setUsesCustomDisplay: (BOOL)inUsesCustomDisplay {
	usesCustomDisplay = inUsesCustomDisplay;
}

- (id <GrowlDisplayPlugin>) displayPlugin {
	return displayPlugin;
}

- (void) setDisplayPluginNamed: (NSString *)name {
	displayPlugin = [[GrowlPluginController controller] displayPluginNamed:name];
}

#pragma mark -

- (NSString *) description {
	return [NSString stringWithFormat:@"<GrowlApplicationTicket: %p>{\n\tApplicationName: \"%@\"\n\ticon: %@\n\tAll Notifications: %@\n\tDefault Notifications: %@\n\tAllowed Notifications: %@\n\tUse Defaults: %@\n}",
		self, appName, icon, allNotifications, defaultNotifications, [self allowedNotifications], ( useDefaults ? @"YES" : @"NO" )];
}

#pragma mark -

- (void) reregisterWithAllNotifications:(NSArray *) inAllNotes defaults:(id) inDefaults icon:(NSImage *) inIcon {
	if (!useDefaults) {
		/*We want to respect the user's preferences, but if the application has
		 *	added new notifications since it last registered, we want to enable those
		 *	if the application says to.
		 */
		NSEnumerator		*enumerator;
		NSMutableDictionary *allNotesCopy = [[allNotifications mutableCopy] autorelease];

		if ([inDefaults respondsToSelector:@selector(objectEnumerator)] ) {
			enumerator = [inDefaults objectEnumerator];
			Class NSNumberClass = [NSNumber class];
			unsigned numAllNotifications = [inAllNotes count];
			id obj;
			while ((obj = [enumerator nextObject])) {
				NSString *note;
				if ([obj isKindOfClass:NSNumberClass]) {
					//it's an index into the all-notifications list
					unsigned notificationIndex = [obj unsignedIntValue];
					if (notificationIndex >= numAllNotifications) {
						NSLog(@"WARNING: application %@ tried to allow notification at index %u by default, but there is no such notification in its list of %u", appName, notificationIndex, numAllNotifications);
					} else {
						note = [inAllNotes objectAtIndex:notificationIndex];
					}
				} else {
					//it's probably a notification name
					note = obj;
				}
				if (![allNotesCopy objectForKey:note]) {
					[allNotesCopy setObject:[GrowlApplicationNotification notificationWithName:note] forKey:note];
				}
			}
		} else if ([inDefaults isKindOfClass:[NSIndexSet class]]) {
			unsigned notificationIndex;
			unsigned numAllNotifications = [inAllNotes count];
			NSIndexSet *iset = (NSIndexSet *)inDefaults;
			for( notificationIndex = [iset firstIndex]; notificationIndex != NSNotFound; notificationIndex = [iset indexGreaterThanIndex:notificationIndex] ) {
				if (notificationIndex >= numAllNotifications) {
					NSLog(@"WARNING: application %@ tried to allow notification at index %u by default, but there is no such notification in its list of %u", appName, notificationIndex, numAllNotifications);
					// index sets are sorted, so we can stop here
					break;
				} else {
					NSString *note = [inAllNotes objectAtIndex:notificationIndex];
					if (![allNotesCopy objectForKey:note]) {
						[allNotesCopy setObject:[GrowlApplicationNotification notificationWithName:note] forKey:note];
					}
				}
			}
		} else {
			if (inDefaults) {
				NSLog(@"WARNING: application %@ passed an invalid object for the default notifications: %@.", appName, inDefaults);
			}
		}

		[allNotifications release];
		allNotifications = [[NSDictionary alloc] initWithDictionary:allNotesCopy];
	}

	//ALWAYS set all notifications list first, to enable handling of numeric indices in the default notifications list!
	[self setAllNotifications:inAllNotes];
	[self setDefaultNotifications:inDefaults];

	[self setIcon:inIcon];
}

- (void) reregisterWithDictionary:(NSDictionary *) dict {
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];

	NSImage *theIcon;
	NSData  *iconData = [dict objectForKey:GROWL_APP_ICON];
	if (iconData) {
		theIcon = [[[NSImage alloc] initWithData:iconData] autorelease];
	} else {
		theIcon = [workspace iconForApplication:[dict objectForKey:GROWL_APP_NAME]];
	}

	//XXX - should assimilate reregisterWithAllNotifications:defaults:icon: here
	[self reregisterWithAllNotifications:[dict objectForKey:GROWL_NOTIFICATIONS_ALL]
								defaults:[dict objectForKey:GROWL_NOTIFICATIONS_DEFAULT]
									icon:theIcon];

	NSString *fullPath = nil;
	id location = [dict objectForKey:GROWL_APP_LOCATION];
	if (location) {
		if ([location isKindOfClass:[NSDictionary class]]) {
			NSDictionary *file_data = [location objectForKey:@"file-data"];
			NSURL *URL = [NSURL fileURLWithDockDescription:file_data];
			fullPath = [URL path];
		} else if ([location isKindOfClass:[NSString class]]) {
			fullPath = location;
			if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
				fullPath = nil;
			}
		}
	}
	if (!fullPath) {
		fullPath = [workspace fullPathForApplication:appName];
	}
	[appPath release];
	appPath = [fullPath retain];
	NSLog(@"(in reregisterWithDictionary:) got appPath: %@", appPath);
}

- (NSArray *) allNotifications {
	return [[[allNotifications allKeys] retain] autorelease];
}

- (void) setAllNotifications:(NSArray *) inArray {
	if (allNotificationNames != inArray) {
		[allNotificationNames autorelease];
		allNotificationNames = [[NSArray alloc] initWithArray:inArray];
		NSMutableSet *new, *cur;
		new = [NSMutableSet setWithArray:inArray];
		
		//We want to keep all of the old notification settings and create entries for the new ones
		cur = [NSMutableSet setWithArray:[allNotifications allKeys]];
		[cur intersectSet:new];
		NSEnumerator *newEnum = [new objectEnumerator];
		NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
		id key, obj;
		while ((key = [newEnum nextObject])) {
			obj = [allNotifications objectForKey:key];
			if (obj) {
				[tmp setObject:obj forKey:key];
			} else {
				[tmp setObject:[GrowlApplicationNotification notificationWithName:key] forKey:key];
			}
		}
		[allNotifications release];
		allNotifications = [[NSDictionary dictionaryWithDictionary:tmp] retain];
	
		// And then make sure the list of default notifications also doesn't have any straglers...
		cur = [NSMutableSet setWithArray:defaultNotifications];
		[cur intersectSet:new];
		[defaultNotifications autorelease];
		defaultNotifications = [[cur allObjects] retain];
	}
}

- (NSArray *) defaultNotifications {
	return [[defaultNotifications retain] autorelease];
}

- (void) setDefaultNotifications:(id) inObject {
	[defaultNotifications autorelease];
	if (!allNotifications) {
		/*WARNING: if you try to pass an array containing numeric indices, and
		 *	the all-notifications list has not been supplied yet, the indices
		 *	WILL NOT be dereferenced. ALWAYS set the all-notifications list FIRST.
		 */
		defaultNotifications = [inObject retain];
	} else if ([inObject respondsToSelector:@selector(objectEnumerator)] ) {
		NSEnumerator *mightBeIndicesEnum = [inObject objectEnumerator];
		NSNumber *num;
		unsigned numDefaultNotifications;
		unsigned numAllNotifications = [allNotificationNames count];
		if ([inObject respondsToSelector:@selector(count)]) {
			numDefaultNotifications = [inObject count];
		} else {
			numDefaultNotifications = numAllNotifications;
		}
		NSMutableArray *mDefaultNotifications = [[NSMutableArray alloc] initWithCapacity:numDefaultNotifications];
		Class NSNumberClass = [NSNumber class];
		while ((num = [mightBeIndicesEnum nextObject])) {
			if ([num isKindOfClass:NSNumberClass]) {
				//it's an index into the all-notifications list
				unsigned notificationIndex = [num unsignedIntValue];
				if (notificationIndex >= numAllNotifications) {
					NSLog(@"WARNING: application %@ tried to allow notification at index %u by default, but there is no such notification in its list of %u", appName, notificationIndex, numAllNotifications);
				} else {
					[mDefaultNotifications addObject:[allNotificationNames objectAtIndex:notificationIndex]];
				}
			} else {
				//it's probably a notification name
				[mDefaultNotifications addObject:num];
			}
		}
		defaultNotifications = mDefaultNotifications;
	} else if ([inObject isKindOfClass:[NSIndexSet class]]) {
		unsigned notificationIndex;
		unsigned numAllNotifications = [allNotificationNames count];
		NSIndexSet *iset = (NSIndexSet *)inObject;
		NSMutableArray *mDefaultNotifications = [[NSMutableArray alloc] initWithCapacity:[iset count]];
		for( notificationIndex = [iset firstIndex]; notificationIndex != NSNotFound; notificationIndex = [iset indexGreaterThanIndex:notificationIndex] ) {
			if (notificationIndex >= numAllNotifications) {
				NSLog(@"WARNING: application %@ tried to allow notification at index %u by default, but there is no such notification in its list of %u", appName, notificationIndex, numAllNotifications);
				// index sets are sorted, so we can stop here
				break;
			} else {
				[mDefaultNotifications addObject:[allNotificationNames objectAtIndex:notificationIndex]];
			}
		}
		defaultNotifications = mDefaultNotifications;
	} else {
		if (inObject) {
			NSLog(@"WARNING: application %@ passed an invalid object for the default notifications: %@.", appName, inObject);
		}
		defaultNotifications = [allNotifications copy];
	}

	if (useDefaults) {
		[self setAllowedNotifications:defaultNotifications];
	}
}

- (NSArray *) allowedNotifications {
	NSMutableArray* allowed = [NSMutableArray array];
	NSEnumerator *notificationEnum = [allNotifications objectEnumerator];
	id obj;
	while ( (obj = [notificationEnum nextObject] ) ) {
		if ([obj enabled]) {
			[allowed addObject:[obj name]];
		}
	}
	return allowed;
}

- (void) setAllowedNotifications:(NSArray *) inArray {
	NSEnumerator *notificationEnum = [inArray objectEnumerator];
	[[allNotifications allValues] makeObjectsPerformSelector:@selector(disable)];
	id obj;
	while ( (obj = [notificationEnum nextObject] ) ) {
		[[allNotifications objectForKey:obj] enable];
	}
	useDefaults = NO;
}

- (void) setAllowedNotificationsToDefault {
	[self setAllowedNotifications:defaultNotifications];
	useDefaults = YES;
}

- (void) setNotificationEnabled:(NSString *) name {
	[[allNotifications objectForKey:name] setEnabled: YES];
	useDefaults = NO;
}

- (void) setNotificationDisabled:(NSString *) name {
	[[allNotifications objectForKey:name] setEnabled: NO];
	useDefaults = NO;
}

- (BOOL) isNotificationAllowed:(NSString *) name {
	return ticketEnabled && [self isNotificationEnabled:name];
}

- (BOOL) isNotificationEnabled:(NSString *) name {
	return [[allNotifications objectForKey:name] enabled];
}

#pragma mark Notification Accessors
// With sticky, 1 is on, 0 is off, -1 means use what's passed
// This corresponds to NSOnState, NSOffState, and NSMixedState
- (int) stickyForNotification:(NSString *) name {
	return [[allNotifications objectForKey:name] sticky];
}

- (void) setSticky:(int)sticky forNotification:(NSString *) name {
	[(GrowlApplicationNotification *)[allNotifications objectForKey:name] setSticky:sticky];
}

- (int) priorityForNotification:(NSString *) name {
	return [[allNotifications objectForKey:name] priority];
}

- (void) setPriority:(int)priority forNotification:(NSString *) name {
	[[allNotifications objectForKey:name] setPriority:(GrowlPriority)priority];
}

- (void) resetPriorityForNotification:(NSString *) name {
	[[allNotifications objectForKey:name] resetPriority];
}
@end

