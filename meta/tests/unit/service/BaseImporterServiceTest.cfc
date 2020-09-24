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
	
	private struct function getAccountMapping(){
	    
	    return {
	        
        	"entity": "Account",
        	
        	"properties": {
        	    
        	    "userID": {
        	        "propertyIdentifier": "remoteID",
        	        "validations": { "required": true, "dataType": "string"}
        	    },
        	    "firstName": {
        		    "propertyIdentifier" : "firstName",
        		    "validations": { "required": true, "dataType": "string" }
        		},
        		"lastName": {
        		    "propertyIdentifier" : "lastName",
        		    "validations": { "dataType": "string" }
        		},
        		"username": {
        		    "propertyIdentifier" : "username",
        		    "validations": { "required": true, "dataType": "string" }
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
                }
        	},
        	
        	// uniqueue identifier, to figure-out upserts of imported data ==> md5( data.accoutRemoteID + data.phoneNumber );
        	// it is needed for scenarios where the incoming data does not have a `remoteID` but is stored in an entity in Slatwall, like `phoneNumber`  
        	"importIdentifier": {
        	    "propertyIdentifier": "importRemoteID", //property on the entity, should exist in all imported entities
                "type": "composite",  // AND, OR --> TODO
                "keys" : [ "userID", "username" ] // to generate, we'll concate the values and then md5; all of the keys must be required
            },
        	
        	// Related-Entities one-to-one, one-to-many, many-to-many, many-to-one
        	"relations": [
        	    {
        	        "entityName": "AccountEmailAddress",
        	        "proeprtyIdentifier": "primaryEmailAddress", // property on the entity
                },
                {
        	        "entityName": "AccountPhoneNumber",
        	        "proeprtyIdentifier": "primaryPhoneNumber",
                }
            ]
        };
	}
	
    private struct function getSampleAccountData(){
	    
	    return {
	        userID: 123, 
	        firstName: "Nitin",  
	        lastName: "Yadav", 
	        username: 'nitin.yadav', 
	        companyName: "Ten24",
	        
	        //AccountEmailAddress
	        email: "nitin.yadav@ten24web.com",
	        
	        //AccountPhoneNumber
	        phone: 9090909090,
	        countryCode: "+91"
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
    public void function getAccountCSVHeaderMetaDataTest_should_match(){
        var header = this.getService().getEntityCSVHeaderMetaData( 'Account' );
        debug( header );
        
        $assert.isEqual("CompanyName,CountryCode,Email,FirstName,LastName,OrganizationFlag,Phone,UserID,Username", header.columns );
    }
	
	
	/*****************************.  Validation.  .******************************/
	
	/**
	 * @test
	*/
	public void function validateAccountData_should_fail(){
	    
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
	public void function validateAccountData_should_pass(){
	    
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
    public void function transformAccountDataTest_should_ignore_extra_properties(){
	    
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
    public void function transformAccountDataTest_importRemoteID_should_match(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    var data = this.getService().transformEntityData("Account", sampleAccountData);
	    debug(data);
	    
	    var importRemoteID = this.getService().createEntityImportRemoteID( "Account", sampleAccountData );
	    
	    expect(data.importRemoteID).toBe( importRemoteID, "importRemoteID in transformed data should match with generated-id ");
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
	    
	    expect(data.primaryEmailAddress).toHaveKey('emailAddress',  "primaryEmailAddress should have key 'phoneNumber' ");
    }
    
    /** 
	 * @test
	*/
    public void function pushRecordIntoImportQueueTest_should_enqueue_to_failureQueue(){
	    
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
    public void function pushRecordIntoImportQueueTest_should_enqueue_to_entityQueue(){
	    
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
    public void function reQueueImportFailureTest(){
	    
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
    public void function processEntityImportTest_should_not_have_errors(){
	    
	    var sampleAccountData = getSampleAccountData();
	    
	    sampleAccountData['username'] = "nitin.yadav.test";
	
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
    public void function processEntityImportTest_should_have_errors(){
	    
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
    
    
}

