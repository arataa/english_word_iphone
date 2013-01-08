//
//  word.m
//  english_word_iphone
//
//  Created by Arata Okura on 1/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "word.h"

@interface Word()
-(void)mapping:(NSDictionary *)dict;
-(NSMutableDictionary *)mapping_to_dict;
@end

@implementation Word
@synthesize id               = _id;
@synthesize english          = _english;
@synthesize english_meaning  = _english_meaning;
@synthesize japanese_meaning = _japanese_meaning;
@synthesize list             = _list;

NSManagedObjectContext *__context;

- (id)init
{
    self = [super init];
    if (self) {
        //コンテキストを設定
        AppDelegate *application = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        __context = application.managedObjectContext;
    }
    return self;
}

-(BOOL)get_words_rest{
    NSString *site = [NSString stringWithFormat:@"%@%@%@",WEBSITE_URL,@"/",GET_REST];
    NSURL *url = [NSURL URLWithString:site];
    NSURLResponse* response = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSError *e   = nil;
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    
    self.list = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dict in array){
        Word *word = [[Word alloc] init];
        [word mapping:dict];
        [self.list addObject:word];
        [word update];
    }
    if (![__context save:&e]) {
        NSLog(@"Unresolved error %@, %@", e, [e userInfo]);
        return false;
    }
    return true;
}

-(BOOL)update_words_rest{

    NSArray *results     = [[self get:nil] fetchedObjects];
    NSMutableArray *post = [[NSMutableArray alloc]init ];
    for (NSManagedObject *result in results){
        NSArray *keys = [[[result entity] attributesByName] allKeys];
        NSDictionary *dict = [result dictionaryWithValuesForKeys:keys];
        [post addObject:dict];
    }

    NSError *e = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post
           options:NSJSONWritingPrettyPrinted error:&e];
    NSString *json_str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *site = [NSString stringWithFormat:@"%@%@%@",WEBSITE_URL,@"/",UPDATE_REST];
    NSURL *url = [NSURL URLWithString:site];
    NSURLResponse* response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[json_str dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ( res == @"true" ){
        return true;
    } else{
        return false;
    }
        
}

-(void)mapping:(NSDictionary *)dict{
    self.id               = [dict objectForKey:@"id"];
    self.english          = [dict objectForKey:@"english"];
    self.english_meaning  = [dict objectForKey:@"english_meaning"];
    self.japanese_meaning = [dict objectForKey:@"japanese_meaning"];
}

-(NSMutableDictionary *)mapping_to_dict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.id               forKey:@"id"];
    [dict setObject:self.english          forKey:@"english"];
    [dict setObject:self.english_meaning  forKey:@"english_meaning"];
    [dict setObject:self.japanese_meaning forKey:@"japanese_meaning"];
    return dict;
}

-(void)save
{
    NSError *e   = nil;
    if (![__context save:&e]) {
        NSLog(@"Unresolved error %@, %@", e, [e userInfo]);
    } 
}

-(void)update{
    NSFetchedResultsController *fetchRequestController = [self get:self.id];
    NSArray *result = fetchRequestController.fetchedObjects;
    NSManagedObject* newObject;
    if ( [result count] > 0) {
        newObject = [result objectAtIndex:0];
    }else{
        newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:__context];
    }
    
    [newObject setValue:self.id forKey:@"id"];
    [newObject setValue:self.english forKey:@"english"];
    [newObject setValue:self.english_meaning forKey:@"english_meaning"];
    [newObject setValue:self.japanese_meaning forKey:@"japanese_meaning"];
}

-(NSFetchedResultsController*)get:(NSNumber*)id{
    // DBから読み取るためのリクエストを作成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // 取得するエンティティを設定
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:__context];
    [fetchRequest setEntity:entityDescription];

    // ソート条件配列を作成
    NSSortDescriptor *desc;
    desc = [[NSSortDescriptor alloc] initWithKey:@"english" ascending:YES selector:@selector(caseInsensitiveCompare:)];

    NSArray *sortDescriptors;
    sortDescriptors = [[NSArray alloc] initWithObjects:desc, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    // 取得条件の設定
    if ( id != nil) {
        NSPredicate *pred;
        pred = [NSPredicate predicateWithFormat:@"id = %@", id];
        [fetchRequest setPredicate:pred];
    }

    // 取得最大数の設定
    [fetchRequest setFetchBatchSize:1];

    // データ取得用コントローラを作成
    NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc]
                      initWithFetchRequest:fetchRequest
                      managedObjectContext:__context
                      sectionNameKeyPath:nil
                      cacheName:@"Word"];   

    // DBから値を取得する
    NSError *error;
    if (![resultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    // 取得結果は[fetchedObjects]プロパティに入っている
    //NSArray *result = resultsController.fetchedObjects;
    
    return resultsController;
     
    /*
     self.list = [[NSMutableArray alloc] init ];
    for (NSManagedObject *data in result){
        Word *word = [[Word alloc] init];
        [word mapping:data];
        [self.list addObject:data];
    }
     */
}
@end
