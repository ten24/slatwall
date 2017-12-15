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

	public void function setUp() {
		super.setup();

		variables.service = request.slatwallScope.getService("hibachiValidationService");
	}

	// validate_dataType()
	/**
	* @test
	*/
	public void function validate_dataType_creditCardNumber_returns_true_when_null() {
		var orderPayment = request.slatwallScope.newEntity('OrderPayment');

		assert( variables.service.validate_dataType(orderPayment, 'creditCardNumber', 'creditCardNumber') );
	}

	/**
	* @test
	*/
	public void function validate_dataType_creditCardNumber_returns_true_when_valid_card() {
		var orderPayment = request.slatwallScope.newEntity('OrderPayment');
		orderPayment.setCreditCardNumber("4111111111111111");

		assert( variables.service.validate_dataType(orderPayment, 'creditCardNumber', 'creditCardNumber') );
	}

	/**
	* @test
	*/
	public void function validate_dataType_creditCardNumber_returns_false_when_empty_string() {
		var orderPayment = request.slatwallScope.newEntity('OrderPayment');
		orderPayment.setCreditCardNumber(" ");

		assertFalse( variables.service.validate_dataType(orderPayment, 'creditCardNumber', 'creditCardNumber') );
	}

	/**
	* @test
	*/
	public void function validate_dataType_creditCardNumber_returns_false_when_non_numeric() {
		var orderPayment = request.slatwallScope.newEntity('OrderPayment');
		orderPayment.setCreditCardNumber("9849579HELLO29874052");

		assertFalse( variables.service.validate_dataType(orderPayment, 'creditCardNumber', 'creditCardNumber') );
	}

	/**
	* @test
	*/
	public void function getValidationStructTest(){
		var order = request.slatwallScope.newEntity('Order');
		var validation = variables.service.getValidationStruct(order);
		addToDebug(validation);
	}
	/**
	* @test
	*/
	public void function getValidationByCoreAndCustomTest_checkThatOverridingPropertiesWorks(){
		var coreValidation = variables.service.getCoreValidation('Account');

		for(var validation in coreValidation.properties.accountCode){
			if(structKeyExists(validation,'conditions') && validation.conditions == 'isOrganizationFlag'){
				assertEquals(validation.unique,true);
				assertEquals(validation.required,true);
			}
		}

		//get customValidationFile
		var customValidationFile = expandPath('/Slatwall')&'/meta/tests/unit/resources/validation/Account.json';
		var rawCustomJSON = fileRead( customValidationFile );
		var customValidation = deserializeJSON( rawCustomJSON );
		makePublic(variables.service,'getValidationByCoreAndCustom');
		var resultingValidation = variables.service.getValidationByCoreAndCustom(coreValidation,customValidation);

		for(var validation in coreValidation.properties.accountCode){
			if(structKeyExists(validation,'conditions') && validation.conditions == 'isOrganizationFlag'){
				assertEquals(validation.unique,false);
				assertEquals(validation.required,true);
			}
		}

	}

	/**
	* @test
	*/
	public void function getValidationByCoreAndCustomTest_checkThatAddingConditionsWorks(){
		var coreValidation = variables.service.getCoreValidation('Account_Create');

		assert(!structKeyExists(coreValidation.conditions,'legalAgeIsChecked'));
		//get customValidationFile
		var customValidationFile = expandPath('/Slatwall')&'/meta/tests/unit/resources/validation/Account_Create.json';
		var rawCustomJSON = fileRead( customValidationFile );
		var customValidation = deserializeJSON( rawCustomJSON );
		makePublic(variables.service,'getValidationByCoreAndCustom');
		var resultingValidation = variables.service.getValidationByCoreAndCustom(coreValidation,customValidation);
		assert(structKeyExists(coreValidation.conditions,'legalAgeIsChecked'));

	}

	/**
	* @test
	*/
	public void function validate_uniqueTest_uniquetrue(){
		var accountCode = "test"&createUUID();
		var accountData = {
			accountID="",
			accountCode=accountCode
		};
		var account = createPersistedTestEntity('Account',accountData);

		var account = createTestEntity('Account',accountData);
		account.validate('save');
		assertEquals(account.getErrors().accountCode[1],'Account Code must be unique or empty');
	}

	//validate_required()
	/**
	* @test
	*/
	public void function validate_required_test_return_true_if_isObject_and_notNull(){

		var account = request.slatwallScope.newEntity('Account');
		var address = request.slatwallScope.newEntity('Address');
		var accountAddress = request.slatwallScope.newEntity('AccountAddress');
		address.setName("personal");
		address.setStreetAddress("house no.=123, xyz Street,");
		address.setCity("Dummy");
		accountAddress.setAddress(address);
		account.setPrimaryAddress(accountAddress);
		assert(variables.service.validate_required(account, 'primaryAddress'));
	}

	/**
	* @test
	*/
	public void function validate_required_test_return_true_if_isSimpleValue_and_hasLength(){
		var account = request.slatwallScope.newEntity('Account');
		account.setFirstName("John");
		assert(variables.service.validate_required(account,'firstName'));
	}

	/**
	* @test
	*/
	public void function validate_required_test_return_false_if_isSimpleValue_and_hasNoLength(){
		var account = request.slatwallScope.newEntity('Account');
		account.setFirstName("");
		assertfalse(variables.service.validate_required(account,'firstName'));
	}

	/**
	* @test
	*/
	public void function validate_required_test_return_true_if_isArray_with_length(){
		var account = request.slatwallScope.newEntity('Account');
		var accountPhoneNumber1 = request.slatwallScope.newEntity('AccountPhoneNumber');
		accountPhoneNumber1.setPhoneNumber("1234567890");
		var accountPhoneNumber2 = request.slatwallScope.newEntity('AccountPhoneNumber');
		accountPhoneNumber2.setPhoneNumber("9876543210");
		var phoneNumbersArray = [accountPhoneNumber1,accountPhoneNumber2];

		account.setAccountPhoneNumbers(phoneNumbersArray);
		assert(variables.service.validate_required(account,'accountPhoneNumbers'));
	}

	/**
	* @test
	*/
	public void function validate_required_test_return_true_if_isArray_with_nolength(){
		var account = request.slatwallScope.newEntity('Account');
		var phoneNumbersArray = [];
		account.setAccountPhoneNumbers(phoneNumbersArray);
		assertfalse(variables.service.validate_required(account,'accountPhoneNumbers'));
	}

	//validate_null()
	/**
	* @test
	*/
	public void function validate_null_return_true_with_constraint_true(){
		var account = request.SlatwallScope.newEntity('Account');
		account.setCompany(javacast("null",""));
		assert(variables.service.validate_null(account,'company', true));
	}

	/**
	* @test
	*/
	public void function validate_null_return_false_with_constraint_true(){
		var account = request.SlatwallScope.newEntity('Account');
		account.setCompany("Dummy");
		assertfalse(variables.service.validate_null(account,'company', true));
	}

	/**
	* @test
	*/
	public void function validate_null_return_false_with_constraint_false(){
		var account = request.SlatwallScope.newEntity('Account');
		account.setFirstName('Joe');
		account.setCompany(javacast("null",""));
		assertfalse(variables.service.validate_null(account,'firstName', false));
		assertfalse(variables.service.validate_null(account,'company', false));
	}

	// validate_minLength()
	/**
	* @test
	*/
	public void function validate_minLength_test_return_false_when_length_isless() {
		var accountData = {
			accountID="",
			firstName="a",
			company="M"
		};
		var account = createPersistedTestEntity('account',accountData);
		assertfalse( variables.service.validate_minLength(account, 'firstName',2));
		assertfalse( variables.service.validate_minLength(account, 'company',2));
	}

	/**
	* @test
	*/
	public void function validate_minLength_test_return_true_when_length_isgreater() {
		var accountData = {
			accountID="",
			firstName="john",
			company="Airbnb"
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_minLength(account, 'firstName',2));
		assert( variables.service.validate_minLength(account, 'company',2));
	}

	/**
	* @test
	*/
	public void function validate_minLength_test_return_true_when_length_isequal() {
		var accountData = {
			accountID="",
			firstName="jo",
			company="AB"
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_minLength(account, 'firstName',2));
		assert( variables.service.validate_minLength(account, 'company',2));
	}

	// validate_maxLength()
	/**
	* @test
	*/
	public void function validate_maxLength_test_return_false_when_length_isgreater() {
		var accountData = {
			accountID="",
			firstName="thisistoolongname",
			company="thistestwilfailbecausetolargetest"
		};
		var account = createPersistedTestEntity('account',accountData);
		assertfalse( variables.service.validate_maxLength(account, 'firstName',10));
		assertfalse( variables.service.validate_maxLength(account, 'company',20));
	}

	/**
	* @test
	*/
	public void function validate_maxLength_test_return_true_when_length_isless() {
		var accountData = {
			accountID="",
			firstName="johnathon",
			company="Airbnb"
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_maxLength(account, 'firstName',10));
		assert( variables.service.validate_maxLength(account, 'company',20));
	}

	/**
	* @test
	*/
	public void function validate_maxLength_test_return_true_when_length_isequal() {
		var accountData = {
			accountID="",
			firstName="johnathon",
			company="Airbnb"
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_maxLength(account, 'firstName',10));
		assert( variables.service.validate_maxLength(account, 'company',20));
	}


	// validate_eq()
	/**
	* @test
	*/
	public void function validate_eq_test_for_boolean_value_return_false_when_notEqual() {
		var accountData = {
			accountID="",
			superUserFlag= false,
			organizationFlag= true
		};
		var account = createPersistedTestEntity('account',accountData);
		assertfalse( variables.service.validate_eq(account, 'superUserFlag', true));
		assertfalse( variables.service.validate_eq(account, 'organizationFlag', false));
	}

	/**
	* @test
	*/
	public void function validate_eq_test_for_boolean_value_return_true_when_equal() {
		var accountData = {
			accountID="",
			superUserFlag= false,
			organizationFlag= true
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_eq(account, 'superUserFlag', false));
		assert( variables.service.validate_eq(account, 'organizationFlag', true));
	}

	// validate_neq()
	/**
	* @test
	*/
	public void function validate_neq_test_for_boolean_value_return_false_when_equal() {
		var accountData = {
			accountID="",
			superUserFlag= false,
			organizationFlag= true
		};
		var account = createPersistedTestEntity('account',accountData);
		assertfalse( variables.service.validate_neq(account, 'superUserFlag', false));
		assertfalse( variables.service.validate_neq(account, 'organizationFlag', true));
	}

	/**
	* @test
	*/
	public void function validate_neq_test_for_boolean_value_return_true_when_notEqual() {
		var accountData = {
			accountID="",
			superUserFlag= false,
			organizationFlag= true
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_neq(account, 'superUserFlag', true));
		assert( variables.service.validate_neq(account, 'organizationFlag', false));
	}

	//validate_gtDateTimeProperty()
	/**
	* @test
	*/
	public void function validate_gtDateTimeProperty_test_return_true(){
		var order = request.slatwallScope.newEntity('Order');
		order.setOrderOpenDateTime("2017-10-19 18:10:03");
		order.setOrderCloseDateTime("2017-09-15 8:08:33");
		assert(variables.service.validate_gtDateTimeProperty(order,'orderOpenDateTime','orderCloseDateTime'));

	}

	/**
	* @test
	*/
	public void function validate_gtDateTimeProperty_test_return_false(){
		var order = request.slatwallScope.newEntity('Order');
		order.setOrderOpenDateTime("2017-09-15 8:08:33");
		order.setOrderCloseDateTime("2017-10-19 18:10:03");
		assertfalse(variables.service.validate_gtDateTimeProperty(order,'orderOpenDateTime','orderCloseDateTime'));

	}

	//validate_ltDateTimeProperty()
	/**
	* @test
	*/
	public void function validate_ltDateTimeProperty_test_return_true(){
		var order = request.slatwallScope.newEntity('Order');
		order.setOrderCloseDateTime("2017-09-15 8:08:33");
		order.setEstimatedDeliveryDateTime("2017-10-19 18:10:03");
		assert(variables.service.validate_ltDateTimeProperty(order,'orderCloseDateTime','estimatedDeliveryDateTime'));

	}

	/**
	* @test
	*/
	public void function validate_ltDateTimeProperty_test_return_false(){
		var order = request.slatwallScope.newEntity('Order');
		order.setOrderCloseDateTime("2017-10-19 18:10:03");
		order.setEstimatedDeliveryDateTime("2017-09-15 8:08:33");
		assertfalse(variables.service.validate_ltDateTimeProperty(order,'orderCloseDateTime','estimatedDeliveryDateTime'));

	}


	// validate_eqProperty()
	/**
	* @test
	*/
	public void function validate_eqProperty_test_return_false_when_notEqual() {
		var accountData = {
			accountID="",
			firstName= "equal",
			lastName= "notequal"
		};
		var account = createPersistedTestEntity('account',accountData);
		assertfalse( variables.service.validate_eqProperty(account, 'firstName', 'lastName'));
	}

	/**
	* @test
	*/
	public void function validate_eqProperty_test_return_true_when_equal() {
		var accountData = {
			accountID="",
			firstName= "equal",
			lastName= "equal"
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_eqProperty(account, 'firstName', 'lastName'));
	}

	// validate_neqProperty()
	/**
	* @test
	*/
	public void function validate_neqProperty_test_return_true_when_notEqual() {
		var accountData = {
			accountID="",
			firstName= "equal",
			lastName= "notequal"
		};
		var account = createPersistedTestEntity('account',accountData);
		assert( variables.service.validate_neqProperty(account, 'firstName', 'lastName'));
	}

	/**
	* @test
	*/
	public void function validate_neqProperty_test_return_false_when_equal() {
		var accountData = {
			accountID="",
			firstName= "equal",
			lastName= "equal"
		};
		var account = createPersistedTestEntity('account',accountData);
		assertfalse( variables.service.validate_neqProperty(account, 'firstName', 'lastName'));
	}

	//validate_unique()
	/**
	* @test
	*/
	public void function validate_unique_test_return_true() {
		var account = request.slatwallScope.newEntity('Account');
		assert( variables.service.validate_unique(account,"accountID"));
	}

	//validate_uniqueOrNull()
	/**
	* @test
	*/
	public void function validate_uniqueOrNull_test_null_return_true(){
		var account= request.slatwallScope.newEntity('Account');
		account.setCompany(javacast("null",""));
		assert(variables.service.validate_uniqueOrNull(account,'company'));
	}

	/**
	* @test
	*/
	public void function validate_uniqueOrNull_test_unique_return_true(){
		var account = request.slatwallScope.newEntity('Account');
		assert( variables.service.validate_unique(account,"accountID"));
	}

	//validate_regex()
	/**
	* @test
	*/
	public void function validate_regex_test_return_true(){
		var collection = request.slatwallScope.newEntity('Collection');
		collection.setCollectionCode("Random_123Val^");
		assert(variables.service.validate_regex(collection,'collectionCode','^[a-zA-Z0-9-_.|:~^]+$'));
	}

	/**
	* @test
	*/
	public void function validate_regex_test_return_false(){
		var collection = request.slatwallScope.newEntity('Collection');
		collection.setCollectionCode("Random%");
		assertfalse(variables.service.validate_regex(collection,'collectionCode','^[a-zA-Z0-9-_.|:~^]+$'));
	}




}


