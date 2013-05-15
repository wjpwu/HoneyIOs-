//
//  VitPopOptions.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum{
    PopListSexs,
    PopListNations,
    PopListCustlevels,
    PopListIndiIdCardTypes,
    PopListHealth,
    PopListBanks,
    PopListRaces,
    PopListMariages,
    PopListPolicyRiskLevels,
    PopListDegrees,
    PopListGroups,
    PopListCustTypes,
    PopListPolicys,
    PopListAimPolicys,
    PopListYesNo,
    PopListCreditLevels,
    PopListOrgIdCardTypes,
    PopListOrgContactPersonPositions,
    PopListOrgBizScales,
    PopListMonths,
    PopListSelfGroups
} PopListOptionEnum;


#define KK_SEX      	    @"KK_SEX"      
#define KK_CUSTOMTYPE   	@"KK_CUSTOMTYPE"         
#define KK_DOCUMENTTYPE 	@"KK_DOCUMENTTYPE" 
#define KK_ORGDOCUMENTTYPE 	@"KK_ORGDOCUMENTTYPE" 
#define KK_CONTACTPERSONTYPE 	@"KK_CONTACTPERSONTYPE" 
#define KK_DEGREE  	        @"KK_DEGREE"  
#define KK_CUSTLEVEL 	    @"KK_CUSTLEVEL" 
#define KK_YESNO   	        @"KK_YESNO"   
#define KK_HEALTH  	        @"KK_HEALTH"  
#define KK_MARRIAGE 	    @"KK_MARRIAGE" 
#define KK_CAREERRISKLEVEL 	@"KK_CAREERRISKLEVEL" 
#define KK_CREDITKLEVEL 	@"KK_CREDITKLEVEL"
#define KK_POLICYTYPE 	    @"KK_POLICYTYPE" 
#define KK_NATION_NO 	    @"KK_NATION_NO" 
#define KK_RACE_NO 	        @"KK_RACE_NO" 
#define KK_BANKS_NO 	    @"KK_BANKS_NO" 
#define KK_CARPOLICYHISTORY 	@"KK_CARPOLICYHISTORY" 
#define KK_CARDRIVEAGE 	    @"KK_CARDRIVEAGE" 
#define KK_CARDRIVESEX 	    @"KK_CARDRIVESEX" 
#define KK_CARDRIVEEXPER	@"KK_CARDRIVEEXPER"

#define KK_CARDRIVE_AREA	@"KK_CARDRIVE_AREA"

#define KK_CARDRIVEMILES	@"KK_CARDRIVEMILES"
#define KK_CARDTHIRDPOLICYPAY	@"KK_CARDTHIRDPOLICYPAY"
#define KK_CARGLASSTYPE	    @"KK_CARGLASSTYPE"
#define KK_CARSCRATCHINSURANCE	@"KK_CARSCRATCHINSURANCE"
#define KK_CARSEPCIALFIX	@"KK_CARSEPCIALFIX"
#define KK_CARSENGINEINSURANCE	@"KK_CARSENGINEINSURANCE"
#define KK_INSURANCETYPE 	@"KK_INSURANCETYPE"

#define KK_POLICYMONTH 	@"KK_POLICYMONTH"
#define KK_CUSTOMIZEDCUSTGROUP 	@"KK_CUSTOMIZEDCUSTGROUP"
#define KK_ORGBIZSCALES    @"KK_ORGBIZSCALES"
#define KK_CITY 	    @"KK_CITY" 


#define VITOPTIONSKEY_TEXT @"text"

#import <Foundation/Foundation.h>

@interface VTPopOptions : NSObject
{
    NSDictionary *popOptions;
}

@property (nonatomic, retain) NSDictionary *popOptions;  


+ (VTPopOptions*)getInstance;
+ (NSArray*) getPopList : (NSString*) anKey;
+ (NSDictionary*) getOptionDictionaryWithHostCode : (NSString*) hostCode hostCodeKey:(NSString*)hKey arrayKey :(NSString*) anKey;
+ (NSDictionary*) getOptionDictionaryWithHostCode : (NSString*) hostCode array :(NSArray*) options;
+ (NSDictionary*) getOptionDictionaryWithText : (NSString*) theText arrayKey :(NSString*) anKey;
+ (NSDictionary*) getOptionDictionaryWithHostCode : (NSString*) hostCode arrayKey :(NSString*) anKey;
+ (NSArray*) getOptionDictionaryArrayWithHostCodes : (NSArray*) hostCodeArray arrayKey :(NSString*) anKey;

@end
