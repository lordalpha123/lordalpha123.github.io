#import <UIKit/UIKit.h>
#import <substrate.h>

#import "interfaces.h"

%hook PSListController

- (void)viewDidLoad
{
	%orig;
	
	if(self.WTT_isAPNetworksController) {
		UISwitch *toggle = [[UISwitch alloc] init];
		
		[toggle addTarget:self action:@selector(WTT_toggledWiFiSwitch:) forControlEvents:UIControlEventValueChanged];
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toggle];
	}
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell *cell = %orig;
	
	if(self.WTT_isAPNetworksController) {
		[(UISwitch*)self.navigationItem.rightBarButtonItem.customView setOn:MSHookIvar<WiFiManager*>(self, "_manager").enabled animated:YES];
		
		if(indexPath.section == 0) {
			switch(indexPath.row) {
				case 0:
					cell.hidden = YES;
					break;
				case 1:
					[self WTT_addTopSeparatorToView:cell];
					break;
			}
		}
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	CGFloat height = %orig;
	
	if(self.WTT_isAPNetworksController && indexPath.section == 0 && indexPath.row == 0) {
		height = 0;
	}
	
	return height;
}

%new
- (void)WTT_addTopSeparatorToView:(UIView*)view
{
	UIView *separator = [[UIView alloc] init];
	separator.backgroundColor = MSHookIvar<UITableView*>(self, "_table").separatorColor;
	separator.translatesAutoresizingMaskIntoConstraints = NO;
	
	[view addSubview:separator];
	
	[view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:separator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:.5]];
}

%new
- (BOOL)WTT_isAPNetworksController
{
	return [self isKindOfClass:%c(APNetworksController)];
}

%new
- (void)WTT_toggledWiFiSwitch:(UISwitch*)toggle
{
	MSHookIvar<WiFiManager*>(self, "_manager").enabled = toggle.on;
}

%end

