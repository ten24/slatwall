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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	// @hint put things in here that you want to run befor EACH test	
	public void function setUp() {
		super.setup();
		
		variables.entity = request.slatwallScope.newEntity('product');
	}
		
	/**
	* @test
	*/
	public void function getDefaultCollectionPropertiesTest(){
		var defaultProperties = variables.entity.getDefaultCollectionProperties();
		for(defaultProperty in defaultProperties){
			assertTrue(!structKeyExists(defaultProperty,'FKCOLUMN'));
		}
	}

	/**
	* @test
	*/
	public void function getPropertyOptionsTest(){
		var accountEmailAddress = request.slatwallScope.newEntity('AccountEmailAddress');
		var collectionOptions = accountEmailAddress.getAccountEmailTypeOptions();
		for(var i =1; i <= arraylen(collectionOptions); i++){
			assert( structKeyExists(collectionOptions[i], 'name') && structKeyExists(collectionOptions[i], 'value'));
		}
	}

	/**
	* @test
	**/
	public void function getPropertyOptionsWithAdditionalProperties(){
		var accountPaymentMethod = request.slatwallScope.newEntity('AccountPaymentMethod');
		var collectionOptions = accountPaymentMethod.getPaymentMethodOptions();
		for(var i =1; i <= arraylen(collectionOptions); i++){
			assert( structKeyExists(collectionOptions[i], 'name'), 'Option Name not found!');
			assert( structKeyExists(collectionOptions[i], 'value'), 'Option Name not found!');
			if(i > 1){
				assert( structKeyExists(collectionOptions[i], 'paymentmethodtype'), 'hb_optionsAdditionalProperties not found in the Option list!');
			}
		}

	}


	/**
	* @test
	*/
	public void function getPropertyCountTest(){

		var productMock = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = 'My Description',
			skus = [
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = 'false'
				}
			]
		};

		var product = createPersistedTestEntity('product', productMock);
		assert( product.getSkusCount() == 5);

	}






}