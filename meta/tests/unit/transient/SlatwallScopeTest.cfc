/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	// getEntity()
	public void function getEntity_works() {
		assert(!isNull(request.slatwallScope.getEntity('SlatwallCountry', 'US')));
	}
	
	public void function getEntity_works_with_struct() {
		assert(!isNull(request.slatwallScope.getEntity('Country', {countryCode='US'})));
	}
	
	// getAccountData() 
	public void function getAccountData_returns_valid_struct() {
		var ad = request.slatwallScope.getAccountData();
		assert(isStruct(ad));
	}
	
	public void function getAccountData_without_any_propertyList_returns_all_available_properties() {
		var ad = request.slatwallScope.getAccountData();
		
		assertEquals(structCount(ad), 12);
	}
	
	public void function getAccountData_returns_errors_set_on_account() {
		request.slatwallScope.getAccount().addError( 'firstName', 'The First Name is Required' );
		request.slatwallScope.getAccount().addError( 'lastName', 'The Last Name is Required' );
		request.slatwallScope.getAccount().addError( 'lastName', 'The Last Name must be xyz' );
		
		var ad = request.slatwallScope.getAccountData( 'accountID' );
		
		assert(ad.hasErrors, "The account data 'hasErrors' is set to true ");
		
		assertEquals(structCount(ad.errors), 2, "Check to make sure that there are 2 error keys for the 2 errors that was added");
		
		assert(structKeyExists(ad.errors, "firstName"), 1, "The 'firstName' error key exists");
		assert(structKeyExists(ad.errors, "lastName"), 1, "The 'lastName' error key exists");
		
		assert(arrayLen(ad.errors.firstName), 1, "There is only 1 message for the 'firstName' error");
		assert(arrayLen(ad.errors.lastName), 2, "There are 2 messages for the 'lastName' error");
		
		assertEquals(ad.errors.firstName[1], "The First Name is Required", "The correct error message exists");
		assertEquals(ad.errors.lastName[1], "The Last Name is Required", "The correct error message exists");
		assertEquals(ad.errors.lastName[2], "The Last Name must be xyz", "The correct error message exists");
	}
	
	public void function getAccountData_always_includes_hasErrors_and_errors_and_processObjects() {
		var ad = request.slatwallScope.getAccountData( 'accountID' );
		
		// hasErrors check
		assert(structKeyExists(ad, 'hasErrors'), "The 'hasErrors' key doesn't exist in response data");
		assert(isBoolean(ad.hasErrors), "The data in the 'hasErrors' key isn't a boolean");
		
		// errors check
		assert(structKeyExists(ad, 'errors'), "The 'errors' key exists in response data");
		assert(isStruct(ad.errors), "The data in the 'errors' key isn't a structure");
		
		// errors check
		assert(structKeyExists(ad, 'processObjects'), "The 'processObjects' key doesn't exist in response data");
		assert(isStruct(ad.processObjects), "The data in the 'processObjects' key isn't a structure");
	}
	
	public void function getAccountData_with_specific_propertyList_returns_only_those_keys() {
		var ad = request.slatwallScope.getAccountData( 'accountID,firstName,lastName' );
		
		// Should be 5... the 3 listed above, plus 'hasErrors', 'errors' & 'processObjects'
		assertEquals(structCount(ad), 6);
	}
	
	public void function getAccountData_with_specific_propertyList_returns_correct_values() {
		request.slatwallScope.getAccount().setFirstName( 'test-first' );
		request.slatwallScope.getAccount().setLastName( 'test-last' );
		
		var ad = request.slatwallScope.getAccountData( 'accountID,firstName,lastName' );
		
		assertEquals( 6, structCount(ad));
		
		// Check that each of the specific ones are there
		assert(structKeyExists(ad, 'accountID'));
		assertEquals(ad.accountID, '');
		
		assert(structKeyExists(ad, 'firstName'));
		assertEquals(ad.firstName, 'test-first');
		
		assert(structKeyExists(ad, 'lastName'));
		assertEquals(ad.lastName, 'test-last');
	}
	
	public void function getAccountData_passing_invalid_property_wont_add_to_return() {
		var ad = request.slatwallScope.getAccountData( 'accountID,firstName,lastName,createdDateTime' );
		
		assertEquals( 6, structCount(ad));
		
		assertFalse( structKeyExists(ad, "createdDateTime") );
	}
	
	// getCartData()
	public void function getCartData_returns_valid_struct() {
		var cd = request.slatwallScope.getCartData();
		assert(isStruct(cd));
	}
	
	public void function getCartData_without_any_propertyList_returns_all_available_properties() {
		var cd = request.slatwallScope.getCartData();
		
		assertEquals(16, structCount(cd));
	}
	
	
	public void function getCartData_returns_errors_set_on_cart() {
		request.slatwallScope.getCart().addError( 'addOrderPayment', 'The order payment could not be added' );
		
		var cd = request.slatwallScope.getCartData( 'orderid' );
		
		assert(cd.hasErrors, "The cart data 'hasErrors' is set to true ");
		
		assertEquals(structCount(cd.errors), 1, "Check to make sure that there only 1 error key for the 1 error that was added");
		
		assert(structKeyExists(cd.errors, "addOrderPayment"), 1, "The correct error key exists");
		
		assert(arrayLen(cd.errors.addOrderPayment), 1, "There is only 1 message for the error");
		
		assertEquals(cd.errors.addOrderPayment[1], "The order payment could not be added", "The correct error message exists");
	}
	
	
	public void function getCartData_always_includes_hasErrors_and_errors() {
		var cd = request.slatwallScope.getCartData( 'orderid' );
		
		// Should be 5... the 1 listed above, plus 'hasErrors', 'errors' and 'processObjects'
		assertEquals(4, structCount(cd));
		
		// hasErrors check
		assert(structKeyExists(cd, 'hasErrors'), "The 'hasErrors' key exists in response data");
		assertFalse(cd.hasErrors, "The value for 'hasErrors' is set to false");
		
		// errors check
		assert(structKeyExists(cd, 'errors'), "The 'errors' key exists in response data");
		assert(isStruct(cd.errors), "The data in the 'errors' key is a structure");
		assertEquals(0, structCount(cd.errors), "The error keys come back as an empty struct by default");
	}
	
	public void function getCartData_with_specific_propertyList_returns_only_those_keys() {
		var cd = request.slatwallScope.getCartData( 'orderid' );
		
		// Should be 4... the 1 listed above, plus 'hasErrors', 'errors' and 'processObjects'
		assertEquals( 4, structCount(cd));
	}
	
	public void function getCartData_passing_invalid_property_wont_add_to_return() {
		var cd = request.slatwallScope.getCartData( 'orderID,hushpuppy' );
		
		assertEquals(4, structCount(cd));
		
		assertFalse( structKeyExists(cd, "hushbuppy") );
	}
	
}


