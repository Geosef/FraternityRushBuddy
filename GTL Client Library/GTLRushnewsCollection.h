/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLRushnewsCollection.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   rushnews/v1
// Description:
//   Rush News API
// Classes:
//   GTLRushnewsCollection (0 custom class methods, 2 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLRushnewsRushNews;

// ----------------------------------------------------------------------------
//
//   GTLRushnewsCollection
//

// This class supports NSFastEnumeration over its "items" property. It also
// supports -itemAtIndex: to retrieve individual objects from "items".

@interface GTLRushnewsCollection : GTLCollectionObject
@property (retain) NSArray *items;  // of GTLRushnewsRushNews
@property (copy) NSString *nextPageToken;
@end
