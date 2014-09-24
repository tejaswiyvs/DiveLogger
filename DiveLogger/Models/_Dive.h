// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Dive.h instead.

#import <CoreData/CoreData.h>


extern const struct DiveAttributes {
	__unsafe_unretained NSString *airTemperature;
	__unsafe_unretained NSString *diveDate;
	__unsafe_unretained NSString *diveDepth;
	__unsafe_unretained NSString *diveLocationX;
	__unsafe_unretained NSString *diveLocationY;
	__unsafe_unretained NSString *diveName;
	__unsafe_unretained NSString *diveNotes;
	__unsafe_unretained NSString *diveTime;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *visibility;
	__unsafe_unretained NSString *waterTemperature;
} DiveAttributes;

extern const struct DiveRelationships {
	__unsafe_unretained NSString *tank;
} DiveRelationships;

extern const struct DiveFetchedProperties {
} DiveFetchedProperties;

@class Tank;













@interface DiveID : NSManagedObjectID {}
@end

@interface _Dive : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DiveID*)objectID;





@property (nonatomic, strong) NSNumber* airTemperature;



@property double airTemperatureValue;
- (double)airTemperatureValue;
- (void)setAirTemperatureValue:(double)value_;

//- (BOOL)validateAirTemperature:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* diveDate;



//- (BOOL)validateDiveDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* diveDepth;



//- (BOOL)validateDiveDepth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* diveLocationX;



@property float diveLocationXValue;
- (float)diveLocationXValue;
- (void)setDiveLocationXValue:(float)value_;

//- (BOOL)validateDiveLocationX:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* diveLocationY;



@property float diveLocationYValue;
- (float)diveLocationYValue;
- (void)setDiveLocationYValue:(float)value_;

//- (BOOL)validateDiveLocationY:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* diveName;



//- (BOOL)validateDiveName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* diveNotes;



//- (BOOL)validateDiveNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* diveTime;



@property int32_t diveTimeValue;
- (int32_t)diveTimeValue;
- (void)setDiveTimeValue:(int32_t)value_;

//- (BOOL)validateDiveTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* visibility;



@property double visibilityValue;
- (double)visibilityValue;
- (void)setVisibilityValue:(double)value_;

//- (BOOL)validateVisibility:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* waterTemperature;



@property double waterTemperatureValue;
- (double)waterTemperatureValue;
- (void)setWaterTemperatureValue:(double)value_;

//- (BOOL)validateWaterTemperature:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Tank *tank;

//- (BOOL)validateTank:(id*)value_ error:(NSError**)error_;





@end

@interface _Dive (CoreDataGeneratedAccessors)

@end

@interface _Dive (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAirTemperature;
- (void)setPrimitiveAirTemperature:(NSNumber*)value;

- (double)primitiveAirTemperatureValue;
- (void)setPrimitiveAirTemperatureValue:(double)value_;




- (NSDate*)primitiveDiveDate;
- (void)setPrimitiveDiveDate:(NSDate*)value;




- (NSString*)primitiveDiveDepth;
- (void)setPrimitiveDiveDepth:(NSString*)value;




- (NSNumber*)primitiveDiveLocationX;
- (void)setPrimitiveDiveLocationX:(NSNumber*)value;

- (float)primitiveDiveLocationXValue;
- (void)setPrimitiveDiveLocationXValue:(float)value_;




- (NSNumber*)primitiveDiveLocationY;
- (void)setPrimitiveDiveLocationY:(NSNumber*)value;

- (float)primitiveDiveLocationYValue;
- (void)setPrimitiveDiveLocationYValue:(float)value_;




- (NSString*)primitiveDiveName;
- (void)setPrimitiveDiveName:(NSString*)value;




- (NSString*)primitiveDiveNotes;
- (void)setPrimitiveDiveNotes:(NSString*)value;




- (NSNumber*)primitiveDiveTime;
- (void)setPrimitiveDiveTime:(NSNumber*)value;

- (int32_t)primitiveDiveTimeValue;
- (void)setPrimitiveDiveTimeValue:(int32_t)value_;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSNumber*)primitiveVisibility;
- (void)setPrimitiveVisibility:(NSNumber*)value;

- (double)primitiveVisibilityValue;
- (void)setPrimitiveVisibilityValue:(double)value_;




- (NSNumber*)primitiveWaterTemperature;
- (void)setPrimitiveWaterTemperature:(NSNumber*)value;

- (double)primitiveWaterTemperatureValue;
- (void)setPrimitiveWaterTemperatureValue:(double)value_;





- (Tank*)primitiveTank;
- (void)setPrimitiveTank:(Tank*)value;


@end
