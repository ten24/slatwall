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
component extends="HibachiService" accessors="true" output="false" {
	
	
	// Cached Properties
	property name="countryCodeOptions" type="array";
	
	// ===================== START: Logical Methods ===========================
	
	public boolean function isAddressInZone(required any address, required any addressZone) {
		var addressInZone = false;
		
		for(var i=1; i <= arrayLen(arguments.addressZone.getAddressZoneLocations()); i++) {
			var location = arguments.addressZone.getAddressZoneLocations()[i];
			var inLocation = true;
			if(!isNull(location.getPostalCode()) && location.getPostalCode() != arguments.address.getPostalCode()) {
				inLocation = false;
			}
			if(!isNull(location.getCity()) && location.getCity() != arguments.address.getCity()) {
				inLocation = false;
			}
			if(!isNull(location.getStateCode()) && location.getStateCode() != arguments.address.getStateCode()) {
				inLocation = false;
			}
			if(!isNull(location.getCountryCode()) && location.getCountryCode() != arguments.address.getCountryCode()) {
				inLocation = false;
			}
			if(inLocation) {
				addressInZone = true;
				break;
			}
		}
		
		return addressInZone;
	}
	
	public any function copyAddress(required any address, saveNewAddress=false) {
		var addressCopy = this.newAddress();

		addressCopy.setName( arguments.address.getName() );
		addressCopy.setCompany( arguments.address.getCompany() );
		addressCopy.setStreetAddress( arguments.address.getStreetAddress() );
		addressCopy.setStreet2Address( arguments.address.getStreet2Address() );
		addressCopy.setLocality( arguments.address.getLocality() );
		addressCopy.setCity( arguments.address.getCity() );
		addressCopy.setStateCode( arguments.address.getStateCode() );
		addressCopy.setPostalCode( arguments.address.getPostalCode() );
		addressCopy.setCountryCode( arguments.address.getCountryCode() );
		
		addressCopy.setSalutation( arguments.address.getSalutation() );
		addressCopy.setFirstName( arguments.address.getFirstName() );
		addressCopy.setLastName( arguments.address.getLastName() );
		addressCopy.setMiddleName( arguments.address.getMiddleName() );
		addressCopy.setMiddleInitial( arguments.address.getMiddleInitial() );
	
		addressCopy.setPhoneNumber( arguments.address.getPhoneNumber() );
		addressCopy.setEmailAddress( arguments.address.getEmailAddress() );
		
		if(arguments.saveNewAddress) {
			getHibachiDAO().save( addressCopy );
		}
		
		return addressCopy;
	}
	
	public array function getCountryCodeOptions() {
		
		var smartList = this.getCountrySmartList();
		smartList.addFilter(propertyIdentifier="activeFlag", value=1);
		smartList.addSelect(propertyIdentifier="countryName", alias="name");
		smartList.addSelect(propertyIdentifier="countryCode", alias="value");
		smartList.addOrder("countryName|ASC");
		
		return smartList.getRecords();
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveCountry(required any country, struct data={}, string context="save") {
	
		if(structKeyExists(arguments.data, "countryCode") && arguments.country.getNewFlag()) {
			arguments.country.setCountryCode( arguments.data.countryCode );
		}
	
		// Call the generic save method to populate and validate
		arguments.country = save(entity=arguments.country, data=arguments.data, context=arguments.context);
	
		// remove the cache of country code options
		getHibachiCacheService().resetCachedKey("addressService_getCountryCodeOptions");
		
		return arguments.country;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
