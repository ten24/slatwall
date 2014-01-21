/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/

component extends="HibachiService" accessors="true" output="false" {
	
	// ===================== START: Logical Methods ===========================
	
	public array function getCollectionObjectOptions() {
		var emd = getEntitiesMetaData();
		var enArr = listToArray(structKeyList(emd));
		arraySort(enArr,"text");
		
		var options = [];
		for(var value in enArr) {
			var option = {};
			option["name"] = rbKey('entity.#value#');
			option["value"] = value; 
			arrayAppend(options, option);
		}
		
		var option = {};
		option["name"] = rbKey('define.select');
		option["value"] = ""; 
		
		arrayPrepend(options, option);
		
		return options;
	}
	
	public array function getCollectionOptionsByCollectionObject( required string collectionObject ) {
		var smartList = this.getCollectionSmartList();
		
		smartList.addSelect('collectionName', 'name');
		smartList.addSelect('collectionID', 'value');
		smartList.addOrder('collectionName|ASC');
		
		var option = {};
		option["name"] = rbKey('define.new');
		option["value"] = ""; 
		
		var options = smartList.getRecords(); 
		
		arrayPrepend(options, option);
		
		return options;
	}
	
	public any function getCollectionObjectColumnProperties( required string collectionObject ) {
		var returnArray = getCollectionObjectProperties( arguments.collectionObject );
		for(var i=arrayLen(returnArray); i>=1; i--) {
			if(listFindNoCase('one-to-many,many-to-many', returnArray[i].fieldType)) {
				arrayDeleteAt(returnArray, i);	
			}
		}
		var noneOption = {};
		noneOption["propertyIdentifier"] = "";
		noneOption["title"] = "#rbKey('define.add')# / #rbKey('define.remove')#";
		arrayPrepend(returnArray, noneOption);
		return returnArray;
	}
	
	public any function getCollectionObjectProperties( required string collectionObject ) {
		var returnArray = [];
		var sortArray = [];
		var attributeCodesList = getHibachiCacheService().getOrCacheFunctionValue("attributeService_getAttributeCodesListByAttributeSetType_ast#getProperlyCasedShortEntityName(arguments.collectionObject)#", "attributeService", "getAttributeCodesListByAttributeSetType", {1="ast#getProperlyCasedShortEntityName(arguments.collectionObject)#"});
		var properties = getPropertiesStructByEntityName(arguments.collectionObject);
		
		for(var attributeCode in listToArray(attributeCodesList)) {
			arrayAppend(sortArray, attributeCode);
			arraySort(sortArray, "textnocase");
			
			var add = {};
			add['propertyIdentifier'] = attributeCode;
			add['fieldType'] = 'column';
			
			arrayInsertAt(returnArray, arrayFindNoCase(sortArray, attributeCode), add);
		}
		
		for(var property in properties) {
			
			if(!structKeyExists(properties[property], "persistent") || properties[property].persistent) {
				arrayAppend(sortArray, property);
				arraySort(sortArray, "textnocase");
				
				var add = {};
				add['propertyIdentifier'] = property;
				add['title'] = rbKey("entity.#arguments.collectionObject#.#property#");
				if(structKeyExists(properties[property], "fieldtype")) {
					add['fieldType'] = properties[property].fieldType;
					if(structKeyExists(properties[property], "cfc")) {
						add['entityName'] = listLast(properties[property].cfc, '.');	
					}
				} else {
					add['fieldType'] = 'column';
				}
				
				arrayInsertAt(returnArray, arrayFindNoCase(sortArray, property), add);
			}
			
		}
		
		return returnArray;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}