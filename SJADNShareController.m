
// SJADNShareController.m

// Seb Jachec

#import "SJADNShareController.h"

@implementation SJADNShareController

- (instancetype)init {
    self = [super init];
    if (self) {
        _shareViaLocalApps = YES;
    }
    return self;
}

//NSSharingServicePickerDelegate method to insert App.net option
- (NSArray*)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker sharingServicesForItems:(NSArray *)items proposedSharingServices:(NSArray *)proposedServices {
    
    NSMutableArray *sharingServices = proposedServices.mutableCopy;
    
    //Dropdown menu image for ADN
    NSImage *ADNImage = [NSImage imageNamed:@"adn"];
    ADNImage.template = YES;
    
    NSSharingService *ADNService = [[NSSharingService alloc] initWithTitle:@"App.net" image:ADNImage alternateImage:ADNImage handler:^{
        [self shareItems:items];
    }];
    
    [sharingServices addObject:ADNService];
    
    return sharingServices;
}

//All-purpose sharing method, can be called from anywhere
- (void)shareItems:(nullable NSArray*)items {
    
    if (items.count < 1) return;
    
    NSString *postText;
    
    for (id theItem in items) {
        if ([theItem isKindOfClass:NSString.class]) {
            postText = postText? [postText stringByAppendingFormat:@"\n%@",theItem] : theItem;
        }
    }
    
    //Encode the post text, for URLs
    NSString *encodedPostText = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)postText, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    BOOL shared = NO;
    if (_shareViaLocalApps) {
        //Try to share with local apps
        shared = [self shareWithApps:encodedPostText];
    }
    
    //Share on web
    if (!shared) [self shareWithWeb:encodedPostText];
}

- (BOOL)shareWithApps:(NSString*)encodedPostText {
    NSString *kiwiPath = [NSWorkspace.sharedWorkspace absolutePathForAppBundleWithIdentifier:@"com.yourhead.kiwi"];
    if (kiwiPath) {
        //Kiwi
        NSString *postURL = [NSString stringWithFormat:@"kiwi://post?text=%@",encodedPostText];
        return [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:postURL]];
    } else {
        //Nothing to open with
        return NO;
    }
}

- (BOOL)shareWithWeb:(NSString*)encodedPostText {
    NSString *postURL = [NSString stringWithFormat:@"https://alpha.app.net/intent/post?text=%@",encodedPostText];
    return [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:postURL]];
}

@end