//
//  word.h
//  english_word_iphone
//
//  Created by Arata Okura on 1/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

@property(nonatomic,retain) NSNumber *id;
@property(nonatomic,retain) NSString *english;
@property(nonatomic,retain) NSString *english_meaning;
@property(nonatomic,retain) NSString *japanese_meaning;
@property(nonatomic,retain) NSMutableArray *list;


-(BOOL)get_words_rest;
-(NSFetchedResultsController *)get:(NSNumber *)id;
-(void)update;
-(BOOL)update_words_rest;
-(void)save;
@end
