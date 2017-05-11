//
//  EVCoreDataClass.m
//  elapp
//
//  Created by 唐超 on 5/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVCoreDataClass.h"
#import "HaveReadNews+CoreDataProperties.h"
#import <CoreData/CoreData.h>

#define entityName @"HaveReadNews"
#define dbName @"ReadHistory"
static  EVCoreDataClass * _instance;
@implementation EVCoreDataClass

- (void)creatDatabase
{
//    1、创建模型对象
//    获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:dbName withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2、创建持久化助理
    //利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径
    NSString *docStr = [self dbFilePath];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"ReadHistory.db"];
    EVLog(@"path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
//    NSFileManager * manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:sqlPath]) {
//        <#statements#>
//    }
    //设置数据库相关信息
    NSError * error;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    if (error) {
        EVLog(@"创建数据库失败 error:%@",error);
    }
    else
    {
        EVLog(@"创建数据库成功 sqlUrl:%@",sqlUrl);
    }
    
    
    //3、创建上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    [context setPersistentStoreCoordinator:store];
    _context = context;
}

- (long long)getDbFileSize
{
    NSString *sqlPath = [[self dbFilePath] stringByAppendingPathComponent:@"ReadHistory.db"];
    return [self fileSizeAtPath:sqlPath];
}

- ( long long )fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}


- (void)cleanUpAllData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsPath = [self dbFilePath];
    
    //沙盒中三个文件
    NSString *filePath1 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",dbName]];
    NSString *filePath2 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db-shm",dbName]];
    NSString *filePath3 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db-wal",dbName]];
    
    NSError *error;
    
    BOOL success = [fileManager removeItemAtPath:filePath1 error:&error];
    [fileManager removeItemAtPath:filePath2 error:nil];
    [fileManager removeItemAtPath:filePath3 error:nil];
    
    if (success)
    {
        EVLog(@"Remove fiel:%@ Success!",dbName);
        [self creatDatabase];
        //清除内存中的缓存
//        [self.context.persistentStoreCoordinator removePersistentStore:self.context.persistentStoreCoordinator.persistentStores[0] error:nil];
//        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:dbName withExtension:@"momd"];
//        [self.context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:modelURL options:nil error:nil];
    }
    else
    {
        EVLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (BOOL)insertReadNewsId:(NSString *)newsid
{
    if ([self checkHaveReadNewsid:newsid]) {
        return YES;
    }
//    1.根据Entity名称和NSManagedObjectContext获取一个新的NSManagedObject
    NSManagedObject *newEntity = [NSEntityDescription
                                  insertNewObjectForEntityForName:entityName
                                  inManagedObjectContext:self.context];
//    2.根据Entity中的键值，一一对应通过setValue:forkey:给NSManagedObject对象赋值
    [newEntity setValue:newsid forKey:@"newsid"];
//    3.保存修改
    NSError *error = nil;
    BOOL result = [self.context save:&error];
    if (error) {
        EVLog(@"插入数据失败： %@",error);
    }
    return result;
}

- (BOOL)checkHaveReadNewsid:(NSString *)newsid
{
//    1.创建NSFetchRequest查询请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    2.设置需要查询的实体描述NSEntityDescription
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:self.context];
    request.entity = desc;
//    3.设置排序顺序NSSortDescriptor对象集合(可选)
//   request.sortDescriptors = descriptorArray;
    NSString * filterStr = [NSString stringWithFormat:@"newsid = %@",newsid];
//    4.设置条件过滤（可选）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterStr];
    request.predicate = predicate;
//    5.执行查询请求
    NSError *error = nil;
    // NSManagedObject对象集合
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
//    for (HaveReadNews * news in objs) {
//        EVLog(@"news.newsid:%@",news.newsid);
//    }
    
    // 查询结果数目
    NSUInteger count = objs.count;
    if (count>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}




#pragma mark - getter
- (NSManagedObjectContext *)context
{
    if (!_context) {
        [self creatDatabase];
    }
    return _context;
}

- (NSString *)dbFilePath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [EVCoreDataClass shareInstance];
}

- (instancetype)copy
{
    return [EVCoreDataClass shareInstance];
}

@end
