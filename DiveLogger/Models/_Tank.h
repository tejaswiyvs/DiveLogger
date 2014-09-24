// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tank.h instead.

#import <CoreData/CoreData.h>


extern const struct TankAttributes {
	__unsafe_unretained NSString *airComposition;
	__unsafe_unretained NSString *airCompositionNotes;
	__unsafe_unretained NSString *endingPressure;
	__unsafe_unretained NSString *startingPressure;
} TankAttributes;

extern const struct TankRelationships {
	__unsafe_unretained NSString *dive;
} TankRelationships;

extern const struct TankFetchedProperties {
} TankFetchedProperties;

@class Dive;






@interface TankID : NSManagedObjectID {}
@end

@interface _Tank : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TankID*)objectID;





@property (nonatomic, strong) NSString* airComposition;



//- (BOOL)validateAirComposition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* airCompositionNotes;



//- (BOOL)validateAirCompositionNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* endingPressure;



@property int32_t endingPressureValue;
- (int32_t)endingPressureValue;
- (void)setEndingPressureValue:(int32_t)value_;

//- (BOOL)validateEndingPressure:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startingPressure;



@property int32_t startingPressureValue;
- (int32_t)startingPressureValue;
- (void)setStartingPressureValue:(int32_t)value_;

//- (BOOL)validateStartingPressure:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Dive *dive;

//- (BOOL)validateDive:(id*)value_ error:(NSError**)error_;





@end

@interface _Tank (CoreDataGeneratedAccessors)

@end

@interface _Tank (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAirComposition;
- (void)setPrimitiveAirComposition:(NSString*)value;




- (NSString*)primitiveAirCompositionNotes;
- (void)setPrimitiveAirCompositionNotes:(NSString*)value;




- (NSNumber*)primitiveEndingPressure;
- (void)setPrimitiveEndingPressure:(NSNumber*)value;

- (int32_t)primitiveEndingPressureValue;
- (void)setPrimitiveEndingPressureValue:(int32_t)value_;




- (NSNumber*)primitiveStartingPressure;
- (void)setPrimitiveStartingPressure:(NSNumber*)value;

- (int32_t)primitiveStartingPressureValue;
- (void)setPrimitiveStartingPressureValue:(int32_t)value_;





- (Dive*)primitiveDive;
- (void)setPrimitiveDive:(Dive*)value;


@end
