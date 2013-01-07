//
//  UpdateContoller.m
//  english_word_iphone
//
//  Created by Arata Okura on 1/6/13.
//
//

#import "UpdateContoller.h"
#import "word.h"
@interface UpdateContoller()
@property(nonatomic, strong) NSDictionary *sections;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation UpdateContoller
@synthesize sections = _sections;
@synthesize id       = _id;

-(void)viewDidLoad{
    [super viewDidLoad];
  
    Word *word = [[Word alloc] init];
    if (self.id != nil) {
        NSFetchedResultsController *fetchRequestController = [word get:self.id];
        NSArray *result = fetchRequestController.fetchedObjects;
        NSManagedObject *object = [result objectAtIndex:0];
        word.id               = [object valueForKey:@"id"];
        word.english          = [object valueForKey:@"english"];
        word.english_meaning  = [object valueForKey:@"english_meaning"];
        word.japanese_meaning = [object valueForKey:@"japanese_meaning"];
    }else{
        word.id               = nil;
        word.english          = @"";
        word.english_meaning  = @"";
        word.japanese_meaning = @"";
    }
    
    UITextField *english          = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    english.text                  = word.english;
    UITextField *english_meaning  = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    english_meaning.text          = word.english_meaning;
    UITextField *japanese_meaning = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    japanese_meaning.text         = word.japanese_meaning;
    
    self.tableView.dataSource = self;
    NSArray *english_rows          = [[NSArray alloc] initWithObjects:english,nil];
    NSArray *english_meaning_rows  = [[NSArray alloc] initWithObjects:english_meaning,nil];
    NSArray *japanese_meaning_rows = [[NSArray alloc] initWithObjects:japanese_meaning,nil];
    self.sections    = [[NSDictionary alloc] initWithObjectsAndKeys:english_rows,@"English",english_meaning_rows,@"English Meaning",japanese_meaning_rows,@"Japanese Meaning", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
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
    
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows  = [[self.sections allValues] objectAtIndex:indexPath.section];
    [cell addSubview:[rows objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 && indexPath.row == 1) {
        Word *word = [[Word alloc] init];
        [word get_words_rest];
    }
}

@end
