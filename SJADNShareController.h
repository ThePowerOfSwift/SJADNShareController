
// SJADNShareController.h

// Seb Jachec

#import <Foundation/Foundation.h>

@interface SJADNShareController : NSObject <NSSharingServicePickerDelegate>

//If YES, share controller will try to use Mac app URL schemes
@property BOOL *shareViaLocalApps;

/*
 * Shares the given items on App.net
 */
- (void)shareItems:(NSArray*)items;

@end
