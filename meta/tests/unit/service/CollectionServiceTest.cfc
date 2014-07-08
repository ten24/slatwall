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
		
		variables.service = request.slatwallScope.getBean("collectionService");
	}
	
	public void function getCollectionObjectColumnProperties_returns_valid_array() {
		var result = variables.service.getCollectionObjectColumnProperties( 'Account' );
		
		assert( isArray( result ) );
	}
	
	// getCollectionObjectProperties()
	public void function getCollectionObjectProperties_returns_valid_array() {
		var result = variables.service.getCollectionObjectProperties( 'Account' );
		
		assert( isArray( result ) );
	}
	
	public void function getCollectionObjectProperties_returns_properties_in_correct_sorted_order() {
		var result = variables.service.getCollectionObjectProperties( 'Account' );
		
		assertEquals( "accountAddresses", result[1].propertyIdentifier );
		assertEquals( "accountAuthentications", result[2].propertyIdentifier );
		assertEquals( "accountContentAccesses", result[3].propertyIdentifier );
		assertEquals( "accountEmailAddresses", result[4].propertyIdentifier );
		assertEquals( "accountID", result[5].propertyIdentifier );
		assertEquals( "accountLoyalties", result[6].propertyIdentifier );
	}
	
	public void function getCollectionObjectOptionsTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionObject = 'Account'
		};
		var collectionEntity = createTestEntity('collection',collectionEntityData);
		var collectionEntityProperties = variables.service.getCollectionObjectProperties(collectionEntity.getCollectionObject());
		
		assert(isArray(collectionEntityProperties));
	}
	
	public void function getCollectionOptionsByCollectionObjectTest(){
		var baseCollectionEntityData = {
			collectionid = '',
			collectionObject = 'Account'
		};
		var baseCollectionEntity = createTestEntity('collection',baseCollectionEntityData);
		
		var collectionOptions = variables.service.getCollectionOptionsByCollectionObject(baseCollectionEntity.getCollectionObject);
	}
	
	/*
	
	public void function getCollectionObjectColumnPropertiesTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionObject = 'Account'
		};
		var collectionEntity = createTestEntity('collection',collectionEntityData);
		var collectionEntityColumnProperties = variables.service.getCollectionObjectColumnProperties(collectionEntity.getCollectionObject());
		request.debug(collectionEntityColumnProperties);
	}*/
	
	public void function getCollectionObjectIntegrationTest(){
		//first a list of collection options is presented to the user
		
		
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'BestAccounts',
			collectionConfig = '{
				"entityName":"SlatwallAccount",
				"columns":[
					{
						"propertyIdentifier":"firstName"
					},
					{
						"propertyIdentifier":"accountID",
						"aggregateFunction":"count"
					}
				],
				"orderBy":[
					{
						"propertyIdentifier":"firstName",
						"direction":"DESC"
					}
				],
				"groupBy":[
					{
						"propertyIdentifier":"accountID" 
					}
				]
			}'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var parentCollectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccounts',
			collectionConfig = '{
				"entityName":"SlatwallAccount",
				"columns":[
					{
						"propertyIdentifier":"firstName"
					},
					{
						"propertyIdentifier":"accountID",
						"aggregateFunction":"count"
					}
				],
				"where":[
					{
						"propertyIdentifier":"firstName",
						"operator":"=",
						"value":"Ryan"
					}
				]
			}'
		};
		var parentCollectionEntity = createPersistedTestEntity('collection',parentCollectionEntityData);
		parentCollectionEntity.setCollectionObject(collectionEntity);
		//request.debug(parentCollectionEntity);
		
		/*var collectionEntityHQL = collectionEntity.getHQL();
		ORMExecuteQuery(collectionEntityHQL);
		request.debug(collectionEntityHQL);*/
		
		
		var parentCollectionEntityHQL = parentCollectionEntity.getHQL();
		var parentQuery = ORMExecuteQuery(parentcollectionEntityHQL);
		request.debug(parentCollectionEntityHQL);
		request.debug(parentQuery);
		
		/*
		ORMExecuteQuery("
			FROM SlatwallAccount 
			where exists(
				FROM SlatwallAccount where firstname = 'Ryan'
			)
		");
		*/
		
	}
}


