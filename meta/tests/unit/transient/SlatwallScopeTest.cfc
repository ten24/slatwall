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
		assertEquals(structCount(ad), 10);
	}
	
	public void function getAccountData_returns_errors_set_on_account() {
		request.slatwallScope.getAccount().addError( 'firstName', 'The First Name is Required' );
		request.slatwallScope.getAccount().addError( 'lastName', 'The First Name is Required' );
		
		var ad = request.slatwallScope.getAccountData( 'accountID' );
		
		debug(ad);
	}
	
	public void function getAccountData_always_includes_hasErrors_and_errors() {
		var ad = request.slatwallScope.getAccountData( 'accountID' );
		
		// Should be 5... the 1 listed above, plus 'hasErrors' and 'errors'
		assertEquals(structCount(ad), 3);
		
		assert(structKeyExists(ad, 'hasErrors'));
		assertEquals(ad.hasErrors, false);
		
		assert(structKeyExists(ad, 'errors'));
		assert(isStruct(ad.errors));
		assertEquals(structCount(ad.errors),0);
	}
	
	public void function getAccountData_with_specific_propertyList_returns_only_those_keys() {
		var ad = request.slatwallScope.getAccountData( 'accountID,firstName,lastName' );
		
		// Should be 5... the 3 listed above, plus 'hasErrors' and 'errors'
		assertEquals(structCount(ad), 5);
	}
	
	public void function getAccountData_with_specific_propertyList_returns_correct_values() {
		request.slatwallScope.getAccount().setFirstName( 'test-first' );
		request.slatwallScope.getAccount().setLastName( 'test-last' );
		
		var ad = request.slatwallScope.getAccountData( 'accountID,firstName,lastName' );
		
		assertEquals(structCount(ad), 5);
		
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
		
		assertEquals(structCount(ad), 5);
		
		assertFalse( structKeyExists(ad, "createdDateTime") );
	}
	
	// getCartData()
	public void function getCartData_returns_valid_struct() {
		var cd = request.slatwallScope.getAccountData();
		debug(cd);
		assert(isStruct(cd));
	}
	
	
	
}


