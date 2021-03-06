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

    https://cfdocs.org/testbox

*/
component accessors="true" extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
    
    property name="service";
    
	public void function setUp() {
		super.setup();
		
		variables.service = variables.mockService.getBaseImporterServiceMock();
		this.initMockFunctions();
	}
	
	private void function initMockFunctions(){
	    
	    variables.service['getIntegration'] = function(){
		    var integrations =  entityLoad("SlatwallIntegration", { "integrationPackage"="slatwallImporter" });
		    
		    return integrations[1];
		}
	}
	
    private struct function getSampleAccountData(){
        
        var randomUsername = "nitin.yadav.test"&rand();
	    
	    return {
	        
	        remoteAccountID     : 123, 
	        firstName           : "Nitin",  
	        lastName            : "Yadav", 
	        username            : randomUsername, 
	        companyName         : "Ten24",
	        
	        organizationFlag    : false,
	        activeFlag          : "does not matter",
	        
	        //AccountEmailAddress
	        email: randomUsername&"@ten24web.com",
	        
	        //AccountPhoneNumber
	        phone: 9090909090,
	        countryCode: "+91"
	    };
	    
	}
	
	private struct function getSampleAccountMapping(){
	    return {
            "entityName": "Account",
            "mappingCode": "_unit_test_Account",
        
            "properties": {
                
                "remoteAccountID": {
                    "propertyIdentifier": "remoteID",
                    "validations": {
                        "required": true,
                        "dataType": "string"
                    }
                },
                "firstName": {
                    "propertyIdentifier": "firstName",
                    "validations": {
                        "required": true,
                        "dataType": "string"
                    }
                },
                "lastName": {
                    "propertyIdentifier": "lastName",
                    "validations": {
                        "dataType": "string"
                    }
                },
                "username": {
                    "propertyIdentifier": "username",
                    "validations": {
                        "dataType": "string",
                        "required": true
                    }
                },
                "companyName": {
                    "propertyIdentifier": "company",
                    "validations": {
                        "dataType": "string"
                    }
                },
                "organizationFlag": {
                    "propertyIdentifier": "organizationFlag",
                    "defaultValue": false,
                    "validations": {
                        "dataType": "boolean"
                    }
                },
                "accountActiveFlag": {
                    "propertyIdentifier": "activeFlag"
                }
            },
            
            "generatedProperties": [
                {
                    "propertyIdentifier": "urtTitle",
                    "allowUpdate": false
                }    
            ],
            
            "relations": [
                {
                    "type": "oneToOne",
                    "isNullabel": true,
                    "entityName": "AccountPhoneNumber",
                    "mappingCode": "AccountPhoneNumber",
                    "propertyIdentifier": "primaryPhoneNumber"
                },
                {
                    "type": "oneToOne",
                    "isNullabel": true,
                    "entityName": "AccountEmailAddress",
                    "mappingCode": "AccountEmailAddress",
                    "propertyIdentifier": "primaryEmailAddress"
                },
                {
                    "type": "oneToMany",
                    "entityName": "AccountAuthentication",
                    "mappingCode": "AccountAuthentication",
                    "propertyIdentifier": "accountAuthentications",
                }
            ],
            
            "importIdentifier": {
                "propertyIdentifier": "importRemoteID",
                "type": "composite",
                "keys": [
                    "remoteAccountID"
                ]
            },
            
            "validationContext": "save",
            
            "postPopulateMethods": [ "updateCalculatedProperties" ]
            
        };
	}
	
	private struct function getAccountEmailAddressMapping(){
        return {
            "entityName": "AccountEmailAddress",
            "mappingCode": "AccountEmailAddress",
            "properties": {
                "email": {
                    "propertyIdentifier": "emailAddress",
                    "validations": { "required": true, "dataType": "email" }
                }
            },
            "importIdentifier": {
                "propertyIdentifier": "importRemoteID",
                "type": "composite",
                "keys": [
                    "remoteAccountID",
                    "email"
                ]
            },
            "dependencies" : [{
                "key"                : "remoteAccountID",
                "entityName"         : "Account",
                "lookupKey"          : "remoteID",
                "propertyIdentifier" : "account"
            }]
        };
    }
	
	

	
	private struct function getSampleProductData(){
        return {
            "PriceGroupActiveFlag": "false",
    		"ProductPublishedFlag": "true",
    		"BrandWebsite": "https://www.alendronate-sodium.com",
    		"ProductTypeActiveFlag": "false",
    		"ProductTypeDescription": "In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.",
    		"BrandName": "Alendronate Sodium",
    		"SkuName": "Bacon Strip Precooked sku 4",
    		"RemoteSkuID": "34875",
    		"SkuActiveFlag": "false",
    		"PriceGroupCode": "pgtTwo",
    		"ProductDescription": "Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.",
    		"ProductTypePublishedFlag": "",
    		"RemoteSkuPriceID": "71097",
    		"CurrencyCode": "PHP",
    		"BrandActiveFlag": "true",
    		"ProductTypeName": "Product type 333",
    		"ProductCode": "product_aaa_bbb_xxx",
    		"PriceGroupName": "Price group two",
    		"SkuDescription": "Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.",
    		"RemoteProductID": "13463",
    		"RemoteProductTypeID": "70845",
    		"Price": "594.47",
    		"MaxQuantity": "93",
    		"ListPrice": "594.47",
    		"RemoteBrandID": "52319",
    		"ProductActiveFlag": "false",
    		"SkuPublishedFlag": "false",
    		"BrandPublishedFlag": "true",
    		"SkuPriceActiveFlag": "true",
    		"MinQuantity": "1",
    		"RemotePriceGroupID": "88698",
    		"ProductName": "Bacon Strip Precooked",
    		"SkuCode": "SKU_34875",
    		"ProductTypeCode": "product_type_3296"
        };
	}
	
	private struct function getSampleSkuData(){

	    return {
            "PriceGroupName": "Price Group AAA",
            "PriceGroupActiveFlag": "",
            "SkuDescription": "",
            "RemoteProductID": "9828535",
            "Price": "67",
            "MaxQuantity": "",
            "ListPrice": "93",
            "SkuPublishedFlag": "true",
            "SkuName": "",
            "RemoteSkuID": "116037",
            "SkuActiveFlag": "",
            "PriceGroupCode": "",
            "SkuPriceActiveFlag": "true",
            "MinQuantity": "",
            "RemotePriceGroupID": "8",
            "RemoteSkuPriceID": "",
            "CurrencyCode": "CZK",
            "SkuCode": ""
        };
	}
	
	private any function insertRow( required string tableName, required struct keyValuePairs ){
	    var sql = "INSERT INTO #arguments.tableName#";
	    var qry = new query();
	    
	    var keys = structKeyList(arguments.keyValuePairs);
	    
	    sql &= " ( #keys# ) ";
	    
        var insertSQL = ListReduce( keys, function( previousValue, key ){
                            var fragment = ":#key#";
                            qry.addParam( name=key, value=keyValuePairs[key], null=!len(trim(keyValuePairs[key])) );
                            
                            return previousValue &= ( len(previousValue) ? "," & fragment : fragment ); 
                        }, '');
        
        sql &= "VALUES ( #insertSQL# ) ";

        debug(sql);
        
		qry = qry.execute(sql=sql);
	    return qry.getResult();
	}
	
	private any function updateRow( required string tableName, required struct keyValuePairs, required string uniqueKey, required string uniqueValue){
	    var sql = "UPDATE #arguments.tableName# SET ";
	    var qry = new query();
	   
        var updateSQL = arguments.keyValuePairs.reduce( function( previousValue, key, value ){
                            var fragment = " `#key#` = :#key#";
                            qry.addParam( name=key, value=value, null=!len(trim(value)) );

                            return previousValue &= ( len(previousValue) ? "," & fragment : fragment ); 
                        }, '');
        
        sql &= updateSQL;
	    sql &= " WHERE #arguments.uniqueKey# = :uniqueValue";
	    
	    qry.addParam( name='uniqueValue', value=arguments.uniqueValue );

        debug(sql);
        
		qry = qry.execute(sql=sql);
	    return qry.getResult();
	}
	
	private any function selectRow(required string tableName, required struct uniqueKeyValuePairs ){
        
        var sql = "SELECT * FROM #arguments.tableName# WHERE ( " ;
    	var qry = new query();
        
        var filterSQL = arguments.uniqueKeyValuePairs.reduce( function( previousValue, key, value ){
                            var fragment = " #key# = :#key#";
                            qry.addParam( name=key, value=value );
                            
                            return previousValue &= ( len(previousValue) ? " AND" & fragment : fragment); 
                        }, '');
        
        sql &= filterSQL;
        sql &= " )";
        
        debug(sql);
        
		qry = qry.execute(sql=sql);
	    return qry.getResult();
    }
	    
    private any function deleteRow(required string tableName, required string uniqueKey, required string uniqueValue ){
        
        var sql = "DELETE FROM #arguments.tableName# WHERE #arguments.uniqueKey# = :uniqueValue";
    	var qry = new query();
		qry.addParam( name='uniqueValue',    value=arguments.uniqueValue );
		
		debug(sql);
		
		qry = qry.execute(sql=sql);
	    return qry.getResult();
    }
    
    /**
	 * @test
	*/
    public void function insertUpdateSelectDeleteTest(){
        //insert batch
        var batchID = hash("123xxxunittest"&now(), 'MD5');
        
        insertRow("swBatch", {
           'batchID': batchID,
           'baseObject': 'Account'
        });
        var select = selectRow('swbatch', { 'batchID': batchID } );
        debug(select);
        
        expect(select.batchID).toBe(batchID, "select batchID should be equal to #batchID# ");
        
        updateRow("swBatch", { "baseObject": "Account2"}, 'batchID', batchID );
        select = selectRow('swbatch', { 'batchID': batchID });
        debug(select);
        
        expect(select.baseObject).toBe("Account2", "select baseObject should be equal to Account2");
        
        deleteRow('swBatch', 'batchID', batchID ); 
        select = selectRow('swbatch', { 'batchID': batchID });
        debug(select);
        
        expect( select.batchID ).toBeEmpty( "select should not have batchID");
        expect( select.baseObject ).toBeEmpty( "select should not have baseObject");
        
    }
    
    /**
     * @test 
    */
    public void function getOrderCSVHeaderMetaData_should_include_address_prefixes(){
        var header = this.getService().getMappingCSVHeaderMetaData( 'Order' );
        debug( header );
        
        $assert.isTrue( ListFind(header.columns, "BillingAddress_city") );
        $assert.isTrue( ListFind(header.columns, "BillingAddress_streetAddress") );
        $assert.isTrue( ListFind(header.columns, "BillingAddress_street2Address") );
        
        $assert.isTrue( ListFind(header.columns, "ShippingAddress_city") );
        $assert.isTrue( ListFind(header.columns, "ShippingAddress_streetAddress") );
        $assert.isTrue( ListFind(header.columns, "ShippingAddress_street2Address") );
        
    }
	
	
	/*****************************.  Validation.  .******************************/
	
	/**
	 * @test
	*/
	public void function validateAccountData_should_fail_for_no_data(){
	    
	    var validation = this.getService().validateMappingData( mappingCode="Account", data={}, collectErrors=false );
	    
	    debug(validation);
	    $assert.isFalse(validation.isValid);
	}

	/**
	 * @test
	*/
	public void function validateAccountData_should_fail_for_firstName(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('firstName');
	    
	    debug(getSampleAccountMapping());
	    
	    var mapping = getSampleAccountMapping();
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var validation = this.getService().validateMappingData(
	        mapping= mapping, 
	        data = sampleAccountData, 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('firstName', "the validation should fail for firstName");
	}

	/**
	 * @test
	*/
	public void function validateAccountData_should_fail_for_email(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData['email'] = "Invalid Email Address";
	    
	    var validation = this.getService().validateMappingData(
	        mappingCode="Account", 
	        data = sampleAccountData, 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('email', "the validation should fail for email");
	}
	
	/**
	 * @test
	*/
	public void function validateAccountData_should_pass_for_valida_data(){
	    
	    var sampleAccountData = getSampleAccountData();

	    var validation = this.getService().validateMappingData(
	        mappingCode="Account", 
	        data = sampleAccountData, 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assert(validation.isValid);
	    expect(validation.errors).toBeEmpty("the validation should pass");
	}
	
	/**
	 * @test
	*/
	public void function validateAccountData_should_pass_without_lastName_and_countryCode(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    sampleAccountData.delete('lastName');
	    sampleAccountData.delete('countryCode');

	    var validation = this.getService().validateMappingData(
	        mappingCode="Account", 
	        data = sampleAccountData, 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assert(validation.isValid);
	    expect(validation.errors).toBeEmpty("the validation should pass without lastName and countryCode");
	}
	
	
    /**
     * @test
    */
    public void function validateAccountData_should_throw_for_invalid_validation_constraint(){
        var sampleAccountData = getSampleAccountData();
        var mapping = getSampleAccountMapping();

        mapping.properties.remoteAccountID.validations["invalidConstraint"] = "whaever";
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        var propertiesValidations = this.getService().getImporterMappingService().getMappingPropertiesValidations( mapping.mappingCode );
        debug(propertiesValidations);
    
        $assert.throws( function() {
            this.getService().validateMappingData(
                data = sampleAccountData,
                collectErrors = true,
                mapping = mapping
            )
        });
    }
    
    /**
     * @test
    */
    public void function validateAccountData_should_call_overriden_validation_function(){
        
        var sampleAccountData = getSampleAccountData();
        var mapping = getSampleAccountMapping();
        mapping.properties.remoteAccountID.validations["testConstraint"] = "whaever";
        
        
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        var propertiesValidations = this.getService().getImporterMappingService().getMappingPropertiesValidations( mapping.mappingCode );
        debug(propertiesValidations);
        
        // declare a mock validation-finction on the target-service
        function validate_testConstraint_value_spy(any propertyValue, any constraintValue){
            this['validate_dataType_testConstraint_called'] = true;
            return true;
        }
        
        this.getService()['validate_testConstraint_value'] = validate_testConstraint_value_spy;

        this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
        
        expect( variables.service ).toHaveKey('validate_dataType_testConstraint_called');
        expect( variables.service.validate_dataType_testConstraint_called ).toBeTrue();
        
        debug(variables.service.validate_dataType_testConstraint_called);
        
        // cleanup
        structDelete( variables.service, 'validate_dataType_testConstraint_called');
        structDelete( variables.service, 'validate_testConstraint_value');
    }


    /**
     * @test
    */
    public void function validateAccountData_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        // declare a mock validation-finction on the target-service
        function validateAccountData_spy(required struct data, required struct mapping, boolean collectErrors){
            this['validateAccountData_spy_called'] = "it works";
            return {isValid:true, errors:[] };
        }
        
        variables.service['validateAccountData'] = validateAccountData_spy;
        
        this.getService().validateMappingData( mappingCode="Account", data=sampleAccountData );
        
        expect( variables.service ).toHaveKey('validateAccountData_spy_called');
        expect( variables.service.validateAccountData_spy_called ).toBe('it works');
        
        debug(variables.service.validateAccountData_spy_called);
        
        // cleanup
        structDelete( variables.service, 'validateAccountData_spy_called');
        structDelete( variables.service, 'validateAccountData');
    }
    
    /**
     * @test
    */
    public void function validateMappingData_should_not_ignre_validation_errors_for_nullabe_relation_when_required_properties_does_exist_in_source_data(){

        var sampleAccountData = getSampleAccountData();
	    sampleAccountData['email'] = "Invalid Email Address";
	    
        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['isNullable'] = true;
        })
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('email');
    }
    
    /**
     * @test
    */
    public void function validateMappingData_should_ignre_validation_errors_for_nullabe_relation_when_required_properties_does_not_exist_in_source_data(){

        var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('email');
	    
        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['isNullable'] = true;
        })

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertTrue(validation.isValid);
	    expect(validation.errors).toBeEmpty();
    }
    
    
    
    /**
     * @test
    */
    public void function validateMappingData_should_not_return_empty_relations_for_failed_validation_when_data_does_have_all_required_properties(){

        var sampleAccountData = getSampleAccountData();
	    sampleAccountData['email'] = "Invalid Email Address"; // the validation will fail for email type
	    
        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['isNullable'] = true;
        })

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('email');
	    
	    expect(validation.emptyRelations).toBeEmpty();
    }
    
     /**
     * @test
    */
    public void function validateMappingData_should_return_empty_relations_when_data_doesnot_have_all_required_properties(){

        var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('email');
	    
        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['isNullable'] = true;
        })

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertTrue(validation.isValid);

	    assertTrue( isStruct(validation.emptyRelations) );
	    expect(validation.emptyRelations).toHaveKey('primaryEmailAddress');
	    assert(validation.emptyRelations.primaryEmailAddress.isEmptyRelation);

	    expect(validation.errors).toBeEmpty();
    }
    
    /**
     * @test
    */
    public void function validateMappingData_should_ignre_validation_errors_for_relations_having_hasMapping_flag(){

        var sampleAccountData = getSampleAccountData();
	    sampleAccountData['email'] = "Invalid Email Address";
	    
        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['hasMapping'] = false;
        })

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertTrue(validation.isValid);
	    expect(validation.errors).toBeEmpty();
    }
    
    /**
     * @test
    */
    public void function validateMappingData_should_fail_validate_for_sourceDataKeysPrefix_for_invalid_data(){

        var sampleAccountData = getSampleAccountData();
        
        var mapping  = getSampleAccountMapping();
        mapping.relations = [{
            "type"                  : "oneToOne",
            "entityName"            : "AccountPhoneNumber",
            "mappingCode"           : "AccountPhoneNumber",
            "propertyIdentifier"    : "primaryPhoneNumber",
            "sourceDataKeysPrefix"  : "testPrefix--"
        }];

	    this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey("testPrefix--phone");
	    expect(validation.errors).toHaveKey("testPrefix--remoteAccountID");
    }
    
    
    /**
     * @test
    */
    public void function validateMappingData_should_pass_validate_for_sourceDataKeysPrefix_for_valid_data(){

        var sampleAccountData = getSampleAccountData();
        
        var mapping  = getSampleAccountMapping();
        mapping.relations = [{
            "type"                  : "oneToOne",
            "entityName"            : "AccountPhoneNumber",
            "mappingCode"           : "AccountPhoneNumber",
            "propertyIdentifier"    : "primaryPhoneNumber",
            "sourceDataKeysPrefix"  : "testPrefix--"
        }];


        sampleAccountData['testPrefix--phone'] = sampleAccountData['phone'];
        sampleAccountData['testPrefix--remoteAccountID'] = sampleAccountData['remoteAccountID'];

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
	    var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
	    
	    debug(validation);
	    assertTrue(validation.isValid);
	    expect(validation.errors).toBeEmpty();
    }
    
    
    
    


	/** ***************************.  Transform  .***************************** */


    /**
     * 
        { 	
            accountID :	'',
            firstName :	'Nitin',
            lastName :	'Yadav',
            remoteID :	123,
            username :	nitin.yadav.
            
            importRemoteID :	'202CB962AC59075B964B07152D234B70',
            
            primaryEmailAddress : {
                accountEmailAddressID :	'',
                emailAddress          :	'nitin.yadav@ten24web.com',
                importRemoteID         :	'202CB962AC59075B964B07152D234B70_1824DCF4879D57843ABBA22D59862B77'
            },
            
            primaryPhoneNumber : {
                accountPhoneNumberID :	'',
                countryCallingCode	 :	'+91',
                importRemoteID        :	'202CB962AC59075B964B07152D234B70_6BA70BB28A5A0D671CA8DD4BB488BE83',
                phoneNumber          :	9090909090
            }
        }

     *
     */
     
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_ignore_extra_source_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    sampleAccountData['extraProp'] = "132432543";

	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect( StructKeyExists(data, 'extraProp') ).toBeFalse("transformed data should not contain key 'extraProp'");
    }

    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_accountID(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('accountID', "transformed data should have key 'accountID' ");
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_importRemoteID(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('importRemoteID', "transformed data should have key 'importRemoteID' ");
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_importRemoteID_should_match_with_createMappingImportRemoteID(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    var importRemoteID = this.getService().createMappingImportRemoteID( 
	        mapping = getSampleAccountMapping(), 
	        data = sampleAccountData 
	    );
	    
	    expect(data.importRemoteID).toBe( importRemoteID, "importRemoteID in transformed data should match with generated-id ");
    }
    
    /**
     * @test
    */
    public void function createMappingImportRemoteID_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        // declare a mock validation-finction on the target-service
        function createAccountImportRemoteID_spy(required struct data, required struct mapping){
            this['createAccountImportRemoteID_spy_called'] = "it works";
            return true;
        }
        
        var mapping  = getSampleAccountMapping();
        mapping.importIdentifier['generatorFunction'] = 'createAccountImportRemoteID';
        
        variables.service['createAccountImportRemoteID'] = createAccountImportRemoteID_spy;
        
        variables.service.createMappingImportRemoteID( mapping=mapping, data=sampleAccountData );

        expect( variables.service ).toHaveKey('createAccountImportRemoteID_spy_called');
        expect( variables.service.createAccountImportRemoteID_spy_called ).toBe('it works');
        
        debug(variables.service.createAccountImportRemoteID_spy_called);
        
        // cleanup
        structDelete( variables.service, 'createAccountImportRemoteID_spy_called');
        structDelete( variables.service, 'createAccountImportRemoteID');
    }
    
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_infer_default_value_when_no_source_property(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    sampleAccountData.delete('organizationFlag');

	    
	    var data = this.getService().transformMappingData(
	        mapping = getSampleAccountMapping(), 
	        data = sampleAccountData
	    );
	    
	    debug(data);
	    
	    expect(data).toHaveKey('organizationFlag', "key organizationFlag should exist in transformed data");
	    expect(data.organizationFlag).toBe( false, "the defaule value for organizationFlag should get inferred and should be false");
    }
    
     
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_use_generator_function_for_properties_when_declared_in_mapping(){
        
        var sampleAccountData = getSampleAccountData();
        
        var mapping = getSampleAccountMapping();
        mapping.properties.activeFlag = {
            "propertyIdentifier": "activeFlag",
            "generatorFunction":  "generateAccountActiveFlag_spy"
        };

        function generateAccountActiveFlag_spy(struct data, struct mapping, struct propertyMetaData){
            // puting something in the THIS scope of the SERVICE so it can be verified later
            variables.this['generateAccountActiveFlag_spy_called'] = 'xxxxx-yyyyy-does-not-matter'; 
            return true;
        }
        // declare a mock generator-finction on the target-service
        variables.service['generateAccountActiveFlag_spy'] = generateAccountActiveFlag_spy;


        var data = this.getService().transformMappingData(mapping, sampleAccountData);
        debug(data);

        expect( variables.service )
            .toHaveKey('generateAccountActiveFlag_spy_called');
            
        debug( variables.service.generateAccountActiveFlag_spy_called );
        
        expect( variables.service.generateAccountActiveFlag_spy_called )
            .toBe('xxxxx-yyyyy-does-not-matter');
            
	    expect( data )
	        .toHaveKey('activeFlag', "key activeFlag should exist in transformed data");
	        
	    expect( data.activeFlag )
	        .toBe( true, "the defaule value for activeFlag should get generated and should be true");
       
        // cleanup
        structDelete( variables.service, 'generateAccountActiveFlag_spy');
        structDelete( variables.service, 'generateAccountActiveFlag_spy_called');
    }
    
    
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_use_generator_function_for_relations_when_declared_in_mapping(){
        
        var sampleAccountData = getSampleAccountData();
        
        var mapping = getSampleAccountMapping();
        mapping.relations = [{
            "entityName": "Account",
            "propertyIdentifier": "exampleRelationProperty",
            "generatorFunction":  "getAccountExampleRelationProperty_spy"
        }];

        function getAccountExampleRelationProperty_spy( struct data, struct parentEntityMapping, struct relationMetaData){
            // puting something in the THIS scope of the SERVICE so it can be verified later
            variables.this['getAccountExampleRelationProperty_spy_called'] = 'xxxxx-yyyyy-does-not-matter'; 
            return {"keyxx": 'valuexx', 'accountID': '12345'};
        }
        // declare a mock generator-finction on the target-service
        variables.service['getAccountExampleRelationProperty_spy'] = getAccountExampleRelationProperty_spy;


        var data = this.getService().transformMappingData(mapping, sampleAccountData);
        debug(data);

        expect( variables.service ).toHaveKey('getAccountExampleRelationProperty_spy_called');
        expect( variables.service.getAccountExampleRelationProperty_spy_called ).toBe('xxxxx-yyyyy-does-not-matter');
            
	    expect( data ).toHaveKey( 'exampleRelationProperty' );
	    expect( data.exampleRelationProperty ).toHaveKey( 'keyxx' );
	    expect( data.exampleRelationProperty.keyxx ).toBe( 'valuexx' );
       
        // cleanup
        structDelete( variables.service, 'getAccountExampleRelationProperty_spy');
        structDelete( variables.service, 'getAccountExampleRelationProperty_spy_called');
    }
    
    
    /**
     * @test
    */
    public void function transformMappingData_should_resolve__generated__properties(){
        var sampleProductData = getSampleProductData();
        
        var mapping = this.getService().getMappingByMappingCode( 'Product' );
        mapping['generatedProperties'] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductUrlTitle"
        }];
        
        mapping.delete('relations');
        
        var data = this.getService().transformMappingData(mapping, sampleProductData);
        debug(data);
        expect( data ).toHaveKey( 'urlTitle' );
    }
    
    /**
     * @test
    */
    public void function transformMappingData_should_resolve__create_only__properties__when_creating_new_entity(){
        var sampleProductData = getSampleProductData();
        
        var mapping = this.getService().getMappingByMappingCode( 'Product' );
        mapping['generatedProperties'] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductUrlTitle",
            "allowUpdate"        : false
        }];
        
        mapping.delete('relations');
        
        var data = this.getService().transformMappingData(mapping, sampleProductData);
        debug(data);
        expect( data ).toHaveKey( 'urlTitle' );
    }
    
    
    /**
     * @test
    */
    public void function transformMappingData_should_not_resolve__create_only__properties__when_updating_existing_entity(){
        var sampleProductData = getSampleProductData();
        
        // simulates updating existing product
        sampleProductData['productID'] = '123456789078765';
        
        var mapping = this.getService().getMappingByMappingCode( 'Product' );
        mapping['generatedProperties'] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductUrlTitle",
            "allowUpdate"        : false
        }];
        
        mapping.delete('relations');
        
        var data = this.getService().transformMappingData(mapping, sampleProductData);
        debug(data);
        
        expect( structKeyExists(data, 'urlTitle') ).toBeFalse();
    }

    
    /**
     * @test
    */
    public void function processEntityImport_check_transform_data(){
        
        // var sampleProductData = getSampleProductData();
        
        var sampleProductData = {
    		"PriceGroupActiveFlag": "false",
    		"ProductPublishedFlag": "true",
    		"BrandWebsite": "https://www.alendronate-sodium.com",
    		"ProductTypeActiveFlag": "false",
    		"ProductTypeDescription": "In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.",
    		"BrandName": "Alendronate Sodium",
    		"SkuName": "Bacon Strip Precooked sku 4",
    		"RemoteSkuID": "34875",
    		"SkuActiveFlag": "false",
    		"PriceGroupCode": "pgtTwo",
    		"ProductDescription": "Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.",
    		"ProductTypePublishedFlag": "",
    		"RemoteSkuPriceID": "71097",
    		"CurrencyCode": "PHP",
    		"BrandActiveFlag": "true",
    		"ProductTypeName": "Product type 333",
    		"ProductCode": "product_aaa_bbb_xxx",
    		"PriceGroupName": "Price group two",
    		"SkuDescription": "Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.",
    		"RemoteProductID": "13463",
    		"RemoteProductTypeID": "70845",
    		"Price": "594.47",
    		"MaxQuantity": "93",
    		"ListPrice": "594.47",
    		"RemoteBrandID": "52319",
    		"ProductActiveFlag": "false",
    		"SkuPublishedFlag": "false",
    		"BrandPublishedFlag": "true",
    		"SkuPriceActiveFlag": "true",
    		"MinQuantity": "1",
    		"RemotePriceGroupID": "88698",
    		"ProductName": "Bacon Strip Precooked",
    		"SkuCode": "SKU_34875",
    		"ProductTypeCode": "product_type_3296"
    	};
             
             
        var data = this.getService().transformMappingData( mapping=this.getService().getMappingByMappingCode("Product"), data=sampleProductData );
        debug(data);
        
    }
    
    
    
    
    
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_account_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('firstName',  "transformed data should have key 'firstName' ");
	    expect(data).toHaveKey('lastName',   "transformed data should have key 'firstName' ");
	    expect(data).toHaveKey('username',   "transformed data should have key 'username' ");
	    expect(data).toHaveKey('company',    "transformed data should have key 'company' ");
	    expect(data).toHaveKey('accountID',  "transformed data should have key 'accountID' ");
	    expect(data).toHaveKey('remoteID',   "transformed data should have key  'remoteID' ");
	    expect(data).toHaveKey('importRemoteID', "transformed data should have key 'importRemoteID' ");
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_related_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('primaryPhoneNumber', "transformed data should have key 'primaryPhoneNumber' ");
	    expect(data.primaryPhoneNumber).toBeTypeOf('struct',  "primaryPhoneNumber should be an struct ");
	   
	    expect(data).toHaveKey('primaryEmailAddress', "transformed data should have key 'primaryEmailAddress' ");
	    expect(data.primaryEmailAddress).toBeTypeOf('struct',  "primaryEmailAddress should be an struct ");
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_primaryPhoneNumber_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('primaryPhoneNumber', "transformed data should have key 'primaryPhoneNumber' ");
	    expect(data.primaryPhoneNumber).toBeTypeOf('struct',  "primaryPhoneNumber should be an struct ");
	   
	    expect(data.primaryPhoneNumber).toHaveKey('importRemoteID', "transformed data should have key 'importRemoteID' ");
	    expect(data.primaryPhoneNumber).toHaveKey('accountPhoneNumberID',  "transformed data should have key 'accountPhoneNumberID' ");
	    
	    expect(data.primaryPhoneNumber).toHaveKey('phoneNumber',  "primaryPhoneNumber should have key 'phoneNumber' ");
	    expect(data.primaryPhoneNumber).toHaveKey('countryCallingCode',  "primaryPhoneNumber should have key 'countryCallingCode' ");
	    
	    
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_primaryEmailAddress_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformMappingData(getSampleAccountMapping(), sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('primaryEmailAddress', "transformed data should have key 'primaryEmailAddress' ");
	    expect(data.primaryEmailAddress).toBeTypeOf('struct',  "primaryEmailAddress should be an struct ");
	   
	    expect(data.primaryEmailAddress).toHaveKey('importRemoteID', "transformed data should have key 'importRemoteID' ");
	    expect(data.primaryEmailAddress).toHaveKey('accountEmailAddressID',  "transformed data should have key 'accountEmailAddressID' ");
	    
	    expect(data.primaryEmailAddress).toHaveKey('emailAddress',  "primaryEmailAddress should have key 'emailAddress' ");
    }
    
    /**
     * @test
    */
    public void function transformMappingData_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        var mapping = getSampleAccountMapping();
        mapping.mappingCode = "TestMapping";

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        debug(mapping);

        // declare a mock validation-finction on the target-service
        function transformTestMappingData(required struct data, required struct mapping, boolean collectErrors){
            this['transformTestMappingData_called'] = "it works";
            return {};
        }
        
        this.getService()['transformTestMappingData'] = transformTestMappingData;
        
        this.getService().transformMappingData( mapping=mapping, data=sampleAccountData );
        
        expect( variables.service ).toHaveKey('transformTestMappingData_called');
        expect( variables.service.transformTestMappingData_called ).toBe('it works');
        
        debug(variables.service.transformTestMappingData_called);
            
    }
    
    
    /**
     * @test
    */
    public void function transformMappingData_should_not_generate_data_for_relation_when_source_data_doesnot_have_all_required_properties(){

        var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('email');
	    
        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['isNullable'] = true;
        })

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
        
        debug(validation);
        
        var transformedData = this.getService().transformMappingData(
            mapping = mapping, 
            data = sampleAccountData, 
            emptyRelations = validation.emptyRelations
        );
	    
	    debug(transformedData);
	    
	    assertFalse(structKeyExists(transformedData, 'primaryEmailAddress'));
    }
    
    /**
     * @test
    */
    public void function transformMappingData_should_generate_data_for_relation_when_source_data_does_have_all_required_properties(){

        var sampleAccountData = getSampleAccountData();

        var mapping = getSampleAccountMapping();
        mapping.relations.each(function(rel){
            rel['isNullable'] = true;
        })

        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var validation = this.getService().validateMappingData(
            data = sampleAccountData,
            collectErrors = true,
            mapping = mapping
        );
        
        debug(validation);
        
        var transformedData = this.getService().transformMappingData(
            mapping = mapping, 
            data = sampleAccountData, 
            emptyRelations = validation.emptyRelations
        );
	    
	    debug(transformedData);
	    
	    assertTrue(structKeyExists(transformedData, 'primaryEmailAddress'));
    }
    
    
    /**
     * @test
    */
    public void function transformMappingData_should_be_able_to_use_prefixed_properties_for_relations(){

        var sampleAccountData = getSampleAccountData();
        
        var mapping  = getSampleAccountMapping();
        mapping.relations = [{
            "type"                  : "oneToOne",
            "entityName"            : "AccountPhoneNumber",
            "mappingCode"           : "AccountPhoneNumber",
            "propertyIdentifier"    : "primaryPhoneNumber",
            "sourceDataKeysPrefix"  : "testPrefix--"
        }];


        sampleAccountData['testPrefix--phone'] = sampleAccountData['phone'];
        sampleAccountData['testPrefix--remoteAccountID'] = sampleAccountData['remoteAccountID'];
        
	    var transformedData = this.getService().transformMappingData(
            mapping = mapping,
            data = sampleAccountData 
        );
        
        debug(transformedData);
        assertTrue( structKeyExists(transformedData, 'primaryPhoneNumber') );
        assertTrue( structKeyExists(transformedData.primaryPhoneNumber, 'phoneNumber') );
        assertTrue( transformedData.primaryPhoneNumber.phoneNumber == 9090909090 );
    }
    
    
    
    /** ***************************.  EntityQueue and FailureQueue .***************************** */

    
    
    /** 
	 * @test
	*/
    public void function pushRecordIntoImportQueueTest_should_enqueue_to_failureQueue_when_validation_fails(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('firstName');
        
        //insert batch
        var batchID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swBatch", { 'batchID': batchID, 'baseObject': 'Account' });
        
        var mapping  = getSampleAccountMapping();
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var validation = this.getService().pushRecordIntoImportQueue( 
	            mapping = mapping, 
	            data    = sampleAccountData,
	            batchID = batchID
	    );
	    
	    //validation errors
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('firstName', "the validation should fail for firstName");
        
        
	    var entityQueueFailure = selectRow('swEntityQueueFailure', { 'batchID': batchID, 'baseObject': 'Account' });
	    debug(entityQueueFailure);
	    expect(entityQueueFailure).toHaveKey('batchID', "the entityQueueFailure should have batchID #batchID#");
        expect(entityQueueFailure.batchID).toBe(batchID, "the entityQueueFailure should have batchID #batchID#");
        
        //............cleanup..........
        
        //reset relationship
        updateRow("swEntityQueueFailure", { "batchID": ""}, 'entityQueueFailureID', entityQueueFailure.entityQueueFailureID );
        // delete entity-queue-faliure
        deleteRow('swEntityQueueFailure', 'entityQueueFailureID', entityQueueFailure.entityQueueFailureID);
        // delete batch
        deleteRow('swBatch', 'batchID', batchID ); 
    }
    
    /** 
	 * @test
	*/
    public void function pushRecordIntoImportQueueTest_should_enqueue_to_entityQueue_when_validation_passes(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    //insert batch
        var batchID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swBatch", { 'batchID': batchID, 'baseObject': 'Account' });
        
        var mapping  = getSampleAccountMapping();
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var validation = this.getService().pushRecordIntoImportQueue( 
	            mapping = mapping, 
	            data    = sampleAccountData,
	            batchID = batchID
	    );
	    debug(validation);
	    assert(validation.isValid);
	    
	    var entityQueue = selectRow('swEntityQueue', { 'batchID': batchID, 'baseObject': 'Account' });
	    debug(entityQueue);
	    expect(entityQueue).toHaveKey('batchID', "the entityQueue should have batchID #batchID#");
        expect(entityQueue.batchID).toBe(batchID, "the entityQueue should have batchID #batchID#");
        
        //............cleanup..........
        
        //reset relationship
        updateRow("swEntityQueue", { "batchID": ""}, 'entityQueueID', entityQueue.entityQueueID );
        // delete entity-queue
        deleteRow('swEntityQueue', 'entityQueueID', entityQueue.entityQueueID);
        // delete batch
        deleteRow('swBatch', 'batchID', batchID ); 
    }
    
    /** 
	 * @test
	*/
    public void function reQueueImportFailure_should_be_able_to_enqueue_from_failure_to_entity_queue(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('firstName');
        
        //insert batch
        var batchID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swBatch", { 'batchID': batchID, 'baseObject': 'Account' });
        
        var mapping  = getSampleAccountMapping();
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var validation = this.getService().pushRecordIntoImportQueue( 
            mapping = mapping, 
            data    = sampleAccountData,
            batchID = batchID
	    );
	    
        // get and format failure-queue-data
	    var entityQueueFailure = selectRow('swEntityQueueFailure', { 'batchID': batchID, 'baseObject': 'Account' });
	    debug(entityQueueFailure);
	    
	    var entityQueueData = DeSerializejson(entityQueueFailure.entityQueueData);
	    entityQueueData.data['firstName'] = 'Nitin';
	    
	    var tempAccount = this.getService().getHibachiService().newAccount();
	    
	    // try to re-queue
	    tempAccount = this.getService().reQueueImportFailure( tempAccount, entityQueueData );
	    expect( tempAccount.hasErrors() ).toBeFalse("Account should not have errors");
        
        
        // asert that it's int the entity-queue
        var entityQueue = selectRow('swEntityQueue', { 'batchID': batchID, 'baseObject': 'Account' });
	    debug(entityQueue);
	    expect(entityQueue).toHaveKey('batchID', "the entityQueue should have batchID #batchID#");
        expect(entityQueue.batchID).toBe(batchID, "the entityQueue should have batchID #batchID#");
        
        //............cleanup..........
        
        //reset relationship
        updateRow("swEntityQueue", { "batchID": ""}, 'entityQueueID', entityQueue.entityQueueID );
        updateRow("swEntityQueueFailure", { "batchID": ""}, 'entityQueueFailureID', entityQueueFailure.entityQueueFailureID );
        // delete entity-queue
        deleteRow('swEntityQueue', 'entityQueueID', entityQueue.entityQueueID);
        // delete entity-queue-faliure
        deleteRow('swEntityQueueFailure', 'entityQueueFailureID', entityQueueFailure.entityQueueFailureID);
        
        // delete batch
        deleteRow('swBatch', 'batchID', batchID ); 
    }
    
        
    /** 
	 * @test
	*/
    public void function processEntityImportTest_should_be_able_to_save_without_errors(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var mapping = getSampleAccountMapping();
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var transformedData = this.getService().transformMappingData(mapping=mapping, data=sampleAccountData);
	    debug(transformedData);
	    
	    var tempAccount = this.getService().getHibachiService().newAccount();
	    
	    // try to import
	    tempAccount = this.getService().processEntityImport( 
	        mapping         = mapping, 
	        entity          = tempAccount, 
	        entityQueueData = transformedData 
	    );
	
	    debug(tempAccount.getErrors()); 
	    
	    expect( tempAccount.hasErrors() ).toBeFalse("Account should not have errors");
        
    }
    
    /** 
	 * @test
	*/
    public void function processEntityImportTest_should_have_errors_when_entity_validations_fails(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('firstName');
	    
	    var mapping  = getSampleAccountMapping();
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

	    var transformedData = this.getService().transformMappingData(mapping, sampleAccountData);

	    debug(transformedData);
	    
	    var tempAccount = this.getService().getHibachiService().newAccount();
	    
	    // try to import
	    tempAccount = this.getService().processEntityImport( tempAccount, transformedData );
	
		debug(tempAccount.getErrors()); 

	    expect( tempAccount.hasErrors() ).toBeTrue("Account should have errors");
    }
    
    
    /** 
	 * @test
	*/
    public void function processEntityImportTest_should_call_post_populate_functions_on_entity_if_provided(){
	    
	    var tempAccount = this.getService().getHibachiService().newAccount();
	    var sampleAccountData = getSampleAccountData();
	    
        var mapping = getSampleAccountMapping();
        mapping.postPopulateMethods = ['postPopulateExampleMethod'];
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);

        var data = this.getService().transformMappingData(mapping, sampleAccountData);
        debug(data);


        function postPopulateExampleMethod_spy(){
            // puting something in the THIS scope of the ENTITY so it can be verified later
            this['postPopulateExampleMethod_called'] = 'it-does-not-matter'; 
        }
        tempAccount['postPopulateExampleMethod'] = postPopulateExampleMethod_spy;

	
        // it does not exist before processing
	    expect( structKeyExists(tempAccount, 'postPopulateExampleMethod_called') ).toBe(false);

	   
	    // try to import
	    tempAccount = this.getService().processEntityImport( tempAccount, data, mapping );
	    
	   
        expect( tempAccount )
            .toHaveKey('postPopulateExampleMethod_called');
        expect( tempAccount.postPopulateExampleMethod_called )
            .toBe('it-does-not-matter');
    }
    
    
    /**
     * @test
    */
    public void function processEntityImport_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        // declare a mock validation-finction on the target-service
        function processAccount_import_spy(required any entity, required struct entityQueueData, ){
            this['processAccount_import_spy_called'] = "it works";
            return true;
        }
        
        variables.service['processAccount_import'] = processAccount_import_spy;
        
        
        var mapping = getSampleAccountMapping();
        debug(mapping);
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var data = this.getService().transformMappingData( mapping=getSampleAccountMapping(), data=sampleAccountData );
        
        var tempAccount = this.getService().getHibachiService().newAccount();
	    tempAccount = this.getService().processEntityImport( tempAccount, data );

        
        expect( variables.service ).toHaveKey('processAccount_import_spy_called');
        expect( variables.service.processAccount_import_spy_called ).toBe('it works');
        
        debug(variables.service.processAccount_import_spy_called);
        
        // cleanup
        structDelete( variables.service, 'processAccount_import_spy_called');
        structDelete( variables.service, 'processAccount_import');
    }
    
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        // declare a mock validation-finction on the target-service
        function resolveAccountEmailAddressDependencies_spy(required any entity, required struct entityQueueData, ){
            this['resolveAccountEmailAddressDependencies_spy_called'] = "it works";
        }
        
        variables.service['resolveAccountEmailAddressDependencies'] = resolveAccountEmailAddressDependencies_spy;
        
        var mapping = getAccountEmailAddressMapping();
        debug(mapping);
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        var propertiesValidations = this.getService().getImporterMappingService().getMappingPropertiesValidations( mapping.mappingCode );
        debug(propertiesValidations);
        
        var data = this.getService().transformMappingData( mapping=mapping, data=sampleAccountData );
        debug(data);
        
        var tempAccountEmailAddress = this.getService().getHibachiService().newAccountEmailAddress();
	    tempAccountEmailAddress = this.getService().resolveEntityDependencies( entity=tempAccountEmailAddress, entityQueueData=data, mapping=mapping );

        
        expect( variables.service ).toHaveKey('resolveAccountEmailAddressDependencies_spy_called');
        expect( variables.service.resolveAccountEmailAddressDependencies_spy_called ).toBe('it works');
        
        debug(variables.service.resolveAccountEmailAddressDependencies_spy_called);
        
        // cleanup
        structDelete( variables.service, 'resolveAccountEmailAddressDependencies_spy_called');
        structDelete( variables.service, 'resolveAccountEmailAddressDependencies');
    }
    
    
    
    
    
    private struct function getAccountEmailAddressMapping(){
        return {
            "entityName"  : "AccountEmailAddress",
            "mappingCode" : "AccountEmailAddress",
            "properties": {
                "email": {
                    "propertyIdentifier": "emailAddress",
                    "validations": { "required": true, "dataType": "email" }
                }
            },
            "importIdentifier": {
                "propertyIdentifier": "importRemoteID",
                "type": "composite",
                "keys": [
                    "remoteAccountID",
                    "email"
                ]
            },
            "dependencies" : [{
                "key"                : "remoteAccountID",
                "entityName"         : "Account",
                "lookupKey"          : "remoteID",
                "propertyIdentifier" : "account"
            }]
        };
    }
    
    /**
     * @test
    */
    public void function processEntityImport_check_transform_data(){
        
        var sampleProductData = {
                "mappingCode" : "Inventory",
            	"__dependancies": [{
            		"key": "remoteSkuID",
            		"entityName": "Sku",
            		"lookupKey": "remoteID",
            		"propertyIdentifier": "sku",
            		"lookupValue": "1"
            	}, {
            		"key": "remoteLocationID",
            		"entityName": "Location",
            		"lookupKey": "remoteID",
            		"propertyIdentifier": "location",
            		"lookupValue": "87090B80C8D31B4CDB500112B16C720B"
            	}],
            	"createdDateTime": "27",
            	"inventoryID": "",
            	"landedAmount": "100",
            	"landedCost": "98",
            	"cost": "54",
            	"stock": {
            		"stockID": "4028c08475735ffa01757360ead40006"
            	},
            	"cogs": "22",
            	"remoteID": "1",
            	"currencyCode": "IDR",
            	"quantityOut": "14",
            	"quantityIn": "53",
            	"importRemoteID": "C4CA4238A0B923820DCC509A6F75849B"
            };
        var tempInventory = this.getService().getHibachiService().newInventory();
	    tempAccountData = this.getService().processEntityImport( tempInventory, sampleProductData );
        //var data = this.getService().transformMappingData( mapping=this.getService().getMappingByMappingCode("Inventory"), data=sampleProductData );

        debug(tempInventory);
        debug(tempAccountData);
    }
    
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_add_errors_when_dependency_is_not_resolve(){
        var emailAddress = this.getService().getHibachiService().newAccountEmailAddress();
        
        var remoteAccountID = RandRange(1000,1000000);
        var data = {
            'remoteAccountID' : remoteAccountID,
            'email': "abc@xyz.com"
        };
        

        var transformedData = variables.service.transformMappingData( data=data, mapping=getAccountEmailAddressMapping());
        debug(transformedData);
        
        variables.service.resolveEntityDependencies( emailAddress, transformedData, getAccountEmailAddressMapping());
        
        debug( emailAddress.getErrors() );
        
        expect( emailAddress.getErrors() ).toBeStruct();
        expect( emailAddress.getErrors() ).toHaveKey( 'account' );
    }
    
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_not_add_errors_when_dependency_is_resolve(){
        var emailAddress = this.getService().getHibachiService().newAccountEmailAddress();
        
        var remoteAccountID = RandRange(1000,1000000);
        var data = {
            'remoteAccountID' : remoteAccountID,
            'email': "abc@xyz.com"
        };
        
        var accountID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swAccount", { 'accountID': accountID, 'remoteID': remoteAccountID });
        
        
        var transformedData = variables.service.transformMappingData( data=data, mapping=getAccountEmailAddressMapping());

        debug(transformedData);
        
        variables.service.resolveEntityDependencies( emailAddress, transformedData, getAccountEmailAddressMapping() );
        
        debug( emailAddress.getErrors() );
        expect( emailAddress.getErrors() ).toBeEmpty();
        
        deleteRow('swAccount', 'accountID', accountID );
    }
    
    
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_add_dependency_data_when_resolved(){
        var emailAddress = this.getService().getHibachiService().newAccountEmailAddress();
        
        var remoteAccountID = RandRange(1000,1000000);
        var data = {
            'remoteAccountID' : remoteAccountID,
            'email': "abc@xyz.com"
        };
        
        var accountID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swAccount", { 'accountID': accountID, 'remoteID': remoteAccountID });
        
        
        var transformedData = variables.service.transformMappingData( data=data, mapping=getAccountEmailAddressMapping());

        debug(transformedData);
        
        variables.service.resolveEntityDependencies( emailAddress, transformedData, getAccountEmailAddressMapping() );
        
        debug( transformedData );
        
        expect( transformedData ).toHaveKey('account');
        expect( transformedData.account ).toBeStruct();
        expect( transformedData.account ).toHaveKey('accountID');
        expect( transformedData.account.accountID ).toBe( accountID );
        
        deleteRow('swAccount', 'accountID', accountID );
    }
    
    
    
    /***************. Lazy Evaluation *******************/

    
    /***************. Lazy Evaluated properties *******************/
    
    /**
     * @test
    */
    public void function transformMappingData_should_not_generate_lazy_evaluated__properties(){

        var sampleData = getSampleProductData();

        var mapping = this.getService().getMappingByMappingCode( '_Product' );
        mapping.properties.each( function( propName ){ 
            mapping.properties[propName]['evaluationMode'] = 'lazy';
        });
        
        var transformedData = this.getService().transformMappingData(
            data = sampleData, 
            mapping = mapping
        );
	    
	    debug(transformedData);
	    
        expect( StructKeyExists(transformedData, 'productCode') ).toBeFalse();
        expect( StructKeyExists(transformedData, 'productDescription') ).toBeFalse();
        expect( StructKeyExists(transformedData, 'productName') ).toBeFalse();
        expect( StructKeyExists(transformedData, 'publishedFlag') ).toBeFalse();
        // .....
        // ....
    }

    /**
     * @test
    */
    public void function transformMappingData_should_generate_data_to_carry_forward_for_lazy_evaluated__properties(){

         var sampleData = getSampleProductData();

        var mapping = this.getService().getMappingByMappingCode( '_Product' );
        mapping.properties.each( function( propName ){ 
            mapping.properties[propName]['evaluationMode'] = 'lazy';
        });
        
        var transformedData = this.getService().transformMappingData(
            data = sampleData, 
            mapping = mapping
        );
        
        debug( transformedData );
	    
        expect( transformedData ).toHaveKey('__lazy');
        expect( transformedData.__lazy ).toBeStruct();
        expect( transformedData.__lazy ).toHaveKey('properties');
        
        expect( transformedData.__lazy.properties ).toHaveKey('productCode');
        expect( transformedData.__lazy.properties ).toHaveKey('productDescription');
        expect( transformedData.__lazy.properties ).toHaveKey('productName');
        // .....
        // ....
    }

    /**
     * @test
    */
    public void function resolveMappingLazyProperties_should_resolve_lazy_evaluated__properties(){

        var sampleData = getSampleProductData();

        var mapping = this.getService().getMappingByMappingCode( '_Product' );
        mapping.properties.each( function( propName ){ 
            mapping.properties[propName]['evaluationMode'] = 'lazy';
        });
        
        var transformedData = this.getService().transformMappingData(
            mapping = mapping,
            data = sampleData 
        );
	    
	    debug(transformedData);
	    
	    var resolvedData = this.getService().resolveMappingLazyProperties( 
	        mapping         = mapping, 
	        transformedData = transformedData 
	    );
        
        debug( resolvedData );
	    
        expect( StructKeyExists(resolvedData, 'urlTitle') ).toBeTrue();
    }


    /***************. Lazy Evaluated generated-properties *******************/

    /**
     * @test
    */
    public void function transformMappingData_should_not_generate_lazy_evaluated__generated_properties(){

        var sampleAccountData = getSampleAccountData();

        var mapping = getSampleAccountMapping();
        mapping["generatedProperties"] = [{
            "propertyIdentifier"    : "urtTitle",
            "allowUpdate"           : false,
            "evaluationMode"        : "lazy",
        }];
        
        var transformedData = this.getService().transformMappingData(
            data = sampleAccountData, 
            mapping = mapping
        );
	    
	    debug(transformedData);
	    
        expect( StructKeyExists(transformedData, 'urlTitle') ).toBeFalse();
    }
    
    /**
     * @test
    */
    public void function transformMappingData_should_generate_data_to_carry_forward_for_lazy_evaluated__generated_properties(){

        var sampleAccountData = getSampleAccountData();

        var mapping = getSampleAccountMapping();
        mapping["generatedProperties"] = [{
            "propertyIdentifier"    : "urtTitle",
            "allowUpdate"           : false,
            "evaluationMode"        : "lazy",
        }];
        
        var transformedData = this.getService().transformMappingData(
            data = sampleAccountData, 
            mapping = mapping
        );
	    
	    debug(transformedData);
	    
        expect( transformedData ).toHaveKey('__lazy');
        expect( transformedData.__lazy ).toBeStruct();
        expect( transformedData.__lazy ).toHaveKey('generatedProperties');
    }
    
    /**
     * @test
    */
    public void function resolveMappingLazyProperties_should_resolve_lazy_evaluated__generated_properties(){

        var sampleData = getSampleProductData();

        var mapping = this.getService().getMappingByMappingCode( '_Product' );
        mapping["generatedProperties"] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductTypeUrlTitle",
            "allowUpdate"        : false,
            "evaluationMode"     : "lazy",
            "__hint"             : "lazy evaluation means, the value for this property will get generted just before populating the object"
        }];
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var transformedData = this.getService().transformMappingData(
            data = sampleData, 
            mapping = mapping
        );
	    
	    debug(transformedData);
	    
	    
	    var resolvedData = this.getService().resolveMappingLazyProperties( 
	        mapping         = mapping, 
	        transformedData = transformedData 
	    );
        
        debug( resolvedData );
	    
        expect( StructKeyExists(resolvedData, 'urlTitle') ).toBeTrue();
    }

    
    
    /***************. Lazy Evaluated relation's properties *******************/

    /**
     * @test
    */
    public void function transformMappingData_should_not_generate_lazy_evaluated__relations_properties(){

        var sampleData = getSampleProductData();

        // modify brand mapping, temporarly
        var mapping = this.getService().getMappingByMappingCode( '_Brand' );
        mapping.properties.each( function( propName ){ 
            mapping.properties[propName]['evaluationMode'] = 'lazy';
        });
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var transformedData = this.getService().transformMappingData(
            data = sampleData, 
            mapping = this.getService().getMappingByMappingCode( '_Product' )
        );
	    
	    debug(transformedData);
	    
        expect( StructKeyExists(transformedData.brand, 'brandName') ).toBeFalse();
        expect( StructKeyExists(transformedData.brand, 'brandWebsite') ).toBeFalse();
        expect( StructKeyExists(transformedData.brand, 'brandPublishedFlag') ).toBeFalse();
        expect( StructKeyExists(transformedData.brand, 'brandActiveFlag') ).toBeFalse();
        // .....
        // ....
    }
    
    /**
     * @test
    */
    public void function transformMappingData_should_generate_data_to_carry_forward_for_lazy_evaluated__relations_properties(){

        var sampleData = getSampleProductData();

        // modify brand mapping, temporarly
        var mapping = this.getService().getMappingByMappingCode( '_Brand' );
        mapping.properties.each( function( propName ){ 
            mapping.properties[propName]['evaluationMode'] = 'lazy';
        });
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var transformedData = this.getService().transformMappingData(
            data = sampleData, 
            mapping = this.getService().getMappingByMappingCode( '_Product' )
        );
	    
	    debug(transformedData);
	    
        expect( transformedData ).toHaveKey('__lazy');
        expect( transformedData.__lazy ).toBeStruct();
        expect( transformedData.__lazy ).toHaveKey('relations');
        
        
        expect(transformedData.brand).toHaveKey('__lazy');
        expect(transformedData.brand.__lazy).toHaveKey('properties');
    }

    /**
     * @test
    */
    public void function resolveMappingLazyProperties_should_resolve_lazy_evaluated__generated_properties(){

        var sampleData = getSampleProductData();

        // modify brand mapping, temporarly
        var mapping = this.getService().getMappingByMappingCode( '_Brand' );
        mapping.properties.each( function( propName ){ 
            mapping.properties[propName]['evaluationMode'] = 'lazy';
        });
        
        this.getService().getImporterMappingService().putMappingIntoCache(mapping);
        
        var transformedData = this.getService().transformMappingData(
            data = sampleData, 
            mapping = this.getService().getMappingByMappingCode( '_Product' )
        );
	    
	    debug(transformedData);
	    
        var resolvedData = this.getService().resolveMappingLazyProperties( 
	        mapping         = mapping, 
	        transformedData = transformedData 
	    );
                
        debug( resolvedData );
	    
        expect( StructKeyExists(resolvedData.brand, 'brandName') ).toBeTrue();
    }


}
