// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Item.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ItemID : NSManagedObjectID {}
@end

@interface _Item : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ItemID *objectID;

@property (nonatomic, strong, nullable) NSString* category;

@property (nonatomic, strong, nullable) NSDate* date;

@property (nonatomic, strong, nullable) NSData* image;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* price;

@property (atomic) float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

@end

@interface _Item (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(nullable NSString*)value;

- (nullable NSDate*)primitiveDate;
- (void)setPrimitiveDate:(nullable NSDate*)value;

- (nullable NSData*)primitiveImage;
- (void)setPrimitiveImage:(nullable NSData*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(nullable NSNumber*)value;

- (float)primitivePriceValue;
- (void)setPrimitivePriceValue:(float)value_;

@end

@interface ItemAttributes: NSObject 
+ (NSString *)category;
+ (NSString *)date;
+ (NSString *)image;
+ (NSString *)name;
+ (NSString *)price;
@end

NS_ASSUME_NONNULL_END
