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
component entityname="SlatwallCycleCountGroup" table="SwCycleCountGroup" output="false" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="physicalService" hb_permission="this" hb_processContexts="" {
	
	// Persistent Properties
	property name="cycleCountGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="cycleCountGroupName" ormtype="string";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="frequencyToCount" ormtype="integer";
	property name="daysInCycle" ormtype="integer";
	property name="skuCollectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json";
		
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)
	property name="locations" singularname="location" cfc="Location" type="array" fieldtype="many-to-many" linktable="SwCycleCountGroupLocation" fkcolumn="cycleCountGroupID" inversejoincolumn="locationID";
	property name="locationCollections" singularname="locationCollection" cfc="Collection" type="array" fieldtype="many-to-many" linktable="SwCycleCntGroupLocCollection" fkcolumn="cycleCountGroupID" inversejoincolumn="collectionID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="cycleCountBatchs" singularname="cycleCountBatch" cfc="CycleCountBatch" fieldtype="many-to-many" linktable="SwCycleCountBatchCountGroup" fkcolumn="cycleCountGroupID" inversejoincolumn="cycleCountBatchID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="skuCollection" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	 public string function getSkuCollectionConfig(){
    	if(isNull(variables.skuCollectionConfig)){
    		var defaultSkuCollectionList = getService('skuService').getSkuCollectionList();
    		defaultSkuCollectionList.setDisplayProperties('activeFlag,publishedFlag,skuName,skuDescription,skuCode,listPrice,price,renewalPrice',{isVisible=true,isSearchabl=true});
    		defaultSkuCollectionList.addDisplayProperty(displayProperty='skuID',columnconfig={isVisible=false});
    		variables.skuCollectionConfig = serializeJson(defaultSkuCollectionList.getCollectionConfigStruct());
    		
    	}
    	return variables.skuCollectionConfig;
    }
    
    public any function getSkuCollection(){
	var skuCollectionList = getService('skuService').getSkuCollectionList();
	skuCollectionList.setCollectionConfig(getSkuCollectionConfig());
	skuCollection = skuCollectionList;
    	return skuCollection;
    }
    
	public any function getCycleCountGroupsStockCollection() {
		var cycleCountGroupCollection = getService('StockService').getStockCollectionList();
		
		// Create base collection to select active skus what have inventory transactions
		cycleCountGroupCollection.addFilter('sku.activeFlag', 1);
		cycleCountGroupCollection.addFilter('inventory', 'NULL', 'IS NOT');
		cycleCountGroupCollection.setDistinct(true);
		
		// Add selected locations filters
		for(var locationEntity in this.getLocations()) {
			cycleCountGroupCollection.addFilter(propertyIdentifier='location.locationIDPath', value='%#locationEntity.getLocationID()#%', comparisonOperator='LIKE', logicalOperator='AND', aggregate= '', filterGroupAlias='skuFilters', filterGroupLogicalOperator='AND');
		}

		var inlist="";
		// Add selected skuCollections filters
		for(var sku in this.getSkuCollection().getRecords()) {
			inList = listAppend(inList, sku.skuID);
		}
			cycleCountGroupCollection.addFilter(propertyIdentifier='sku.skuID', value='#inList#', comparisonOperator='IN', logicalOperator='AND', aggregate= '', filterGroupAlias='skuFilters', filterGroupLogicalOperator='AND');

		// Add selected location Collections filters
		for(var locationCollection in this.getLocationCollections()) {
			for(var locationEntity in locationCollection.getRecords()) {
				cycleCountGroupCollection.addFilter(propertyIdentifier='location.locationIDPath', value='%#locationEntity.getLocationID()#%', comparisonOperator='LIKE', logicalOperator='AND', aggregate= '', filterGroupAlias='locationCollectionFilters', filterGroupLogicalOperator='AND');
			}
		}
		
		// set page records to show required number of Skus based on count and frequency
		if ( cycleCountGroupCollection.getRecordsCount() ) {
			cycleCountGroupCollection.setPageRecordsShow((ceiling( cycleCountGroupCollection.getRecordsCount() * this.getFrequencyToCount()) / this.getDaysInCycle()));
		}
		
		return cycleCountGroupCollection;
	}

	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Locations (many-to-many - owner)
	public void function addLocation(required any location) {
		if(arguments.location.isNew() or !hasLocation(arguments.location)) {
			arrayAppend(variables.locations, arguments.location);
		}
		if(isNew() or !arguments.location.hasCycleCountGroup( this )) {
			arrayAppend(arguments.location.getCycleCountGroups(), this);
		}
	}
	public void function removeLocation(required any location) {
		var thisIndex = arrayFind(variables.locations, arguments.location);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.locations, thisIndex);
		}
		var thatIndex = arrayFind(arguments.location.getCycleCountGroups(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.location.getCycleCountGroups(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
