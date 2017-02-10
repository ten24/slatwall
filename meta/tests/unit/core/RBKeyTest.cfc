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
	
	
	
	public void function allValidationsHaveRBkeys(){
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		var allFound = true;
		
		for(var entityName in allEntities) {
			var thisEntityName = replace(entityName, "Slatwall","","all");
			var exampleEntity = request.slatwallScope.newEntity( thisEntityName );
			var validationStruct = request.slatwallScope.getService('HibachiValidationService').getValidationStruct(exampleEntity);
			if(structKeyExists(validationStruct,'properties')){
				for(var propertyName in validationStruct.properties){
					var validationPropertyDetails = validationStruct.properties[propertyName];
					for(var validationPropertyDetail in validationPropertyDetails){
						var contexts = ["save"];
						if(structKeyExists(validationPropertyDetail,'contexts')){
							contexts = listToArray(validationPropertyDetail.contexts);
						}
						for(var context in contexts){
							for(var key in validationPropertyDetail){
								//'validate.delete.Account.ownerAccount.canDeleteByOwner'
								
								if(key != 'contexts' && key != 'conditions'){
									
									var validationTypeName = key;
									if(key == 'method'){
										validationTypeName = validationPropertyDetail[key];
									}
									
									var rbkey = 'validate.#context#.#thisEntityName#.#propertyName#.#validationTypeName#';
									if(key == 'dataType'){
										rbkey &= ".#validationPropertyDetail[key]#";	
									}else if (listFindNoCase("lteProperty,ltProperty,gteProperty,gtProperty", key)) {
										var rbkeyFallback = rbkey;
										rbkey &= ".#validationPropertyDetail[key]#,#rbkeyFallback#";	
									}
									
									//exclude attribute message based regex validation
									if(rbkey != 'validate.save.AttributeValue.attributeValue.regexMatches'){
										var keyValue = request.slatwallScope.rbKey(rbkey,{propertyName=propertyName,className=exampleEntity.getClassName()});
										if(right(keyValue,8) == '_missing') {
											//if object doesn't have rbkey then check if the processObject has one
											if(exampleEntity.hasProcessObject(context)){
												var processObject = exampleEntity.getProcessObject(context);
												rbkey = "validate.#processObject.getClassName()#.#propertyName#.#validationTypeName#";
												keyValue = request.slatwallScope.rbKey(rbkey,{propertyName=propertyName,className=exampleEntity.getClassName()});						
												if(right(keyValue,8) == '_missing') {
													addToDebug(keyValue);
													allFound = false;
												}
											}else{
												addToDebug(keyValue);
												allFound = false;	
											}
										}
									
									}
								}
							}
						}
					}
				}	
			}
		}
		assert(allFound, ArrayToList(variables.debugArray, chr(13) & chr(10)));
	}

	public void function all_entity_properties_have_keys() {
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		var allFound = true;

		for(var entityName in allEntities) {

			var thisEntityName = replace(entityName, "Slatwall","","all");

			// Check for the entity key
			var keyValue = request.slatwallScope.rbKey('entity.#thisEntityName#');
			if(right(keyValue,8) == '_missing') {
				addToDebug(keyValue);
				allFound = false;
			}

			// Check for the entity key plural
			var keyValue = request.slatwallScope.rbKey('entity.#thisEntityName#_plural');
			if(right(keyValue,8) == '_missing') {
				addToDebug(keyValue);
				allFound = false;
			}

			// Check for the entity property keys
			var exampleEntity = request.slatwallScope.newEntity( thisEntityName );
			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {
				if(!structKeyExists(property, "persistent") || property.persistent) {
					//var keyValue = request.slatwallScope.rbKey('entity.#thisEntityName#.#property.name#');
					if(exampleEntity.getClassName() != "AttributeValue"){
						var keyValue = exampleEntity.getPropertyTitle( property.name );
						if(right(keyValue,8) == '_missing' && thisEntityName != 'setting' && property.name != 'settingValue') {
							addToDebug( "#thisEntityName# | #property.name# | #keyValue#" );
							allFound = false;
						}
					}
				}
			}
		}

		assert(allFound, ArrayToList(variables.debugArray, chr(13) & chr(10)));
	}
	
	public void function settingsHaveRBkeys() {
		var settingMetaData = request.slatwallScope.getService("settingService").getAllSettingMetaData();
		var settingNameList = structKeyList(settingMetaData);
		
		var criminalsMessage = '';
		var numOfMissingRbkey = 0;
		
		for (settingName in settingNameList) {
		
			var rbkeyString = request.SlatwallScope.rbKey('setting.#settingName#');

			if(len(rbkeyString) >= 8 && right(rbkeyString,8) == '_missing'){
				numOfMissingRbkey++;
				criminalsMessage &= "settingName=#settingName# rbkeyString=#rbkeyString# , <br>"&chr(10)&chr(13);
			}
			
		}
		criminalsMessage = 'There are #numOfMissingRbkey# settingNames miss the RBKeys , <br>'&chr(10)&chr(13) & criminalsMessage;
		assertTrue(numOfMissingRbkey == 0, criminalsMessage);
	}

}
