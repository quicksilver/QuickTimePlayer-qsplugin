//
//  QSQuicktimePlugin_Source.m
//
//  Created by Henngin Jungkurth on 14/04/12
//

#import "QSQuicktimePlugin_Source.h"

#define bundleIdentifier @"com.apple.QuickTimePlayerX"

@implementation QSQuicktimePlugin_Source
// Right arrowing into QuickTime Player.app
- (BOOL)loadChildrenForObject:(QSObject *)object {
	NSMutableArray *documentsArray = [NSMutableArray arrayWithCapacity:0];

	// make sure latest changes are available
	CFPreferencesSynchronize((CFStringRef) bundleIdentifier,
							 kCFPreferencesCurrentUser,
							 kCFPreferencesAnyHost);

	NSArray *recentDocuments = [(NSArray *)CFPreferencesCopyValue((CFStringRef) @"MGRecentURLPropertyLists",
														 (CFStringRef) bundleIdentifier,
														 kCFPreferencesCurrentUser,
														 kCFPreferencesAnyHost) autorelease];
	NSURL *url;
	NSError *err;
	for(NSData *bookmarkData in recentDocuments) {
		err = nil;
		url = [NSURL URLByResolvingBookmarkData:bookmarkData
										options:NSURLBookmarkResolutionWithoutMounting|NSURLBookmarkResolutionWithoutUI
								  relativeToURL:nil
							bookmarkDataIsStale:NO
										  error:&err];
		if (url == nil || err != nil) {
			// couldn't resolve bookmark, so skip
			continue;
		}
		[documentsArray addObject:[QSObject fileObjectWithPath:[url path]]];
	}

	if ([documentsArray count] == 0) {
		return NO;
	}

	[object setChildren:documentsArray];
	return YES;
}

@end
