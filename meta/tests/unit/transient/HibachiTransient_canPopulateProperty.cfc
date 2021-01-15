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
    
    
    // @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		
		request.slatwallScope.getAccount().setSuperUserFlag(false);
		
		variables.entityService = request.slatwallScope.getService( 'accountService' );
		variables.entity = request.slatwallScope.getBean('account');
	}
    
    private struct function getSampleAccountData(){
        
	    var account = {
	        "accountID"           : '', 
	        "company"             : "Ten24",
	        "lastName"            : "Yadav", 
	        "username"            : "nitin.yadav.test"&rand(), 
	        "remoteID"            : randRange( 1, 999999999 ),
	        "firstName"           : "Nitin",  
	        "activeFlag"          : false,
	        'importRemoteID'      : hash( rand(), 'MD5'),
	        "organizationFlag"    : false
	    };
	    
	    account[ 'primaryPhoneNumber' ] = createPhoneNumberData();
	    account[ 'accountPhoneNumbers' ] = [];
	    for(var i=1; i<=randRange(1,6); i++ ){
	        account.accountPhoneNumbers.append(createPhoneNumberData());
	    }

	    account[ 'primaryEmailAddress' ] = createEmailAddressData();
	    account[ 'accountEmailAddresses' ] = [];
	    for(var i=1; i<=randRange(1,6); i++ ){
	        account.accountEmailAddresses.append(createEmailAddressData());
	    }

	    account[ 'primaryAddress' ] = createAccountAddressData();
	    account[ 'accountAddresses' ] = [];
	    for(var i=1; i<=randRange(1,6); i++ ){
	        account.accountAddresses.append(createAccountAddressData());
	    }
	    
	    return account;
	}
	
	private struct function createPhoneNumberData(){
	    return {
            "remoteID"              : randRange( 1, 999999999 ),
            "phoneNumber"           : randRange( 9000000001, 9999999999 ),
	        'importRemoteID'        : hash( rand(), 'MD5'),
            "countryCallingCode"    : "+91",
            "accountPhoneNumberID"  : ""
        };
	}
	
	private struct function createEmailAddressData(){
	    return {
            "remoteID"              : randRange( 1, 999999999 ),
            "emailAddress"          : "nitin.yadav.test"&rand()&"@ten24web.com",
	        'importRemoteID'        : hash( rand(), 'MD5'),
            "accountEmailAddressID" : ""
        };
	}
	
	private struct function createAccountAddressData(){
	    return {
	        'address'             : createAddressData(),
	        "remoteID"            : randRange( 1, 999999999 ),
	        'importRemoteID'      : hash( rand(), 'MD5'),
	        "accountAddressID"    : '',
	        'accountAddressName'  : 'Test Account Address '&rand()
	    }
	}
	
	private struct function createAddressData(){
	    return {
            "addressID"         : '',
        	"remoteID"          : randRange( 1, 999999999 ),
        	"name"              : "Test address "&rand(),
        	"city"              : "Delhi",
        	"company"           : 'Ten24',
        	"locality"          : "Whatever locality",
        	"stateCode"         : "DL",
        	"postalCode"        : randRange( 100000, 999999 ),
        	"countryCode"       : "IN",
        	"streetAddress"     : 'Test street '&rand(),
        	"street2Address"    : 'Test street address 2',
	        'importRemoteID'    : hash( rand(), 'MD5'),
        };
	}
	
	
	/**
	* @test
	*/
	public void function populate_works() {
        // debug( variables.entity );
        // var data = getSampleAccountData();
        // debug( data );
        // variables.entity.populate( data );
        // debug( variables.entity );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__true__for_populateMode__default(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : true
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "default" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__true__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : true
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__true__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : true
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
	
	
    /**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__true__for_populateMode__private_even__when_user_does_not_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return false;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : true
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__true__for_populateMode__public__even__when_user_does_not_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return false;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : true
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__true__for_populateMode__default_even__when_user_does_not_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return false;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : true
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__false__for_populateMode__default(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : false
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "default" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__false__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : false
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__false__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : false
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__false__for_populateMode__private_even__when_user_does_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : false
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__false__for_populateMode__public__even__when_user_does_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : false
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__false__for_populateMode__default__even__when_user_does_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : false
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__none__for_populateMode__default(){
	    var propertyMeta = {
	        "name"               : "xyg",
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "default" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__none__for_populateMode__default__when_user_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "default" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__none__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__none__for_populateMode__public__when_user_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__none__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__none__for_populateMode__private__when_user_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__unknown__for_populateMode__default(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'whatever'

	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "default" )
	    );
	}
		
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__unknown__for_populateMode__default__when_user_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'whatever'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "default" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__unknown__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'whatever'

	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
		
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__unknown__for_populateMode__public__when_user_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'whatever'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__unknown__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'whatever'

	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__unknown__for_populateMode__private__when_user_have_crud_permissions(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'whatever'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}	
		
	
	
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__default__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'default'
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__default__for_populateMode__public__when_user_does_not_have_crud_permission(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return false;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'default'
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__default__for_populateMode__public__when_user_have_crud_permission(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'default'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__default__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'default'
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
		
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__default__for_populateMode__private__when_user_does_not_have_crud_permission(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return false;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'default'
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__default__for_populateMode__private__when_user_have_crud_permission(){
	    
	    var realFunction = request.slatwallScope['authenticateEntityProperty'];
	    
	    
	    request.slatwallScope['authenticateEntityProperty'] = function(){
	        return true;
	    }
	    
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'default'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	    
	    request.slatwallScope['authenticateEntityProperty'] = realFunction;
	}
	
	
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__public__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'public'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__public__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'public'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
	
	
	
	/**
	 * @Test 
	*/
	public void function it_should_not_allow__populateLevel__private__for_populateMode__public(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'private'
	    }
	    
	    $assert.isFalse(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "public" )
	    );
	}
	
	/**
	 * @Test 
	*/
	public void function it_should_allow__populateLevel__private__for_populateMode__private(){
	    var propertyMeta = {
	        "name"               : "xyg",
	        "hb_populateEnabled" : 'private'
	    }
	    
	    $assert.isTrue(
	        request.slatwallScope.getBean('account').canPopulateProperty(propertyMeta, "private" )
	    );
	}
	


}


