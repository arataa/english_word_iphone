//
//  UpdateContoller.m
//  english_word_iphone
//
//  Created by Arata Okura on 1/6/13.
//
//

#import "UpdateController.h"
#import "word.h"
@interface UpdateController()
@property(nonatomic, strong) NSDictionary *sections;
@property(nonatomic, strong) UITextField *english;
@property(nonatomic, strong) UITextField *english_meaning;
@property(nonatomic, strong) UITextField *japanese_meaning;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation UpdateController
@synthesize sections = _sections;
@synthesize id       = _id;
@synthesize english  = _english;
@synthesize english_meaning  = _english_meaning;
@synthesize japanese_meaning = _japanese_meaning;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.dataSource = self;
  
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
    
    self.english          = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.english.text                  = word.english;
    self.english_meaning  = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.english_meaning.text          = word.english_meaning;
    self.japanese_meaning = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.japanese_meaning.text         = word.japanese_meaning;
    
    self.tableView.dataSource = self;
    NSArray *english_rows          = [[NSArray alloc] initWithObjects:self.english,nil];
    NSArray *english_meaning_rows  = [[NSArray alloc] initWithObjects:self.english_meaning,nil];
    NSArray *japanese_meaning_rows = [[NSArray alloc] initWithObjects:self.japanese_meaning,nil];
    self.sections    = [[NSDictionary alloc] initWithObjectsAndKeys:english_rows,@"English",english_meaning_rows,@"English Meaning",japanese_meaning_rows,@"Japanese Meaning", nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(updateObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
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
}

-(void)updateObject:(id)selector
{
    Word *word            = [[Word alloc] init];
    word.english          = self.english.text;
    word.english_meaning  = self.english_meaning.text;
    word.japanese_meaning = self.japanese_meaning.text;
    word.id               = self.id;
    [word update];
}

@end
