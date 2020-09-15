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
component accessors="true" extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
    
    property name="service";
    
	public void function setUp() {
		super.setup();
		variables.service = variables.mockService.getBaseImporterServiceMock();
	}
	
	private struct function getAccountMapping(){
	    
	    return {
        	"entity": "Account",
        	"properties": {
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
        		"emailAddress": {
        		    "propertyIdentifier" : "primaryEmailAddress.emailAddress",
        		    "validations": { "required": true, "dataType": "email" }
        		},
        		"city": {
        		    "propertyIdentifier" : "primaryAccountAddress.address.city",
        		    "validations": { "dataType": "string" }
        		},
        		"state": {
        		    "propertyIdentifier" : "primaryAccountAddress.address.state",
        		    "validations": { "dataType": "string" }
        		}
        	}
        };
        
	}
	
	{
	    "entity" : "EmailAddress",
	    "properties": {
	        
	        "emailAddressXYZ": { // key in the incoming struct
	        
    		    "propertyIdentifier" : "emailAddress", // property name in this entity
    		    "validations": { "required": true, "dataType": "string" }
    		    
    		},
	    },
	    
	    // it is needed for scenarios where the incoming data does not have a `remoteID` but is stored in an entity in Slatwall, like `phoneNumber`  
	    "importIdentifier": {
	        "propertyIdentifier": "importRemoteID",
            "properties" : 'remoteOrderID,remoteOderItemID' // list of keys keys in the data not DB ; 
            // to generate, we'll concate the values and then hash  
            // all of the keys are required
	    }
	    
	}
	
	
	{
        	"entity": "Account",
        	"properties": {
        	    
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
        		
        		"emailAddress123": {
        		    
        		    "entity"      : "AccountEmailAddress",
        		    "relation"    : 'oneToMany',
        		    
    		        "propertyIdentifier" : "primaryEmailAddress.emailAddressXYZ",  // first part is the name on the property in the current entity, next parts are the name of the key in the struct for subsequent entity-mapping
    		        
        		    "validations": { "required": true, "dataType": "email" }
        		},
        		
        		"city": {
        		    
        		    "entity"      : "AccountAddress",
        		    "relation"    : 'oneToOne',
        		    
        		    "propertyIdentifier" : "primaryAccountAddress.address.city",
        		    "validations": { "dataType": "string" }
        		},
        		
        		"state": {
        		    "propertyIdentifier" : "primaryAccountAddress.address.state",
        		    "validations": { "dataType": "string" }
        		}
        	}
        }
	
	/**
	* @test
	*/
	public void function validateEntityData_should_fail(){
	    
	    var validation = this.getService().validateEntityData( entityName="Account", data={}, mapping=this.getAccountMapping(), collectErrors=false );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	}
	
		
	/**
	* @test
	*/
	public void function validateEntityData_should_fail_for_firstNamexxx(){
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
	        data = { lastName: "Yadav", remoteAccountID:'1234', username: 'nitin.yadav', emailAddress: "nitin.yadav@ten24web.com" }, 
	        mapping = this.getAccountMapping(), 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('firstName', "the validation should fail for firstName");
	}

	
	/**
	* @test
	*/
	public void function validateEntityData_should_fail_for_firstName(){
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
	        data = { lastName: "Yadav", username: 'nitin.yadav', emailAddress: "nitin.yadav@ten24web.com" }, 
	        mapping = this.getAccountMapping(), 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('firstName', "the validation should fail for firstName");
	}

	/**
	* @test
	*/
	public void function validateEntityData_should_fail_for_email(){
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
	        data = { firstName: "Nitin", lastName: "Yadav", username: 'nitin.yadav', emailAddress: "invalid email address" }, 
	        mapping = this.getAccountMapping(), 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('emailAddress', "the validation should fail for email");
	}
	
	/**
	* @test
	*/
	public void function validateEntityData_should_fail_for_username(){
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
	        data = { firstName: "Nitin", lastName: "Yadav", usernameeee: 'nitin.yadav', emailAddress: "nitin.yadav@ten24web.com" }, 
	        mapping = this.getAccountMapping(), 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assertFalse(validation.isValid);
	    expect(validation.errors).toHaveKey('username', "the validation should fail for username");
	}
	
	/**
	* @test
	*/
	public void function validateEntityData_should_pass(){
	    
	    var validation = this.getService().validateEntityData(
	        entityName="Account", 
	        data = { firstName: "Nitin", username: 'nitin.yadav', emailAddress: "nitin.yadav@ten24web.com" }, 
	        mapping = this.getAccountMapping(), 
	        collectErrors = true 
	    );
	    
	    debug(validation);
	    assert(validation.isValid);
	    expect(validation.errors).toBeEmpty("the validation should fail for username");
	}
	
	
	
	/**
	* @test
	*/
	public void function transformDataTest(){
	    
	    var data = this.getService().transformAccountData( 
	        data = { 
	            firstName: "Nitin", 
	            lastName: "Yadav",
	            username: 'nitin.yadav', 
	            emailAddress: "nitin.yadav@ten24web.com",
	            extraProp: "safwgreng",
	            city: "Gurgaon",
	            state: "Haryana"
	        }, 
	        mapping = this.getAccountMapping()
	    );
	    debug(data);
	    
	    expect(data).toHaveKey('firstName', "transformed data should have key 'firstName' ");
	    expect(data).toHaveKey('lastName',  "transformed data should have key 'firstName' ");
	    expect(data).toHaveKey('username',  "transformed data should have key 'username' ");
	    
	    expect(data).toHaveKey('primaryEmailAddress',  "transformed data should have key 'primaryEmailAddress' ");
	    expect(data.primaryEmailAddress).toHaveKey('emailAddress',  "primaryEmailAddress should have key 'emailAddress' ");
	    
	    expect(data).toHaveKey('primaryAccountAddress',  "transformed data should have key 'primaryAccountAddress' ");
	    expect(data.primaryAccountAddress).toHaveKey('address',  "primaryAccountAddress should have key 'address' ");
	    expect(data.primaryAccountAddress.address).toHaveKey('state',  "primaryAccountAddress.address should have key 'state' ");
	    expect(data.primaryAccountAddress.address).toHaveKey('city',  "primaryAccountAddress.address should have key 'city' ");

    }
}


