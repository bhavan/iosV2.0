//
//  OCHamcrest - OCHamcrest.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

/**
	@defgroup library Matcher Library

	Library of Matcher implementations
 */

/**
	@defgroup core_matchers Core Matchers
 
	Fundamental matchers of objects and values, and composite matchers
 
	@ingroup library
 */
#import "HCAllOf.h"
#import "HCAnyOf.h"
#import "HCDescribedAs.h"
#import "HCIs.h"
#import "HCIsAnything.h"
#import "HCIsEqual.h"
#import "HCIsInstanceOf.h"
#import "HCIsNil.h"
#import "HCIsNot.h"
#import "HCIsSame.h"

/**
	@defgroup collection_matchers Collection Matchers
    
    Matchers of collections
 
	@ingroup library
 */
#import "HCHasCount.h"
#import "HCIsCollectionContaining.h"
#import "HCIsCollectionContainingInAnyOrder.h"
#import "HCIsCollectionContainingInOrder.h"
#import "HCIsCollectionOnlyContaining.h"
#import "HCIsDictionaryContaining.h"
#import "HCIsDictionaryContainingEntries.h"
#import "HCIsDictionaryContainingKey.h"
#import "HCIsDictionaryContainingValue.h"
#import "HCIsEmptyCollection.h"
#import "HCIsIn.h"

/**
	@defgroup number_matchers Number Matchers
    
    Matchers that perform numeric comparisons
 
	@ingroup library
 */
#import "HCIsCloseTo.h"
#import "HCOrderingComparison.h"

/**
	@defgroup primitive_number_matchers Primitive Number Matchers

	Matchers for testing equality against primitive numeric types

	@ingroup number_matchers
 */
#import "HCIsEqualToNumber.h"

/**
	@defgroup object_matchers Object Matchers
    
    Matchers that inspect objects
 
	@ingroup library
 */
#import "HCHasDescription.h"

/**
	@defgroup text_matchers Text Matchers
    
    Matchers that perform text comparisons
 
	@ingroup library
 */
#import "HCIsEqualIgnoringCase.h"
#import "HCIsEqualIgnoringWhiteSpace.h"
#import "HCStringContains.h"
#import "HCStringEndsWith.h"
#import "HCStringStartsWith.h"

/**
	@defgroup integration Unit Test Integration
 */
#import "HCAssertThat.h"

/**
	@defgroup integration_numeric Unit Tests of Primitive Numbers

	Unit test integration for primitive numbers

	@ingroup integration
 */
#import "HCNumberAssert.h"

/**
	@defgroup core Core API
 */

/**
	@defgroup helpers Helpers
 
	Utilities for writing Matchers
 
	@ingroup core
 */
