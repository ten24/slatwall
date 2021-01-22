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
	
	public any function saveAddress(required any address, struct data={}, string context="save", boolean verifyAddressFlag=false){
		
		arguments.address = super.saveAddress(address,data,context);
		if(structKeyExists(arguments.data, 'verifyAddressFlag') && arguments.data.verifyAddressFlag == true){
			arguments.verifyAddressFlag = true;
		}
		
		if(!arguments.address.hasErrors() && arguments.verifyAddressFlag){
			//Have to flush in order to get address struct
			getHibachiScope().flushORMSession();
			verifyAddressByID(arguments.address.getAddressID());
		}
		return arguments.address;
	}
	
	public boolean function isAddressInZoneByZoneID(required any address, required string addressZoneID) {
		var cacheKey = "isAddressInZoneByZoneID"&arguments.addressZoneID
			&arguments.address.getPostalCode()&arguments.address.getCity()&arguments.address.getStateCode()
			&arguments.address.getCountryCode();
		if(!getService('HibachiCacheService').hasCachedValue(cacheKey)){
			var isAddressInZone = ORMExecuteQuery("
				Select COUNT(azl) FROM SlatwallAddressZone az 
				LEFT JOIN az.addressZoneLocations azl
				where az.addressZoneID = :addressZoneID
				and (azl.postalCode = :postalCode OR azl.postalCode is NULL)
				and (azl.city = :city OR azl.city is NULL)
				and (azl.stateCode = :stateCode OR azl.stateCode is NULL)
				and (azl.countryCode = :countryCode OR azl.countryCode is NULL)
				",
				{
					addressZoneID=arguments.addressZoneID,
					postalCode=arguments.address.getPostalCode(),
					city=arguments.address.getCity(),
					stateCode=arguments.address.getStateCode(),
					countryCode=arguments.address.getCountryCode()
				},
				true
			);
			//cache Address verification for 5 min
			getService('HibachiCacheService').setCachedValue(cacheKey,isAddressInZone);
		}
		
		var isAddressInZone = ORMExecuteQuery("
			Select COUNT(azl) FROM SlatwallAddressZone az 
			LEFT JOIN az.addressZoneLocations azl
			where az.addressZoneID = :addressZoneID
			and (azl.postalCode = :postalCode OR azl.postalCode is NULL)
			and (azl.city = :city OR azl.city is NULL)
			and (azl.stateCode = :stateCode OR azl.stateCode is NULL)
			and (azl.countryCode = :countryCode OR azl.countryCode is NULL)
			",
			{
				addressZoneID=arguments.addressZone.getAddressZoneID(),
				postalCode=arguments.address.getPostalCode(),
				city=arguments.address.getCity(),
				stateCode=arguments.address.getStateCode(),
				countryCode=arguments.address.getCountryCode()
			},
			true
		);
			//cache Address verification for 5 min
		getService('HibachiCacheService').setCachedValue(cacheKey,isAddressInZone);
	
		return isAddressInZone;
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
	
	public any function verifyAddressStruct(required struct addressStruct){
		
		var integrationID = getHibachiScope().setting('globalIntegrationForAddressVerification');
		
		var cacheKey = hash(serializeJSON(arguments.addressStruct),'md5');
		
		var addressVerificationStruct = {};
		
		if(structKeyExists(arguments.addressStruct,'addressID')){
			var address = this.getAddress(arguments.addressStruct['addressID']);
			
			if( !isNull(address) && 
				!isNull(address.getVerificationCacheKey()) &&
				len(address.getVerificationCacheKey()) && 
				compare(address.getVerificationCacheKey(),cacheKey) == 0
			) {
				addressVerificationStruct = deserializeJson(address.getVerificationJson());
			} 
		}
		 			
		if( StructIsEmpty(addressVerificationStruct) &&
			!isNull(integrationID) && 
			len(integrationID) && 
			integrationID != 'internal' 
		){
			addressVerificationStruct = getService("IntegrationService")
											.getIntegrationByIntegrationPackage(integrationID)
												.getIntegrationCFC("Address")
													.verifyAddress(arguments.addressStruct);
			addressVerificationStruct['address'] = arguments.addressStruct;
		}
		
		if(!isNull(address)){
			
			address.setVerificationJson(serializeJSON(addressVerificationStruct));
			address.setVerificationCacheKey(cacheKey);
			
			if (structKeyExists(addressVerificationStruct, 'success')) {
				address.setVerifiedByIntegrationFlag(addressVerificationStruct['success']);
			
				if(!addressVerificationStruct['success']){
					address.setIntegrationVerificationErrorMessage(addressVerificationStruct['message']);
				}
			}
			this.saveAddress(address);
		}
		
		return addressVerificationStruct;
		
	}
	
	/**
	 * @Deprecated this function is deprecated in favor of *verifyAccountAddressByID()*.
	 * left here for compatibility with other projects, should be removed
	 * 
	*/ 
	public any function verifyAccountAddressWithShippingIntegration(required string accountAddressID){
		return verifyAccountAddressByID(arguments.accountAddressID);
	}
	
	/**
	 * @Deprecated this function is deprecated in favor of *verifyAddressByID()*.
	 * left here for compatibility with other projects, should be removed
	 * 
	*/ 
	public any function verifyAddressWithShippingIntegration(required string addressID){
		return verifyAddressByID(arguments.addressID);
	}
	
	/**
	 * Function to verify Address by an addressID using an AddressIntegration 
	 * Note: the integration is driven by a @setting globalIntegrationForAddressVerification
	 *  
	 * @addressID id, of the Address to verify
	*/ 
	public any function verifyAddressByID(required string addressID){
		
			var data = getDAO("AddressDAO").getAddressStruct(addressID);
		
			if(len(data)){
				return this.verifyAddressStruct(data[1]);
			}
	}
	
	/**
	 * Function to verify AccountAddress by an accountAddressID using an AddressIntegration 
	 * Note: the integration is driven by a @setting globalIntegrationForAddressVerification
	 *  
	 * @accountAddressID id, of the AccountAddress to verify
	 */ 
	public any function verifyAccountAddressByID(required string accountAddressID){

			var data = getDAO("AddressDAO").getAccountAddressStruct(accountAddressID);
			
			if(len(data)){
				return this.verifyAddressStruct(data[1]);
			} 
	}

	
	public any function getAddressName(required any addressStruct){
			var name = "";
			var fields = [ 'StreetAddress',  'Street2Address',  'City',  'StateCode',  'PostalCode','CountryCode'];
			
			for(var field in fields){
				if( structKeyExists(arguments.addressStruct,field) ) {
					name = listAppend(name, " #arguments.addressStruct[field]#" );
				}
			}
			
			return name;
		
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
