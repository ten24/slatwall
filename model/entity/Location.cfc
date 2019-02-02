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
component displayname="Location" entityname="SlatwallLocation" table="SwLocation" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="this" hb_parentPropertyName="parentLocation"  hb_childPropertyName="childLocations" {
	
	// Persistent Properties
	property name="locationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationCode" ormtype="string";
	property name="locationIDPath" ormtype="string";
	property name="locationName" ormtype="string";
	property name="activeFlag" ormtype="boolean" ;
	
	// Related Object Properties (Many-to-One)
	property name="currencyCode" ormtype="string" length="3" hb_formFieldType="select";
	property name="primaryAddress" cfc="LocationAddress" fieldtype="many-to-one" fkcolumn="locationAddressID";
	property name="parentLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="parentLocationID";
	
	// Related Object Properties (One-to-Many)
	property name="stocks" singularname="stock" cfc="Stock" type="array" fieldtype="one-to-many" fkcolumn="locationID" cascade="all-delete-orphan" inverse="true" lazy="extra"   ;
	property name="locationAddresses" singularname="locationAddress" cfc="LocationAddress" type="array" fieldtype="one-to-many" fkcolumn="locationID" cascade="all-delete-orphan" inverse="true";
	property name="locationConfigurations" singularname="locationConfiguration" cfc="LocationConfiguration" type="array" fieldtype="one-to-many" fkcolumn="locationID" cascade="all-delete-orphan" inverse="true";
	property name="childLocations" singularname="childLocation" cfc="Location" fieldtype="one-to-many" inverse="true" fkcolumn="parentLocationID" cascade="all" type="array";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="locationID" cascade="all-delete-orphan" inverse="true";
	property name="minMaxStockTransferItemToTopLocationIDs" singularname="minMaxStockTransferItemToTopLocationIDs" cfc="MinMaxStockTransferItem" type="array" fieldtype="one-to-many" fkcolumn="locationID" inversejoincolumn="toTopLocationID" cascade="all-delete-orphan" inverse="true" lazy="extra";
	property name="minMaxStockTransferItemToLeafLocationIDs" singularname="minMaxStockTransferItemToLeafLocationID" cfc="MinMaxStockTransferItem" type="array" fieldtype="one-to-many" fkcolumn="locationID" inversejoincolumn="toLeafLocationID" cascade="all-delete-orphan" inverse="true" lazy="extra";
	property name="minMaxStockTransferItemFromTopLocationIDs" singularname="minMaxStockTransferItemFromTopLocationIDs" cfc="MinMaxStockTransferItem" type="array" fieldtype="one-to-many" fkcolumn="locationID" inversejoincolumn="fromTopLocationID" cascade="all-delete-orphan" inverse="true" lazy="extra";
	property name="minMaxStockTransferItemFromLeafLocationIDs" singularname="minMaxStockTransferItemFromLeafLocationID" cfc="MinMaxStockTransferItem" type="array" fieldtype="one-to-many" fkcolumn="locationID" inversejoincolumn="fromLeafLocationID" cascade="all-delete-orphan" inverse="true" lazy="extra";
	property name="skuLocationQuantities" singularname="skuLocationQuantity" fieldtype="one-to-many" fkcolumn="locationID" cfc="SkuLocationQuantity" inverse="true" cascade="all-delete-orphan";

	// Related Object Properties (Many-to-Many - owner)
	property name="sites" singularname="site" cfc="Site" type="array" fieldtype="many-to-many" linktable="SwLocationSite" fkcolumn="locationID" inversejoincolumn="siteID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="physicals" singularname="physical" cfc="Physical" type="array" fieldtype="many-to-many" linktable="SwPhysicalLocation" fkcolumn="locationID" inversejoincolumn="physicalID" inverse="true";
	property name="cycleCountGroups" singularname="cycleCountGroup" cfc="CycleCountGroup" type="array" fieldtype="many-to-many" linktable="SwCycleCountGroupLocation" fkcolumn="locationID" inversejoincolumn="cycleCountGroupID" inverse="true";
	property name="fulfillmentBatches" singularname="fulfillmentBatch" cfc="FulfillmentBatch" type="array" fieldtype="many-to-many" linktable="SwFulfillmentBatchLocation" fkcolumn="locationID" inversejoincolumn="fulfillmentBatchID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	//Calculated Properties
	property name="calculatedLocationPathName" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="baseLocation" type="string" persistent="false";
	property name="locationPathName" persistent="false";
	
	
	public boolean function isDeletable() {
		return !(getService("LocationService").isLocationBeingUsed(this) || getService("LocationService").getLocationCount() == 1);
	}
	
	public boolean function hasChildren() {
		return (arraylen(getchildLocations()) > 0);
	}
	
	public numeric function getChildLocationCount(){
		return getService('locationService').getChildLocationCount(this);
	}
	
	public any function getPrimaryAddress() {
		if(!isNull(variables.primaryAddress)) {
			return variables.primaryAddress;
		} else if (arrayLen(getLocationAddresses())) {
			variables.primaryAddress = getLocationAddresses()[1];
			return variables.primaryAddress;
		} else {
			return getService("locationService").newLocationAddress();
		}
	}
	
	//get top level locations 
	public any function getBaseLocation() {
		var baseID = listFirst(getlocationIDPath());
	
		var cacheKey = 'location_getBaseLocation#baseID#';
	
		if(!getService('HibachiCacheService').hasCachedValue(cacheKey)){
			getService('HibachiCacheService').setCachedValue(cacheKey,getService("locationService").getLocation().getLocationName());
		}
		return getService('HibachiCacheService').getCachedValue(cacheKey);
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getLocationPathName() {
		if(!structKeyExists(variables, "locationPathName")) {
			
			variables.locationPathName = "";
			
			//Add each of the parents in the chain to the string.
			var parentLocation = this.getParentLocation();
			while (!isNull(parentLocation)){
				variables.locationPathName = listAppend(variables.locationPathName, parentLocation.getLocationName(), "#chr(187)#");
				if(isNull(parentLocation.getParentLocation())){
					break;
				}
				parentLocation = parentLocation.getParentLocation();
			}
			//Add this location name to the end.
			variables.locationPathName = listAppend(variables.locationPathName, this.getLocationName(), "#chr(187)#");
			variables.locationPathName = rereplace(variables.locationPathName,'#chr(187)#',' #chr(187)# ','all');
		}
		
		return variables.locationPathName;
	}
	
	public boolean function isRootLocation(  ){
		return isNull(this.getParentLocation());
	}
	
	public any function getRootLocation(  ){
		
		// If we don't have a parent, we are a root.
		if (isNull( this.getParentLocation() )){
			return this;
		}
		// Else, find the root.
		var rootLocation = this.getParentLocation();
		while (!isNull(rootLocation)){
			if(isNull(rootLocation.getParentLocation())){
				break;
			}
			rootLocation = rootLocation.getParentLocation();
		}
		return rootLocation;
	}
	
	public any function getLocationOptions(){
		return getService("locationService").getLocationOptions(this.getLocationID());
	}
	
	public array function getCurrencyCodeOptions() {
		return getService("currencyService").getCurrencyOptions();
	}

	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	
	// Attribute Values (one-to-many)    
    	public void function addAttributeValue(required any attributeValue) {    
    		arguments.attributeValue.setLocation( this );    
    	}    
    	public void function removeAttributeValue(required any attributeValue) {    
    		arguments.attributeValue.removeLocation( this );    
    	}
	
	// Location Addresses (one-to-many)
	public void function addLocationAddress(required any locationAddress) {
		arguments.locationAddress.setLocation( this );
	}
	public void function removeLocationAddress(required any locationAddress) {
		arguments.locationAddress.removeLocation( this );
	}
	
	
	// Location Configurations (one-to-many)
	public void function addLocationConfiguration(required any locationConfiguration) {
		arguments.locationConfiguration.setLocation( this );
	}
	public void function removeLocationConfiguration(required any locationConfiguration) {
		arguments.locationConfiguration.removeLocation( this );
	}
	
	// Physicals (many-to-many - inverse)
	public void function addPhysical(required any physical) {
		arguments.physical.addLocation( this );
	}
	public void function removePhysical(required any physical) {
		arguments.physical.removeLocation( this );
	}
	
	// FulfillmentBatches (many-to-many - inverse)
	public void function addFulfillmentBatch(required any fulfillmentBatch) {
		arguments.fulfillmentBatch.addLocation( this );
	}
	public void function removeFulfillmentBatch(required any fulfillmentBatch) {
		arguments.fulfillmentBatch.removeLocation( this );
	}
	
	// Primary Location Address (many-to-one | circular)
	public void function setPrimaryLocationAddress( any primaryLocationAddress) {    
		if(structKeyExists(arguments, "primaryLocationAddress")) {
			variables.primaryLocationAddress = arguments.primaryLocationAddress;
			arguments.primaryLocationAddress.setLocation( this );	
		} else {
			structDelete(variables, "primaryLocationAddress");
		}
	}

	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// If locationPathID is null returns all otherwise returns current locationIDPath 
	public string function getLocationIDPath() {
		if(isNull(variables.locationIDPath)) {
			variables.locationIDPath = buildIDPathList( "parentLocation" );
		}
		return variables.locationIDPath;
	}
	
	public any function getPrimaryLocationAddress() {
		if(!isNull(variables.primaryLocationAddress)) {
			return variables.primaryLocationAddress;
		} else if (arrayLen(getLocationAddresses())) {
			variables.primaryLocationAddress = getLocationAddresses()[1];
			return variables.primaryLocationAddress;
		} else {
			return getService("locationService").newLocationAddress();
		}
	}
	
	public string function getSimpleRepresentation() {

		if(!isNull(getCalculatedLocationPathName())){
			return getCalculatedLocationPathName();
		}else{
			return getLocationPathName();
		}
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	public void function preInsert(){
		setLocationIDPath( buildIDPathList( "parentLocation" ) );
		setCalculatedLocationPathName( getLocationPathName() );
		super.preInsert();
	}
	
	public void function preUpdate(struct oldData){
		setLocationIDPath( buildIDPathList( "parentLocation" ) );
		setCalculatedLocationPathName( getLocationPathName() );
		super.preUpdate(argumentcollection=arguments);
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

