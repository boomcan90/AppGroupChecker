#include "PTPRootListController.h"
#include <Cephei/HBOutputForShellCommand.h>

@implementation PTPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void) alert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button Test"
    message: @"Will this work?"
    delegate:nil
    cancelButtonTitle:@"Done"
    otherButtonTitles:nil];
    [alert show];
}

- (void) openButton {

    NSMutableArray * allAppGroups = [NSMutableArray new];
    NSString *applications = HBOutputForShellCommand(@"find /private/var/containers/Bundle/Application/ -maxdepth 3 -executable -type f");
    // Sample output: 
    // /private/var/containers/Bundle/Application/2E1CC8C3-9019-40AE-8B62-A0963E40F862/Challenge.app/Challenge
    // /private/var/containers/Bundle/Application/FFB747EF-28CD-46D3-844B-649C815A8C9C/WhatsApp.app/WhatsApp  

    NSArray *applicationsArray = [applications componentsSeparatedByString: @"\n"];
    unsigned int cnt = [applicationsArray count];
    NSLog(@"%i", cnt);

    for (int i = 0; i < [applicationsArray count]; i++) {
        
        NSLog(@"%d", i);
        NSLog(@"%@", applicationsArray[i]);

        NSString *command = [NSString stringWithFormat:@"%@%@", @"jtool --ent ", applicationsArray[i]];
        
        NSString *commandOutput = HBOutputForShellCommand(command);

        NSData * data = [commandOutput dataUsingEncoding:NSUTF8StringEncoding];

        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSDictionary * dict = (NSDictionary*)[NSPropertyListSerialization
                                        propertyListFromData:data
                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                        format:&format
                                        errorDescription:&errorDesc];


        NSArray *keys = [dict allKeys];

        NSLog(@"%@", keys);
        if ([keys containsObject:@"com.apple.security.application-groups"]) {
            

            NSArray *pathImmutableArray = [applicationsArray[i] componentsSeparatedByString:@"/"];

            NSMutableArray *path = [pathImmutableArray mutableCopy];
            [path removeLastObject];
            [path addObject:@"Info.plist"];

            NSString *pathToInfo = [[path valueForKey:@"description"] componentsJoinedByString:@"/"];

            NSDictionary * dict2 = [NSDictionary dictionaryWithContentsOfFile:pathToInfo];

            NSString * bundleName = dict2[@"CFBundleDisplayName"]; 
            NSString * appGroups = dict[@"com.apple.security.application-groups"];

            NSString * toAppend = [NSString stringWithFormat:@"%@:%@\n", bundleName, appGroups];

            [allAppGroups addObject:toAppend];
            NSLog(@"%@", toAppend);
        } else {
            NSLog(@"Not the right thing");
        }
    }

    NSLog(@"Calling Alert");

    NSString * output = [[allAppGroups valueForKey:@"description"] componentsJoinedByString:@"\n"];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Application Groups"
                               message:output 
                               preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Copy to Clipboard" style:UIAlertActionStyleDefault
   handler:^(UIAlertAction * action) {
       UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = output;
   }];
 
[alert addAction:defaultAction];
[self presentViewController:alert animated:YES completion:nil];

    // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button Test"
    // message:output
    // delegate:nil
    // cancelButtonTitle:@"Done"
    // otherButtonTitles:nil];
    // [alert show];


    
@end

// message:HBOutputForShellCommand(@"find /private/var/containers/Bundle/Application/ -maxdepth 3 -executable -type f -print0 | while read -d $'\\0' file; do echo -n \"$file\" | gawk -F '/' '{print $NF}' ; jtool --ent \"$file\" -arch arm64 | grep -A2 com.apple.security.application-group | grep string | sed 's|<string>||g' | sed 's|<\\/string>||g' | gawk '{$1=$1};1'; done | grep -B1 group | grep -v \"\\-\\-\"")
    
