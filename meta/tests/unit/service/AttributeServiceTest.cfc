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
		variables.service = request.slatwallScope.getBean("attributeService");
	}
	
	public void function saveAttributeTest_cacheClearedOnAttributeSave(){
		var attributeSetData = {
			attributeSetID="",
			attributeSetName="unitTestAttributeSet",
			attributeSetCode="unitTestAttributeSetCode"&generateRandomString(),
			attributeSetObject="Account"
		};
		var attributeSet = createPersistedTestEntity('attributeSet',attributeSetData);
		
		var attributeData = {
			attributeID="",
			attributeName="unitTestAttribute",
			attributeCode="unitTestAttributeCode"&generateRandomInteger(),
			attributeSet={
				attributeSetID=attributeSet.getAttributeSetID()
			}
		};
		var attribute = createPersistedTestEntity('attribute',attributeData);
		
		request.slatwallScope.getService('hibachiCacheService').resetCachedKey('attributeService_getAttributeModel');
		request.slatwallScope.getService('hibachiCacheService').resetCachedKey('attributeService_getAttributeModel_#attributeSet.getAttributeSetObject()#');
		
		request.slatwallScope.getService('hibachiCacheService').resetCachedKey('attribtueService_getAttributeModel_#attributeSet.getAttributeSetObject()#_#attributeSet.getAttributeSetCode()#');
		
		
		var attributeMetaData = variables.service.getAttributeModel();
		
		//assert that the cache was built
		assert(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attributeService_getAttributeModel') == true);
		assert(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attributeService_getAttributeModel_#attributeSet.getAttributeSetObject()#') == true);
		assert(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attribtueService_getAttributeModel_#attributeSet.getAttributeSetObject()#_#attributeSet.getAttributeSetCode()#') == true);
		//saving clears the cache
		var attributeName = 'adf'&generateRandomString();
		attribute = variables.service.saveAttribute(attribute,{attributeName=attributeName,attributeType="text"});
		sleep(200);
		//make sure no errors
		assert(structCount(attribute.getErrors()) == 0);
		//make sure change happened
		assert(attribute.getAttributeName() == attributeName);
		//make sure that the cache did clear
		assertFalse(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attributeService_getAttributeModel') == true);
		assertFalse(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attributeService_getAttributeModel_#attributeSet.getAttributeSetObject()#'));
		assertFalse(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attribtueService_getAttributeModel_#attributeSet.getAttributeSetObject()#_#attributeSet.getAttributeSetCode()#') == true);
	}
	
	public void function getAttributeModelTest(){
		
		var attributeSetData = {
			attributeSetID="",
			attributeSetName="unitTestAttributeSet",
			attributeSetCode="unitTestAttributeSetCode"&generateRandomInteger(),
			attributeSetObject="Account"
		};
		var attributeSet = createPersistedTestEntity('attributeSet',attributeSetData);
		
		var attributeData = {
			attributeID="",
			attributeName="unitTestAttribute",
			attributeCode="unitTestAttributeCode"&generateRandomInteger(),
			attributeSet={
				attributeSetID=attributeSet.getAttributeSetID()
			},
			attributeType="text"
		};
		//save with service should delete the cache
		var attribute = createPersistedTestEntity(entityName='attribute',data=attributeData,saveWithService=true);
		
		//assert we don't have a cache
		assertFalse(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attributeService_getAttributeModel_Account'));
		
		assertFalse(attribute.hasErrors());
		//check not cached time
		var notCachedTickBegin = GetTickCount();
		var attributeMetaData = variables.service.getAttributeModel();
		var notCachedTickEnd = getTickCount();
		var notCachedTime = notCachedTickEnd - notCachedTickBegin;
		
		assert(structKeyExists(attributeMetaData,'Account'),'no entity');
		if(structKeyExists(attributeMetaData,'Account')){
			assert(structKeyExists(attributeMetaData['Account'],attributeSet.getAttributeSetCode()),'no attribute set');
		}
		if(structKeyExists(attributeMetaData['Account'],attributeSet.getAttributeSetCode())){
			assert(attributeMetaData['Account'][attributeSet.getAttributeSetCode()]['attributeSetName'] == attributeSet.getAttributeSetName(),'no attribute set name');
			assert(structKeyExists(attributeMetaData['Account'][attributeSet.getAttributeSetCode()],'attributes'),'no attributes');
			if(structKeyExists(attributeMetaData['Account'][attributeSet.getAttributeSetCode()],'attributes')){
				assert(
					structKeyExists(
						attributeMetaData['Account'][attributeSet.getAttributeSetCode()]['attributes'],
						attribute.getAttributeCode()
					),'no attribute code'
				);
				if(
					structKeyExists(
						attributeMetaData['Account'][attributeSet.getAttributeSetCode()]['attributes'],
						attribute.getAttributeCode()
					)
				){
					assert(attributeMetaData['Account'][attributeSet.getAttributeSetCode()]['attributes'][attribute.getAttributeCode()]['attributeName']==attribute.getAttributeName(),'no attribute name');
				}
			}
		}
		
		//assert the cache is populated
		assert(request.slatwallScope.getService('hibachiCacheService').hasCachedValue('attributeService_getAttributeModel_Account'));
		var cachedTickBegin = GetTickCount();
		attributeMetaData = variables.service.getAttributeModel();
		var cachedTickEnd = getTickCount();
		var cachedTime = cachedTickEnd - cachedTickBegin;
		addToDebug(notCachedTime);
		addToDebug(cachedTime);
		assert(cachedTime < notCachedTime);
		
	}
}


