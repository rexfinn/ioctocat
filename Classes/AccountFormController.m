#import "AccountFormController.h"
#import "GHAccount.h"
#import "GradientButton.h"
#import "NSString+Extensions.h"


@implementation AccountFormController

@synthesize index;
@synthesize account;
@synthesize accounts;
@synthesize loginField;
@synthesize passwordField;
@synthesize tokenField;
@synthesize endpointField;
@synthesize saveButton;

- (id)initWithAccounts:(NSMutableArray *)theAccounts andIndex:(NSUInteger)theIndex {    
    [super initWithNibName:@"AccountForm" bundle:nil];
	self.index = theIndex;
	self.accounts = theAccounts;
	
	// Find existing or initialize a new account
	if (index == NSNotFound) {
		self.account = [NSMutableDictionary dictionary];
	} else {
		self.account = [accounts objectAtIndex:index];
	}
    
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [NSString stringWithFormat:@"%@ Account", index == NSNotFound ? @"New" : @"Edit"];
	loginField.text = [account valueForKey:kLoginDefaultsKey];
	passwordField.text = [account valueForKey:kPasswordDefaultsKey];
	tokenField.text = [account valueForKey:kTokenDefaultsKey];
	endpointField.text = [account valueForKey:kEndpointDefaultsKey];
}

- (void)dealloc {
	[account release], account = nil;
	[accounts release], accounts = nil;
	[loginField release], loginField = nil;
    [passwordField release], passwordField = nil;
    [tokenField release], tokenField = nil;
    [endpointField release], endpointField = nil;
	[saveButton release], saveButton = nil;
    [super dealloc];
}

- (IBAction)saveAccount:(id)sender {
	NSCharacterSet *trimSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *login = [loginField.text stringByTrimmingCharactersInSet:trimSet];
	NSString *password = [passwordField.text stringByTrimmingCharactersInSet:trimSet];
	NSString *token = [tokenField.text stringByTrimmingCharactersInSet:trimSet];
	NSString *endpoint = [endpointField.text stringByTrimmingCharactersInSet:trimSet];
	
	if ([login isEmpty] || [password isEmpty]) {
		[[iOctocat sharedInstance] alert:@"Validation failed" with:@"Please enter a login and a password"];
	} else {
		[account setValue:login forKey:kLoginDefaultsKey];
		[account setValue:password forKey:kPasswordDefaultsKey];
		[account setValue:token forKey:kTokenDefaultsKey];
		[account setValue:endpoint forKey:kEndpointDefaultsKey];
		
		// Add new account to list of accounts
		if (index == NSNotFound) [accounts addObject:account];
		
		// Save
		[AccountsController saveAccounts:accounts];
		
		// Go back
		[loginField resignFirstResponder];
		[passwordField resignFirstResponder];
		[tokenField resignFirstResponder];
		[endpointField resignFirstResponder];
		
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[loginField resignFirstResponder];
	[passwordField resignFirstResponder];
	[tokenField resignFirstResponder];
	[endpointField resignFirstResponder];
}

#pragma mark Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (textField == loginField) [passwordField becomeFirstResponder];
    if (textField == passwordField) [tokenField becomeFirstResponder];
    if (textField == tokenField) [endpointField becomeFirstResponder];
    if (textField == endpointField) [self saveAccount:nil];
	return YES;
}

#pragma mark Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

@end