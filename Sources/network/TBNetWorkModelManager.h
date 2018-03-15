//
//  TBNetWorkModelManager.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/6/4.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@class TBNetWorkHttpModel;
@interface TBNetWorkModelManager : NSObject

{
    NSMutableArray *allRequests;
    BOOL enablePersistent;
}

@property(nonatomic,strong) NSString *sqlitePassword;
@property(nonatomic,assign) int saveRequestMaxCount;

/**
 *  get recorded requests 's SQLite filename
 *
 *  @return filename
 */
+ (NSString *)filename;

/**
 *  get NEHTTPModelManager's singleton object
 *
 *  @return singleton object
 */
+ (TBNetWorkModelManager *)defaultManager;

/**
 *  create NEHTTPModel table
 */
- (void)createTable;


/**
 *  add a NEHTTPModel object to SQLite
 *
 *  @param aModel a NEHTTPModel object
 */
- (void)addModel:(TBNetWorkHttpModel *) aModel;

/**
 *  get SQLite all NEHTTPModel object
 *
 *  @return all NEHTTPModel object
 */
- (NSMutableArray *)allobjects;

/**
 *  delete all SQLite records
 */
- (void) deleteAllItem;

- (NSMutableArray *)allMapObjects;
- (void)addMapObject:(TBNetWorkHttpModel *)mapReq;
- (void)removeMapObject:(TBNetWorkHttpModel *)mapReq;
- (void)removeAllMapObjects;



@end
