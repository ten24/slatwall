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
	
	public array function getLocationOptions( string baseLocation="" ) {
		if(!structKeyExists(variables,"locationOptions")) {
			arguments.entityName = "SlatwallLocation";
			var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
			smartList.addWhereCondition( "NOT EXISTS( SELECT loc FROM SlatwallLocation loc WHERE loc.parentLocation.locationID = aslatwalllocation.locationID)");
			smartList.addOrder("locationIDPath");
			var locations = smartList.getRecords();
			
			variables.locationOptions = [];
			
			for(var i=1;i<=arrayLen(locations);i++) {
				arrayAppend(variables.locationOptions, {name=locations[i].getSimpleRepresentation(), value=locations[i].getLocationID()});
			}
		}
		return variables.locationOptions;
		
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	public any function saveLocation(required any location, required struct data) {
		arguments.location = super.save(arguments.location, arguments.data);
		if(!location.hasErrors()){
			getHibachiDAO().flushORMSession();
			if( locationHasStock(arguments.location.getParentLocation())) {
				updateStockLocation( fromLocationID=arguments.location.getParentLocation().getlocationID(),toLocationID=arguments.location.getlocationID());
			}
		} else {
			writeDump(var="#location.hasErrors()#" top="3");
		}
		return arguments.location;
	}
	
	public any function updateStockLocation(required string fromLocationID, required string toLocationID) {
		getStockDAO().updateStockLocation( arguments.fromLocationID, arguments.toLocationID);
	}
	
	
	public boolean function locationHasStock(required any location) {
		return (!arrayIsEmpty(arguments.location.getStocks()) > 0);
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}

