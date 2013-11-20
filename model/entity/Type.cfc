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
component entityname="SlatwallType" table="SwType" persistent="true" accessors="true" output="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="settingService" hb_permission="this" hb_parentPropertyName="parentType" {
	
	// Persistent Properties
	property name="typeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="typeIDPath" ormtype="string" length="4000";
	property name="type" ormtype="string";
	property name="systemCode" ormtype="string";
	
	// Related Object Properties
	property name="parentType" cfc="Type" fieldtype="many-to-one" fkcolumn="parentTypeID";
	property name="childTypes" singularname="childType" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="parentTypeID" cascade="all" inverse="true";
	
	public any function getChildTypes() {
		if(!isDefined('variables.childTypes')) {
			variables.childTypes = arraynew(1);
		}
		return variables.childTypes;
	}
	
	public any function getType() {
		if(!structKeyExists(variables, "type")) {
			variables.type = "";
		}
		return variables.type;
	}
	
	// This overrides the build in system code getter to look up to the parent if a system code doesn't exist for this type.
	public string function getSystemCode() {
		if(isNull(variables.systemCode)) {
			return getParentType().getSystemCode();
		}
		return variables.systemCode;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public string function getTypeIDPath() {
		if(isNull(variables.typeIDPath)) {
			variables.typeIDPath = buildIDPathList( "parentType" );
		}
		return variables.typeIDPath;
	}
	
	// ==============  END: Overridden Implicet Getters ====================
		
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
    	return "type";
    }
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		setTypeIDPath( buildIDPathList( "parentType" ) );
		super.preInsert();
	}
	
	public void function preUpdate(struct oldData){
		setTypeIDPath( buildIDPathList( "parentType" ) );;
		super.preUpdate(argumentcollection=arguments);
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

