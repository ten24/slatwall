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
	
	private struct function getAccountEmailAddressMapping(){
        return {
            "entityName": "AccountEmailAddress",
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
            "BrandWebsite": "www.Valsartan and Hydrochlorothiazide.com",
            "TypeCode": "abcdefgdilkl",
            "ProductTypeActiveFlag": "false",
            "ProductTypeDescription": "",
            "BrandName": "Valsartan and Hydrochlorothiazide",
            "SkuName": "Water - Spring Water 500ml sku 4",
            "RemoteSkuID": "8919",
            "SkuActiveFlag": "false",
            "PriceGroupCode": "pgtOne",
            "ProductDescription": "Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.",
            "ProductTypePublishedFlag": "",
            "RemoteSkuPriceID": "81957",
            "CurrencyCode": "CAD",
            "BrandActiveFlag": "true",
            "ProductTypeName": "Product type 111",
            "ProductCode": "",
            "PriceGroupName": "Price group one",
            "SkuDescription": "Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.",
            "RemoteProductID": "65584",
            "RemoteProductTypeID": "37890",
            "Price": "397.03",
            "MaxQuantity": "0",
            "ListPrice": "",
            "RemoteBrandID": "93326",
            "ProductActiveFlag": "true",
            "SkuPublishedFlag": "true",
            "BrandPublishedFlag": "false",
            "SkuPriceActiveFlag": "true",
            "MinQuantity": "4",
            "RemotePriceGroupID": "79978",
            "ProductName": "Water - Spring Water 500ml",
            "SkuCode": "SKU_8919"
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
    public void function getAccountCSVHeaderMetaData_should_match_with_given_columns(){
        var header = this.getService().getEntityCSVHeaderMetaData( 'Account' );
        debug( header );
        
        $assert.isEqual("AccountActiveFlag,CompanyName,CountryCode,Email,FirstName,LastName,OrganizationFlag,Phone,RemoteAccountID,Username", header.columns );
    }
	
	
	 /**
     * @test
    */
    public void function getEntityMapping_should_call_extention_point_when_declared(){
        
        // declare a mock finction on the target-service
        function getAccountMapping_spy(){
            this['getAccountMapping_spy_called'] = "it works";
            return {};
        }
        
        variables.service['getAccountMapping'] = getAccountMapping_spy;
        
        this.getService().getEntityMapping( "Account" );
        
        expect( variables.service ).toHaveKey('getAccountMapping_spy_called');
        expect( variables.service.getAccountMapping_spy_called ).toBe('it works');
        
        debug(variables.service.getAccountMapping_spy_called);
        
        // cleanup
        structDelete( variables.service, 'getAccountMapping_spy_called');
        structDelete( variables.service, 'getAccountMapping');
    }

	
	/*****************************.  Validation.  .******************************/
	
	/**
	 * @test
	*/
	public void function validateAccountData_should_fail_for_no_data(){
	    
	    var validation = this.getService().validateEntityData( entityName="Account", data={}, collectErrors=false );
	    
	    debug(validation);
	    $assert.isFalse(validation.isValid);
	}

	/**
	 * @test
	*/
	public void function validateAccountData_should_fail_for_firstName(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('firstName');
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
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
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
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
	public void function validateAccountData_should_fail_for_username(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('username');
	    sampleAccountData['usernameeee'] = "nitin.yadav";
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
	        data = sampleAccountData, 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('username', "the validation should fail for username");
	}
	
	/**
	 * @test
	*/
	public void function validateAccountData_should_pass_for_valida_data(){
	    
	    var sampleAccountData = getSampleAccountData();

	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
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

	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
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
        var mapping = this.getService().getEntityMapping( 'Account' );

        mapping.properties.remoteAccountID.validations["invalidConstraint"] = "whaever";

        $assert.throws( function() {
            this.getService().validateEntityData(
                entityName="Account",
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
        var mapping = this.getService().getEntityMapping( 'Account' );
        mapping.properties.remoteAccountID.validations["testConstraint"] = "whaever";
        
        // declare a mock validation-finction on the target-service
        function validate_testConstraint_value_spy(any propertyValue, any constraintValue){
            this['validate_dataType_testConstraint_called'] = true;
            return true;
        }
        
        variables.service['validate_testConstraint_value'] = validate_testConstraint_value_spy;

        this.getService().validateEntityData(
            entityName="Account",
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
        function validateAccountData_spy(required string entityName, required struct data, struct mapping, boolean collectErrors){
            this['validateAccountData_spy_called'] = "it works";
            return {isValid:true, errors:[] };
        }
        
        variables.service['validateAccountData'] = validateAccountData_spy;
        
        this.getService().validateEntityData( entityName="Account", data=sampleAccountData );
        
        expect( variables.service ).toHaveKey('validateAccountData_spy_called');
        expect( variables.service.validateAccountData_spy_called ).toBe('it works');
        
        debug(variables.service.validateAccountData_spy_called);
        
        // cleanup
        structDelete( variables.service, 'validateAccountData_spy_called');
        structDelete( variables.service, 'validateAccountData');
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

	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    expect( StructKeyExists(data, 'extraProp') ).toBeFalse("transformed data should not contain key 'extraProp'");
    }

    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_accountID(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('accountID', "transformed data should have key 'accountID' ");
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_importRemoteID(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('importRemoteID', "transformed data should have key 'importRemoteID' ");
    }
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_importRemoteID_should_match_with_createEntityImportRemoteID(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    var importRemoteID = this.getService().createEntityImportRemoteID( "Account", sampleAccountData );
	    
	    expect(data.importRemoteID).toBe( importRemoteID, "importRemoteID in transformed data should match with generated-id ");
    }
    
    /**
     * @test
    */
    public void function createEntityImportRemoteID_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        // declare a mock validation-finction on the target-service
        function createAccountImportRemoteID_spy(required string entityName, required struct data, struct mapping, boolean collectErrors){
            this['createAccountImportRemoteID_spy_called'] = "it works";
            return true;
        }
        
        variables.service['createAccountImportRemoteID'] = createAccountImportRemoteID_spy;
        
        variables.service.createEntityImportRemoteID( "Account", sampleAccountData );

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

	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('organizationFlag', "key organizationFlag should exist in transformed data");
	    expect(data.organizationFlag).toBe( false, "the defaule value for organizationFlag should get inferred and should be false");
    }
    
     
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_use_generator_function_for_properties_when_declared_in_mapping(){
        
        var sampleAccountData = getSampleAccountData();
        
        var mapping = this.getService().getEntityMapping( 'Account' );
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


        var data = this.getService().transformEntityData("Account", sampleAccountData, mapping);
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
    public void function transformAccountDataTest_should_use_conventional_generator_function_for_properties_when_declared_in_service(){
        
        var sampleAccountData = getSampleAccountData();
        
        var mapping = this.getService().getEntityMapping( 'Account' );
        mapping.properties['exampleProperty'] = {
            "propertyIdentifier": "examplePropertyIdentifier",
        };

        function generateAccountExamplePropertyIdentifier_spy(struct data, struct mapping, struct propertyMetaData){
            // puting something in the THIS scope of the SERVICE so it can be verified later
            this['generateAccountExamplePropertyIdentifier_spy_called'] = 'it-does-not-matter'; 
            return 'example_value';
        }
        
        
        // declare a mock generator-finction on the target-service
        // it follows the pattern `generate[entityName][PropertyIdentifier]`
        variables.service['generateAccountExamplePropertyIdentifier'] = generateAccountExamplePropertyIdentifier_spy;


        var data = this.getService().transformEntityData("Account", sampleAccountData, mapping);
        debug(data);

        expect( variables.service )
            .toHaveKey('generateAccountExamplePropertyIdentifier_spy_called');
            
        debug( variables.service.generateAccountExamplePropertyIdentifier_spy_called );
        
        expect( variables.service.generateAccountExamplePropertyIdentifier_spy_called )
            .toBe('it-does-not-matter');
            
	    expect( data )
	        .toHaveKey('examplePropertyIdentifier', "key examplePropertyIdentifier should exist in transformed data");
	        
	    expect( data.examplePropertyIdentifier )
	        .toBe( 'example_value', "the defaule value for examplePropertyIdentifier should get generated and should be 'example_value' ");
       
        // cleanup
        structDelete( variables.service, 'generateAccountExamplePropertyIdentifier_spy_called');
        structDelete( variables.service, 'generateAccountExamplePropertyIdentifier');
    }
    
    
    
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_use_generator_function_for_relations_when_declared_in_mapping(){
        
        var sampleAccountData = getSampleAccountData();
        
        var mapping = this.getService().getEntityMapping( 'Account' );
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


        var data = this.getService().transformEntityData("Account", sampleAccountData, mapping);
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
    public void function transformAccountDataTest_should_use_conventional_generator_function_for_relations_when_declared_in_service(){
        
        var sampleAccountData = getSampleAccountData();
        
        var mapping = this.getService().getEntityMapping( 'Account' );
        mapping.relations = [{
            "entityName": "Account",
            "propertyIdentifier": "exampleRelationXXXYYYProperty",
        }];

        function getAccountExampleRelationXXXYYYProperty_spy( struct data, struct parentEntityMapping, struct relationMetaData){
            // puting something in the THIS scope of the SERVICE so it can be verified later
            variables.this['getAccountExampleRelationXXXYYYProperty_spy_called'] = 'xxxxx-yyyyy-does-not-matter'; 
            return {"keyxx": 'valuexx', 'accountID': '12345'};
        }
        // declare a mock generator-finction on the target-service
        variables.service['generateAccountExampleRelationXXXYYYProperty'] = getAccountExampleRelationXXXYYYProperty_spy;


        var data = this.getService().transformEntityData("Account", sampleAccountData, mapping);
        debug(data);

        expect( variables.service ).toHaveKey('getAccountExampleRelationXXXYYYProperty_spy_called');
        expect( variables.service.getAccountExampleRelationXXXYYYProperty_spy_called ).toBe('xxxxx-yyyyy-does-not-matter');
            
	    expect( data ).toHaveKey( 'exampleRelationXXXYYYProperty' );
	    expect( data.exampleRelationXXXYYYProperty ).toHaveKey( 'keyxx' );
	    expect( data.exampleRelationXXXYYYProperty.keyxx ).toBe( 'valuexx' );
       
        // cleanup
        structDelete( variables.service, 'getAccountExampleRelationXXXYYYProperty_spy');
        structDelete( variables.service, 'getAccountExampleRelationXXXYYYProperty_spy_called');
    }
    
    
     /**
     * @test
    */
    public void function transformEntityData_should_resolve__generated__properties(){
        var sampleProductData = getSampleProductData();
        
        var mapping = this.getService().getEntityMapping( 'Product' );
        mapping['generatedProperties'] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductUrlTitle"
        }];
        
        mapping.delete('relations');
        
        var data = this.getService().transformEntityData("Product", sampleProductData, mapping);
        debug(data);
        expect( data ).toHaveKey( 'urlTitle' );
    }
    
    /**
     * @test
    */
    public void function transformEntityData_should_resolve__create_only__properties__when_creating_new_entity(){
        var sampleProductData = getSampleProductData();
        
        var mapping = this.getService().getEntityMapping( 'Product' );
        mapping['generatedProperties'] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductUrlTitle",
            "allowUpdate"        : false
        }];
        
        mapping.delete('relations');
        
        var data = this.getService().transformEntityData("Product", sampleProductData, mapping);
        debug(data);
        expect( data ).toHaveKey( 'urlTitle' );
    }
    
    
    /**
     * @test
    */
    public void function transformEntityData_should_not_resolve__create_only__properties__when_updating_existing_entity(){
        var sampleProductData = getSampleProductData();
        
        // simulates updating existing product
        sampleProductData['productID'] = '123456789078765';
        
        var mapping = this.getService().getEntityMapping( 'Product' );
        mapping['generatedProperties'] = [{
            "propertyIdentifier" : "urlTitle",
            "generatorFunction"  : "generateProductUrlTitle",
            "allowUpdate"        : false
        }];
        
        mapping.delete('relations');
        
        var data = this.getService().transformEntityData("Product", sampleProductData, mapping);
        debug(data);
        
        expect( structKeyExists(data, 'urlTitle') ).toBeFalse();
    }

    
    /**
     * @test
    */
    public void function processEntityImport_check_transform_data(){
        
        // var sampleProductData = getSampleProductData();
        
        var sampleProductData = {
                "productType": {
                    "parentProductType": {
                        "productTypeID": "444df2f7ea9c87e60051f3cd87b435a1"
                    },
                    "productTypeDescription": "Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.",
                    "productTypeID": "",
                    "systemCode": "١٢٣",
                    "remoteID": "71580",
                    "importRemoteID": "9A177BF0543ED8157A0E9903295F01FA",
                    "productTypeName": "Product type 22245",
                    "urlTitle": "Product-type-22245"
                },
                "brand": {
                    "brandWebsite": "https://www.SENSAICELLULARPERFORMANCEPOWDERFOUNDATION.com",
                    "brandName": "SENSAI CELLULAR PERFORMANCE POWDER FOUNDATION",
                    "brandID": "",
                    "remoteID": "73002",
                    "urlTitle": "SENSAI-CELLULAR-PERFORMANCE-POWDER-FOUNDATION",
                    "importRemoteID": "83159AC34DAF800DC96FA00DFD44BD52"
                },
                "productDescription": "Sed ante. Vivamus tortor. Duis mattis egestas metus.",
                "defaultSku": {
                    "skuDescription": "Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.",
                    "imageFile": "SKU_30443-.jpeg",
                    "skuName": "Pecan Raisin - Tarts sku 5",
                    "skuID": "",
                    "remoteID": "30443",
                    "skuCode": "SKU_30443",
                    "urlTitle": "SKU_30443_1234",
                    "importRemoteID": "1BA4D572A08BABFE8C7D9C9717EC1599",
                    "skuPrices": [
                        {
                            "skuPriceID": "",
                            "price": "622.8",
                            "maxQuantity": "5",
                            "listPrice": "513.83",
                            "minQuantity": "1",
                            "priceGroup": {
                                "priceGroupName": "Price group two",
                                "priceGroupID": "",
                                "priceGroupCode": "pgtTwo",
                                "remoteID": "60850",
                                "importRemoteID": "366BB8CABA334AB2D8CAC7E2AAFA7302"
                            },
                            "remoteID": "55627",
                            "currencyCode": "RUB",
                            "importRemoteID": "1BA4D572A08BABFE8C7D9C9717EC1599_67654743CC32DFEEBF2D2D154DB69CD8_C4CA4238A0B923820DCC509A6F75849B_CFCD208495D565EF66E7DFF9F98764DA_366BB8CABA334AB2D8CAC7E2AAFA7302"
                        }
                    ]
                },
                "remoteID": "24036",
                "productName": "Pecan Raisin - Tarts",
                "importRemoteID": "251713B2559F797B13EC939AB7550AC6",
                "productID": "",
                "productCode": "product_1234",
                "urlTitle": "product-1234-2344",
            };
             
        debug(sampleProductData);
       
// 		var product = createPersistedTestEntity( 'product' );
		var product = request.slatwallScope.getBean('Product');
        product.populate( data=sampleProductData, objectPopulateMode='private' );
        debug(product.getErrors());
        
        product.validate('save');
        
        debug(product.getErrors());
        // var data = this.getService().transformEntityData( entityName="Product", data=sampleProductData );

        
    }
    
    
    
    
    
    
    /** 
	 * @test
	*/
    public void function transformAccountDataTest_should_contain_account_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
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
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
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
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
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
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
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
    public void function transformAccountDataTest_should_contain_accountAuthentication_properties(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    expect(data).toHaveKey('accountAuthentications', "transformed data should have key 'accountAuthentications' ");
	    expect(data.accountAuthentications).toBeTypeOf('array',  "accountAuthentications should be an struct ");
	    
	    var accountAuthentication = data.accountAuthentications[1];
	    expect(accountAuthentication).toBeTypeOf('struct',  "accountAuthentication should be an struct ");
	   
	    expect(accountAuthentication).toHaveKey('importRemoteID', "transformed data should have key 'importRemoteID' ");
	    expect(accountAuthentication).toHaveKey('accountAuthenticationID',  "transformed data should have key 'accountAuthenticationID' ");
	    
	    expect(accountAuthentication).toHaveKey('password',  "transformed data should have key 'password' ");
	    expect(accountAuthentication).toHaveKey('activeFlag',  "primaryEmailAddress should have key 'activeFlag' ");
	    expect(accountAuthentication).toHaveKey('updatePasswordOnNextLoginFlag',  "primaryEmailAddress should have key 'updatePasswordOnNextLoginFlag' ");
    }
    
    
    /**
     * @test
    */
    public void function transformEntityData_should_call_extention_point_when_declared(){
        
        var sampleAccountData = getSampleAccountData();

        // declare a mock validation-finction on the target-service
        function transformAccountData_spy(required string entityName, required struct data, struct mapping, boolean collectErrors){
            this['transformAccountData_spy_called'] = "it works";
            return {};
        }
        
        variables.service['transformAccountData'] = transformAccountData_spy;
        
        this.getService().transformEntityData( entityName="Account", data=sampleAccountData );
        
        expect( variables.service ).toHaveKey('transformAccountData_spy_called');
        expect( variables.service.transformAccountData_spy_called ).toBe('it works');
        
        debug(variables.service.transformAccountData_spy_called);
        
        // cleanup
        structDelete( variables.service, 'transformAccountData_spy_called');
        structDelete( variables.service, 'transformAccountData');
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
        
	    var validation = this.getService().pushRecordIntoImportQueue( 
	            entityName="Account", 
	            data = sampleAccountData,
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
        
	    var validation = this.getService().pushRecordIntoImportQueue( 
	            entityName="Account", 
	            data = sampleAccountData,
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
        
	    var validation = this.getService().pushRecordIntoImportQueue( 
	            entityName="Account", 
	            data = sampleAccountData,
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
	    
	    var transformedData = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(transformedData);
	    
	    var tempAccount = this.getService().getHibachiService().newAccount();
	    
	    // try to import
	    tempAccount = this.getService().processEntityImport( tempAccount, transformedData );
	
	    debug(tempAccount.getErrors()); 
	    
	    expect( tempAccount.hasErrors() ).toBeFalse("Account should not have errors");
        
    }
    
    /** 
	 * @test
	*/
    public void function processEntityImportTest_should_have_errors_when_entity_validations_fails(){
	    
	    var sampleAccountData = getSampleAccountData();
	    sampleAccountData.delete('firstName');
	    
	    var transformedData = this.getService().transformEntityData("Account", sampleAccountData);

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
	    
        var mapping = this.getService().getEntityMapping( 'Account' );
        mapping.postPopulateMethods = ['postPopulateExampleMethod'];
        
        var data = this.getService().transformEntityData("Account", sampleAccountData, mapping);
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
        
        var data = this.getService().transformEntityData( entityName="Account", data=sampleAccountData );
        
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
        function resolveAccountDependencies_spy(required any entity, required struct entityQueueData, ){
            this['resolveAccountDependencies_spy_called'] = "it works";
        }
        
        variables.service['resolveAccountDependencies'] = resolveAccountDependencies_spy;
        
        var data = this.getService().transformEntityData( entityName="Account", data=sampleAccountData );
        
        var tempAccount = this.getService().getHibachiService().newAccount();
	    tempAccount = this.getService().resolveEntityDependencies( tempAccount, data );

        
        expect( variables.service ).toHaveKey('resolveAccountDependencies_spy_called');
        expect( variables.service.resolveAccountDependencies_spy_called ).toBe('it works');
        
        debug(variables.service.resolveAccountDependencies_spy_called);
        
        // cleanup
        structDelete( variables.service, 'resolveAccountDependencies_spy_called');
        structDelete( variables.service, 'resolveAccountDependencies');
    }
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_add_errors_when_dependancy_is_not_resolve(){
        var emailAddress = this.getService().getHibachiService().newAccountEmailAddress();
        
        var data = {
            'remoteAccountID' : '12345465',
            'email': "abc@xyz.com"
        };
        

        var transformedData = variables.service.transformEntityData( "AccountEmailAddress", data, getAccountEmailAddressMapping());
        debug(transformedData);
        
        variables.service.resolveEntityDependencies( emailAddress, transformedData );
        
        debug( emailAddress.getErrors() );
        
        expect( emailAddress.getErrors() ).toBeStruct();
        expect( emailAddress.getErrors() ).toHaveKey( 'account' );
        
        expect( emailAddress.getErrors().account[1] )
        .toBe('Depandancy for propertyIdentifier [account] on Entity [AccountEmailAddress] could not be resolved yet');
        
    }
    
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_not_add_errors_when_dependancy_is_resolve(){
        var emailAddress = this.getService().getHibachiService().newAccountEmailAddress();
        
        var data = {
            'remoteAccountID' : '12345465',
            'email': "abc@xyz.com"
        };
        
        var accountID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swAccount", { 'accountID': accountID, 'remoteID': '12345465' });
        
        
        var transformedData = variables.service.transformEntityData( "AccountEmailAddress", data, getAccountEmailAddressMapping());

        debug(transformedData);
        
        variables.service.resolveEntityDependencies( emailAddress, transformedData );
        
        debug( emailAddress.getErrors() );
        expect( emailAddress.getErrors() ).toBeEmpty();
        
        deleteRow('swAccount', 'accountID', accountID );
    }
    
    
    
    /**
     * @test
    */
    public void function resolveEntityDependencies_should_add_dependancy_data_when_resolved(){
        var emailAddress = this.getService().getHibachiService().newAccountEmailAddress();
        
        var data = {
            'remoteAccountID' : '12345465',
            'email': "abc@xyz.com"
        };
        
        var accountID = hash("123xxxunittest"&now(), 'MD5');
        insertRow("swAccount", { 'accountID': accountID, 'remoteID': '12345465' });
        
        
        var transformedData = variables.service.transformEntityData( "AccountEmailAddress", data, getAccountEmailAddressMapping());

        debug(transformedData);
        
        variables.service.resolveEntityDependencies( emailAddress, transformedData );
        
        debug( transformedData );
        
        expect( transformedData ).toHaveKey('account');
        expect( transformedData.account ).toBeStruct();
        expect( transformedData.account ).toHaveKey('accountID');
        expect( transformedData.account.accountID ).toBe( accountID );
        
        deleteRow('swAccount', 'accountID', accountID );
    }


    
}
