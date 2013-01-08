//
//  SettingController.m
//  english_word_iphone
//
//  Created by Arata Okura on 1/5/13.
//
//

#import "SettingController.h"
#import "word.h"

@interface SettingController()
@property(nonatomic, strong) NSDictionary *sections;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SettingController
@synthesize sections = _sections;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.dataSource = self;
   
    NSArray *connect = [[NSArray alloc] initWithObjects:@"push",@"pull", nil];
    self.sections    = [[NSDictionary alloc] initWithObjectsAndKeys:connect,@"Connect", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [self.sections count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = [[self.sections allValues] objectAtIndex:section];
    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows  = [[self.sections allValues] objectAtIndex:indexPath.section];
    cell.textLabel.text       = [rows objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL result;
    if ( indexPath.section == 0 && indexPath.row == 1) {
        Word *word = [[Word alloc] init];
        result = [word get_words_rest];
    }
    
    if ( indexPath.section == 0 && indexPath.row == 0) {
        Word *word = [[Word alloc] init];
        result = [word update_words_rest];
    }
  
    NSString *message = @"";
    if ( result == true) {
        message = @"Complete!";
    }else{
        message = @"Failed";
    }
    UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [resultAlert show];
}

@end