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
component displayname="ContainerPreset" entityname="SlatwallContainerPreset" table="SwContainerPreset" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="containerService" hb_permission="this" {
	
	// Persistent Properties
	property name="containerPresetID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="containerName" ormtype="string";
	property name="height" ormtype="double";
	property name="width" ormtype="double";
	property name="depth" ormtype="double";

	// Related Object Properties (many-to-one)
	property name="dimensionUnit" cfc="MeasurementUnit" fieldtype="many-to-one" fkcolumn="dimensionUnitID";
	
	// Related Object Properties (one-to-many)
	property name="containers" type="array" cfc="Container" singularname="container" fieldtype="one-to-many" fkcolumn="containerPresetID" cascade="all-delete-orphan" inverse="true";
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp" hb_displayType="datetime";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp" hb_displayType="datetime";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
	property name="dimensionUnitOptions" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	public array function getDimensionUnitOptions(){
	    if(!structKeyExists(variables,'dimensionUnitOptions')){
            var dimensionUnitCollectionList = getService('measurementService').getMeasurementUnitCollectionList(measurmentType='length');
            dimensionUnitCollectionList.addOrderBy('conversionRatio');
            variables.dimensionUnitOptions = dimensionUnitCollectionList.getRecordOptions(false);
	    }
	    return variables.dimensionUnitOptions;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
    	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	public string function getSimpleRepresentationPropertyName() {
		return "containerName";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================	//CUSTOM FUNCTIONS BEGIN

public array function getBottleSizeOptions(){
        if(!structKeyExists(variables,'bottleSizeOptions')){
            var bottleSizeOptionCollection = getService('optionService').getOptionCollectionList();
            bottleSizeOptionCollection.addFilter('optionGroup.optionGroupCode','size');
             bottleSizeOptionCollection.addOrderBy('sortOrder');
            variables.bottleSizeOptions = bottleSizeOptionCollection.getRecordOptions(false);
        }
        return variables.bottleSizeOptions;
    }//CUSTOM FUNCTIONS END
}