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
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	
	property name="locationDAO" type="any";
	property name="stockDAO" type="any";
	
	public boolean function isLocationBeingUsed(required any location) {
		return getLocationDAO().isLocationBeingUsed(arguments.location);
	}
	
	public numeric function getLocationCount() {
		return getLocationDAO().getLocationCount();
	}
	
	// Returns array of leaf locations, i.e. locations that can have stock
	// @locationID string If specified will be used as top level location
	public array function getLocationOptions( string locationID ) {
		var locationOptions = [];
		var smartList = this.getLocationSmartList();
		if(structKeyExists(arguments,"locationID")) {
			smartList.addFilter("locationID",arguments.locationID);
		}
		smartList.addWhereCondition( "NOT EXISTS( SELECT loc FROM SlatwallLocation loc WHERE loc.parentLocation.locationID = aslatwalllocation.locationID)");
		smartList.addOrder("locationIDPath");
		var locations = smartList.getRecords();
		
		for(var i=1;i<=arrayLen(locations);i++) {
			var locationOption = {};
			locationOption['name'] = locations[i].getSimpleRepresentation();
			locationOption['value'] = locations[i].getLocationID();
			arrayAppend(locationOptions, locationOption);
		}
		
		return locationOptions;
	}
	
	// Returns array including all locations
	// @includeNone Boolean If true then 'None' will be included as an option
	public array function getLocationParentOptions(boolean includeNone=true) {
		var locationParentOptions = [];
		
		var smartList = this.getLocationSmartList();
		smartList.addOrder("locationName,locationIDPath");
		var locations = smartList.getRecords();
		
		if( includeNone ) { 
			arrayAppend(locationParentOptions, {name="None", value=""}); 
		}
		
		for(var i=1;i<=arrayLen(locations);i++) {
			arrayAppend(locationParentOptions, {name=locations[i].getSimpleRepresentation(), value=locations[i].getLocationID()});
		}
		
		return locationParentOptions;

	}
	
	// Returns array of a location and all of its children
	// @locationID String Top level location 
	public array function getLocationAndChildren( required string locationID ) {
		var locAndChildren = [];
		var smartList = this.getLocationSmartList();
		smartList.addLikeFilter( "locationIDPath", "%#arguments.locationID#%" );
		var locations = smartList.getRecords();
		for(var i=1;i<=arrayLen(locations);i++) {
			arrayAppend(locAndChildren, {name=locations[i].getSimpleRepresentation(), value=locations[i].getLocationID()});
		}
		return locAndChildren;
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public any function updateStockLocation(required string fromLocationID, required string toLocationID) {
		getStockDAO().updateStockLocation( argumentCollection=arguments );
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveLocation(required any location, required struct data) {
		
		arguments.location = super.save(arguments.location, arguments.data);
		
		if(!location.hasErrors()){
			
			// We need to persist the state here, so that we can have the locationID in the database
			getHibachiDAO().flushORMSession();
			
			// If this location has any stocks then we need to update them
			if( arrayLen(arguments.location.getStocks()) && !isNull(arguments.location.getParentLocation()) ) {
				updateStockLocation( fromLocationID=arguments.location.getParentLocation().getlocationID(), toLocationID=arguments.location.getlocationID());
			}
		} 
		
		return arguments.location;
	}
	
	// ======================  END: Save Overrides ============================

		// ====================== START: Delete Overrides =========================
	
	public boolean function deleteLocation(required any location) {
		
		//Remove this location from all order defaultstocklocation assignments
		var orderSmartList=getService("OrderService").getOrderSmartlist();
		orderSmartList.addFilter('defaultstocklocation.locationID',arguments.location.getLocationID());
		var defaultStockLocationOrders=orderSmartList.getRecords();
		for(var i=1; i<=arrayLen(defaultStockLocationOrders); i++) {
				defaultStockLocationOrders[i].setDefaultStockLocation(javaCast('null',''));
		}
		
		return super.delete(arguments.location);
	}
	
	// ======================  END: Delete Overrides ==========================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}

