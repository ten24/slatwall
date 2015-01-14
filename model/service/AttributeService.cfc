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

component  extends="HibachiService" accessors="true" {

	property name="attributeDAO";
	
	// ===================== START: Logical Methods ===========================
	
	public string function getAttributeCodesListByAttributeSetObject( required string attributeSetObject ) {
		var attributeCodeList = ""; 
		var rs = getAttributeDAO().getAttributeCodesQueryByAttributeSetObject( arguments.attributeSetObject );
		
		for(var i=1; i<=rs.recordCount; i++) {
			attributeCodeList = listAppend(attributeCodeList, rs[ "attributeCode" ][i]);			
		}
		
		return attributeCodeList;
	}
	
	public any function getAttributeNameByAttributeCode(string attributeCode) {
		var key = 'attributeService_getAttributeNameByAttributeCode_#arguments.attributeCode#';
		if(getHibachiCacheService().hasCachedValue(key)) {
			return getHibachiCacheService().getCachedValue(key);
		}
		
		var attribute = this.getAttributeByAttributeCode(arguments.attributeCode);
		var atributeName = "";
		if (!isNull(attribute)) {
			atributeName = attribute.getAttributeName();
		}
		
		getHibachiCacheService().setCachedValue(key, atributeName);
		
		return atributeName;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getAttributeValuesForEntity() {
		return getAttributeDAO().getAttributeValuesForEntity(argumentcollection=arguments);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveAttribute(required any attribute, struct data={}) {
		arguments.attribute = super.save(arguments.attribute, arguments.data);
		
		if(!arguments.attribute.hasErrors() && !isNull(arguments.attribute.getAttributeSet())) {
			getHibachiDAO().flushORMSession();
			
			getHibachiCacheService().resetCachedKey("attributeService_getAttributeCodesListByAttributeSetObject_#arguments.attribute.getAttributeSet().getAttributeSetObject()#");
		}
		
		return arguments.attribute;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ====================== START: Delete Overrides =========================
	
	public boolean function deleteAttribute(required any attribute) {
		
		if(!isNull(arguments.attribute.getAttributeSet())) {
			var attributeSetObject = arguments.attribute.getAttributeSet().getAttributeSetObject();	
		}
		
		var deleteOK = super.delete(arguments.attribute);
		  
		// Clear the cached value of acceptable
		if(deleteOK && len(attributeSetObject)) {
			getHibachiDAO().flushORMSession();
			
			getHibachiCacheService().resetCachedKey("attributeService_getAttributeCodesListByAttributeSetObject_#attributeSetObject#");
		}

		return deleteOK;
	}
	
	public boolean function deleteAttributeOption(required any attributeOption) {
		if(arguments.attributeOption.isDeletable()) {
			getAttributeDAO().removeAttributeOptionFromAllAttributeValues( arguments.attributeOption.getAttributeOptionID() );
			
			return super.delete(arguments.attributeOption);
		}

		return false;
	}
	
	// ======================  END: Delete Overrides ==========================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

