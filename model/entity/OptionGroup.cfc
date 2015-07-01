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
component displayname="Option Group" entityname="SlatwallOptionGroup" table="SwOptionGroup" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="optionService" hb_permission="this" {

	// Persistent Properties
	property name="optionGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionGroupName" ormtype="string";
	property name="optionGroupCode" ormtype="string" index="PI_OPTIONGROUPCODE";
	property name="optionGroupImage" ormtype="string";
	property name="optionGroupDescription" ormtype="string" length="4000";
	property name="imageGroupFlag" ormtype="boolean" default="0";
	property name="sortOrder" ormtype="integer" required="true";
	property name="globalFlag" ormtype="boolean" default="1";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Related Object Properties (one-many)
	property name="options" singularname="option" cfc="Option" fieldtype="one-to-many" fkcolumn="optionGroupID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="optionGroupID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many - owner)
	property name="productTypes" singularname="productType" cfc="ProductType" type="array" fieldtype="many-to-many" linktable="SwOptionGroupProductType" fkcolumn="optionGroupID" inversejoincolumn="productTypeID";

	public array function getOptions(orderby, sortType="text", direction="asc") {
		if(!structKeyExists(arguments,"orderby")) {
			return variables.Options;
		} else {
			return getService("hibachiUtilityService").sortObjectArray(variables.Options,arguments.orderby,arguments.sortType,arguments.direction);
		}
	}

    public any function getOptionsSmartList() {
    	return getPropertySmartList(propertyName="options");
    }
    
    // ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Options (one-to-many)
	public void function addOption(required any option) {
		arguments.option.setOptionGroup( this );
	}
	public void function removeOption(required any option) {
		arguments.option.removeOptionGroup( this );
	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setOptionGroup( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeOptionGroup( this );
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {    
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {    
			arrayAppend(variables.productTypes, arguments.productType);    
		}
		if(isNew() or !arguments.productType.hasOptionGroup( this )) {    
			arrayAppend(arguments.productType.getOptionGroups(), this);    
		}    
	}
	public void function removeProductType(required any productType) {    
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.productTypes, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.productType.getOptionGroups(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getOptionGroups(), thatIndex);    
		}
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	public boolean function getGlobalFlag() {
		if(!structKeyExists(variables, "globalFlag")) {
			variables.globalFlag = 1;
		}
		
		return variables.globalFlag;
	}
	
	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}

