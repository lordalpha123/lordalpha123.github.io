<code class=�objc�>#import <SpringBoard/SpringBoard.h>

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" 
        message:@"Welcome to your iPhone Brandon!" 
        delegate:nil 
        cancelButtonTitle:@"Thanks" 
        otherButtonTitles:nil];
    [alert show];
    [alert release];
}

%end</code>